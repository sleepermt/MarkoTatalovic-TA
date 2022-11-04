Shader "UI/ClubIcons"
{
	Properties
	{
		[Header(SHAPES)]
		[Space(20)]
		_MainTex ("Sprite Texture", 2D) = "white" {}
		[Toggle(INDEX_FROM_VERTEX_DATA)] _indexFromVertexData ("Read Indicies from Vertex Data", Float) = 0

		[NoScaleOffset] _Shield ("Shield Texture Array", 2DArray) = "white" {}
		_ShieldIndex("Shield Index", Range(0, 4)) = 0
		
        [NoScaleOffset] _Symbol ("Symbol Texture Array", 2DArray) = "white" {}
		_SymbolIndex("Symbol Index", Range(0, 4)) = 0
		
		[NoScaleOffset] _Banner ("Banner Texture Array", 2DArray) = "white" {}
		_BannerIndex ("Banner Index", Range(0, 3)) = 0
		
		[Space(50)]

		[Header(COLORS)]
		[Space(20)]
		_FlagColorSchemeIdx ("Flag Color Scheme Idx", Range(0, 4.1)) = 0
        _PrimaryColorIdx 	("Primary Color Index", Range(0, 32)) = 0
        _SecondaryColorIdx 	("Secondary Color Index", Range(0, 32)) = 0
        _TertiaryColorIdx 	("Tertiary Color Index", Range(0, 32)) = 0
        _QuartenaryColorIdx ("Quartenary Color Index", Range(0, 32)) = 0
        _QuinaryColorIdx 	("Quinary Color Index", Range(0, 32)) = 0

		[Space(20)]
		[Toggle(USE_TEXTURE_PALLETE)] _use_texture_pallete ("Use Texture for Color Pallete", Float) = 0
        [NoScaleOffset] _IconColors ("Icon Colors", 2D) = "white" {}

		[Space(50)]
		[Header(DEBUG)]
		[Space(20)]
		[Toggle(DEBUG)] _debugOn ("Debug On", Float) = 0
		
        _ShieldOuterShadow ("Shield Outer Shadow", Range(0.5, 1.0)) = 0.758
        _ShieldInnerShadow ("Shield Inner Shadow", Range(0.5, 0.001)) = 0.273
        _FlagOuterShadow ("Flag Outer Shadow", Range(0, 1)) = 0.143
		_Lighting ("Lighting", Range(0, 2)) = 1.978
        _SymbolOuterEdge ("Symbol Outer Edge", Float) = 0.65
        _SymbolInnerEdge ("Symbol Inner Edge", Float) = 0.45

		[HideInInspector]_StencilComp ("Stencil Comparison", Float) = 8
        [HideInInspector]_Stencil ("Stencil ID", Float) = 0
        [HideInInspector]_StencilOp ("Stencil Operation", Float) = 0
        [HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
        [HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255

        [HideInInspector]_ColorMask ("Color Mask", Float) = 15
		
	}
	
	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
		}

		Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

		Cull Off
		Lighting Off
		ZTest [unity_GUIZTestMode]
		ZWrite Off
		Blend One OneMinusSrcAlpha
		ColorMask [_ColorMask]

		Pass
		{
		CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature INDEX_FROM_VERTEX_DATA
			#pragma shader_feature USE_TEXTURE_PALLETE
			#pragma shader_feature DEBUG
            #ifndef INDEX_FROM_VERTEX_DATA
                #pragma multi_compile_instancing 
				#include "UnityCG.cginc"
            #endif
			
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				
				#ifdef INDEX_FROM_VERTEX_DATA
					float3 texcoord :TEXCOORD0;
					fixed4 colIdx : TEXCOORD1;	// Index Into Color Pallete
					fixed4 ssbf : TEXCOORD2; 	// Shield Symbol Banner FlagScheme
				#else
					float2 texcoord : TEXCOORD0;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
				#endif
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				

				#ifdef INDEX_FROM_VERTEX_DATA
					float3 texcoord :TEXCOORD0;
					fixed4 colIdx : TEXCOORD1;	// Index Into Color Pallete
					fixed4 ssbf : TEXCOORD2; 	// Shield Symbol Banner FlagScheme
				#else
					float2 texcoord : TEXCOORD0;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
				#endif
			};
			 
			v2f vert(appdata_t IN)
			{
				v2f OUT;

				#ifdef INDEX_FROM_VERTEX_DATA
					OUT.colIdx = IN.colIdx;
					OUT.ssbf = IN.ssbf;
                #else
                    UNITY_SETUP_INSTANCE_ID(IN);
                    UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				#endif

				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				return OUT;
			}

			#ifdef USE_TEXTURE_PALLETE
				#define pxSize 0.03125 // 1 / 32
				#define GET_COLOR(idx) tex2D(_IconColors, float2(IN.texcoord.x * pxSize + idx * pxSize , 0))
				sampler2D _IconColors;
			#else
				static const fixed4 ColorPallete[32] = 
					{
						fixed4(0.13725, 0.13725, 0.13725, 1.0),
						fixed4(0.81176, 0.81176, 0.81176, 1.0),
						fixed4(0.45882, 0.45882, 0.45882, 1.0),
						fixed4(0.80784, 0.09804, 0.14902, 1.0),
						fixed4(0.67059, 0.04314, 0.14118, 1.0),
						fixed4(0.71765, 0.07059, 0.14510, 1.0),
						fixed4(0.76741, 0.08235, 0.14510, 1.0),
						fixed4(0.94510, 0.35294, 0.13333, 1.0),

						fixed4(0.95686, 0.44706, 0.12941, 1.0),
						fixed4(0.96471, 0.53333, 0.12157, 1.0),
						fixed4(0.97255, 0.61176, 0.10980, 1.0),
						fixed4(0.98824, 0.69020, 0.08627, 1.0),
						fixed4(1.00000, 0.77647, 0.04314, 1.0),
						fixed4(1.00000, 0.86275, 0.00000, 1.0),
						fixed4(0.98824, 0.94118, 0.00784, 1.0),
						fixed4(0.81961, 0.86667, 0.14902, 1.0), 

						fixed4(0.60784, 0.79216, 0.23529, 1.0),
						fixed4(0.36078, 0.72941, 0.28235, 1.0),
						fixed4(0.01569, 0.67843, 0.30980, 1.0),
						fixed4(0.00000, 0.65882, 0.37255, 1.0),
						fixed4(0.01569, 0.69020, 0.52157, 1.0),
						fixed4(0.01569, 0.72549, 0.66667, 1.0),
						fixed4(0.21176, 0.75686, 0.82353, 1.0),
						fixed4(0.27843, 0.76078, 0.94510, 1.0),

						fixed4(0.17647, 0.63922, 0.86275, 1.0),
						fixed4(0.11765, 0.53725, 0.79216, 1.0),
						fixed4(0.00392, 0.44314, 0.72941, 1.0),
						fixed4(0.01569, 0.36078, 0.67451, 1.0),
						fixed4(0.23922, 0.32941, 0.64706, 1.0),
						fixed4(0.39608, 0.39020, 0.61961, 1.0),
						fixed4(0.50980, 0.23922, 0.59216, 1.0),
						fixed4(0.63529, 0.21961, 0.59608, 1.0)
					};
				#define GET_COLOR(idx) ColorPallete[idx]		
			#endif
			
			#define sUvs (IN.texcoord * 30.0)
			#define checkeredUV floor(IN.texcoord*7)
            #define isEqual(a, b) 1.0 - abs(sign(a-b))
            #define flagScheme1 (lerp(secondaryColor,	primaryColor, 		step(IN.texcoord.x, 0.5)))
            #define flagScheme2 (lerp(primaryColor,		secondaryColor, 	step(IN.texcoord.y, 0.5)))
            #define flagScheme3 (lerp(tertiaryColor, 	flagScheme1, 		step(1.0 - IN.texcoord.y, 0.5)))
            #define flagScheme4 (lerp(primaryColor, 	secondaryColor, 	step(0, (sin(sUvs.x + sUvs.y)))))
			#define flagScheme5 (lerp(primaryColor, 	secondaryColor,		fmod(checkeredUV.x + checkeredUV.y, 2.0)))

			UNITY_DECLARE_TEX2DARRAY(_Shield);
			UNITY_DECLARE_TEX2DARRAY(_Symbol);
			UNITY_DECLARE_TEX2DARRAY(_Banner);

			#ifdef INDEX_FROM_VERTEX_DATA
				#define SHIELD_IDX 				IN.ssbf.x
				#define SYMBOL_IDX 				IN.ssbf.y
				#define BANNER_IDX 				IN.ssbf.z
				#define FLAGSCHEME_IDX 			IN.ssbf.w
				#define PRIMARY_COLOR_IDX 		IN.colIdx.x
				#define SECONDARY_COLOR_IDX		IN.colIdx.y
				#define TERTIARY_COLOR_IDX		IN.colIdx.z
				#define QUARTENARY_COLOR_IDX	IN.colIdx.w
				#define QUINARY_COLOR_IDX		IN.texcoord.z
			#else
				UNITY_INSTANCING_BUFFER_START(Props)
					UNITY_DEFINE_INSTANCED_PROP(int, _ShieldIndex)
					UNITY_DEFINE_INSTANCED_PROP(int, _SymbolIndex)
					UNITY_DEFINE_INSTANCED_PROP(int, _BannerIndex)
					UNITY_DEFINE_INSTANCED_PROP(int, _FlagColorSchemeIdx)
					UNITY_DEFINE_INSTANCED_PROP(int, _PrimaryColorIdx)
					UNITY_DEFINE_INSTANCED_PROP(int, _SecondaryColorIdx)
					UNITY_DEFINE_INSTANCED_PROP(int, _TertiaryColorIdx)
					UNITY_DEFINE_INSTANCED_PROP(int, _QuartenaryColorIdx)
					UNITY_DEFINE_INSTANCED_PROP(int, _QuinaryColorIdx)
				UNITY_INSTANCING_BUFFER_END(Props)	
				#define I(a) UNITY_ACCESS_INSTANCED_PROP(Props, a)
				#define SHIELD_IDX 				I(_ShieldIndex)
				#define SYMBOL_IDX 				I(_SymbolIndex)
				#define BANNER_IDX 				I(_BannerIndex)
				#define FLAGSCHEME_IDX 			I(_FlagColorSchemeIdx)
				#define PRIMARY_COLOR_IDX 		I(_PrimaryColorIdx)
				#define SECONDARY_COLOR_IDX		I(_SecondaryColorIdx)
				#define TERTIARY_COLOR_IDX		I(_TertiaryColorIdx)
				#define QUARTENARY_COLOR_IDX	I(_QuartenaryColorIdx)
				#define QUINARY_COLOR_IDX		I(_QuinaryColorIdx)
			#endif
			

			#ifdef DEBUG
				float _ShieldOuterShadow;
				float _ShieldInnerShadow;
				float _FlagOuterShadow;
				float _Lighting;
				float _SymbolOuterEdge;
				float _SymbolInnerEdge;
			#else
				#define _ShieldOuterShadow 0.758
				#define _ShieldInnerShadow 0.273
				#define _FlagOuterShadow 0.143
				#define _Lighting 1.978
				#define _SymbolOuterEdge 0.65
				#define _SymbolInnerEdge 0.45
			#endif
			
			fixed4 frag(v2f IN) : SV_Target
			{
                #ifndef INDEX_FROM_VERTEX_DATA
                    UNITY_SETUP_INSTANCE_ID(IN);
                #endif
				               
                // COLORS		
				fixed4 primaryColor 	= GET_COLOR (	PRIMARY_COLOR_IDX    );
				fixed4 secondaryColor 	= GET_COLOR (	SECONDARY_COLOR_IDX  );
				fixed4 tertiaryColor 	= GET_COLOR (	TERTIARY_COLOR_IDX   );
				fixed4 quartenaryColor 	= GET_COLOR (	QUARTENARY_COLOR_IDX );
				fixed4 quinaryColor 	= GET_COLOR (	QUINARY_COLOR_IDX    );	
				
                // SHIELD SHADOW
				fixed shieldShape = UNITY_SAMPLE_TEX2DARRAY(_Shield, float4(IN.texcoord.xy, SHIELD_IDX, 0));
                fixed shieldOuterShadow = smoothstep(0.5, _ShieldOuterShadow, shieldShape);
                fixed shieldInnerShadow = smoothstep(_ShieldInnerShadow, 0.1, shieldShape);

                // FLAG 
                fixed flagShape = smoothstep(_FlagOuterShadow, .1, shieldShape); 
                
                fixed4 	flagColor 	= lerp(primaryColor, 	flagScheme1, 	isEqual( FLAGSCHEME_IDX, 1));
                		flagColor	= lerp(flagColor, 		flagScheme2, 	isEqual( FLAGSCHEME_IDX, 2));
                		flagColor	= lerp(flagColor, 		flagScheme3, 	isEqual( FLAGSCHEME_IDX, 3));
                		flagColor	= lerp(flagColor, 		flagScheme4, 	isEqual( FLAGSCHEME_IDX, 4));
						flagColor	= lerp(flagColor, 		flagScheme5, 	isEqual( FLAGSCHEME_IDX, 5));

				// SYMBOL
                fixed symbolShape = UNITY_SAMPLE_TEX2DARRAY(_Symbol, float4(IN.texcoord.xy * 1.75 - 0.375, SYMBOL_IDX, 0));
				fixed symbolOuterEdge = smoothstep(0.63, _SymbolOuterEdge, symbolShape);
				fixed symbolInnerEdge = 1.0 - smoothstep(_SymbolInnerEdge, 0.50, symbolShape);

				symbolShape = saturate(symbolOuterEdge + symbolInnerEdge);

				// BANNER
				fixed2 banner = UNITY_SAMPLE_TEX2DARRAY(_Banner, float4(IN.texcoord.xy, BANNER_IDX, 0));;
				fixed bannerOutsideEdge = smoothstep(0.5, 0.45, banner.x);
				fixed bannerInnerEdge = smoothstep(0.60, 0.55, banner.x);
				
				fixed b = (bannerOutsideEdge - bannerInnerEdge)+ banner.y;

				// LIGHTING
                fixed grad = 1.0 - abs(IN.texcoord.x - 0.5) * _Lighting;

				// RESULT
				fixed4 c = 1.0 - saturate(shieldOuterShadow + shieldInnerShadow); 
                c *= quinaryColor * (IN.texcoord.y); //Vertical Light
                c = saturate(c + flagShape * flagColor * grad);
				c = lerp(symbolShape * quartenaryColor , c , symbolOuterEdge) * (IN.texcoord.x + IN.texcoord.y)*1.5;
                c = saturate(lerp(((b + 0.5) * quinaryColor) * bannerOutsideEdge, c ,  step(0.6, banner.x)));

				// ALPHA
				c.a = step(step(0.8, shieldShape) * step(0.6, banner.x), 0);
				c.rgb*=c.a;

				return c;
            }
		ENDCG
		}
	}
}