# Building Upgrade Effect

 Scene: UpgradeEffect.unity
 Note: Set the display size to 2048x2048 to see all the buildings.

# General:

Effect made to show the upgrade of the building, or when player buys a new building. In the context of project this was made for we use addressables to spawn the effect multiple times, so the effect overlaps.

# How it works:

Shader uses normalized z position sprite rendered out with our internal Blender tools. Tool I've made for this goes through vertices of all objects building is made of and calculates min and max z position, which are then passed to Blender material to remap original z position into 0-1 sized domain.

Using z Position shader sweeps the sprite from bottom to top, and when it reaches the middle it starts to fade out.
Sprite is also scaled in the vertex part of the shader to make it look like it is growing from the center of the building.

*z is vertical Axis in Blender