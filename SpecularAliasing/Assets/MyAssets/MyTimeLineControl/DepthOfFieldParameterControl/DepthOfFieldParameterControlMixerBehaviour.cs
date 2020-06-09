using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityStandardAssets.ImageEffects;

public class DepthOfFieldParameterControlMixerBehaviour : PlayableBehaviour
{
    bool m_DefaultEnabled;
    float m_DefaultAperture;
    float m_DefaultFocalLength;
    float m_DefaultFocalSize;
    float m_DefaultMaxBlurSize;
    bool m_DefaultNearBlur;
    bool m_DefaultVisualized;

    bool m_AssignedEnabled;
    float m_AssignedAperture;
    float m_AssignedFocalLength;
    float m_AssignedFocalSize;
    float m_AssignedMaxBlurSize;
    bool m_AssignedNearBlur;
    bool m_Visualized;

    DepthOfField m_TrackBinding;

    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        m_TrackBinding = playerData as DepthOfField;

        if (m_TrackBinding == null)
            return;

        if (m_TrackBinding.enabled != m_AssignedEnabled)
            m_DefaultEnabled = m_TrackBinding.enabled;
        if (!Mathf.Approximately(m_TrackBinding.aperture, m_AssignedAperture))
            m_DefaultAperture = m_TrackBinding.aperture;
        if (!Mathf.Approximately(m_TrackBinding.focalLength, m_AssignedFocalLength))
            m_DefaultFocalLength = m_TrackBinding.focalLength;
        if (!Mathf.Approximately(m_TrackBinding.focalSize, m_AssignedFocalSize))
            m_DefaultFocalSize = m_TrackBinding.focalSize;
        if (!Mathf.Approximately(m_TrackBinding.maxBlurSize, m_AssignedMaxBlurSize))
            m_DefaultMaxBlurSize = m_TrackBinding.maxBlurSize;
        if (m_TrackBinding.nearBlur != m_AssignedNearBlur)
            m_DefaultNearBlur = m_TrackBinding.nearBlur;
        if (m_TrackBinding.visualizeFocus != m_Visualized)
            m_DefaultVisualized = m_TrackBinding.visualizeFocus;

        int inputCount = playable.GetInputCount ();

        float blendedAperture = 0f;
        float blendedFocalLength = 0f;
        float blendedFocalSize = 0f;
        float blendedMaxBlurSize = 0f;
        float totalWeight = 0f;
        float greatestWeight = 0f;
        int currentInputs = 0;

        for (int i = 0; i < inputCount; i++)
        {
            float inputWeight = playable.GetInputWeight(i);
            ScriptPlayable<DepthOfFieldParameterControlBehaviour> inputPlayable = (ScriptPlayable<DepthOfFieldParameterControlBehaviour>)playable.GetInput(i);
            DepthOfFieldParameterControlBehaviour input = inputPlayable.GetBehaviour ();
            
            blendedAperture += input.aperture * inputWeight;
            blendedFocalLength += input.focalLength * inputWeight;
            blendedFocalSize += input.focalSize * inputWeight;
            blendedMaxBlurSize += input.maxBlurSize * inputWeight;
            totalWeight += inputWeight;

            if (inputWeight > greatestWeight)
            {
                m_AssignedEnabled = input.enabled;
                m_TrackBinding.enabled = m_AssignedEnabled;
                m_AssignedNearBlur = input.nearBlur;
                m_TrackBinding.nearBlur = m_AssignedNearBlur;
                m_Visualized = input.visualized;
                m_TrackBinding.visualizeFocus = m_Visualized;
                greatestWeight = inputWeight;
            }

            if (!Mathf.Approximately (inputWeight, 0f))
                currentInputs++;
        }

        m_AssignedAperture = blendedAperture + m_DefaultAperture * (1f - totalWeight);
        m_TrackBinding.aperture = m_AssignedAperture;
        m_AssignedFocalLength = blendedFocalLength + m_DefaultFocalLength * (1f - totalWeight);
        m_TrackBinding.focalLength = m_AssignedFocalLength;
        m_AssignedFocalSize = blendedFocalSize + m_DefaultFocalSize * (1f - totalWeight);
        m_TrackBinding.focalSize = m_AssignedFocalSize;
        m_AssignedMaxBlurSize = blendedMaxBlurSize + m_DefaultMaxBlurSize * (1f - totalWeight);
        m_TrackBinding.maxBlurSize = m_AssignedMaxBlurSize;

        if (currentInputs != 1 && 1f - totalWeight > greatestWeight)
        {
            m_TrackBinding.enabled = m_DefaultEnabled;
            m_TrackBinding.nearBlur = m_DefaultNearBlur;
            m_TrackBinding.visualizeFocus = m_DefaultVisualized;
        }
    }
}
