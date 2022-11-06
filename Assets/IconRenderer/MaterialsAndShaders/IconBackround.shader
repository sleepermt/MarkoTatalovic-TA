Shader "IconRender/Background"
{   
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off
        Ztest Always
        ZWrite Off
        
        Pass // 0 MASK WRITE
        {
            CGPROGRAM
                #include "IconUtils.cginc"
                #pragma vertex vert
                #pragma fragment frag

                sampler2D _MainTex;

                fixed4 frag (v2f i) : SV_Target
                {
                    fixed4 col = tex2D(_MainTex, i.uv);
                    
                    if (col.a == 0)
                        return col = fixed4(0, 0, 0, 0);
                    else
                        return col = fixed4(1, 1, 1, 1);

                    return col;
                }
            ENDCG
        }

        Pass // 1 => OUTLINE
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
                #include "IconUtils.cginc"
                #pragma vertex vert
                #pragma fragment frag

                #define DIV_SQRT_2 0.70710678118
                
                sampler2D _MainTex;
                
                float _OutlineWidth;
                float4 _OutlineColor;
                float _ExtendMask;
                

                fixed4 frag (v2f i) : SV_Target
                {
                    float2 directions[8] = {float2(1, 0), float2(0, 1), float2(-1, 0), float2(0, -1),
                    float2(DIV_SQRT_2, DIV_SQRT_2), float2(-DIV_SQRT_2, DIV_SQRT_2),
                    float2(-DIV_SQRT_2, -DIV_SQRT_2), float2(DIV_SQRT_2, -DIV_SQRT_2)};

                    float aspect = _ScreenParams.x * (_ScreenParams.w - 1); //width times 1/height
                    float2 sampleDistance = float2(_OutlineWidth / aspect, _OutlineWidth);
                    
                    //generate outline
                    float maxAlpha = 0;
                    for(uint index = 0; index<8; index++)
                    {
                        float2 sampleUV = i.uv + directions[index] * sampleDistance;
                        maxAlpha = max(maxAlpha, tex2D(_MainTex, sampleUV).a);
                    }

                    float4 col = lerp(tex2D(_MainTex, i.uv), _OutlineColor, 1.0 - maxAlpha);
                    if (_ExtendMask > 0.5f)
                        col.rgb = maxAlpha;
                    col.a = maxAlpha;

                    return col;
                }
            ENDCG
        }
        Pass // 2 GUASSIAN BLUR
        {
            CGPROGRAM
                #define BLUR
                #include "IconUtils.cginc"
                #pragma vertex vert
                #pragma fragment frag

                sampler2D _MainTex;
                float _size;
                float2 _direction;

                fixed4 frag (v2f i) : SV_Target
                {
                    return SeparableGuasianBlur(_MainTex, i.uv, _direction * _size);
                }
            ENDCG

        }
    

        Pass // 3 - Composite => BACKGROUND, VIGNETTE
        {
            CGPROGRAM
                #define OVERLAY
                #include "IconUtils.cginc"
                #pragma vertex vert
                #pragma fragment frag

                sampler2D _MainTex, _LightRays, _WhiteGlow, _ModelWithOutline;
                float4 _BackgroundColor;
                float _DirtOpacity;

                float _VignetteIntensity;
                float _VignetteExtend;

                float _GlowOpacity;

                float _Brightness;
                float _Contrast;
                float _Hue;
                float _Saturation;
                float _Luminance;
                float4 _GlowColor;

                float4 frag (v2f i) : SV_Target
                {
                    //Background
                    float dirt = tex2D(_MainTex, i.uv).x;
                    float rays = tex2D(_LightRays, i.uv).a * (1.0 - dot(i.uv - 0.5f, i.uv - 0.5f)*3.0);
    
                    float4 col1 = lerp(_BackgroundColor, saturate(_BackgroundColor + dirt), _DirtOpacity);

                    float2 vignetteUV =  i.uv * (1.0 - i.uv.yx);   
                    float vignette = vignetteUV.x*vignetteUV.y * _VignetteIntensity; 
                    vignette = saturate(pow(vignette, _VignetteExtend)); 

                    float4 col = saturate(col1 + rays) ;
                    float4 whiteGlow = tex2D(_WhiteGlow, i.uv);
                    float4 rays2 = BlendLinearDodge(rays , whiteGlow * _GlowColor , _GlowOpacity);
                    col = lerp(col, rays2, rays2);
                    float4 modelWithOutline = tex2D(_ModelWithOutline, i.uv);
                    col = lerp(col, modelWithOutline, modelWithOutline.a);


                    col.rgb = RGBToHSL(col.rgb) + float3(_Hue, _Saturation, _Luminance);
                    
                    col.rgb = HSLToRGB(col.rgb);
                    col.rgb = ContrastBrightness(col, _Brightness, _Contrast);
                    col *= vignette;
                    col.a = 1.0;
                    return col;
                }
            ENDCG
        }
    }
}
