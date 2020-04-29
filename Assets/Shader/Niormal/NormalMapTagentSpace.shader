Shader "Custom/NormalMapTagentSpace"
{
	Properties{
		_MainTex("Main Text", 2D) = "white" {}
		_BumpTex("Normal Map", 2D) = "white" {}
		_BumpScale("Bump Scale", float) = 1.0
		_Color("Color", Color) = (1,1,1,1)
	}
		SubShader
		{
			Tags
			{
				"LightMode" = "ForwardBass"
			}
			Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				sampler2D _MainTex;
		float4 _MainTex_ST;
				sampler2D _BumpTex;
				float4 _BumpTex_ST;
				float _BumpScale;
				float4 _Color;
				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 uv: TEXCOORD0;
					float4 tangent : TANGENT;
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					float4 uv: TEXCOORD1;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv.xy = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					o.uv.zw = v.uv.xy * _BumpTex_ST.xy + _BumpTex_ST.zw;
					float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz) * v.tangent.w);
					float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);
					return o;
				}

				float4 frag(v2f i) : SV_Target
				{
					float4 packedNormal = tex2D(_BumpTex, i.uv.zw);
					float3 tangentNormal;

					tangentNormal.xy = (packedNormal.xy * 2 - 1) * _BumpScale;
					tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

					//tangentNormal = UnpackNormal(packedNormal);
					//tangentNormal.xy *= _BumpScale;
					//tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

					float4 color;
					color.rgb = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
					return color;
				}
				ENDCG
			}
		}
}