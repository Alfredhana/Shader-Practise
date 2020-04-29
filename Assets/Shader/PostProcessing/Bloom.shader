Shader "Custom/Bloom"
{
    Properties
    {
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Bloom("Bloom", 2D) = "black" {}
		_LuminanceThreshold("Threshold", Float) = 0.5
		_BlurSize("Blur Size", Float) = 1.0
	}
		SubShader
		{
			CGINCLUDE
			sampler2D _MainTex;
			half4 _MainTex_TexelSize;
			sampler2D _Bloom;
			float _LuminanceThreshold;
			float _BlurSize；

			struct appdata {
				float4 vertex : POSITION;
				half2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD1;
			};

			v2f vertExtractBright(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed luminance(fixed4 c) {
				return 0.2125 * c.r + 0.7154 * c.g + 0.0721 * c.b;
			}

			fixed4 fragExtractBright(v2f i) : SV_Target{
				fixed4 c = tex2D(_Maintex, i.uv);
				// 截取範圍到0 至 1
				fixed val = clamp(luminance(c) - _LuminanceThreshold, 0.0, 1.0);
				return c * val;
			}

			struct v2fBloom {
				float4 pos : SV_POSITION;
				half4 uv : TEXCOORD1;
			};

			v2fBloom vertBloom(appdata v) {
				v2fBloom o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.uv.xy = v.uv;
				o.uv.zw = v.uv;

				#if UNITY_UV_STARTS_AT_TOP
				if (_MainTex_TexelSize.y < 0.0)
					o.uv.w = 1.0 - o.uv.w;
				#endif
				return o;
			}

			fixed4 fragBloom(v2fBloom) : SV_Target{
				return tex2D(_MainTex, i.uv.xy) + tex2D(_Bloom, i.uv.zw);
			}
			ENDCG

			ZWrite off ZTest Always Cull off
			pass {
				CGPROGRAM
				#pragma vert vertExtractBright
				#pragma frag fragExtractBright
				ENDCG
			}

			UsePass "Custom/GaussianBlur/GAUSSIAN_BLUR_VERTICAL"
			UsePass "Custom/GaussianBlur/GAUSSIAN_BLUR_HORIZONTAL"

			pass {
				CGPROGRAM
				#pragma vert vertBloom
				#pragma frag fragBloom
				ENDCG
			}

		}
    FallBack "Diffuse"
}
