using UnityEditor;
using UnityEngine;
using UnityEngine.Playables;
using UnityStandardAssets.ImageEffects;

[CustomPropertyDrawer(typeof(DepthOfFieldParameterControlBehaviour))]
public class DepthOfFieldParameterControlDrawer : PropertyDrawer
{
    public override float GetPropertyHeight (SerializedProperty property, GUIContent label)
    {
        int fieldCount = 7;
        return fieldCount * EditorGUIUtility.singleLineHeight;
    }

    public override void OnGUI (Rect position, SerializedProperty property, GUIContent label)
    {
        SerializedProperty enabledProp = property.FindPropertyRelative("enabled");
        SerializedProperty apertureProp = property.FindPropertyRelative("aperture");
        SerializedProperty focalLengthProp = property.FindPropertyRelative("focalLength");
        SerializedProperty focalSizeProp = property.FindPropertyRelative("focalSize");
        SerializedProperty maxBlurSizeProp = property.FindPropertyRelative("maxBlurSize");
        SerializedProperty nearBlurProp = property.FindPropertyRelative("nearBlur");
        SerializedProperty visualizedProp = property.FindPropertyRelative("visualized");

        Rect singleFieldRect = new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight);
        EditorGUI.PropertyField(singleFieldRect, enabledProp);

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, apertureProp);

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, focalLengthProp);

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, focalSizeProp);

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, maxBlurSizeProp);

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, nearBlurProp);

        singleFieldRect.y += 2*EditorGUIUtility.singleLineHeight;
        EditorGUI.LabelField(singleFieldRect, "Drag Timeline to Update \"Visualized\"");

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, visualizedProp);
    }
}
