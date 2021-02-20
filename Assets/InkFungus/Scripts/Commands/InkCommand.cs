using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Fungus;
using InkFungus;

public abstract class InkCommand : Command
{
    private static NarrativeDirector director;    

    public override Color GetButtonColor()
    {
        return Color.white;
    }

    protected NarrativeDirector Director()
    {
        if (director == null)
        {
            director = GameObject.FindObjectOfType<NarrativeDirector>();
        }
        return director;
    }
}
