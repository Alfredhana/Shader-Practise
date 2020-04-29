using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementShaderEffect : MonoBehaviour
{
    public Shader ReplacementShader;
    public Texture mainTex;
    public Texture secondTex;

    private void OnValidate()
    {
        //Shader.SetGlobalColor("_OverDrawColor", color);
        Shader.SetGlobalTexture("mainTex", mainTex);
        Shader.SetGlobalTexture("secondTex", secondTex);
    }

    private void OnEnable()
    {
        if (ReplacementShader != null)
            GetComponent<Camera>().SetReplacementShader(ReplacementShader, "RenderType");
    }

    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
