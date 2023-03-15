using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

namespace InkFungus
{
    [CommandInfo("Ink", "Choose Option", "Chooses an option in a branching point of the Ink story.")]
    public class ChooseOption : InkCommand
    {
        public IntegerData optionIndex;

        public override string GetSummary()
        {
            return $"Choose option '{optionIndex.GetDescription()}' in Ink";
        }

        public override void OnEnter()
        {
            Director().OnOptionChosen(optionIndex.Value);

            Continue();
        }
    }
}
