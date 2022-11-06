# Building Upgrade Effect

 Scene: UpgradeEffect.unity
 
 Note: Set the display size to 2048x2048 to see all the buildings.



https://user-images.githubusercontent.com/16105403/200174912-18547f51-dcd0-4b58-bbd1-db9c70d0fa16.mp4



# General:

Effect made to show the upgrade of the building, or when player buys a new building. In the context of project this was made for we use addressables to spawn the effect multiple times, so the effect overlaps.



https://user-images.githubusercontent.com/16105403/200174801-e39f5b88-239d-4c18-9240-a70ef9e274ae.mp4


# How it works:

Shader uses normalized z position sprite rendered out with our internal Blender tools. Tool I've made for this goes through vertices of all objects building is made of and calculates min and max z position, which are then passed to Blender material to remap original z position into 0-1 sized domain.

![image](https://user-images.githubusercontent.com/16105403/200174828-476fd7af-dc20-4f24-a723-91028ef94773.png)


Using z Position shader sweeps the sprite from bottom to top, and when it reaches the middle it starts to fade out.
Sprite is also scaled in the vertex part of the shader to make it look like it is growing from the center of the building.

*z is vertical Axis in Blender
