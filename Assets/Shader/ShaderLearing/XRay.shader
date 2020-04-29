Shader "Custom/XRay"
{
	Properties{
		_Color("Diffuse Color", Color) = (1,1,1,1)
		_XRayColor("ZTest Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Pass
		{
			Stencil {
			  Ref 4
			  Comp always
			  Pass replace
			  ZFail keep
			}
			Tags
			{
				"Queue" = "Transparent"
			}

			Blend SrcAlpha OneMinusSrcAlpha

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
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				float3 norm = normalize(v.normal);
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return _Color;
			}
			ENDCG
		}
		Pass
		{
			Stencil {
				Ref 3
				Comp Greater
				Fail Keep
				Pass Replace
			}
			Tags
			{
				"Queue" = "Transparent"
			}

			ZWrite Off
			ZTest Always
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _XRayColor;

			struct appdata
			{
				float4 vertex : POSITION; 
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o; 
				float3 norm = normalize(v.normal); 
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return _XRayColor;
			}
			ENDCG
		}
	}
}