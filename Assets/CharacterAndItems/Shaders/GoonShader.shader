Shader "Unlit/GoonShader"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        [Toggle(DEBUG)] _DEBUG ("DEBUG", Float) = 0
        [NoScaleOffset] _NormalMap ("Normal Map", 2D) = "white" {}
        [NoScaleOffset] _CurvatureMap ("Curvature Map", 2D) = "white" {}
        [NoScaleOffset] _AmbientMap ("Ambient Map", 2D) = "white" {}
        [NoScaleOffset] _NormalAoCurvature ("NAOC", 2D) = "white" {}
        [NoScaleOffset] _Mask ("Mask", 2D) = "white" {}
        [Toggle(SECONDARY_COLOR)] _SECONDARY_COLOR ("SECONDARY COLOR", Float) = 0
        [Toggle(_NO_OUTLINE)] _NO_OUTLINE ("NO OUTLINE", Float) = 0
        
        _PrimaryColor ("Primary Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _PrimarySubsurfaceColor ("Subsurface Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _SecondaryColor   ("Secondary Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _SecondarySubsufraceColor ("Secondary Subsufrace Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _SpecularColor   ("Specular Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _RimColor ("Rim Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _SubsurfacePower ("Subsurface Power", Float) = 1
        _SubsurfaceScale ("Subsurface Scale", Float) = 1
        _SpecularPower ("Specular Power", Float) = 1

        _OutlineWidth ("Outline Width", Float) = 0.1
        _OutlineColor ("Outline Depth Offset", Float) = 0.5     
        _OutlineColor ("Outline Color", Color) = (0.0, 1.0, 0.0, 1.0)


        //_HSV ("_HSV", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma shader_feature DEBUG
            #pragma shader_feature SECONDARY_COLOR

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;
                float3 tspace0 : TEXCOORD2;
                float3 tspace1 : TEXCOORD3;
                float3 tspace2 : TEXCOORD4;
                float3 viewDir : TEXCOORD5;
            };

            #ifdef DEBUG
                sampler2D _NormalMap;
                sampler2D _CurvatureMap;
                sampler2D _AmbientMap;
            #else
                sampler2D _NormalAoCurvature;
            #endif
            //sampler2D _HSV;
            
            //float4 _MainTex_ST;
            float4 _PrimaryColor;
            float4 _PrimarySubsurfaceColor;
            float4 _SpecularColor;
            float _SubsurfacePower;
            float _SubsurfaceScale;
            float _SpecularPower;
            float4 _RimColor;

            #ifdef SECONDARY_COLOR
                sampler2D _Mask;
                float4 _SecondaryColor;
                float4 _SecondarySubsufraceColor;
            #endif
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
                half3 wNormal = UnityObjectToWorldNormal(v.normal);
                o.normal = wNormal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                half3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.viewDir = UnityWorldSpaceViewDir(o.worldPos);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            inline float wrapDiffuse(float3 normal, float3 lightVector, float w)
            {
                return max(0.0, pow((dot(lightVector, normal) + w), _SubsurfacePower) / (1.0 + w));
            }

            fixed4 frag (v2f i, fixed facing : VFACE) : SV_Target
            {
                float3 worldNormal;

                #ifdef DEBUG
                
                    float3 tnormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                    float ao = tex2D(_AmbientMap, i.uv);
                    float curvature = tex2D(_CurvatureMap, i.uv).r;
                #else
                    float4 normalAmbientCurvature = tex2D(_NormalAoCurvature, i.uv);
                    float3 tnormal = float3(normalAmbientCurvature.rg * 2.0 - 1.0, 0.0);
                    tnormal.z = sqrt(1.0 - tnormal.x*tnormal.x - tnormal.y * tnormal.y);
                    float ao = normalAmbientCurvature.b;
                    float curvature = normalAmbientCurvature.a;
                #endif

                worldNormal.x = dot(i.tspace0, tnormal);
                worldNormal.y = dot(i.tspace1, tnormal);
                worldNormal.z = dot(i.tspace2, tnormal);

                worldNormal = normalize(worldNormal);

                float4 col = float4(0.0, 0.0, 0.0, 1.0);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float NdotL = max(0.0, dot(worldNormal, lightDir));
                float3 viewDir = normalize(i.viewDir);
                float3 H = normalize(lightDir + viewDir);
                float NdotH = dot(worldNormal, H);

                float w = wrapDiffuse(worldNormal, lightDir, _SubsurfaceScale ) ;
                #ifdef SECONDARY_COLOR
                    float r = tex2D(_Mask, i.uv);
                    col = lerp(_PrimaryColor, _SecondaryColor, r) * NdotL;
                    float4 subsC = lerp(_PrimarySubsurfaceColor, _SecondarySubsufraceColor, r);
                    float4 subs = subsC * w + saturate(curvature * 2.0f - 1.0f) * 0.5f;
                    col += subs;
                    float intensity = pow(saturate(NdotH), 15.0) * (1.0 - r);
                #else
                
                    col = NdotL * _PrimaryColor;
                    float4 subs = _PrimarySubsurfaceColor * w + saturate(curvature * 2.0f - 1.0f) * 0.5f;
                    col += subs;
                    float intensity = pow(saturate(NdotH), 15.0);
                #endif

                col += intensity * _SpecularColor * _SpecularPower;
                col *= saturate(curvature * 2.0) * ao;
                col += max(0.0, (1.0 - dot(viewDir, worldNormal) * 2)) * .3 * _RimColor;
                col *= saturate(i.worldPos.y * 4 + 0.2);
                col *= facing > 0 ? 1.0 : 0.15;
                col.a = 1;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    Pass {
            
            Cull Front

            CGPROGRAM

            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram
            #pragma shader_feature _NO_OUTLINE

            half4 _OutlineColor;
            half _OutlineWidth;
            half _OutlineDepthOffset;

            float4 VertexProgram(float4 position : POSITION, float3 normal : NORMAL) : SV_POSITION {
                float4 clipPosition = UnityObjectToClipPos(position);
                float3 clipNormal = mul((float3x3) UNITY_MATRIX_VP, mul((float3x3) UNITY_MATRIX_M, normal));
                float2 offset = normalize(clipNormal.xy) / _ScreenParams.xy * _OutlineWidth * clipPosition.w * 2.0; //COMMENT(Fuxna): we multiply by w component of clip space so further the vertex is line is thicker)
                clipPosition.xy += offset;
                clipPosition.z -= _OutlineDepthOffset;
                return clipPosition;
            }

            half4 FragmentProgram() : SV_TARGET {
                #ifdef _NO_OUTLINE
                    discard;
                #endif
                return _OutlineColor;
            }
            ENDCG
        }
    }
}
