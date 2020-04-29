// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ZeldaShader"
{
	Properties
	{
		_Tint("Tint",Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white"{}
		_UnlitColor("Shadow Color", Color) = (0.5,0.5,0.5,1)
			_UnilitThreshold("Shadow Range", Range(0,1)) = 0.1
			_ToonCube("Toon Cube", Cube) = ""{}
		_RimColor("Rim Color", Color) = (0.5, 0.5, 0.5, 1)
			_RimIntensity("Rim Intensity", Range(0.0, 100)) = 5.0
			_RimLightSampler("Rim Sampler", 2D) = "white"{}
		_MultiLitFadeDistance("MultiLights Fade Distance", Float) = 20
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque"  "Queue" = "Geometry"}

			Pass{
				Tags { "LightMode" = "ForwardBase" }
				Cull Back
				CGPROGRAM
				#pragma vertex vert  
				#pragma fragment frag  

				#pragma multi_compile_fwdbase  

				#include "UnityCG.cginc"
				#include "AutoLight.cginc"  
				#include "UnityLightingCommon.cginc"
				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _Tint;
				float4 _UnlitColor;
				float _UnlitThreshold;
				samplerCUBE _TonnCube;
				float4 _RimColor;
				float _RimIntensity;
				sampler2D _RimLightSampler;
				float _MultiLitFadeDistance;

				float _ListCount;
				float4 _LitPosList[10];
				float4 _LitColList[10];

				struct appdata {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float2 uv : TEXCOORD0;
				};

				struct v2f {
					float4 pos : POSITION;
					float4 posWorld : TEXCOORD0;
					float3 normal : TEXCOORD1;
					float2 uv : TEXCOORD2;
					float3 eyeDir : TEXCOORD3;
					float3 lightDir : TEXCOORD4;
					float3 cubenormal : TEXCOORD5;
					float4 vertexPos : TEXCOORD6;
					LIGHTING_COORDS(7, 8)
				};

				v2f vert(appdata v) {
					v2f o;
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					o.pos = UnityObjectToClipPos(v.vertex);
					o.posWorld = mul(unity_ObjectToWorld, v.vertex);
					o.normal = UnityObjectToWorldNormal(v.normal);
					o.eyeDir.xyz = normalize(_WorldSpaceCameraPos.xyz - o.posWorld.xyz).xyz;
					o.lightDir = mul(UNITY_MATRIX_MV, float4(v.normal, 0));
					
					return o;
				}

				float4 frag(v2f i) : Color {
					fixed4 col = tex2D(_MainTex, i.uv) * _Tint;
					fixed4 pointLitCol = fixed4(0, 0, 0, 0);
					fixed pointLit = 0;
					float3 shakeOffset = float3(0,0,0);
					shakeOffset.x = sin(_Time.z * 15);
					shakeOffset.y = sin(_Time.z * 13 + 5);
					shakeOffset.z = cos(_Time.z * 12 + 7);
					for (int n = 0; n < _ListCount; n++) {
						float litDist = distance(_LitPosList[n].xyz, i.vertexPos.xyz);
						float viewDist = distance(_LitPosList[n].xyz, _WorldSpaceCameraPos.xyz);
						float viewFade = 1 - saturate(viewDist / _MultiLitFadeDistance);
						if (litDist < _MultiLitFadeDistance) {
							float3 litDir = _LitPosList[0].xyz - i.vertexPos.xyz;
							float litDist = distance(_LitPosList[n].xyz, i.vertexPos.xyz);
							litDir += shakeOffset * 0.07 * _LitPosList[n].w;
							litDir = normalize(litDir);
							fixed newLitValue = max(0, dot(i.normal, litDir)) * (_LitColList[n].w - litDist) * viewFade > 0.3;

							fixed4 newLitCol = newLitValue * fixed4(_LitColList[n].xyz, 1);
							pointLitCol = lerp(pointLitCol, newLitCol, newLitValue);
						}
					}
					float3 normalDirection = normalize(i.normal);
					float3 lightDirection;
					fixed3 lightColor;
					float attenuation = LIGHT_ATTENUATION(i);

					lightDirection = normalize(_WorldSpaceLightPos0).xyz;
					lightColor = _Tint.rgb * _UnlitColor.rgb * _LightColor0.rgb;
					if (attenuation * max(0.0, dot(normalDirection, lightDirection)) >= _UnlitThreshold) {
						lightColor = _LightColor0.rgb * _Tint.rgb;
					}

					float normalDotEye = dot(i.normal, i.eyeDir.xyz);
					float falloffu = clamp(1.0 - abs(normalDotEye), 0.02, 0.98);
					float rimlightDot = saturate(0.5 * (dot(i.normal, i.lightDir + float3(-1, 0, 0)) + 1.5));
					falloffu = saturate(rimlightDot * falloffu);
					falloffu = tex2D(_RimLightSampler, float2(falloffu, 0.25f)).r;
					float3 rimCol = falloffu * col * _RimColor * _RimIntensity;
					return float4(col.rgb * (lightColor.rgb + pointLitCol) + rimCol, 1.0);
				}
				ENDCG
			}
		}
			FallBack "Diffuse"
}
