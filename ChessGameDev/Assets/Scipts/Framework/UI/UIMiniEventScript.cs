using System;
using UnityEngine;
using UnityEngine.EventSystems;

public class UIMiniEventScript : UIComponent, IPointerDownHandler, IEventSystemHandler, IPointerClickHandler, IPointerUpHandler
{
    public bool closeFormWhenClicked;


    [NonSerialized]
    public UIEventPointerCallBack onMiniPointerDownCallBack = null;
    [NonSerialized]
    public UIEventPointerCallBack onMiniPointerUpCallBack = null;
    [NonSerialized]
    public UIEventPointerCallBack onMiniPointerClickCallBack = null;
    

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
        onMiniPointerDownCallBack = null;
        onMiniPointerUpCallBack = null;
        onMiniPointerClickCallBack = null;
        closeFormWhenClicked = false;
    }

    protected override void OnDestroy()
    {
        onMiniPointerDownCallBack = null;
        onMiniPointerUpCallBack = null;
        onMiniPointerClickCallBack = null;
        closeFormWhenClicked = false;
        base.OnDestroy();
    }

    public virtual void OnPointerDown(PointerEventData eventData)
    {
        if (onMiniPointerDownCallBack != null)
        {
            onMiniPointerDownCallBack(eventData);
        }
    }

    public virtual void OnPointerUp(PointerEventData eventData)
    {
        if (onMiniPointerUpCallBack != null)
        {
            onMiniPointerUpCallBack(eventData);
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
        if (flag)
        {
            if (onMiniPointerClickCallBack != null)
            {
                onMiniPointerClickCallBack(eventData);
            }

            if (closeFormWhenClicked && belongedFormScript != null)
            {
                belongedFormScript.Close();
            }
        }
    }

}
