using System.Collections;
using UnityEngine;


public class UpgradeEffect : MonoBehaviour
{
    private Material material;
    private float duration = 1.0f;

    void Start()
    {
        material = GetComponent<Renderer>().material;
        StartCoroutine(Animate());
    }

    private IEnumerator Animate()
    {
        float t = 0f;
        yield return new WaitForSeconds(Random.Range(0.0f, 1f)); // start animation at different times (just for showcase)

        while (true)
        {
            float f = t/duration;
            material.SetFloat("_Scale", f);
            material.SetFloat("_Alpha", f < 0.5f ? f : 1.0f - f);
            t += Time.deltaTime;
            if (t > duration)
            {
                t = 0f;
            }
            yield return null;
        }
    }
}
