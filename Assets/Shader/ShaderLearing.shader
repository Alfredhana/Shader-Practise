// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ShaderLearning"
{
	Properties{
		_MainTex("Main Text", 2D) = "white" {}
		_DisplacementTex("Displacement Texture", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0, 1)) = 0
			
			_SecondTex("Second Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
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
			sampler2D _SecondTex;
			float _Tween;
			sampler2D _DisplacementTex;
			float _Magnitude;		
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
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			/*

			float4 frag(v2f i) : SV_Target
			{
				float2 distuv = float2(i.uv.x + _Time.x * 2, i.uv.y + _Time.x * 2);
				float2 disp = tex2D(_DisplacementTex, distuv).xy;
				disp = ((disp * 2) - 1) * _Magnitude;

				float4 col = tex2D(_MainTex, i.uv + disp);
				return col;
			}*/

			float4 frag(v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.uv);
				float lum = color.r * 0.3 + color.g * 0.59 + color.b * 0.11;
				float4 grayscale = float4(lum, lum, lum, color.a);
				return grayscale * _Color;
			}
			ENDCG
		}
	}
}