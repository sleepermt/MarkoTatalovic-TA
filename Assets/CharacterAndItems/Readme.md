# Characters and Items

Scene: CharactersAndItems.unity

## General:

My work on characters and items consisted of following:
1. Retopology of the models from the high poly(all the characters base body and some of the items)
2. Rigging and weighting of the characters with rigify addon (blend file is provided)

![image](https://user-images.githubusercontent.com/16105403/200188851-72e8aece-05d9-430e-ad4c-744fe07a2531.png)

3. Making workflow for artist to follow in regards to uv mapping and texturing
4. Custom Shader and material setup for characters and items
5. Devising a way to have multiple characters sharing same body but have differend hair, noses, ears, skin color etc.
6. Devising a way to have items be equipable by different character types.

<img src="https://user-images.githubusercontent.com/16105403/200189468-bc3b792e-fce3-45f4-a370-4b55b08267e5.png" width=30% height=30%>
<img src="https://user-images.githubusercontent.com/16105403/200189498-dfbd269b-5002-4067-8fc8-775f204e15a5.png" width=30% height=30%>
<img src="https://user-images.githubusercontent.com/16105403/200189542-40d2b5f7-2010-40d6-bbb1-9ea238aa9df4.png" width=30% height=30%>
<img src="https://user-images.githubusercontent.com/16105403/200189780-465b8e93-f574-40c9-aa44-feac05277629.png" width=30% height=30%>


## Shader:

Using custom wrap diffuse shading to get fake subsurface and soft shadows effect in combination with Blinn–Phong model and rim lighting.

### Maps:

There are 41 characters and 164 items in the in game.
We have 4 unique textures for all the characters, and about 22 unique textures for the items. One of my tasks on this project was to use as little textures as possible so I have created shaders that use textures with channel packing, and have helped artists to pack as much of the item models uvs together as possible.

<img src="https://user-images.githubusercontent.com/16105403/200190487-7ff33f27-d398-4e06-8b08-4c7ea82078c8.png" width=30% height=30%>

1. Materials use one _NAC texture which holds X and Y compnents of the baked normals in the red and green channel and ambient occlusion in the blue channel, and finally curvature in the alpha channel. Z compnenent of the normal is reconstructed in the fragment shader using the formula: `sqrt(1 - x^2 - y^2)`

https://user-images.githubusercontent.com/16105403/200189011-af38c742-3ceb-4674-a5d1-a463ac5cc08a.mp4

2. Mask map if item/character needs to have different colors on different parts of the model

### Curvature:

Curvature maps are blended in as a subtle effect to make the model features more pronounced.

<img width="250" alt="c1bc3c882ba21d79aec3e2441a09a6ee" src="https://user-images.githubusercontent.com/16105403/200187897-cfc501b8-1df0-4b0f-8b19-77ac7ffc0293.png">
<img width="250" alt="2e6a0755bd578a6e995520b19243d6e1" src="https://user-images.githubusercontent.com/16105403/200187900-276fd1e1-1cbc-4f48-ba4a-be518027da7e.png">

Finally there is small vertical gradient across the model (which ideally would be in object space but since in this game objects never go below 0 in y direction I never bothered)

<img src="https://user-images.githubusercontent.com/16105403/200188105-6c346601-a3b6-4140-8e31-bf7c9843ee77.png" width=30% height=30%>
<img src="https://user-images.githubusercontent.com/16105403/200188127-0f45e0f3-d251-439a-8af4-8d8bae8d2e2e.png" width=30% height=30%>

Shader also has secondary outline pass implemented using inverted hull approach which can be disabled with the `NO_OUTLINE` define.

<img src="https://user-images.githubusercontent.com/16105403/200188791-14d340d5-6cc7-4847-b85c-8252423b8914.png" width=30% height=30%>











