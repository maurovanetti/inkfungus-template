using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

[CommandInfo("Ink", "Jump To", "Jump to a specified knot or stitch of the Ink story. Use the dot-separated format: 'knot' or 'knot.stitch'.")]
public class JumpTo : InkCommand
{
    public string knotOrStitch;

    public override string GetSummary()
    {
        return $"Jump to '{knotOrStitch}' in Ink";
    }

    public override void OnEnter()
    {
        Director().JumpTo(knotOrStitch);

        Continue();
    }
}
