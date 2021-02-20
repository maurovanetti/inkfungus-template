using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Replace Menu Dialog", "Replaces the Menu Dialog used by Ink.")]
public class ReplaceMenuDialog : InkCommand
{
    public MenuDialog menuDialog;

    public override string GetSummary()
    {
        if (menuDialog == null)
        {
            return "Error: no Menu Dialog selected";
        }
        else
        {
            return $"Use Menu Dialog '{menuDialog.name}' in Ink";
        }        
    }

    public override void OnEnter()
    {
        Director().ReplaceMenuDialog(menuDialog);

        Continue();
    }
}
