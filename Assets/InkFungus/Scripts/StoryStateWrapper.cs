using UnityEngine;
using Ink.Runtime;

namespace InkFungus
{
    // This is a solution to the problem of finding the cPath for nodes with choices.

    class StoryStateWrapper
    {
        public readonly string cPath;

        public StoryStateWrapper(StoryState state)
        {                        
            cPath = state.currentPathString;
            if (cPath == null && state.currentChoices.Count > 0) {
                cPath =  state.currentChoices[0].targetPath.ToString();
            }
        }
    }
}
