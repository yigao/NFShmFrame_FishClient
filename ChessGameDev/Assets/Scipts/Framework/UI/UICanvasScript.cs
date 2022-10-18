using System;
using UnityEngine;

public class UICanvasScript : UIComponent
{
    public bool isNeedMaskParticle;

    private Canvas m_canvas;

    public override void Initialize(UIFormScript formScript)
    {
        if (m_isInitialized)
        {
            return;
        }
        m_canvas = GetComponent<Canvas>();
        base.Initialize(formScript);
    }

    public override void Hide()
    {
        base.Hide();
        UIUtility.SetGameObjectLayer(gameObject, 31);
    }

    public override void Appear()
    {
        base.Appear();
        UIUtility.SetGameObjectLayer(gameObject, 5);
    }

    public override void SetSortingOrder(int sortingOrder)
    {
        if (m_canvas != null && isNeedMaskParticle)
        {
            m_canvas.overrideSorting = true;
            m_canvas.sortingOrder = sortingOrder + 1;
        }
    }
}
