using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Resume Narrative", "Starts or resumes the Ink story.")]
public class ResumeNarrative : InkCommand
{
    public override string GetSummary()
    {
        return "Start or resume Ink";
    }

    public override void OnEnter()
    {
        Director().Resume();

        Continue();
    }
}
