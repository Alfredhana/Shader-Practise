Shader "Custom/VertexAnimation"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Magnitude("Magnitude", Float) = 1
		_Frequency("Frequency", Float) = 1
		_WaveLength("Wave Length", Float) = 1
		_Speed("Speed", Float) = 0.5
    }
    SubShader
    {
		Tags { "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" "DisableBatching" = "True" }

		Pass{
			Tags{"LightMode" = "ForwardBase"}
			ZWrite off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull off

			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Magnitude;
			fixed _Frequency;
			fixed _WaveLength;
			fixed _Speed;
			fixed4 _Color;

			struct a2f {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv: TEXCOORD1;
			};

			v2f vert(a2f v) {
				v2f o;
				float4 offset;
				offset.yzw = float3(0.0, 0.0, 0.0);
				offset.x = sin(_Frequency * _Time.y + v.vertex.x * _WaveLength + v.vertex.y * _WaveLength + v.vertex.z * _WaveLength) * _Magnitude;
				o.pos = UnityObjectToClipPos(v.vertex + offset);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex) ;
				o.uv += float2(0.0, _Time.y * _Speed);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				fixed4 c = tex2D(_MainTex, i.uv);
				c.rgb *= _Color.rgb;
				return c;
			}
			ENDCG
		}
    }
    FallBack "Transparent/VertexLit"
}
