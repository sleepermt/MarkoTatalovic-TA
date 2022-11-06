using System.Collections;
using UnityEngine;

public class GoonGoonScreenAnimation : MonoBehaviour
{
    private Animator animator;
    
    void Start()
    {
        animator = GetComponent<Animator>();

        StartCoroutine(Animate());
    }

    IEnumerator Animate()
    {
        while (true)
        {
            yield return new WaitForSeconds(3.333f);
            animator.SetBool("IdleComplex", true);
            
            yield return new WaitForSeconds(5.133f);
            animator.SetBool("IdleComplex", false);
        }
    }
}