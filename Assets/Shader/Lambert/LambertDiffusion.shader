Shader "Custom/LambertDiffusion"
{
    Properties
    {
        _Diffuse("Diffuse",Color) = (1,1,1,1)
		_Outline("Outline", Range(0,1)) = 0.02
		_OutlineColor("OutlineColor", Color) = (0, 0, 0, 1)
    }
    SubShader
    {
		Pass{
			Tags {"RenderType" = "Opaque" "LightMode" = "ForwardBase" 
			"XRay" = "Outline"}

			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};

			float4 _Diffuse;
			float _Outline;
			fixed4 _OutlineColor;

			v2f vert(appdata v) {
				v2f o;
				float3 normal = v.normal;
				v.vertex.xyz += normal * _Outline;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target {
				return fixed4(_OutlineColor.rgb, 1);
			}
			ENDCG
		}

		Pass{
			Tags {"LightMode" = "ForwardBase"}

			Cull Back

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};

			float4 _Diffuse;

			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				return o;
			}

			float4 frag(v2f i) : SV_Target {
				// 半蘭伯特光照模型
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				float dotL = 0.5 + 0.5 * dot(i.worldNormal, worldLight);
				if (dotL > 0.9) {
					dotL = 1;
				}
				else if (dotL > 0.5){
					dotL = 0.6;
				}
				else
				{
					dotL = 0;
				}
				float lightIndensity = dotL > 0 ? 1 : 0;
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * dotL ;
				return float4(diffuse + ambient , 1.0);
			}
			ENDCG
		}
    }
    FallBack "Diffuse"
}
