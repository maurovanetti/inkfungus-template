using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Save Snapshot", "Saves the Ink state at the moment when the current line of story was displayed.")]
public class SaveSnapshot : InkCommand
{
    public string slotName = "manual";

    public override string GetSummary()
    {
        return $"Save Ink snapshot in slot '{slotName}'";
    }

    public override void OnEnter()
    {
        Director().SaveSnapshot(slotName);

        Continue();
    }
}
