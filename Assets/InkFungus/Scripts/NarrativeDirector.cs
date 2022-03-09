using Fungus;
using Ink.Runtime;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;
using UnityEngine;

namespace InkFungus
{
    public class NarrativeDirector : MonoBehaviour
    {
        [Header("Basic Settings")]
        public TextAsset ink;
        public SayDialog sayDialog;
        public MenuDialog menuDialog;
        public Color defaultCharacterColor;

        [Header("Default Flags")]
        public bool hideQuestions = true;
        public bool echoAnswers = false;
        public bool autoProceed = false;
        public bool ignoreDialogRegex = false;
        public bool choiceTimer = false;

        [Header("Messages to Fungus for Ink Events")]
        public string prefixForAllMessages = "ink "; // if it must append a blank space, append a blank space here
        public string refreshVariablesMessage = "refresh";
        public string textPauseMessage = "pause";
        public string textResumeMessage = "resume";
        public string textStopMessage = "stop";
        public string saveMessage = "save";
        public string loadMessage = "load";
        public string newKnotStitchMessage = "at";

        [Header("Advanced Settings")]
        public string dialogRegex =
        @"^(?<character>[\w\- ]*)(\?(?<portrait>[\w\- ]+))? ""(?<text>((""[^""]*"")|(.))+?)""?[ ]*$";
        public Flowchart gatewayFlowchart;
        public float defaultChoiceTime = 5f;

        [Header("Log Messages")]
        public LogLevel logging = LogLevel.Verbose;
        public enum LogLevel
        {
            Verbose,
            Rich,
            Narrative,
            Off
        }

        private Story story;
        private Regex compiledDialogRegex;
        private Dictionary<string, Character> characters = new Dictionary<string, Character>();
        private GlobalVariables fungusGlobalVariables;
        private Dictionary<string, List<Flowchart>> syncVariables = new Dictionary<string, List<Flowchart>>();
        private bool beforeFirstSync = true;

        // Configurations driven by Ink tags:
        private bool pause = true;
        private float pauseTime = float.PositiveInfinity;
        private float waitTime = 0;
        private float resumeTime = float.PositiveInfinity;
        private Action onResume;
        private float choiceTime;

        // Inner states needed for loading:
        private bool loading = false;
        private int narrationHandle = 0;
        private string lastKnotStitch = null;

        // Flags
        private Dictionary<string, Flag> flags = new Dictionary<string, Flag>();

        // Lists stuff
        private const string ListItemSeparator = "__";
        private readonly string[] ListItemSeparators = { ListItemSeparator };

        private class Flag
        {
            public bool ordinaryValue;
            public bool currentValue;

            public bool Get()
            {
                return currentValue;
            }

            public void Set(bool value)
            {
                ordinaryValue = currentValue = value;
            }

            public void SetExceptional(bool value)
            {
                currentValue = value;
            }

            public void Reset()
            {
                currentValue = ordinaryValue;
            }

            public Flag(bool value)
            {
                Set(value);
            }
        }

        void Reset()
        {
            defaultCharacterColor = Color.black;
            defaultCharacterColor.a = 1;
        }


        void Awake()
        {
            story = new Story(ink.text);
            if (sayDialog == null)
            {
                sayDialog = FindObjectOfType<SayDialog>();
            }
            if (menuDialog == null)
            {
                menuDialog = FindObjectOfType<MenuDialog>();
            }
            if (gatewayFlowchart == null)
            {
                gatewayFlowchart = GetComponentInChildren<Flowchart>();
            }
            choiceTime = defaultChoiceTime;
            flags.Add("hide", new Flag(hideQuestions));
            flags.Add("echo", new Flag(echoAnswers));
            flags.Add("auto", new Flag(autoProceed));
            flags.Add("verbatim", new Flag(ignoreDialogRegex));
            flags.Add("timer", new Flag(choiceTimer));
        }

        private void SyncListToFungus(string inkListName, object inkListNewValue)
        {
            InkList inkList = story.variablesState[inkListName] as InkList;
            if (inkList == null)
            {
                Debug.LogError("Sync list mismatch: " + inkListName + " is not a list in Ink");
            }
            else
            {
                foreach (string syncVariableName in syncVariables.Keys)
                {
                    if (syncVariableName.StartsWith(inkListName + ListItemSeparator))
                    {
                        string inkItemName = SplitFungusVariableName(syncVariableName)[1];
                        bool itemInList = inkList.ContainsItemNamed(inkItemName);
                        SyncToFungus(syncVariableName, itemInList);
                    }
                }
            }
        }

        private void SyncToFungus(string inkVariableName, object inkVariableNewValue)
        {
            bool hasChanged;
            Variable fungusVariable = fungusGlobalVariables.GetVariable(inkVariableName);
            Type fungusVariableType = fungusVariable.GetValue().GetType();
            if (fungusVariableType == typeof(int))
            {
                int intValue = (fungusVariable as IntegerVariable).Value;
                hasChanged = (intValue != (int)inkVariableNewValue);
            }
            else if (fungusVariableType == typeof(string))
            {
                string stringValue = (fungusVariable as StringVariable).Value;
                hasChanged = (stringValue != (string)inkVariableNewValue);
            }
            else if (fungusVariableType == typeof(float))
            {
                float floatValue = (fungusVariable as FloatVariable).Value;
                hasChanged = (floatValue != (float)inkVariableNewValue);
            }
            else if (fungusVariableType == typeof(bool))
            {
                bool boolValue = (fungusVariable as BooleanVariable).Value;
                hasChanged = (boolValue != ((bool)inkVariableNewValue));
            }
            else
            {
                hasChanged = false;
            }
            if (hasChanged)
            {
                // Picks the first flowchart: any flowchart is OK, it's a global variable
                Flowchart flowchart = syncVariables[inkVariableName][0];
                Type inkVariableType = inkVariableNewValue.GetType();
                try
                {
                    Log(LogLevel.Rich, inkVariableName + "=" + inkVariableNewValue + " (Ink->Fungus)");
                    if (inkVariableType == typeof(int))
                    {
                        if (fungusVariableType == typeof(bool)) // converts int to bool
                        {
                            flowchart.SetBooleanVariable(inkVariableName, (0 != (int)inkVariableNewValue));
                        }
                        else
                        {
                            flowchart.SetIntegerVariable(inkVariableName, (int)inkVariableNewValue);
                        }
                    }
                    else if (inkVariableType == typeof(bool))
                    {
                        if (fungusVariableType == typeof(bool))
                        {
                            flowchart.SetBooleanVariable(inkVariableName, (bool)inkVariableNewValue);
                        }
                        else // converts bool to int
                        {
                            flowchart.SetIntegerVariable(inkVariableName, ((bool)inkVariableNewValue ? 1 : 0));
                        }
                    }
                    else if (inkVariableType == typeof(string))
                    {
                        flowchart.SetStringVariable(inkVariableName, (string)inkVariableNewValue);
                    }
                    else if (inkVariableType == typeof(float))
                    {
                        flowchart.SetFloatVariable(inkVariableName, (float)inkVariableNewValue);
                    }
                    else // it's an Ink list
                    {
                        throw new InvalidCastException();
                    }
                    foreach (Flowchart affectedFlowchart in syncVariables[inkVariableName])
                    {
                        BroadcastToFungus(refreshVariablesMessage, affectedFlowchart); // rough and simple
                        BroadcastToFungus(refreshVariablesMessage + " " + inkVariableName, affectedFlowchart); // fine-grained
                    }
                }
                catch (InvalidCastException)
                {
                    Debug.LogError("Sync variable mismatch: " + inkVariableName + " is " + inkVariableType + " in Ink but it's not in Fungus");
                }
            }
            else
            {
                Log(LogLevel.Verbose, inkVariableName + " is already in sync with Fungus");
            }
        }

        private string[] SplitFungusVariableName(string fungusVariableName)
        {
            return fungusVariableName.Split(ListItemSeparators, 2, StringSplitOptions.None);
        }

        void Start()
        {
            Character[] allCharacters = FindObjectsOfType<Character>();
            foreach (Character anyCharacter in allCharacters)
            {
                characters.Add(anyCharacter.name, anyCharacter);
            }
            compiledDialogRegex = new Regex(dialogRegex);
            Flowchart[] allFlowcharts = FindObjectsOfType<Flowchart>();
            foreach (Flowchart flowchart in allFlowcharts)
            {
                foreach (Variable fungusVariable in flowchart.Variables)
                {
                    if (fungusVariable.Scope == VariableScope.Global)
                    {
                        if (syncVariables.ContainsKey(fungusVariable.Key))
                        {
                            syncVariables[fungusVariable.Key].Add(flowchart);
                        }
                        else
                        {
                            List<Flowchart> newList = new List<Flowchart>();
                            newList.Add(flowchart);
                            syncVariables.Add(fungusVariable.Key, newList);
                        }
                    }
                }
            }
            fungusGlobalVariables = FungusManager.Instance.GlobalVariables;
            List<string> unsyncVariableNames = new List<string>();
            foreach (string fungusVariableName in new List<string>(syncVariables.Keys))
            {
                try
                {
                    string[] listVariableParts = SplitFungusVariableName(fungusVariableName);
                    if (listVariableParts.Length <= 1)
                    {
                        story.ObserveVariable(fungusVariableName, SyncToFungus);
                    }
                    else
                    {
                        Log(LogLevel.Verbose, "Registering list " + listVariableParts[0]);
                        story.ObserveVariable(listVariableParts[0], SyncListToFungus);
                    }
                }
                catch (StoryException se)
                {
                    Debug.LogWarning("Sync variable skipped: " + fungusVariableName + " is global in Fungus but it's not in Ink. " + se.Message);
                    unsyncVariableNames.Add(fungusVariableName);
                }
            }
            foreach (string unsyncVariableName in unsyncVariableNames)
            {
                syncVariables.Remove(unsyncVariableName);
            }
            Idle();
        }

        void Update()
        {
            if (pause)
            {
                if (Time.time >= resumeTime)
                {
                    Log(LogLevel.Rich, "Timer triggered proceeding");
                    Resume();
                }
            }
        }

        public void JumpTo(string pathString)
        {            
            story.ChoosePathString(pathString);
            Resume(true);
        }

        private void AfterDelayDo(Action action, float delay)
        {
            pause = true;
            onResume = action;
            resumeTime = Time.time + delay;
            if (resumeTime == float.PositiveInfinity)
            {
                Log(LogLevel.Rich, "Idling until further notice");
            }
            else
            {
                Log(LogLevel.Rich, "Idling for " + delay + "s");
            }
            BroadcastToFungus(textPauseMessage);
        }

        public void Idle()
        {
            AfterDelayDo(Narrate, pauseTime);
        }
        
        public void Resume(bool force = false)
        {
            if (pause || force)
            {
                pause = false;
                BroadcastToFungus(textResumeMessage);
                onResume();                
            }
        }

        private bool IsNarrationAt(int narrationHandle)
        {
            return (this.narrationHandle == narrationHandle);
        }

        private void Narrate()
        {            
            if (story.canContinue || loading)
            {
                foreach (Flag flag in flags.Values)
                {
                    flag.Reset();
                }                
                if (!loading)
                {
                    story.Continue();
                    if (beforeFirstSync)
                    {
                        SyncAllVariablesToFungus();
                        beforeFirstSync = false;
                    }
                }
                string line = story.currentText;
                Log(LogLevel.Narrative, "»" + line);
                ProcessTags(story.currentTags);
                bool verbatim = flags["verbatim"].Get();
                Match dialogLine = null;
                Sprite portrait = null;
                if (!verbatim)
                {
                    dialogLine = compiledDialogRegex.Match(line);
                    if (!dialogLine.Success)
                    {
                        verbatim = true;
                    }
                }
                SayDialog sayDialogToUse = sayDialog;
                if (!verbatim)
                {
                    line = dialogLine.Groups["text"].Value;
                    string character = dialogLine.Groups["character"].Value;
                    if (characters.ContainsKey(character))
                    {
                        Character speaker = characters[character];
                        string portraitName = (dialogLine.Groups["portrait"].Success) ?
                            dialogLine.Groups["portrait"].Value : null;
                        portrait = FindPortrait(speaker, portraitName);
                        SayDialog specificSayDialog = speaker.SetSayDialog;
                        if (speaker.SetSayDialog != null && speaker.SetSayDialog != sayDialog)
                        {
                            sayDialogToUse = speaker.SetSayDialog;                            
                        }
                        sayDialogToUse.SetCharacter(speaker);
                    }
                    else
                    {
                        sayDialogToUse.SetCharacterName(character, defaultCharacterColor);
                    }
                }
                else
                {
                    sayDialogToUse.SetCharacterName("", defaultCharacterColor);
                }
                sayDialogToUse.SetCharacterImage(portrait);
                Action nextStep;
                if (pauseTime > 0)
                {
                    nextStep = Idle;
                }
                else
                {
                    nextStep = Narrate;
                }
                narrationHandle++;
                int originalNarrationHandle = narrationHandle;
                Action onSayComplete = delegate ()
                {
                    if (IsNarrationAt(originalNarrationHandle))
                    {
                        nextStep();
                    }
                    else
                    {
                        Log(LogLevel.Verbose, "Discarding orphan action associated with expired narration handle " + originalNarrationHandle);
                    }
                };
                bool fadeWhenDone = story.canContinue || flags["hide"].Get();
                Action say = delegate ()
                {
                    StartCoroutine(sayDialogToUse.DoSay(line, true, !flags["auto"].Get(), fadeWhenDone, true, true, null, onSayComplete));
                };       
                if (waitTime > 0)
                {
                    AfterDelayDo(say, waitTime);
                }
                else
                {
                    say();
                }
                AutoSave();
            }
            else
            {
                List<Choice> choices = story.currentChoices;
                if (choices.Count == 0)
                {
                    Debug.LogWarning("Story reached a stop");
                    BroadcastToFungus(textStopMessage);
                }
                else
                {
                    menuDialog.SetActive(true);
                    menuDialog.Clear();
                    if (flags["hide"].Get())
                    {
                        menuDialog.HideSayDialog(); // probably not needed
                    }
                    foreach (Choice choice in choices)
                    {
                        int choiceIndex = choice.index;
                        string line = choice.text;
                        Log(LogLevel.Narrative, choiceIndex + "»" + line);
                        Block callbackBlock = gatewayFlowchart.FindBlock("Choose " + choiceIndex);
                        if (callbackBlock == null)
                        {
                            Debug.LogError("Choice block #" + choice.index + " does not exist in the Gateway Flowchart");
                        }
                        Match dialogLine = null;
                        if (!flags["verbatim"].Get())
                        {
                            dialogLine = compiledDialogRegex.Match(line);
                            if (dialogLine.Success)
                            {
                                line = dialogLine.Groups["text"].Value;
                            }
                        }
                        menuDialog.AddOption(line, true, false, callbackBlock);
                        if (choice == choices[0] && flags["timer"].Get())
                        {
                            menuDialog.ShowTimer(choiceTime, callbackBlock);
                        }
                    }
                }
            }
        }

        private void BroadcastToFungus(string message, Flowchart flowchart = null)
        {
            string fullMessage = (prefixForAllMessages + message).TrimEnd();
            if (flowchart == null)
            {
                Log(LogLevel.Rich, "Message to all flowcharts: «" + fullMessage + "»");
                Flowchart.BroadcastFungusMessage(fullMessage);
            }
            else
            {
                Log(LogLevel.Rich, "Message to flowchart " + flowchart.name + ": «" + fullMessage + "»");
                flowchart.SendFungusMessage(fullMessage);
            }
        }

        static readonly char[] TagSeparators = { ' ', '\t' };

        private void ProcessTags(List<string> tags)
        {
            pauseTime = 0;
            waitTime = 0;
            foreach (string tag in tags)
            {
                Log(LogLevel.Rich, "Processing tag: " + tag);
                string[] t = tag.Trim().Split(TagSeparators, 2);
                string command = t[0].ToLowerInvariant();
                bool defaultArgument;
                string argument;
                if (t.Length > 1)
                {
                    defaultArgument = false;
                    argument = t[1];
                }
                else
                {
                    defaultArgument = true;
                    argument = "";
                }
                switch (command)
                {
                    case "pause": // e.g. # pause 2.5
                        if (defaultArgument)
                        {
                            pauseTime = float.PositiveInfinity;
                        }
                        else
                        {
                            try
                            {
                                pauseTime = float.Parse(argument, CultureInfo.InvariantCulture.NumberFormat);
                            }
                            catch
                            {
                                Debug.LogWarning($"Could not parse argument {argument} for command #{command}");
                            }
                        }
                        break;

                    case "wait": // e.g. # wait 4.1
                        if (defaultArgument)
                        {
                            waitTime = float.PositiveInfinity;
                        }
                        else
                        {
                            try
                            {
                                waitTime = float.Parse(argument, CultureInfo.InvariantCulture.NumberFormat);
                            }
                            catch
                            {
                                Debug.LogWarning($"Could not parse argument {argument} for command #{command}");
                            }
                        }
                        break;

                    case "timer": // e.g. # timer 3.8
                        if (defaultArgument)
                        {
                            choiceTime = defaultChoiceTime;
                        }
                        else
                        {
                            try
                            {
                                choiceTime = float.Parse(argument, CultureInfo.InvariantCulture.NumberFormat);
                            }
                            catch
                            {
                                Debug.LogWarning($"Could not parse argument {argument} for command #{command}");
                            }
                        }
                        break;

                    case "on":
                        OnOff(argument, true);
                        break;

                    case "off":
                        OnOff(argument, false);
                        break;

                    case "yes":
                        YesNo(argument, true);
                        break;

                    case "no":
                        YesNo(argument, false);
                        break;

                    default:
                        BroadcastToFungus($"{command} {argument}"); // simple as that
                        break;
                }
            }
        }

        private void OnOff(string flagName, bool value)
        {
            if (flags.ContainsKey(flagName))
            {
                flags[flagName].Set(value);
            }
        }

        private void YesNo(string flagName, bool value)
        {
            if (flags.ContainsKey(flagName))
            {
                flags[flagName].SetExceptional(value);
            }
        }

        public void OnOptionChosen(int choiceIndex)
        {
            Log(LogLevel.Narrative, $"Option #{choiceIndex} chosen");
            story.ChooseChoiceIndex(choiceIndex);
            if (!flags["echo"].Get() && story.canContinue)
            {
                string discardedLine = story.Continue();
                Log(LogLevel.Verbose, $"X»{discardedLine}");
                AutoSave();
            }
            Narrate();
        }

        public void OnVariablesChanged(Flowchart origin)
        {
            Log(LogLevel.Verbose, $"OnVariablesChange origin={origin.name}");
            if (beforeFirstSync)
            {
                Log(LogLevel.Verbose, "Still initializing, Fungus->Ink sync request ignored");
                return;
            }
            List<Variable> affectedFungusVariables;
            if (origin != null)
            {
                affectedFungusVariables = origin.Variables;
            }
            else
            {
                affectedFungusVariables = new List<Variable>();
                foreach (KeyValuePair<string, List<Flowchart>> syncVariable in syncVariables)
                {
                    // Picks the first flowchart: any flowchart is OK, it's a global variable
                    affectedFungusVariables.Add(syncVariable.Value[0].GetVariable(syncVariable.Key));
                }
            }
            bool useless = true;
            foreach (Variable fungusVariable in affectedFungusVariables)
            {
                if (fungusVariable.Scope == VariableScope.Global && syncVariables.ContainsKey(fungusVariable.Key))
                {
                    useless = false;
                    Type fungusVariableType = fungusVariable.GetValue().GetType();
                    if (fungusVariableType == typeof(int))
                    {
                        int intValue = (fungusVariable as IntegerVariable).Value;
                        Log(LogLevel.Rich, $"{fungusVariable.Key}={intValue} (Fungus->Ink)");
                        story.variablesState[fungusVariable.Key] = intValue;
                    }
                    else if (fungusVariableType == typeof(string))
                    {
                        string stringValue = (fungusVariable as StringVariable).Value;
                        Log(LogLevel.Rich, $"{fungusVariable.Key}={stringValue} (Fungus->Ink)");
                        story.variablesState[fungusVariable.Key] = stringValue;
                    }
                    else if (fungusVariableType == typeof(float))
                    {
                        float floatValue = (fungusVariable as FloatVariable).Value;
                        Log(LogLevel.Rich, $"{fungusVariable.Key}={floatValue} (Fungus->Ink)");
                        story.variablesState[fungusVariable.Key] = floatValue;
                    }
                    else if (fungusVariableType == typeof(bool))
                    {
                        bool boolValue = (fungusVariable as BooleanVariable).Value;
                        Log(LogLevel.Rich, $"{fungusVariable.Key}={boolValue} (Fungus->Ink)");
                        string[] listVariableParts = SplitFungusVariableName(fungusVariable.Key);
                        if (listVariableParts.Length <= 1)
                        {
                            story.variablesState[fungusVariable.Key] = boolValue;
                        }
                        else
                        {
                            string listName = listVariableParts[0];
                            string listItemName = listVariableParts[1];
                            InkList inkList = story.variablesState[listName] as InkList;
                            if (inkList == null)
                            {
                                Debug.LogError("Sync list mismatch: " + listName + " is not a list in Ink");
                            }
                            else
                            {
                                if (boolValue)
                                {
                                    if (!inkList.ContainsItemNamed(listItemName))
                                    {
                                        inkList.AddItem(listItemName);
                                        Log(LogLevel.Rich, listItemName + " added in Ink list " + listName);
                                    }
                                }
                                else
                                {
                                    List<InkListItem> toRemove = new List<InkListItem>();
                                    foreach (InkListItem inkListItem in inkList.Keys)
                                    {
                                        if (inkListItem.itemName == listItemName)
                                        {
                                            toRemove.Add(inkListItem);
                                        }
                                    }
                                    foreach (InkListItem inkListItem in toRemove)
                                    {
                                        inkList.Remove(inkListItem);
                                        Log(LogLevel.Rich, inkListItem.fullName + " removed from Ink list " + listName);
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        Debug.LogWarning("Sync variable skipped: " + fungusVariable.Key + " is " + fungusVariableType
                            + " in Fungus, which does not translate well to Ink");
                    }
                }
            }
            if (useless)
            {
                Debug.LogWarning("No global Fungus variables to sync, consider removing this Sync Variables command from the flowchart");
            }
        }

        private static Sprite FindPortrait(Character speaker, string portraitName)
        {
            if (speaker.Portraits.Count == 0)
            {
                return null;
            }
            Sprite bestGuess = speaker.Portraits[0];
            if (portraitName != null && speaker.Portraits.Count > 1)
            {
                string portraitNameLowerCase = portraitName.ToLowerInvariant();
                foreach (Sprite portrait in speaker.Portraits)
                {
                    string candidate = portrait.name.ToLowerInvariant();
                    if (candidate == portraitNameLowerCase)
                    {
                        return portrait;
                    }
                    if (candidate.Contains(portraitNameLowerCase))
                    {
                        bestGuess = portrait;
                    }
                }
            }
            return bestGuess;
        }

        const string AutoSaveSlot = "auto";
        const string CheckpointSaveSlot = "checkpoint";
        const string PreCheckpointSaveSlot = "precheckpoint";
        const string ManualSaveSlot = "manual";

        public void ManualSaveCheckpoint()
        {
            SaveCheckpoint(ManualSaveSlot);
        }

        public void ManualSaveSnapshot()
        {
            SaveSnapshot(ManualSaveSlot);
        }

        public void SaveCheckpoint(string slot)
        {
            Save(CheckpointSaveSlot, slot);
        }

        public void SaveSnapshot(string slot)
        {
            Save(AutoSaveSlot, slot);
        }

        public void Save(string originSlot, string destinationSlot)
        {
            if (originSlot == destinationSlot)
            {
                Debug.LogError("Save failed: origin and destination slots are the same (" + originSlot + ")");
                return;
            }
            Log(LogLevel.Verbose, "Save from " + GetSavePath(originSlot) + " to " + GetSavePath(destinationSlot));
            BroadcastToFungus(saveMessage);
            BroadcastToFungus(saveMessage + " " + destinationSlot);
            try
            {
                File.Copy(GetSavePath(originSlot), GetSavePath(destinationSlot), true);
                foreach (string flagName in flags.Keys)
                {
                    File.Copy(GetFlagSavePath(originSlot, flagName), GetFlagSavePath(destinationSlot, flagName), true);
                }
            }
            catch (Exception e)
            {
                Debug.LogError("Save failed: " + e.Message);
            }
        }

        public bool CheckKnotStitchChanged()
        {            
            string cPath = new StoryStateWrapper(story.state).cPath;
            if (cPath == null)
            {
                Debug.LogWarning("cPath is null, cannot check if knot.stitch changed");
                return false;
            }

            string knotStitch;
            string[] knotStitchEtc = cPath.Split('.');
            if (knotStitchEtc.Length <= 2 || char.IsNumber(knotStitchEtc[1], 0))
            {
                knotStitch = knotStitchEtc[0]; // only knot
            }
            else
            {
                knotStitch = knotStitchEtc[0] + '.' + knotStitchEtc[1]; // knot.stitch
            }
            Log(LogLevel.Verbose, "Current knot.stitch = " + knotStitch);
            if (knotStitch != lastKnotStitch)
            {
                lastKnotStitch = knotStitch;
                BroadcastToFungus(newKnotStitchMessage);
                BroadcastToFungus(newKnotStitchMessage + " " + knotStitch);
                return true;
            }
            return false;
        }

        IEnumerator BackgroundThreadSave(string path, string jsonState)
        {
            bool atCheckpoint = false;
            if (!loading)
            {
                atCheckpoint = CheckKnotStitchChanged();
            }
            try
            {
                if (atCheckpoint)
                {
                    SaveSnapshot(PreCheckpointSaveSlot);
                }
                File.WriteAllText(path, jsonState);
            }
            catch (Exception e)
            {
                Debug.LogError("Autosave failed at final stage: " + e.Message);
            }
            finally
            {
                story.BackgroundSaveComplete();
                if (atCheckpoint)
                {
                    SaveSnapshot(CheckpointSaveSlot);
                }
            }
            yield return null;
        }

        public void AutoSave()
        {
            string path = GetSavePath(AutoSaveSlot);
            Log(LogLevel.Verbose, "Autosave to " + path);
            try
            {
                foreach (string flagName in flags.Keys)
                {
                    File.WriteAllText(GetFlagSavePath(AutoSaveSlot, flagName), JsonUtility.ToJson(flags[flagName]));
                }
                string jsonState = story.CopyStateForBackgroundThreadSave().ToJson();
                StartCoroutine(BackgroundThreadSave(path, jsonState));
            }
            catch (Exception e)
            {
                Debug.LogError("Autosave failed at preliminary stage: " + e.Message);
            }
        }

        public void ManualLoad()
        {
            Load(ManualSaveSlot);
        }

        public void Load(string slot)
        {
            Load(slot, false);
        }

        private void Load(string slot, bool andContinue)
        {
            Log(LogLevel.Rich, "Load " + GetSavePath(slot));
            loading = !andContinue;
            BroadcastToFungus(loadMessage);
            BroadcastToFungus(loadMessage + " " + slot);
            try
            {
                string json = File.ReadAllText(GetSavePath(slot));
                story.state.LoadJson(json);
                BroadcastToFungus(loadMessage + " ok");
            }
            catch
            {
                BroadcastToFungus(loadMessage + " fail");
                return;
            }
            // This is required only because variables reset to their initial state are not notified as changed:
            SyncAllVariablesToFungus();
            menuDialog.Clear();
            if (pause)
            {
                Resume();
            }
            else
            {
                Narrate();
            }
            loading = false;
        }

        public void SwitchLanguage(string language)
        {
            Log(LogLevel.Verbose, "SwitchLanguage " + language);
            TextAsset newInk = null;
            if (language == "")
            {
                newInk = ink;
            }
            else
            {
                AlternateLanguageNarrativeDirector[] altDirectors = GetComponents<AlternateLanguageNarrativeDirector>();
                foreach (AlternateLanguageNarrativeDirector altDirector in altDirectors)
                {
                    if (altDirector.language == language)
                    {
                        newInk = altDirector.alternateInk;
                        break;
                    }
                }
            }
            if (newInk == null)
            {
                Debug.LogError("AlternateLanguageNarrativeDirector not found for language " + language);
            }
            else
            {
                Log(LogLevel.Rich, "Replacing current Ink file with " + newInk.name);
                story = new Story(newInk.text);
                Load(PreCheckpointSaveSlot, true);  // and continue to checkpoint
            }
        }

        public void SyncAllVariablesToFungus()
        {
            foreach (string syncVariableName in syncVariables.Keys)
            {
                string[] listVariableParts = SplitFungusVariableName(syncVariableName);
                if (listVariableParts.Length <= 1)
                {
                    SyncToFungus(syncVariableName, story.variablesState[syncVariableName]);
                }
                else
                {
                    SyncListToFungus(listVariableParts[0], story.variablesState[syncVariableName]);
                }                
            }
        }

        private static string GetSavePath(string slot)
        {
            return System.IO.Path.Combine(Application.persistentDataPath, slot + ".json");
        }

        private static string GetFlagSavePath(string slot, string flagName)
        {
            return System.IO.Path.Combine(Application.persistentDataPath, slot + "." + flagName + ".json");
        }

        public void ReplaceSayDialog(SayDialog sayDialog)
        {
            this.sayDialog = sayDialog;
        }

        public void ReplaceMenuDialog(MenuDialog menuDialog)
        {
            this.menuDialog = menuDialog;
        }

        private void Log(LogLevel level, string entry)
        {
            if (level >= logging)
            {
                Debug.Log(entry);
            }
        }
    }
}
