Shader "Unlit/EyesShader"
{
    Properties
    {
        _Color ("Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        [NoScaleOffset] _EyeMask ("Eyes Mask", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _EyeMask;
            fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 mask = tex2D(_EyeMask, i.uv).rgb;
                fixed3 col = lerp(fixed3(1, 1, 1), _Color, 1.0 - mask.r) * mask.g;
                return fixed4(col, 1.0);
            }
            ENDCG
        }
    }
}
