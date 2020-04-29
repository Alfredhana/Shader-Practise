Shader "Custom/NormalLighting"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    { 
		Tags
		{
			"LightMode" = "ForwardBase"
		}
		Pass{

			CGPROGRAM

			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD1;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = normalize(v.normal);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float ndotl = dot(i.normal, _WorldSpaceLightPos0));
				return float4(ndol, ndotl, ndotl, 0);
			}
			ENDCG
		}
    }
    FallBack "Diffuse"
}
