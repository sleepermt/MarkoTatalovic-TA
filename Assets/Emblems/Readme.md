# Club Emblems

Scene: Emblems.unity   
Note: Please set the display resolution in Game preview window to 2048x2048 so both mesh and canvas emblems are visible. On the left side are mesh emblems, on the right side are canvas emblems.

## General:
Customizable emblem system that enables players to create emblems with custom color patterns, shield and banner shapes using SDF shader techniques. SDF approach was used to avoid any scaling issues at different device resolutions that emblems would otherwise have with common raster options. 

Originally this system was designed for a canvas based UI system, but for the purposes of this demo it was addapted to also work with mesh objects. For both variants the same shader file is used, and they both support rendering virtualy infinite amount of emblems on the screen in one draw call.

## How it works:
Emblem elements like shield, symbol and banner shape are read from texture array: https://gyazo.com/5612b0c535a8e7341302c0334db2d467

Texture arrays hold signed distance field (SDF) textures for each element. SDF texture are genereated in Photoshop with stroke effect.

Indexing of the texture array for the canvas variant is done by writing the index values into vertex attributes, namely into additional UV channels.



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






