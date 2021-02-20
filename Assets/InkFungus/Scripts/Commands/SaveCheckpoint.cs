using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Save Checkpoint", "Saves the Ink state at the moment when the current knot or stitch of story started.")]
public class SaveCheckpoint : InkCommand
{
    public string slotName = "manual";

    public override string GetSummary()
    {
        return $"Save Ink checkpoint in slot '{slotName}'";
    }

    public override void OnEnter()
    {
        Director().SaveCheckpoint(slotName);

        Continue();
    }
}
