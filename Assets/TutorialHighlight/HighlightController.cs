using UnityEngine;
using UnityEngine.UI;

public class HighlightController : MonoBehaviour
{
    static HighlightController instance;
    static private Image image;

    private static Material material;
    private static Color[] colors = new Color[4]{Color.red, Color.green, Color.cyan, Color.yellow};

    public void Awake()
    {
        material = GetComponent<Image>().material;
        image = GetComponent<Image>();
        image.color = Color.clear;
    }

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
   
}
