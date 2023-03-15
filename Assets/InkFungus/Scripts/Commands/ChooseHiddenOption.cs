using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

namespace InkFungus
{
    [CommandInfo("Ink", "Choose Hidden Option", "Chooses a hidden option in a branching point of the Ink story.")]
    public class ChooseHiddenOption : InkCommand
    {
        public StringData optionLabel;

        public override string GetSummary()
        {
            return $"Choose hidden option '{optionLabel.GetDescription()}' in Ink";
        }

        public override void OnEnter()
        {
            Director().OnHiddenOptionChosen(optionLabel.Value);

            Continue();
        }
    }
}
