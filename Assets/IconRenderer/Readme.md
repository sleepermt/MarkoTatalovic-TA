# Icon Renderer

Scene: IconRenderer.unity
Note: Please set the display resolution in Game preview window to 512x512
This is an extracted version of the code, renderTexture sizes are hardcoded to 512x512 to avoid running out of memory issues on your machine.
Its supposed to be used in Editor

# General:

Tool made for rendering of the icons for the game. It uses postprocessing effects to render the icons, and then saves them to the disk. Original tool goes through all the heroes/items instantiates them, loads materials, and renders them. This version is what i was able to extract from the original tool.

Later we swtiched to rendering icons in Blender.

# How it works:

The tool was designed to emulate what our artist was doing in photoshop with layers. Separate passes are rendered into separate render textures, and blended together in the end.

1. Dirt texture is blended with the backround color.
2. Result of the first step is then blended with the rays texture.
3. Mask of the model is rendered with the outline shader, then is blured with the gaussian blur shader to achive glow effect which is finally multiplied with the glow color.
4. Blend step 3 with the result of the step 2.
5. Render the model with the outline shader and blend in with previous steps.
6. Blend the original model render with previous steps
7. Add vignete effect to the result of the previous step.
8. And finally there are simple color correction properties artist can tweak. 

Shader file used for rendering has multiple passes which are used in postprocessing stack. Each pass renders a different effect.
There's also a IconUtils.cginc shader file with many helper functions that emulate photoshop blending modes as well as separable gaussian blur.