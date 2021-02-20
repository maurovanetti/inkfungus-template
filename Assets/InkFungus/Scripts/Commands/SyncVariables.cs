using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Sync Variables", "Synchronizes updated variables in this Flowchart with the variables in the same name in the Ink script.")]
public class SyncVariables : InkCommand
{
    public override string GetSummary()
    {
        return "Sync updated variables with Ink";
    }

    public override void OnEnter()
    {
        Director().OnVariablesChanged(GetFlowchart());

        Continue();
    }
}
