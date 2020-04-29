Shader "Custom/BillBarding"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_VerticalBillBoarding("Vertical Restrains", Range(0,1)) = 1
    }
    SubShader
    { 
		Tags { "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" "DisableBatching" = "True" }
		Pass{
			Tags { "LightMode"="ForwardBase"}
			ZWrite off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull off

			CGPROGRAM

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Colr;
			float _VerticalBillBoarding;
			struct a2f {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv: TEXCOORD1;
				float4 pos : SV_POSITION;
			};

			v2f vert(a2f v) {
				v2f o;
				float3 center = float3(0.0, 0.0, 0.0);
				float3 viewDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));
				float3 normalDir = viewDir - center;
				normalDir.y = normalDir.y * _VerticalBillBoarding;
				normalDir = normalize(normalDir);
				float3 upDir = abs(normalDir.y) > 0.999 ? float3(0, 0, 1) : float3(0, 1, 0);
				float3 rightDir = normalize(cross(upDir, normalDir));
				upDir = normalize(normalDir, rightDir);
				float3 centerOffs = v.vertex.xyz - center;
				float3 localPos = center + rightDir * centerOffs.x + upDir * ccenterOffs.y + normalDir * centerOffs.z;
				o.pos = UnityObjectClipPos(float4(localPos,1));
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
