// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ReplacementSelfTesting"{
	Properties{
			mainTex("Main Text", 2D) = "white" {}
			secondTex("Second Text", 2D) = "white" {}
			_Color("Color", Color) = (1,1,1,1)
	}
	CGINCLUDE
	sampler2D mainTex;
	sampler2D secondTex;

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv: TEXCOORD0;
	};

	struct v2f
	{
		float4 vertex : SV_POSITION;
		float2 uv: TEXCOORD1;
	};

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		return o;
	}
	ENDCG
		
		SubShader{
			Tags { "RenderType" = "Transparent" }
			Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				float4 frag(v2f i) : SV_Target
				{
					float4 color = tex2D(secondTex, i.uv);
					return color;
				}
				ENDCG
			}

		}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				float4 frag(v2f i) : SV_Target
				{
					float4 color = tex2D(mainTex, i.uv);
					return color;
				}
				ENDCG
			}
				}
}