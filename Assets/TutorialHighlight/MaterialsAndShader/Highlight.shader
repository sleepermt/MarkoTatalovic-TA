Shader "UI/Highlight"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
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
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            Name "Default"
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float4 _Transform;
            //float _DimAll;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                OUT.worldPosition = v.vertex;
                OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

                OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                OUT.color = v.color * _Color;
                return OUT;
            }

            #define SPEED 5
            #define RATIO float2(_ScreenParams.x/_ScreenParams.y, 1)
            #define RADIUS 0.005

            float msign(in float x) {return (x < 0.0) ? -1.0 : 1.0; }
                
            float2 sdBox( in float2 p, in float2 b, in float r )
            {
                float2 q = abs(p)-b;
                
                return float2( 
                    
                    (3.0+msign(p.x))*(b.x+b.y+1.570796*r) + msign(p.y*p.x)*
                    (b.y + ((q.y>0.0)?r*((q.x>0.0)?atan2(q.y,q.x):1.570796)+max(-q.x,0.0):q.y)),
                    
                    min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r );
            }
            float2 polarCoord(float2 pos, float RadialScale, float LengthScale)
            {
                float radius = length(pos) * 2 * RadialScale;
                float angle = atan2(pos.x, pos.y) * 1.0/6.28 * LengthScale;
                return float2(radius, angle);
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;

                float2 uv = IN.texcoord.xy;
                float2 pos =  (uv.xy - _Transform.xy) * RATIO;
                float2 extents = _Transform.zw * RATIO * 0.5;  

                float2 transformedUV = sdBox(pos, extents, RADIUS);
                float box = 1.0 - smoothstep(0.0,1.0,sqrt(abs(transformedUV.y)/0.4));
                float perimeter = 4.0*(extents.x+extents.y+1.570796*RADIUS);
                float r = 1.0 - smoothstep(0.0,0.006,abs(transformedUV.y));

                transformedUV = transformedUV * 2/perimeter  + float2(_Time.y * SPEED * 0.05 / perimeter, 1.0);
                r = frac(1.0 - transformedUV.x) * r;
                box *= smoothstep(0.0, 1.0, sin(_Time.y*SPEED)) * 0.6;
                
                float4 c = (box + r) * IN.color;
                #ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif
                return c;
            }
        ENDCG
        }
    }
}