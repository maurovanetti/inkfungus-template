using System;
using UnityEngine;

namespace Ink.Runtime
{
    // This is a very dirty solution to the problem of finding the cPath for nodes with choices.

    class StoryStateWrapper
    {
        [Serializable]
        public class CurrentChoices
        {
#pragma warning disable 649
            public string targetPath;
#pragma warning restore 649     
        }

        [Serializable]
        public class MinimalStoryState {
#pragma warning disable 649
            public CurrentChoices[] currentChoices;
#pragma warning restore 649
        }

        MinimalStoryState minState;
        string cPath;

        public StoryStateWrapper(StoryState state)
        {
            minState = JsonUtility.FromJson<MinimalStoryState>(state.ToJson());
            cPath = state.currentPathString;
        }
        
        public string CPath
        {
            get {
                if (cPath != null) { return cPath; }
                else if (minState.currentChoices.Length > 0) { return minState.currentChoices[0].targetPath; }
                else { return null; }
            }
        }        
    }
}
