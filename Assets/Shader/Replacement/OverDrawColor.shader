// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/OverDrawColor"
{
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
		}
		Pass
		{
			Blend One One
			ZTest Always
			ZWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			float4 _OverDrawColor;
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return _OverDrawColor;
			}
			ENDCG
		}
	}
}