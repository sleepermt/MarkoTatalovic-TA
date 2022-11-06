# Icon Renderer

Scene: IconRenderer.unity
Note: Please set the display resolution in Game preview window to 512x512
This is an extracted version of the code, renderTexture sizes are hardcoded to 512x512 to avoid running out of memory issues on your machine.
Its supposed to be used in Editor



https://user-images.githubusercontent.com/16105403/200177016-42b099e7-5d4f-43f6-bed6-d1158af153ca.mp4



# General:

Tool made for rendering of the icons for the game. It uses postprocessing effects to render the icons, and then saves them to the disk. Original tool goes through all the heroes/items instantiates them, loads materials, and renders them. This version is what i was able to extract from the original tool.

Some of the icons from our game rendered with this tool:

![IC_W_Sword_0](https://user-images.githubusercontent.com/16105403/200177091-52ad1f5d-a6ad-46ea-9e70-83783009eb1a.png)
![IC_W_Sword_1](https://user-images.githubusercontent.com/16105403/200177096-704169ba-f727-4130-8cc0-da0665de8782.png)
![IC_W_Sword_2](https://user-images.githubusercontent.com/16105403/200177099-6a51c118-720b-456a-b303-b055026ddcb4.png)
![IC_W_Sword_3](https://user-images.githubusercontent.com/16105403/200177103-bbdb63c5-2555-4746-b985-e95675ac2c21.png)



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
There's also a `IconUtils.cginc` shader file with many helper functions that emulate photoshop blending modes as well as separable gaussian blur.
