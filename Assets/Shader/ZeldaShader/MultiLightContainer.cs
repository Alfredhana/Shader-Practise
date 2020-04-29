using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LightCollection;

namespace LightCollection
{
    [ExecuteInEditMode]
    public class MultiLightContainer : MonoBehaviour
    {
        public Transform[] pointLits;
        private Light[] pointLightList;
        private MultiLitTag[] lightTagLight;
        public Transform hero;

        public void Start()
        {
            pointLightList = new Light[pointLits.Length];
            lightTagLight = new MultiLitTag[pointLits.Length];
            for (int n = 0; n < pointLightList.Length; n++)
            {
                pointLightList[n] = pointLits[n].GetComponent<Light>() as Light;
                lightTagLight[n] = pointLits[n].GetComponent<MultiLitTag>() as MultiLitTag;

            }
        }

        public void FixedUpdate()
        {
            Vector4[] litPosList = new Vector4[10];
            Vector4[] litColList = new Vector4[10];
            for (int n = 0; n < pointLightList.Length; n++)
            {

                litPosList[n] = new Vector4(pointLits[n].position.x,
                    pointLits[n].position.y,
                    pointLits[n].position.z,
                    lightTagLight[n].shakeStrength
                    );
                litColList[n] = new Vector4(
                    pointLightList[n].color.g,
                    pointLightList[n].color.b,
                    pointLightList[n].range
                    );
                //pointLits[n].RotateAround(hero.position, Vector3.up, 1.0f);
            }
            Shader.SetGlobalFloat("_LitCount", pointLits.Length);
            Shader.SetGlobalVectorArray("_LitPosList", litPosList);
            Shader.SetGlobalVectorArray("_LitColList", litColList);
        }
    }
}