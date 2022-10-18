using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIComponent : MonoBehaviour
{
    [HideInInspector]
    public UIFormScript belongedFormScript;

    [HideInInspector]
    public UIListScript belongedListScript;

    [HideInInspector]
    public int indexInList;

    public GameObject[] widgets = new GameObject[0];

    protected bool m_isInitialized;

    public virtual void Initialize(UIFormScript formScript)
    {
        if (m_isInitialized)
        {
            return;
        }
        
        belongedFormScript = formScript;
        if (belongedFormScript != null)
        {
            belongedFormScript.AddUIComponent(this);
            SetSortingOrder(belongedFormScript.GetSortingOrder());
        }
        m_isInitialized = true;
    }

    protected virtual void OnDestroy()
    {
        belongedFormScript = null;
        belongedListScript = null;
        widgets = null;
    }

    public virtual void Close()
    { 
        
    }

    public virtual void Hide()
    { 
    
    }

    public virtual void Appear()
    { 
    
    }

    public virtual void SetSortingOrder(int sortingOrder)
    {
        
    }

    public void SetBelongedList(UIListScript uiBelongedListScript, int index)
    {
        belongedListScript = uiBelongedListScript;
        indexInList = index;
    }

    public GameObject GetWidget(int index)
    {
        if (index < 0 || index >= widgets.Length)
        {
            return null;
        }
        return widgets[index];
    }

    protected T GetComponentInChildren<T>(GameObject go) where T : Component
    {
        T t = go.GetComponent<T>();
        if (t != null)
        {
            return t;
        }
        for (int i = 0; i < go.transform.childCount; i++)
        {
            t = GetComponentInChildren<T>(go.transform.GetChild(i).gameObject);
            if (t != null)
            {
                return t;
            }
        }
        return (T)((object)null);
    }

    protected GameObject Instantiate(GameObject srcGameObject)
    {
        GameObject gameObject = UnityEngine.Object.Instantiate(srcGameObject) as GameObject;
        gameObject.transform.SetParent(srcGameObject.transform.parent);
        RectTransform rectTransform = srcGameObject.transform as RectTransform;
        RectTransform rectTransform2 = gameObject.transform as RectTransform;
        if (rectTransform != null && rectTransform2 != null)
        {
            rectTransform2.pivot = rectTransform.pivot;
            rectTransform2.anchorMin = rectTransform.anchorMin;
            rectTransform2.anchorMax = rectTransform.anchorMax;
            rectTransform2.offsetMin = rectTransform.offsetMin;
            rectTransform2.offsetMax = rectTransform.offsetMax;
            rectTransform2.localPosition = rectTransform.localPosition;
            rectTransform2.localRotation = rectTransform.localRotation;
            rectTransform2.localScale = rectTransform.localScale;
        }
        return gameObject;
    }

    protected void InitializeComponent(GameObject root)
    {
        UIComponent[] components = root.GetComponents<UIComponent>();
        if (components != null && components.Length > 0)
        {
            for (int i = 0; i < components.Length; i++)
            {
                components[i].Initialize(belongedFormScript);
            }
        }
        for (int j = 0; j < root.transform.childCount; j++)
        {
            InitializeComponent(root.transform.GetChild(j).gameObject);
        }
    }
}
