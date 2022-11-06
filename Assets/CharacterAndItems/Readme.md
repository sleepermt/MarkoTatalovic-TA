# Characters and Items

Scene: CharactersAndItems.unity

stavi sliku

## General:

My work on characters and items consisted of following:
1. Retopology of the models from the high poly(all the characters base body and some of the items)
2. Rigging and weighting of the characters with rigify addon (blend file is provided)
3. Making workflow for artist to follow in regards to uv mapping and texturing
4. Custom Shader and material setup for characters and items
5. Devising a way to have multiple characters sharing same body but have differend hair, noses, ears, skin color etc.

## Shader:

Using custom wrap diffuse shading to get fake subsurface and soft shadows effect in combination with Blinn–Phong model and rim lighting. Materials use one _NAC texture which holds X and Y compnents of the baked normals in the red and green channel and ambient occlusion in the blue channel, and finally curvature in the alpha channel.

Z compnenent of the normal is reconstructed in the shader using the formula: `sqrt(1 - x^2 - y^2)` and perturbed normal is calculated using the formula: `perturbedNormal = normal + tangent * tangentNormal.x + bitangent * tangentNormal.y`

Curvature maps are blended in as a subtle effect to make the model features more pronounced.

Shader also has secondary outline pass implemented using inverted hull approach which can be disabled with the `NO_OUTLINE` define.










