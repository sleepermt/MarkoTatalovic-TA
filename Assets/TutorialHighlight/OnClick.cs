using UnityEngine;
using UnityEngine.UI;

public class OnClick : MonoBehaviour
{
    public void Start()
    {
        Image image = GetComponent<Image>();
        if (image != null)
            GetComponent<Button>().onClick.AddListener(() => HighlightController.SetPositionAndSize(image.rectTransform));
           
    }

    public void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Vector2 mousePosition = Input.mousePosition;
            RaycastHit2D hit = Physics2D.Raycast(Camera.main.ScreenToWorldPoint(mousePosition), Vector2.zero);
            if (hit.collider != null)
            {
                HighlightController.SetPositionAndSize(hit.collider.bounds);
            }
        }
    }
}
