// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/CutOffShader"
{
	Properties{
		_MainTex("Main Text", 2D) = "white" {}
	_TransitionTex("Transition Texture", 2D) = "white"{}
		_CutOff("Cut Off", Range(0, 1)) = 1
		_Color("Color", Color) = (1,1,1,1)
		[MaterialToggle] _Distort("Distort", Float) = 0
		_Fade("Fade", Range(0, 1)) = 0
	}
		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
			}
			Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				sampler2D _MainTex;
				sampler2D _TransitionTex;
				float4 _MainTex_ST;
				int _Distort;
				float _Fade;
				float _CutOff;
				float4 _Color;
				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv: TEXCOORD0;
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					float2 uv: TEXCOORD1;
					float2 uv1: TEXCOORD2;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					o.uv1 = v.uv;

#if UNITY_UV_STARTS_AT_TOP
					if (_MainTex_ST.y < 0)
						o.uv1.y = 1 - o.uv1.y;
#endif
					return o;
				}

				float4 frag(v2f i) : SV_Target
				{
					fixed4 transit = tex2D(_TransitionTex, i.uv1);

					fixed2 direction = float2(0,0);
					if (_Distort)
						direction = normalize(float2((transit.r - 0.5) * 2, (transit.g - 0.5) * 2));

					fixed4 col = tex2D(_MainTex, i.uv + _CutOff * direction);

					if (transit.b < _CutOff)
						return col = lerp(col, _Color, _Fade);

					return col;
				}
				ENDCG
			}
		}
}