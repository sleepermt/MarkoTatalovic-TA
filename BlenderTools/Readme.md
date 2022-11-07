# Blender Tools

I have developed many tools for Blender. Some of them are listed below.

Note almost all addons are created for internal use. I've provided code examples for them, but note that most of the paths for saving and loading data are hard coded, or are dependant on external libraries not provided by blender's python distribution and for our purposes we have older edited versions of blender.

## Character Icon Render

This addon allows artist to load character models from the unity project. It reads out addressable asset references assigned in visual data scriptable object inside unity project. Loads models and materials. Additionally it goes through all material yaml files and loads textures. 

Once artist setup the scene, he save the camera position for each character type. Then he can render all characters in one click. Result is saved as sprite sheet.

## City Renderer

This addon allows artist to easily setup isometric rendering of each building we have in the game.

There is an Controller object that artist is using to frame the building. Once artist sets the controller's position and scale, addon finds the closest power of four size based on the controller size and pixel per unit property.

Artist can render each building separately or all buildings in one collection. There's additional option to render out Z pass used in building upgrade effect. 

This addon also has capability of rendering tiles to be used with unity tile renderer. It renders all tiles in one collection and saves them as sprite sheet.

# Other Tools

## Explode Tools

This addon allows artist to explode mesh objects usually needed for baking normal maps or for visualisation.

## Puzzle Generator

Creted this for client that prints puzzles. 