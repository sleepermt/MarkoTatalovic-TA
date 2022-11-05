using UnityEngine;
using System.IO;
using UnityEditor;


[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class IconRenderer : MonoBehaviour
{
    public Color backgroundColor;
    public Color glowColor;
    public Texture2D backgroundDirtTexture;
    public Texture2D lightRaysTexture;
    [Range(0, 1)] public float dirtStrength = 1.0f;
    [Range(0, 1)] public float glowSize = 0.02f;
    [Range(0, 1)] public float glowOpacity = 1.0f;
    [Range(1, 16)] public int iterations = 1;  
    [Range(1, 100)] public float vignetteIntensity = 40f;
    [Range(0, 1)] public float vignetteExtent = 0.2f;
    [Range(0, 1)] public float outlineWidth = 1.0f;
    Material iconMaterial;
    int renderTextureSize = 512;
    static int writeMaskPass = 0;
    static int writeOutline  = 1;
    static int guassianBlurPass = 2;
    static int compositePass = 3;
    [Range(-1, 1)] public float hue = 0;
    [Range(-1, 1)] public float saturation = 0;
    [Range(-1, 1)] public float luminance = 0;
    [Range(-100, 100)] public float brightness = 0;
    [Range(-100, 100)] public float contrast = 0;
    
    int colorIdx = 0;
    string savePath = "Assets/Art/Icons/";
    Texture2D RTImage(Camera camera)
    {
        var currentRT = RenderTexture.active;
        RenderTexture target = new RenderTexture(512, 512, 24, RenderTextureFormat.Default);
        target.antiAliasing = 0;
        target.Create();

        RenderTexture.active = target;
        camera.targetTexture = target;
        camera.Render();
        
        Texture2D image = new Texture2D(512, 512);
        image.ReadPixels(new Rect(0, 0, 512, 512), 0, 0);
        image.Apply();
        
        
        RenderTexture.active = currentRT;
        target.Release();
        camera.targetTexture = null;
        return image;
    }

    public async void Render()
    {
        // var image = RTImage(Camera.main);
        // var path = savePath + "IC_" + child.gameObject.name.Substring(3) + "_" + i.ToString() + ".png";
        // File.WriteAllBytes(path, image.EncodeToPNG());   
    }

    void OnRenderImage (RenderTexture source, RenderTexture destination)
    {
        //renderTextureSize = source.width;

        if (iconMaterial == null)
        {
            iconMaterial = new Material(Shader.Find("IconRender/Background"));
            iconMaterial.hideFlags = HideFlags.HideAndDontSave;
        }

        RenderTexture mask = RenderTexture.GetTemporary(renderTextureSize, renderTextureSize, 0, source.format);
        Graphics.Blit(source, mask, iconMaterial, writeMaskPass);

        RenderTexture[] textures = new RenderTexture[16];
        RenderTexture currentDestination = textures[0] = RenderTexture.GetTemporary(renderTextureSize, renderTextureSize, 0, source.format);
        //currentDestination.antiAliasing = 0;

        iconMaterial.SetFloat("_OutlineWidth", glowSize);
        iconMaterial.SetColor("_OutlineColor", Color.white);
        iconMaterial.SetFloat("_ExtendMask", 1.0f);
        Graphics.Blit(mask, currentDestination, iconMaterial, writeOutline);

        RenderTexture.ReleaseTemporary(mask);

        RenderTexture cSource = currentDestination;
        
        
        int width = renderTextureSize;
        int height = renderTextureSize;

        int i = 1;
        
        iconMaterial.SetVector("_direction", new Vector2(1.0f, 0.0f));
        //iterations = 9;
        for (; i < iterations; i++) {
            if (i % 3 == 0)
            {
                iconMaterial.SetFloat("_size", i);
            }
            if ( i % 2 == 1)
            {
                iconMaterial.SetVector("_direction", new Vector2(0.0f, 1.0f));
                
            }   
            else 
                iconMaterial.SetVector("_direction", new Vector2(1.0f, 0.0f));

            currentDestination = textures[i] = RenderTexture.GetTemporary(width, height, 0, source.format);
            //currentDestination.antiAliasing = 0;
            Graphics.Blit(cSource, currentDestination, iconMaterial, guassianBlurPass);
            cSource = currentDestination;
        }
        


        RenderTexture modelWithOutline = RenderTexture.GetTemporary(renderTextureSize, renderTextureSize, 0, source.format);
        //modelWithOutline.antiAliasing = 0;
        iconMaterial.SetFloat("_OutlineWidth", outlineWidth);
        iconMaterial.SetColor("_OutlineColor", Color.black);
        iconMaterial.SetFloat("_ExtendMask", 0.0f);
        Graphics.Blit(source, modelWithOutline, iconMaterial, writeOutline);


        iconMaterial.SetColor("_BackgroundColor", backgroundColor);
        iconMaterial.SetTexture("_LightRays", lightRaysTexture);
        iconMaterial.SetTexture("_WhiteGlow", cSource);
        iconMaterial.SetTexture("_ModelWithOutline", modelWithOutline);
        iconMaterial.SetFloat("_DirtOpacity", dirtStrength);
        iconMaterial.SetFloat("_GlowOpacity", glowOpacity);
        iconMaterial.SetFloat("_VignetteIntensity", vignetteIntensity);
        iconMaterial.SetFloat("_VignetteExtend", vignetteExtent);

        iconMaterial.SetFloat("_Brightness", brightness);
        iconMaterial.SetFloat("_Contrast", contrast);
        iconMaterial.SetFloat("_Hue", hue);
        iconMaterial.SetFloat("_Saturation", saturation);
        iconMaterial.SetFloat("_Luminance", luminance);
        iconMaterial.SetColor("_GlowColor", glowColor);
        
        Graphics.Blit(backgroundDirtTexture, destination, iconMaterial, compositePass);
        
       
        RenderTexture.ReleaseTemporary(cSource);
        RenderTexture.ReleaseTemporary(modelWithOutline);

    }
}