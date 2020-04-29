// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DoubleTransparent" {
	Properties{
			_MainTex("Main Text", 2D) = "white" {}
			_SecondTex("Second Text", 2D) = "white" {}
			_DisplacementTex("Displacement", 2D) = "white"{}
			_Magnitude("Magnitude", float) = 1.0
	}
		SubShader{
			Tags { "Queue" = "Transparent" }
			CGINCLUDE
			sampler2D _MainTex;
			sampler2D _SecondTex;

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
				Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha
				ZWrite Off
				Cull Back
				CGPROGRAM
					sampler2D _DisplacementTex;
				float _Magnitude;
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				float4 frag(v2f i) : SV_Target
				{ 
					float2 distuv = float2(i.uv.x + _Time.x * 2, i.uv.y + _Time.x * 2);

					float2 disp = tex2D(_DisplacementTex, distuv).xy;
					disp = ((disp * 2) - 1) * _Magnitude;

					float4 color = tex2D(_SecondTex, i.uv + disp);
					return color;
				}
					ENDCG
			}
				Pass
				{
					Blend SrcAlpha OneMinusSrcAlpha
					ZWrite Off
					Cull Back
					CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				float4 frag(v2f i) : SV_Target
				{
					float4 color = tex2D(_MainTex, i.uv);
					return color;
				}
				ENDCG
			}
				
	}
}