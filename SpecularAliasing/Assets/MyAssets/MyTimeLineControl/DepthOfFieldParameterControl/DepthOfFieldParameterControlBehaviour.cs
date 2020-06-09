using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityStandardAssets.ImageEffects;

[Serializable]
public class DepthOfFieldParameterControlBehaviour : PlayableBehaviour
{
    public bool enabled;
    [Range(0,1)]
    public float aperture;
    public float focalLength;
    [Range(0,2)]
    public float focalSize;
    [Range(0,2)]
    public float maxBlurSize;
    public bool nearBlur;
    public bool visualized;
}
