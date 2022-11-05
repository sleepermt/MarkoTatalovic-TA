Shader "Sprites/UpgradeEffect"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
        _Scale ("Scale", Range(0, 1)) = 0
		_Alpha ("Alpha", Range(0, 1)) = 0
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
			};
			
			fixed4 _Color;
            fixed _Alpha;
			fixed _Scale;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex * lerp(1.00 , 1.25, _Scale));
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float _AlphaSplitEnabled;

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if UNITY_TEXTURE_ALPHASPLIT_ALLOWED
				if (_AlphaSplitEnabled)
					color.a = tex2D (_AlphaTex, uv).r;
#endif //UNITY_TEXTURE_ALPHASPLIT_ALLOWED

				return color;
			}
			
			fixed4 frag(v2f IN) : SV_Target
			{
                fixed4 mask = SampleSpriteTexture (IN.texcoord);
				fixed bias = mask.r * 2.0 - 1.0;
				fixed lPos = (_Scale * -2.0 + 1.0) * 1.2;
				fixed l = 1.0 - smoothstep(0.0, 0.1, abs(bias + lPos));
                fixed f = (_Alpha * 0.8 + l * 0.2 );

				f = saturate(f);
                mask.a *= f;
				
				return _Color * mask.a;
			}
		ENDCG
		}
	}
}