using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderConfig : MonoBehaviour
{
    Renderer meshRenderer = null;

    [Tooltip("设置sortingOrder")]
    public int sortingOrder = 0;


    void Start()
    {
        meshRenderer = this.GetComponent<Renderer>();


        SetCurrentSortOrder(sortingOrder);
    }

    void SetCurrentSortOrder(int so)
    {
        if(meshRenderer)
        {
            meshRenderer.sortingOrder = so;
        }
    }
}
