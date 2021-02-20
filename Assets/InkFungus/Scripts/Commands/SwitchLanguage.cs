using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Switch Language", "Changes the language used by the Ink script.\nLeave the language code empty to indicate the default language.")]
public class SwitchLanguage : InkCommand
{    
    public string languageCode = "";   

    public override string GetSummary()
    {
        if (languageCode == "")
        {
            return "Restore Ink to default language";
        }
        else
        {
            return $"Switch Ink to language '{languageCode}'";
        }
    }

    public override void OnEnter()
    {
        Director().SwitchLanguage(languageCode);

        Continue();
    }
}
