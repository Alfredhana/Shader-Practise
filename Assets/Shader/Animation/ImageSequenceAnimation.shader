// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ImageSequenceAnimation"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Image Sequence", 2D) = "white" {}
		_HorizontalAmount("Horizontal Amount", Float) = 4
		_VerticalAmount("Vertical Amount", Float) = 4
		_Speed("Speed", Range(1,100)) = 30
    }
    SubShader
    {
		Pass{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			Zwrite off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			struct a2f {
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f {
				float4 pos: SV_POSITION;
				float2 uv: TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _HorizontalAmount;
			fixed _VerticalAmount;
			fixed _Speed;
			fixed4 _Color;

			v2f vert(a2f v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) :SV_Target{
				// floor 向下取整
				//_Time.y = Time.timeSinceLevelLoad 自場景加載后所經過的時間
				float time = floor(_Time.y * _Speed);
				float row = floor(time / _HorizontalAmount);
				float column = time - row * _HorizontalAmount;
				//half2 uv = float2(i.uv.x / _HorizontalAmount, i.uv.y / _VerticalAmount);
				//uv.x += column / _HorizontalAmount;
				//uv.y -= row / _VerticalAmount;
				half2 uv = i.uv + half2(column, -row);
				uv.x /= _HorizontalAmount;
				uv.y /= _VerticalAmount;
				fixed4 c = tex2D(_MainTex, uv);
				c.rgb *= _Color;
				return c;
			}
			ENDCG
		}
        
    }
    FallBack "Diffuse"
}
