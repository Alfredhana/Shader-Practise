
Shader "Custom/NormalLightingLearning"
{
	Properties{
		_Color("Diffuse Color", Color) = (1,1,1,1)
	}
		SubShader
	{
		Tags
		{
			"XRay" = "Outline"
			"LightMode" = "ForwardBase"
		}
		Pass
		{
			Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Color;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD1;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD1;
				float3 viewDir: TEXCORRD2;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex)));
				return o;
			}

float4 frag(v2f i) : SV_Target
{
	float ndotV = 1- dot(i.normal, i.viewDir) * 2;
	return float4(ndotV, ndotV, ndotV, 0);
}
			ENDCG
		}
	}
}