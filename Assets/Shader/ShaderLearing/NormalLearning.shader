﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/NormalLearning"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
		SubShader
		{
Tags
{
	"LightMode" = "ForwardBase"
}
			Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				sampler2D _MainTex;
				#include "UnityCG.cginc"

#include "Lighting.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					float3 normal : NORMAL;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.normal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
					return o;
				}

				float4 frag(v2f i) : SV_Target
				{
					return saturate(dot(i.normal, _WorldSpaceLightPos0));
				}
				ENDCG
			}
		}
}
