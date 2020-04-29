using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class XRayReplacement : MonoBehaviour
{
    public Shader XRayShader;
    private void OnEnable()
    {
        GetComponent<Camera>().SetReplacementShader(XRayShader, "XRay");
    }
    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
