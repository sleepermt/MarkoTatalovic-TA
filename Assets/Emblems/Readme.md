# Club Emblems

Scene: Emblems.unity   
Note: Please set the display resolution in Game preview window to 2048x2048 so both mesh and canvas emblems are visible. On the left side are mesh emblems, on the right side are canvas emblems.

<img src = "https://user-images.githubusercontent.com/16105403/200170973-96715f15-215c-4677-8125-d32199514080.png" width=25% height=25%><img src = "https://user-images.githubusercontent.com/16105403/200192051-930dd0c1-b3bc-4e80-ba7e-c2fc24ea3bc3.png" width=40% height=40%>



## General:
Customizable emblem system that enables players to create emblems with custom color patterns, shield and banner shapes using SDF shader techniques. SDF approach was used to avoid any scaling issues at different device resolutions that emblems would otherwise have with common raster options. 

Originally this system was designed for a canvas based UI system, but for the purposes of this demo it was addapted to also work with mesh objects. For both variants the same shader file is used, and they both support rendering virtualy infinite amount of emblems on the screen in one draw call.

## How it works:
Emblem elements like shield, symbol and banner shape are read from texture array: 

https://user-images.githubusercontent.com/16105403/200170379-11d9d77b-212e-421b-9d8a-62bd7950c7bf.mp4

Texture arrays hold signed distance field (SDF) textures for each element. SDF texture are genereated in Photoshop with stroke effect.
Indexing of the texture array (and colors, flagschems etc.) for the canvas variant is done by writing the index values into vertex attributes, namely into additional UV channels. Some of the texture arrays like one for the banner use different color RG channels to store back and front to achieve layered effect.

```
SetIndexAsUV.cs
...
public override void ModifyMesh(VertexHelper vh)
{
    UIVertex vert = new UIVertex();
    for (int i = 0; i < vh.currentVertCount; i++)
    {
        vh.PopulateUIVertex(ref vert, i);
        vert.uv0 = new Vector3(vert.uv0.x, vert.uv0.y, quinaryColorIdx);
        vert.uv1 = new Vector4(primaryColorIdx, secondaryColorIdx, tertiaryColorIdx, quartenaryColorIdx);
        vert.uv2 = new Vector4(shieldIdx, symbolIdx, bannerIdx, flagSchemeIdx);
        vh.SetUIVertex(vert, i);
    }
}
```

For the mesh variant index are passed through a property block to support GPU instancing.

Which shader variant is used is determined by the keyword: `INDEX_FROM_VERTEX_DATA`

Shader also supports 32 different colors for each element, which can be read either from lut texture or from hardcoded color values defined in the shader, and up to 5 different flag schemes (easily extendable to more).






