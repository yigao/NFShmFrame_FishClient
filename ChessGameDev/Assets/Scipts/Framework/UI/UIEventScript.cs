using System;
using UnityEngine;
using UnityEngine.EventSystems;

public delegate void UIEventPointerCallBack(PointerEventData eventData);

public class UIEventScript : UIComponent, IPointerDownHandler, IEventSystemHandler, IPointerClickHandler, IPointerUpHandler, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    public bool closeFormWhenClicked;

    private bool m_canClick;

    private Vector2 m_downPosition;

    [NonSerialized]
    public UIEventPointerCallBack onPointerDownCallBack = null;
    [NonSerialized]
    public UIEventPointerCallBack onPointerUpCallBack = null;
    [NonSerialized]
    public Action<bool> onPressCallBack = null;
    [NonSerialized]
    public UIEventPointerCallBack onPointerClickCallBack = null;
    [NonSerialized]
    public UIEventPointerCallBack onBeginDragCallBack = null;
    [NonSerialized]
    public UIEventPointerCallBack onDragCallBack = null;
    [NonSerialized]
    public UIEventPointerCallBack onEndDragCallBack = null;


    public override void Initialize(UIFormScript formScript)
    {
        if (m_isInitialized)
        {
            return;
        }
        base.Initialize(formScript);
    }

    public override void Close()
    {
        base.Close();
        m_canClick = false;
        m_downPosition = Vector2.zero;
        onPointerDownCallBack = null;
        onPointerUpCallBack = null;
        onPointerClickCallBack = null;
        onBeginDragCallBack = null;
        onDragCallBack = null;
        onEndDragCallBack = null;
        closeFormWhenClicked = false;
    }

    protected override void OnDestroy()
    {
        onPointerDownCallBack = null;
        onPointerUpCallBack = null;
        onPointerClickCallBack = null;
        onBeginDragCallBack = null;
        onDragCallBack = null;
        onEndDragCallBack = null;
        closeFormWhenClicked = false;
        base.OnDestroy();
    }

    public virtual void OnPointerDown(PointerEventData eventData)
    {
        this.m_canClick = true;

        m_downPosition = eventData.position;

        if (onPointerDownCallBack != null)
        {
            onPointerDownCallBack(eventData);
        }
        if(onPressCallBack != null)
        {
            onPressCallBack(true);
        }
    }

    public virtual void OnPointerUp(PointerEventData eventData)
    {
        if (onPointerUpCallBack != null)
        {
            onPointerUpCallBack(eventData);
        }

        if (onPressCallBack != null)
        {
            onPressCallBack(false);
        }
    }

    public virtual void OnPointerClick(PointerEventData eventData)
    {
        bool flag = true;
        if (belongedFormScript != null && !belongedFormScript.enableMultiClickedEvent)
        {
            flag = (belongedFormScript.clickedEventDispatchedCounter == 0);
            belongedFormScript.clickedEventDispatchedCounter++;
        }
        if (flag && m_canClick)
        {
            if (onPointerClickCallBack != null)
            {
                onPointerClickCallBack(eventData);
            }

            if (closeFormWhenClicked && belongedFormScript != null)
            {
                belongedFormScript.Close();
            }
        }
    }

    public virtual void OnBeginDrag(PointerEventData eventData)
    {
        if (this.m_canClick && belongedFormScript != null && belongedFormScript.ChangeScreenValueToForm(Vector2.Distance(eventData.position, this.m_downPosition)) > 40f)
        {
            this.m_canClick = false;
        }

        if (onBeginDragCallBack != null)
        {
            onBeginDragCallBack(eventData);
        }

        if (belongedListScript != null && belongedListScript.scrollRect != null)
        {
            belongedListScript.scrollRect.OnBeginDrag(eventData);
        }
    }

    public virtual void OnDrag(PointerEventData eventData)
    {
        if (this.m_canClick && belongedFormScript != null && belongedFormScript.ChangeScreenValueToForm(Vector2.Distance(eventData.position, this.m_downPosition)) > 40f)
        {
            this.m_canClick = false;
        }

        if (onDragCallBack != null)
        {
            onDragCallBack(eventData);
        }

        if (belongedListScript != null && belongedListScript.scrollRect != null)
        {
            belongedListScript.scrollRect.OnDrag(eventData);
        }
    }

    public virtual void OnEndDrag(PointerEventData eventData)
    {
        if (this.m_canClick && belongedFormScript != null && belongedFormScript.ChangeScreenValueToForm(Vector2.Distance(eventData.position, this.m_downPosition)) > 40f)
        {
            this.m_canClick = false;
        }

        if (onEndDragCallBack != null)
        {
            onEndDragCallBack(eventData);
        }

        if (belongedListScript != null && belongedListScript.scrollRect != null)
        {
            belongedListScript.scrollRect.OnEndDrag(eventData);
        }
    }
}
