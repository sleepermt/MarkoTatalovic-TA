# Blender Tools

I have developed many tools for Blender. Some of them are listed below.

Note almost all addons are created for internal use. I've provided code examples for them, but note that most of the paths for saving and loading data are hard coded, or are dependant on external libraries not provided by blender's python distribution and for our purposes we have older edited versions of blender.

## Character Icon Render

<img src="https://user-images.githubusercontent.com/16105403/200317726-32e23ed2-bcd1-4f05-8161-5c00d57560e5.png" width=20% height = 20%>

This addon allows artist to load character models from the unity project. It reads out addressable asset references assigned in visual data scriptable object inside unity project. Loads models and materials. Additionally it goes through all material yaml files and loads textures. 

<img src="https://user-images.githubusercontent.com/16105403/200318062-360eb945-e2ec-4eec-a27f-4d892d9a68b1.png" width=20% height = 20%>

Once artist setup the scene, he save the camera position for each character type. Then he can render all characters in one click. Result is saved as sprite sheet.

<img src="https://user-images.githubusercontent.com/16105403/200318413-e7dfe66e-2997-4dc1-83d8-19b1cb89c0f2.png" width=45% height = 45%>

## City Renderer

This addon allows artist to easily setup isometric rendering of each building we have in the game.

![image](https://user-images.githubusercontent.com/16105403/200318975-56193d02-6b00-4d9a-bdfe-9623745adf8c.png)


There is an Controller object that artist is using to frame the building. Once artist sets the controller's position and scale, addon finds the closest power of four size based on the controller size and pixel per unit property.

https://user-images.githubusercontent.com/16105403/200319793-536b1773-a277-4483-878a-e533b2d6a166.mp4

Artist can render each building separately or all buildings in one collection. There's additional option to render out Z pass used in building upgrade effect. 

This addon also has capability of rendering tiles to be used with unity tile renderer. It renders all tiles in one collection and saves them as sprite sheet.

<img src="https://user-images.githubusercontent.com/16105403/200319990-6e0d52f6-ceb6-43ff-b88a-4ad537b56c12.png" width=45% height = 45%>

# Other Tools

## Explode Tools


https://user-images.githubusercontent.com/16105403/200320632-6902d67c-d87d-44e3-9405-b56e44bfb000.mp4


This addon allows artist to explode mesh objects usually needed for baking normal maps or for visualisation.

## Puzzle Generator


https://user-images.githubusercontent.com/16105403/200321513-c4a63506-5146-433e-ba89-32d278b6c946.mp4


Creted this for client that prints puzzles. 
