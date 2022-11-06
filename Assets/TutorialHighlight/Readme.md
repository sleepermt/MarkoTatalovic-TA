# Tutorial Highlight

Scene: Emblems.unity

Note: Note: Please set the display resolution in Game preview window to 2048x2048 so both mesh and canvas emblems are visible. On the left side are mesh emblems, on the right side are canvas emblems. Tutorial Highlight effect works on both.


https://user-images.githubusercontent.com/16105403/200173718-8468f169-b622-4495-bb7e-32d30cfa92f3.mp4


## General:
Effect made to highlight a specific area of the screen. It is also used to highlight the area where the player should click to continue the tutorial.

Based on what type of the object needs to be highlighted size of the highlight area is calculated and passed to the shader. For UI elements it is calculated based on the size of the RectTransform, for meshes it is calculated based on the bounds of the mesh projected into screenspace.

```
HighlightController.cs
...
static public void SetPositionAndSize(RectTransform rectTransform)
{
    Vector3 offset = (2.0f * rectTransform.pivot - Vector2.one) * new Vector3(rectTransform.rect.width * 0.5f, rectTransform.rect.height * 0.5f, 1.0f);
    Vector2 position = (rectTransform.position - offset) / new Vector2(Screen.width, Screen.height);

    float width = rectTransform.rect.width / Screen.width;
    float height = rectTransform.rect.height / Screen.height;
    material.SetVector("_Transform", new Vector4(position.x, position.y, width, height));
    image.color = colors[Random.Range(0, colors.Length)];
    
}

static public void SetPositionAndSize(Bounds bounds)
{
    Vector2 position = Camera.main.WorldToScreenPoint(bounds.center);
    Vector3 extents = Camera.main.WorldToScreenPoint(bounds.center - new Vector3(bounds.extents.x, bounds.extents.y, 0.0f) * 2.0f);
    float width = Mathf.Abs(position.x - extents.x) / Screen.width;
    float height = Mathf.Abs(position.y - extents.y) / Screen.height;
    position /= new Vector2(Screen.width, Screen.height);

    material.SetVector("_Transform", new Vector4(position.x, position.y, width, height));
    image.color = colors[Random.Range(0, colors.Length)];
}
```

## How it works:

The effect is achived by using a shader that renders a 2D SDF box into quad that covers the whole screen.
For the line sweep effect the shader calculates perimiter of the box, scales the distance field by the perimiter length, and makes the time offset proportional to perimiter length to get same sweep speed for all sizes of the box.










