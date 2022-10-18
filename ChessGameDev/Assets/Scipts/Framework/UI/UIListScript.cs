using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public enum enUIListType
{
    Vertical,
    Horizontal,
    VerticalGrid,
    HorizontalGrid
}

public struct stRect
{
    public int m_width;

    public int m_height;

    public int m_top;

    public int m_bottom;

    public int m_left;

    public int m_right;

    public Vector2 m_center;
}

public class UIListScript : UIComponent
{
    public enUIListType listType;

    public int elementAmount;

    public Vector2 elementSpacing;

    public float elementLayoutOffset;

    public bool autoInstantiateElement;

    public bool autoCenteredElements;

    public bool autoCenteredBothSides;

    protected int m_selectedElementIndex = -1;

    protected int m_lastSelectedElementIndex = -1;

    protected List<UIListElementScript> m_elementScripts;

    protected List<UIListElementScript> m_unUsedElementScripts;

    protected GameObject m_elementTemplate;

    protected string m_elementName;

    protected Vector2 m_elementDefaultSize;

    protected List<Vector2> m_elementsSize;

    protected List<stRect> m_elementsRect;

    [HideInInspector]
    public Action<GameObject> InstantiateElementCallback;

    [HideInInspector]
    public ScrollRect scrollRect;

    [HideInInspector]
    public Vector2 scrollAreaSize;

    [HideInInspector]
    [System.NonSerialized]
    public bool isInstantiateElementComplete;

    protected GameObject m_content;

    protected RectTransform m_contentRectTransform;

    protected Vector2 m_contentSize;

    protected Scrollbar m_scrollBar;

    protected Vector2 m_lastContentPosition;

    public bool useOptimized;

    [HideInInspector]
    public bool useExternalElement;

    [HideInInspector]
    public string externalElementPrefabPath;

    [HideInInspector]
    public bool autoAdjustScrollAreaSize = false;

    [HideInInspector]
    public Vector2 scrollRectAreaMaxSize = new Vector2(100f, 100f);

    public bool scrollExternal;

    public bool isDisableScrollRect;

    public float fSpeed = 0.2f;

    public override void Initialize(UIFormScript formScript)
    {
        
        if (m_isInitialized)
        {
            return;
        }
        base.Initialize(formScript);
        m_selectedElementIndex = -1;
        m_lastSelectedElementIndex = -1;
        isInstantiateElementComplete = false;
        scrollRect = GetComponentInChildren<ScrollRect>(gameObject);
        if (scrollRect != null)
        {
            scrollRect.enabled = false;
            RectTransform rectTransform = scrollRect.transform as RectTransform;
            scrollAreaSize = new Vector2(rectTransform.rect.width, rectTransform.rect.height);
            m_content = scrollRect.content.gameObject;
        }
        m_scrollBar = base.GetComponentInChildren<Scrollbar>(gameObject);
        if (listType == enUIListType.Vertical || listType == enUIListType.VerticalGrid)
        {
            if (m_scrollBar != null)
            {
                m_scrollBar.direction = Scrollbar.Direction.BottomToTop;
            }
           
            if (scrollRect != null)
            {
                scrollRect.horizontal = false;
                scrollRect.vertical = true;
                scrollRect.horizontalScrollbar = null;
                scrollRect.verticalScrollbar = m_scrollBar;
            }
        }
        else if (listType == enUIListType.Horizontal || listType == enUIListType.HorizontalGrid)
        {
            if (m_scrollBar != null)
            {
                m_scrollBar.direction = Scrollbar.Direction.LeftToRight;
            }
        
            if (scrollRect != null)
            {
                scrollRect.horizontal = true;
                scrollRect.vertical = false;
                scrollRect.horizontalScrollbar = m_scrollBar;
                scrollRect.verticalScrollbar = null;
            }
        }
        m_elementScripts = new List<UIListElementScript>();
        m_unUsedElementScripts = new List<UIListElementScript>();
        if (useOptimized && m_elementsRect == null)
        {
            m_elementsRect = new List<stRect>();
        }
        UIListElementScript uiListElementScript = null;
        if (useExternalElement)
        {
            GameObject gameObject1 = null;
            if (externalElementPrefabPath != null)
            {
                gameObject1 = (GameObject)Singleton<ResourceManager>.GetInstance().GetResource(externalElementPrefabPath, typeof(GameObject), false, false).content;
                if (gameObject1 != null)
                {
                    uiListElementScript = gameObject1.GetComponent<UIListElementScript>();
                }
            }
            if (uiListElementScript != null && gameObject1 != null)
            {
                uiListElementScript.Initialize(formScript);
                m_elementTemplate = gameObject1;
                m_elementName = gameObject1.name;
                m_elementDefaultSize = uiListElementScript.m_defaultSize;
            }
        }
        else
        {
            uiListElementScript = GetComponentInChildren<UIListElementScript>(gameObject);
            if (uiListElementScript != null)
            {
                uiListElementScript.Initialize(formScript);
                m_elementTemplate = uiListElementScript.gameObject;
                m_elementName = uiListElementScript.gameObject.name;
                m_elementDefaultSize = uiListElementScript.m_defaultSize;
                if (m_elementTemplate != null)
                {
                    m_elementTemplate.name = m_elementName + "_Template";
                }
            }
        }
        if (m_elementTemplate != null)
        {
            UIListElementScript component = m_elementTemplate.GetComponent<UIListElementScript>();
            if (component != null && component.m_useSetActiveForDisplay)
            {
                m_elementTemplate.SetActive(false);
            }
            else
            {
                if (!m_elementTemplate.activeSelf)
                {
                    m_elementTemplate.SetActive(true);
                }
                CanvasGroup canvasGroup = m_elementTemplate.GetComponent<CanvasGroup>();
                if (canvasGroup == null)
                {
                    canvasGroup = m_elementTemplate.AddComponent<CanvasGroup>();
                }
                canvasGroup.alpha = 0f;
                canvasGroup.blocksRaycasts = false;
            }
        }
        if (m_content != null)
        {
            m_contentRectTransform = (m_content.transform as RectTransform);
            m_contentRectTransform.pivot = new Vector2(0f, 1f);
            m_contentRectTransform.anchorMin = new Vector2(0f, 1f);
            m_contentRectTransform.anchorMax = new Vector2(0f, 1f);
            m_contentRectTransform.anchoredPosition = Vector2.zero;
            m_contentRectTransform.localRotation = Quaternion.identity;
            m_contentRectTransform.localScale = new Vector3(1f, 1f, 1f);
            m_lastContentPosition = m_contentRectTransform.anchoredPosition;
        }
      
        if (m_elementTemplate != null)
        {
            SetElementAmount(elementAmount);
        }
    }

    public void SetExternalElementPrefab(string externalElmtPrefPath)
    {
        UIListElementScript uiListElementScript = null;
        GameObject gameObject = null;
        if (externalElmtPrefPath != null)
        {
            gameObject = (GameObject)Singleton<ResourceManager>.GetInstance().GetResource(externalElmtPrefPath, typeof(GameObject), false, false).content;
            if (gameObject != null)
            {
                uiListElementScript = gameObject.GetComponent<UIListElementScript>();
            }
        }
        if (uiListElementScript != null && gameObject != null)
        {
            uiListElementScript.Initialize(belongedFormScript);
            m_elementTemplate = gameObject;
            m_elementName = gameObject.name;
            m_elementDefaultSize = uiListElementScript.m_defaultSize;
        }
        if (m_elementTemplate != null)
        {
            SetElementAmount(elementAmount);
        }
    }

    protected override void OnDestroy()
    {
        //if (LeanTween.IsInitialised())
        //{
        //    LeanTween.cancel(gameObject);
        //}
        m_elementTemplate = null;
        scrollRect = null;
        m_content = null;
        m_contentRectTransform = null;
        m_scrollBar = null;
        if (m_elementScripts != null)
        {
            m_elementScripts.Clear();
            m_elementScripts = null;
        }
        if (m_unUsedElementScripts != null)
        {
            m_unUsedElementScripts.Clear();
            m_unUsedElementScripts = null;
        }
        base.OnDestroy();
    }

    protected virtual void Update()
    {
        if ((belongedFormScript != null && belongedFormScript.IsClosed()) || !isInstantiateElementComplete)
        {
            return;
        }

        if (useOptimized)
        {
            UpdateElementsScroll();
        }
        if (scrollRect != null && !scrollExternal && !isDisableScrollRect)
        {
            if (m_contentSize.x > scrollAreaSize.x || m_contentSize.y > scrollAreaSize.y)
            {
                if (!scrollRect.enabled)
                {
                    scrollRect.enabled = true;
                }
            }
            else if ((double)Mathf.Abs(m_contentRectTransform.anchoredPosition.x) < 0.001 && (double)Mathf.Abs(m_contentRectTransform.anchoredPosition.y) < 0.001 && scrollRect.enabled)
            {
                scrollRect.enabled = false;
            }
            DetectScroll();
        }
    }

    protected void DetectScroll()
    {
        if (m_contentRectTransform.anchoredPosition != m_lastContentPosition)
        {
            m_lastContentPosition = m_contentRectTransform.anchoredPosition;
        }
    }

    public void SetElementAmount(int amount)
    {
        SetElementAmount(amount, null);
    }

    public virtual void SetElementAmount(int amount, List<Vector2> elementsSize)
    {
        if (amount < 0)
        {
            amount = 0;
        }
        if (elementsSize != null && amount != elementsSize.Count)
        {
            return;
        }
        RecycleElement(false);
        elementAmount = amount;
        m_elementsSize = elementsSize;
        ProcessElements();
        ProcessUnUsedElement();
    }


    public virtual void SelectElement(int index)
    {
        m_lastSelectedElementIndex = m_selectedElementIndex;
        m_selectedElementIndex = index;
        if (m_lastSelectedElementIndex == m_selectedElementIndex)
        {
            return;
        }
        if (m_lastSelectedElementIndex >= 0)
        {
            UIListElementScript elemenet = GetElemenet(m_lastSelectedElementIndex);
            if (elemenet != null)
            {
                elemenet.ChangeDisplay(false);
            }
        }
        if (m_selectedElementIndex >= 0)
        {
            UIListElementScript elemenet2 = GetElemenet(m_selectedElementIndex);
            if (elemenet2 != null)
            {
                elemenet2.ChangeDisplay(true);
                if (elemenet2.onSelected != null)
                {
                    elemenet2.onSelected();
                }
            }
        }
    }

    public int GetElementAmount()
    {
        return elementAmount;
    }

    public UIListElementScript GetElemenet(int index)
    {
        if (index < 0 || index >= elementAmount)
        {
            return null;
        }
        if (useOptimized)
        {
            for (int i = 0; i < m_elementScripts.Count; i++)
            {
                if (m_elementScripts[i].m_index == index)
                {
                    return m_elementScripts[i];
                }
            }
            return null;
        }
        return m_elementScripts[index];
    }

    public UIListElementScript GetSelectedElement()
    {
        return GetElemenet(m_selectedElementIndex);
    }

    public UIListElementScript GetLastSelectedElement()
    {
        return GetElemenet(m_lastSelectedElementIndex);
    }

    public Vector2 GetEelementDefaultSize()
    {
        return m_elementDefaultSize;
    }

    public int GetSelectedIndex()
    {
        return m_selectedElementIndex;
    }

    public int GetLastSelectedIndex()
    {
        return m_lastSelectedElementIndex;
    }

    public bool IsElementInScrollArea(int index)
    {
        if (index < 0 || index >= elementAmount)
        {
            return false;
        }
        stRect stRect = (!useOptimized) ? m_elementScripts[index].m_rect : m_elementsRect[index];
        return IsRectInScrollArea(ref stRect);
    }

    public Vector2 GetContentSize()
    {
        return m_contentSize;
    }

    public Vector2 GetScrollAreaSize()
    {
        return scrollAreaSize;
    }

    public Vector2 GetContentPosition()
    {
        return m_lastContentPosition;
    }

    public bool IsNeedScroll()
    {
        return m_contentSize.x > scrollAreaSize.x || m_contentSize.y > scrollAreaSize.y;
    }

    public void ResetContentPosition()
    {
        //if (LeanTween.IsInitialised())
        //{
        //    LeanTween.cancel(base.gameObject);
        //}
        if (m_contentRectTransform != null)
        {
            m_contentRectTransform.anchoredPosition = Vector2.zero;
        }
    }

    public void MoveElementInScrollArea(int index, bool moveImmediately)
    {
        if (index < 0 || index >= elementAmount)
        {
            return;
        }
        Vector2 zero = Vector2.zero;
        Vector2 zero2 = Vector2.zero;
        stRect stRect = (!useOptimized) ? m_elementScripts[index].m_rect : m_elementsRect[index];
        zero2.x = m_contentRectTransform.anchoredPosition.x + (float)stRect.m_left;
        zero2.y = m_contentRectTransform.anchoredPosition.y + (float)stRect.m_top;
        if (zero2.x < 0f)
        {
            zero.x = -zero2.x;
        }
        else if (zero2.x + (float)stRect.m_width > scrollAreaSize.x)
        {
            zero.x = scrollAreaSize.x - (zero2.x + (float)stRect.m_width);
        }
        if (zero2.y > 0f)
        {
            zero.y = -zero2.y;
        }
        else if (zero2.y - (float)stRect.m_height < -scrollAreaSize.y)
        {
            zero.y = -scrollAreaSize.y - (zero2.y - (float)stRect.m_height);
        }
        if (moveImmediately)
        {
            m_contentRectTransform.anchoredPosition += zero;
        }
        else
        {
            //Vector2 to = m_contentRectTransform.anchoredPosition + zero;
            //LeanTween.value(base.gameObject, delegate(Vector2 pos)
            //{
            //    m_contentRectTransform.anchoredPosition = pos;
            //}, m_contentRectTransform.anchoredPosition, to, fSpeed);
        }
    }

    public virtual bool IsSelectedIndex(int index)
    {
        return m_selectedElementIndex == index;
    }


    public void MoveContent(Vector2 offset)
    {
        if (m_contentRectTransform != null)
        {
            Vector2 vector = (m_content.transform as RectTransform).anchoredPosition;
            vector += offset;
            if (offset.x != 0f)
            {
                if (vector.x > 0f)
                {
                    vector.x = 0f;
                }
                else if (vector.x + m_contentSize.x < scrollAreaSize.x)
                {
                    vector.x = scrollAreaSize.x - m_contentSize.x;
                }
            }
            if (offset.y != 0f)
            {
                if (vector.y < 0f)
                {
                    vector.y = 0f;
                }
                else if (m_contentSize.y - vector.y < scrollAreaSize.y)
                {
                    vector.y = m_contentSize.y - scrollAreaSize.y;
                }
            }
            m_contentRectTransform.anchoredPosition = vector;
        }
    }

    protected virtual void ProcessElements()
    {
        m_contentSize = Vector2.zero;
        Vector2 zero = Vector2.zero;
        if (listType == enUIListType.Vertical || listType == enUIListType.VerticalGrid)
        {
            zero.y += elementLayoutOffset;     
        }
        else
        {
            zero.x += elementLayoutOffset;
        }
        for (int i = 0; i < elementAmount; i++)
        {
            stRect stRect = LayoutElement(i, ref m_contentSize, ref zero);
            if (useOptimized)
            {
                if (i < m_elementsRect.Count)
                {
                    m_elementsRect[i] = stRect;
                }
                else
                {
                    m_elementsRect.Add(stRect);
                }
            }
            if (!useOptimized || IsRectInScrollArea(ref stRect))
            {
                if (autoInstantiateElement)
                {
                    CreateElement(i, ref stRect);
                    isInstantiateElementComplete = true;
                }
                else
                {
                    isInstantiateElementComplete = false;
                }
            }
        }

        ResizeContent(ref m_contentSize, false);
    }


    protected void UpdateElementsScroll()
    {
        int i = 0;
        while (i < m_elementScripts.Count)
        {
            if (!IsRectInScrollArea(ref m_elementScripts[i].m_rect))
            {
                RecycleElement(m_elementScripts[i], true);
            }
            else
            {
                i++;
            }
        }
        for (int j = 0; j < elementAmount; j++)
        {
            stRect stRect = m_elementsRect[j];
            if (IsRectInScrollArea(ref stRect))
            {
                bool flag = false;
                for (int k = 0; k < m_elementScripts.Count; k++)
                {
                    if (m_elementScripts[k].m_index == j)
                    {
                        flag = true;
                        break;
                    }
                }
                if (!flag)
                {
                    CreateElement(j, ref stRect);
                }
            }
        }
    }

    protected stRect LayoutElement(int index, ref Vector2 contentSize, ref Vector2 offset)
    {
        stRect result = default(stRect);
        result.m_width = (int)((m_elementsSize != null && listType != enUIListType.Vertical && listType != enUIListType.VerticalGrid && listType != enUIListType.HorizontalGrid) ? m_elementsSize[index].x : m_elementDefaultSize.x);
        result.m_height = (int)((m_elementsSize != null && listType != enUIListType.Horizontal && listType != enUIListType.VerticalGrid && listType != enUIListType.HorizontalGrid) ? m_elementsSize[index].y : m_elementDefaultSize.y);
        result.m_left = (int)offset.x;
        result.m_top = (int)offset.y;
        result.m_right = result.m_left + result.m_width;
        result.m_bottom = result.m_top - result.m_height;
        result.m_center = new Vector2((float)result.m_left + (float)result.m_width * 0.5f, (float)result.m_top - (float)result.m_height * 0.5f);
        if ((float)result.m_right > contentSize.x)
        {
            contentSize.x = (float)result.m_right;
        }
        if ((float)(-(float)result.m_bottom) > contentSize.y)
        {
            contentSize.y = (float)(-(float)result.m_bottom);
        }
        switch (listType)
        {
            case enUIListType.Vertical:
                offset.y -= (float)result.m_height + elementSpacing.y;
                break;
            case enUIListType.Horizontal:
                offset.x += (float)result.m_width + elementSpacing.x;
                break;
            case enUIListType.VerticalGrid:
                offset.x += (float)result.m_width + elementSpacing.x;
                if (offset.x + (float)result.m_width > scrollAreaSize.x)
                {
                    offset.x = 0f;
                    offset.y -= (float)result.m_height + elementSpacing.y;
                }
                break;
            case enUIListType.HorizontalGrid:
                offset.y -= (float)result.m_height + elementSpacing.y;
                if (-offset.y + (float)result.m_height > scrollAreaSize.y)
                {
                    offset.y = 0f;
                    offset.x += (float)result.m_width + elementSpacing.x;
                }
                break;
        }
        return result;
    }

    protected virtual void ResizeContent(ref Vector2 size, bool resetPosition)
    {
        float num = 0f;
        float num2 = 0f;
        if (autoAdjustScrollAreaSize)
        {
            Vector2 scrollAreaSizeval = scrollAreaSize;
            scrollAreaSize = size;
            if (scrollAreaSize.x > scrollRectAreaMaxSize.x)
            {
                scrollAreaSize.x = scrollRectAreaMaxSize.x;
            }
            if (scrollAreaSize.y > scrollRectAreaMaxSize.y)
            {
                scrollAreaSize.y = scrollRectAreaMaxSize.y;
            }
            Vector2 vector = scrollAreaSize - scrollAreaSizeval;
            if (vector != Vector2.zero)
            {
                RectTransform rectTransform = gameObject.transform as RectTransform;
                if (rectTransform.anchorMin == rectTransform.anchorMax)
                {
                    rectTransform.sizeDelta += vector;
                }
            }
        }
        else if (autoCenteredElements)
        {
            if (listType == enUIListType.Vertical && size.y < scrollAreaSize.y)
            {
                num2 = (size.y - scrollAreaSize.y) / 2f;
                if (autoCenteredBothSides)
                {
                    num = (scrollAreaSize.x - size.x) / 2f;
                }
            }
            else if (listType == enUIListType.Horizontal && size.x < scrollAreaSize.x)
            {
                num = (scrollAreaSize.x - size.x) / 2f;
                if (autoCenteredBothSides)
                {
                    num2 = (size.y - scrollAreaSize.y) / 2f;
                }
            }
            else if (listType == enUIListType.VerticalGrid && size.x < scrollAreaSize.x)
            {
                float num3 = size.x;
                float num4 = num3 + elementSpacing.x;
                while (true)
                {
                    num3 = num4 + m_elementDefaultSize.x;
                    if (num3 > scrollAreaSize.x)
                    {
                        break;
                    }
                    size.x = num3;
                    num4 = num3 + elementSpacing.x;
                }
                num = (scrollAreaSize.x - size.x) / 2f;
            }
            else if (listType == enUIListType.HorizontalGrid && size.y < scrollAreaSize.y)
            {
                float num5 = size.y;
                float num6 = num5 + elementSpacing.y;
                while (true)
                {
                    num5 = num6 + m_elementDefaultSize.y;
                    if (num5 > scrollAreaSize.y)
                    {
                        break;
                    }
                    size.y = num5;
                    num6 = num5 + elementSpacing.y;
                }
                num2 = (size.y - scrollAreaSize.y) / 2f;
            }
        }
        if (size.x < scrollAreaSize.x)
        {
            size.x = scrollAreaSize.x;
        }
        if (size.y < scrollAreaSize.y)
        {
            size.y = scrollAreaSize.y;
        }
        if (m_contentRectTransform != null)
        {
            m_contentRectTransform.sizeDelta = size;
            if (resetPosition)
            {
                m_contentRectTransform.anchoredPosition = Vector2.zero;
            }
            if (autoCenteredElements)
            {
                if (num != 0f)
                {
                    m_contentRectTransform.anchoredPosition = new Vector2(num, m_contentRectTransform.anchoredPosition.y);
                }
                if (num2 != 0f)
                {
                    m_contentRectTransform.anchoredPosition = new Vector2(m_contentRectTransform.anchoredPosition.x, num2);
                }
            }
        }
    }

    protected bool IsRectInScrollArea(ref stRect rect)
    {
        Vector2 zero = Vector2.zero;
        zero.x = m_contentRectTransform.anchoredPosition.x + (float)rect.m_left;
        zero.y = m_contentRectTransform.anchoredPosition.y + (float)rect.m_top;
        return zero.x + (float)rect.m_width >= 0f && zero.x <= scrollAreaSize.x && zero.y - (float)rect.m_height <= 0f && zero.y >= -scrollAreaSize.y;
    }

    protected void RecycleElement(bool disableElement)
    {
        while (m_elementScripts.Count > 0)
        {
            UIListElementScript uiListElementScript = m_elementScripts[0];
            m_elementScripts.RemoveAt(0);
            if (disableElement)
            {
                uiListElementScript.Disable();
            }
            m_unUsedElementScripts.Add(uiListElementScript);
        }
    }

    protected void RecycleElement(UIListElementScript elementScript, bool disableElement)
    {
        if (disableElement)
        {
            elementScript.Disable();
        }
        m_elementScripts.Remove(elementScript);
        m_unUsedElementScripts.Add(elementScript);
    }

    public UIListElementScript AddElement(int index)
    {
        stRect stRect = m_elementsRect[index];
        if (IsRectInScrollArea(ref stRect))
        {
            bool flag = false;
            for (int k = 0; k < m_elementScripts.Count; k++)
            {
                if (m_elementScripts[k].m_index == index)
                {
                    flag = true;
                    break;
                }
            }
            if (!flag)
            {
                return CreateElement(index, ref stRect);
            }
        }
        isInstantiateElementComplete = true;
        return null;
        
    }
    
    
    protected UIListElementScript CreateElement(int index, ref stRect rect)
    {
        UIListElementScript uiListElementScript = null;
        if (m_unUsedElementScripts.Count > 0)
        {
            uiListElementScript = m_unUsedElementScripts[0];
            m_unUsedElementScripts.RemoveAt(0);
        }
        else if (m_elementTemplate != null)
        {
            GameObject gameObject1 = GameObject.Instantiate(m_elementTemplate);
            gameObject1.transform.SetParent(m_content.transform);
            gameObject1.transform.localScale = Vector3.one;
            base.InitializeComponent(gameObject1);
            uiListElementScript = gameObject1.GetComponent<UIListElementScript>();
            if (InstantiateElementCallback != null)
            {
                InstantiateElementCallback(gameObject1);
            }
        }
        if (uiListElementScript != null)
        {
            uiListElementScript.Enable(this, index, m_elementName, ref rect, IsSelectedIndex(index));
            m_elementScripts.Add(uiListElementScript);
        }
        return uiListElementScript;
    }

    protected void ProcessUnUsedElement()
    {
        if (m_unUsedElementScripts != null && m_unUsedElementScripts.Count > 0)
        {
            for (int i = 0; i < m_unUsedElementScripts.Count; i++)
            {
                m_unUsedElementScripts[i].Disable();
            }
        }
    }
}
