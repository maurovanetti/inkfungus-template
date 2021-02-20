using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Load", "Loads the Ink state from a save slot.")]
public class Load : InkCommand
{
    public string slotName = "manual";

    public override string GetSummary()
    {
        return $"Load Ink state from slot '{slotName}'";
    }

    public override void OnEnter()
    {
        Director().Load(slotName);

        Continue();
    }
}
