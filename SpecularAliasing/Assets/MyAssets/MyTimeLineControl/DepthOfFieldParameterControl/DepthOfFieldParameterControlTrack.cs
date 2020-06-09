using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.Collections.Generic;
using UnityStandardAssets.ImageEffects;

[TrackColor(0.259434f, 0.629717f, 1f)]
[TrackClipType(typeof(DepthOfFieldParameterControlClip))]
[TrackBindingType(typeof(DepthOfField))]
public class DepthOfFieldParameterControlTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
        return ScriptPlayable<DepthOfFieldParameterControlMixerBehaviour>.Create (graph, inputCount);
    }

    // Please note this assumes only one component of type DepthOfField on the same gameobject.
    public override void GatherProperties (PlayableDirector director, IPropertyCollector driver)
    {
#if UNITY_EDITOR
        DepthOfField trackBinding = director.GetGenericBinding(this) as DepthOfField;
        if (trackBinding == null)
            return;

        // These field names are procedurally generated estimations based on the associated property names.
        // If any of the names are incorrect you will get a DrivenPropertyManager error saying it has failed to register the name.
        // In this case you will need to find the correct backing field name.
        // The suggested way of finding the field name is to:
        // 1. Make sure your scene is serialized to text.
        // 2. Search the text for the track binding component type.
        // 3. Look through the field names until you see one that looks correct.
        driver.AddFromName<DepthOfField>(trackBinding.gameObject, "m_Enabled");
        driver.AddFromName<DepthOfField>(trackBinding.gameObject, "aperture");
        driver.AddFromName<DepthOfField>(trackBinding.gameObject, "focalLength");
        driver.AddFromName<DepthOfField>(trackBinding.gameObject, "focalSize");
        driver.AddFromName<DepthOfField>(trackBinding.gameObject, "maxBlurSize");
        driver.AddFromName<DepthOfField>(trackBinding.gameObject, "nearBlur");
#endif
        base.GatherProperties (director, driver);
    }
}
