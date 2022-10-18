using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;


public enum enPivotType
{
    Centre,
    LeftTop
}

public class UIListElementScript : UIComponent
{
    public delegate void OnSelectedDelegate();

    [HideInInspector]
    public Vector2 m_defaultSize;

    [HideInInspector]
    public int m_index;

    [HideInInspector]
    public enPivotType m_pivotType = enPivotType.LeftTop;

    [HideInInspector] public Action<int> OnEnableElement;

    public stRect m_rect;

    public bool m_useSetActiveForDisplay = true;

    public UIListElementScript.OnSelectedDelegate onSelected;

    private CanvasGroup m_canvasGroup;

    public override void Initialize(UIFormScript formScript)
    {
        if (m_isInitialized)
        {
            return;
        }
        base.Initialize(formScript);

        if (!m_useSetActiveForDisplay)
        {
            m_canvasGroup = base.gameObject.GetComponent<CanvasGroup>();
            if (m_canvasGroup == null)
            {
                m_canvasGroup = base.gameObject.AddComponent<CanvasGroup>();
            }
        }
        m_defaultSize = GetDefaultSize();
        InitRectTransform();
    }

    protected override void OnDestroy()
    {
        onSelected = null;
        m_canvasGroup = null;
        base.OnDestroy();
    }

    protected virtual Vector2 GetDefaultSize()
    {
        return new Vector2(((RectTransform)gameObject.transform).rect.width, ((RectTransform)gameObject.transform).rect.height);
    }

    public void Enable(UIListScript belongedList, int index, string name, ref stRect rect, bool selected)
    {
        belongedListScript = belongedList;
        m_index = index;
        gameObject.name = name + "_" + index.ToString();
        if (m_useSetActiveForDisplay)
        {
            base.gameObject.SetActive(true);
        }
        else
        {
            m_canvasGroup.alpha = 1f;
            m_canvasGroup.blocksRaycasts = true;
        }
        SetComponentBelongedList(gameObject);
        SetRect(ref rect);
        if (OnEnableElement != null)
        {
            OnEnableElement(index);
        }
        ChangeDisplay(selected);
    }

    public void Disable()
    {
        if (m_useSetActiveForDisplay)
        {
            gameObject.SetActive(false);
        }
        else
        {
            m_canvasGroup.alpha = 0f;
            m_canvasGroup.blocksRaycasts = false;
        }
    }

    public  void OnSelected(BaseEventData baseEventData)
    {
        belongedListScript.SelectElement(m_index);
    }

    public virtual void ChangeDisplay(bool selected)
    {
      
    }

    public void SetComponentBelongedList(GameObject gameObject)
    {
        UIComponent[] components = gameObject.GetComponents<UIComponent>();
        if (components != null && components.Length > 0)
        {
            for (int i = 0; i < components.Length; i++)
            {
                components[i].SetBelongedList(belongedListScript, m_index);
            }
        }
        for (int j = 0; j < gameObject.transform.childCount; j++)
        {
            SetComponentBelongedList(gameObject.transform.GetChild(j).gameObject);
        }
    }

    public void SetRect(ref stRect rect)
    {
        m_rect = rect;
        RectTransform rectTransform = gameObject.transform as RectTransform;
        rectTransform.sizeDelta = new Vector2((float)m_rect.m_width, (float)m_rect.m_height);
        if (m_pivotType == enPivotType.Centre)
        {
            rectTransform.anchoredPosition3D =new Vector3(rect.m_center.x,rect.m_center.y,0);
        }
        else
        {
            rectTransform.anchoredPosition3D = new Vector3((float)rect.m_left, (float)rect.m_top,0);
        }
    }

    private void InitRectTransform()
    {
        RectTransform rectTransform = gameObject.transform as RectTransform;
        rectTransform.anchorMin = new Vector2(0f, 1f);
        rectTransform.anchorMax = new Vector2(0f, 1f);
        rectTransform.pivot = ((m_pivotType != enPivotType.Centre) ? new Vector2(0f, 1f) : new Vector2(0.5f, 0.5f));
        rectTransform.sizeDelta = m_defaultSize;
        rectTransform.localRotation = Quaternion.identity;
        rectTransform.localScale = new Vector3(1f, 1f, 1f);
    }

}
