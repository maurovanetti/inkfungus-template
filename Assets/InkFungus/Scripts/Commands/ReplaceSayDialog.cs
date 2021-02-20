using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Replace Say Dialog", "Replaces the Say Dialog used by Ink.")]
public class ReplaceSayDialog : InkCommand
{
    public SayDialog sayDialog;

    public override string GetSummary()
    {
        if (sayDialog == null)
        {
            return "Error: no Say Dialog selected";
        }
        else
        {
            return $"Use Say Dialog '{sayDialog.name}' in Ink";
        }        
    }

    public override void OnEnter()
    {
        Director().ReplaceSayDialog(sayDialog);

        Continue();
    }
}
