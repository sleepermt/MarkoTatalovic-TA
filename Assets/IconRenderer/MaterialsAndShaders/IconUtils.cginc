struct appdata_icon
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
};

v2f vert (appdata_icon v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    return o;
}



#ifdef BLUR
    fixed4 SeparableGuasianBlur(sampler2D text, float2 uv, float2 direction){
        fixed4 col = fixed4(0.0, 0.0, 0.0, 0.0);

        float2 off1 = float2(1.411764705882353, 1.411764705882353)  * direction;
        float2 off2 = float2(3.2941176470588234, 3.2941176470588234) * direction;
        float2 off3 = float2(5.176470588235294, 5.176470588235294)  * direction;
        col += tex2D(text, uv) * 0.1964825501511404;
        col += tex2D(text, uv + (off1 / _ScreenParams.xy)) * 0.2969069646728344;
        col += tex2D(text, uv - (off1 / _ScreenParams.xy)) * 0.2969069646728344;
        col += tex2D(text, uv + (off2 / _ScreenParams.xy)) * 0.09447039785044732;
        col += tex2D(text, uv - (off2 / _ScreenParams.xy)) * 0.09447039785044732;
        col += tex2D(text, uv + (off3 / _ScreenParams.xy)) * 0.010381362401148057;
        col += tex2D(text, uv - (off3 / _ScreenParams.xy)) * 0.010381362401148057;
        return col;
    }
#endif

float blendLinearDodge(float base, float blend) {
	// Note : Same implementation as BlendAddf
	return min(base+blend,1.0);
}

float4 BlendLinearDodge(float4 base, float4 blend) {
	// Note : Same implementation as BlendAdd
	return min(base+blend,float4(1.0, 1.0, 1.0, 1.0 ));
}

float4 BlendLinearDodge(float4 base, float4 blend, float opacity) {
	return (BlendLinearDodge(base, blend) * opacity + base * (1.0 - opacity));
}

#ifdef OVERLAY
    float4 Overlay(float4 d, float4 s)
    {
        return (d < 0.5) ? 2.0 * s * d : 1.0 - 2.0 * (1.0 - s) * (1.0 - d);
    }
    float4 Overlay(float4 d, float s)
    {
        return (d < 0.5) ? 2.0 * s * d : 1.0 - 2.0 * (1.0 - s) * (1.0 - d);
    }
#endif


#define FLT_EPSILON 1.192092896e-07F

float4 ContrastBrightness(float4 col, float brightnessControl, float contrastControl)
{
    
    float a, b;
    float brightness = brightnessControl;
    float contrast = contrastControl;
  
    brightness /= 100.0f;
    float delta = contrast / 200.0f;

    /*
    * The algorithm is by Werner D. Streidt
    * (http://visca.com/ffactory/archives/5-99/msg00021.html)
    * Extracted of OpenCV demhist.c
    */

    if (contrast > 0) {
        a = 1.0f - delta * 2.0f;
        a = 1.0f / max(a, FLT_EPSILON);
        b = a * (brightness - delta);
    }
    else {
        delta *= -1;
        a = max(1.0f - delta * 2.0f, 0.0f);
        b = a * brightness + delta;
    }
  
    float4 result = col * a + b;
    result.a = col.a;
    
    return result;

}

float3 RGBToHSL(float3 color)
{
	float3 hsl; // init to 0 to avoid warnings ? (and reverse if + remove first part)
	
	float fmin = min(min(color.r, color.g), color.b);    //Min. value of RGB
	float fmax = max(max(color.r, color.g), color.b);    //Max. value of RGB
	float delta = fmax - fmin;             //Delta RGB value

	hsl.z = (fmax + fmin) / 2.0; // Luminance

	if (delta == 0.0)		//This is a gray, no chroma...
	{
		hsl.x = 0.0;	// Hue
		hsl.y = 0.0;	// Saturation
	}
	else                                    //Chromatic data...
	{
		if (hsl.z < 0.5)
			hsl.y = delta / (fmax + fmin); // Saturation
		else
			hsl.y = delta / (2.0 - fmax - fmin); // Saturation
		
		float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
		float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
		float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;

		if (color.r == fmax )
			hsl.x = deltaB - deltaG; // Hue
		else if (color.g == fmax)
			hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
		else if (color.b == fmax)
			hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue

		if (hsl.x < 0.0)
			hsl.x += 1.0; // Hue
		else if (hsl.x > 1.0)
			hsl.x -= 1.0; // Hue
	}

	return hsl;
}

float HueToRGB(float f1, float f2, float hue)
{
	if (hue < 0.0)
		hue += 1.0;
	else if (hue > 1.0)
		hue -= 1.0;
	float res;
	if ((6.0 * hue) < 1.0)
		res = f1 + (f2 - f1) * 6.0 * hue;
	else if ((2.0 * hue) < 1.0)
		res = f2;
	else if ((3.0 * hue) < 2.0)
		res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
	else
		res = f1;
	return res;
}

float3 HSLToRGB(float3 hsl)
{
	float3 rgb;
	
	if (hsl.y == 0.0)
		rgb = float3(hsl.z, hsl.z, hsl.z); // Luminance
	else
	{
		float f2;
		
		if (hsl.z < 0.5)
			f2 = hsl.z * (1.0 + hsl.y);
		else
			f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);
			
		float f1 = 2.0 * hsl.z - f2;
		
		rgb.r = HueToRGB(f1, f2, hsl.x + (1.0/3.0));
		rgb.g = HueToRGB(f1, f2, hsl.x);
		rgb.b= HueToRGB(f1, f2, hsl.x - (1.0/3.0));
	}
	
	return rgb;
}