using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class DepthOfFieldParameterControlClip : PlayableAsset, ITimelineClipAsset
{
    public DepthOfFieldParameterControlBehaviour template = new DepthOfFieldParameterControlBehaviour ();

    public ClipCaps clipCaps
    {
        get { return ClipCaps.Blending; }
    }

    public override Playable CreatePlayable (PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<DepthOfFieldParameterControlBehaviour>.Create (graph, template);
        return playable;
    }
}
