Shader "Custom/Lava"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Color1 ("Color1", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Range ("Range", Range(0,1)) = 0.5
        _Range2 ("Range2", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        fixed _Range;
        fixed _Range2;
        fixed4 _Color1;


        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        float random (float2 st) {
            return frac(sin(dot(st.xy, float2(12.9898,78.233)))*43758.5453123);
        }

        float noise (in float2 st) {
            float2 i = floor(st);
            float2 f = frac(st);

            // Four corners in 2D of a tile
            float a = random(i);
            float b = random(i + float2(1.0, 0.0));
            float c = random(i + float2(0.0, 1.0));
            float d = random(i + float2(1.0, 1.0));

            float2 u = f * f * (3.0 - 2.0 * f);

            return lerp(a, b, u.x) +
                    (c - a)* u.y * (1.0 - u.x) +
                    (d - b) * u.x * u.y;
        }

        #define OCTAVES 8
        float fbm (in float2 st) {
            float value = 0.0;
            float amplitude = .5;
            float frequency = 0.;

            [unroll]
            for (int i = 0; i < OCTAVES; i++) {
                value += amplitude * noise(st);
                st *= 2.;
                amplitude *= .5;
            }
            return value;
        }

        float remap(float a, float b, float t)
        {
            return (t - a) / (b - a);
        }

        void vert(inout appdata v)
		{
			float d = tex2Dlod(_DisplacementTex, float4(v.texcoord.xy, 0, 0)).r * _Displacement;
			v.vertex.xyz -= v.normal * d;
		}


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            float2 uv = IN.uv_MainTex*10;
            float2 speed = float2(0.0, _Time.x * 50);
            float a = fbm(uv * 0.5 + speed);
            float b = fbm(uv * 0.5 + speed + 1.0);
            float2 ab = float2(a,b);

            float2 r = float2(0, 0);
            r.x = fbm(float2( uv + 2.0*ab + float2(1.7,9.2)+ 0.2*_Time.x) );
            r.y = fbm(float2( uv + 4.0*ab + float2(8.3,2.8)+ 0.5*_Time.x) );

            float brownian = fbm(IN.uv_MainTex.xy * 10 + speed);//c.rgb; 
            brownian = fbm(IN.uv_MainTex.xy * brownian);//c.rgb;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = 0; 
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Emission = r.x * r.y;
            o.Alpha = 1.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
