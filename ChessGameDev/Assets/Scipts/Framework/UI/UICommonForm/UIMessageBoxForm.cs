using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class UIMessageBoxForm : UIComponent
{
    private Action confrimCallback;

    private Action cancelCallback;

    private Action closeCallback;


    public void ShowMessageBoxForm(string strContent,bool isHaveConfirmBtn, bool isHaveCancelBtn,bool isHaveCloseBtn ,Action confirmCallBack, Action cancelCallBack,Action closeCallBack, string confirmStr = "", string cancelStr = "", int autoCloseTime = 0)
    {
        if (belongedFormScript == null)
        {
            return;
        }
        GameObject gameObject = belongedFormScript.gameObject;
  
        if (gameObject == null)
        {
            return;
        }
        if (string.IsNullOrEmpty(confirmStr))
        {
            confirmStr = "确定";
        }
        if (string.IsNullOrEmpty(cancelStr))
        {
            cancelStr = "取消";
        }
        this.confrimCallback = confirmCallBack;

        this.cancelCallback = cancelCallBack;

        this.closeCallback = closeCallBack;
        
        GameObject obj3 = gameObject.transform.Find("Content/btnGroup/Button_Confirm").gameObject;
        obj3.GetComponentInChildren<Text>().text = confirmStr;
        GameObject obj4 = gameObject.transform.Find("Content/btnGroup/Button_Cancel").gameObject;
        obj4.GetComponentInChildren<Text>().text = cancelStr;

        GameObject obj5 = gameObject.transform.Find("Content/Close_Btn").gameObject;
        Text component = gameObject.transform.Find("Content/Info_Text").GetComponent<Text>();
        component.text = strContent;

        if (!isHaveConfirmBtn)
        {
            obj3.SetActive(false);
        }
        else
        {
            obj3.SetActive(true);
        }

        if (!isHaveCancelBtn)
        {
            obj4.SetActive(false);
        }
        else
        {
            obj4.SetActive(true);
        }

        if (!isHaveCloseBtn)
        {
            obj5.SetActive(false);
        }
        else
        {
            obj5.SetActive(true);
        }

        UIEventScript script2 = obj3.GetComponent<UIEventScript>();
        UIEventScript script3 = obj4.GetComponent<UIEventScript>();
        UIEventScript script5 = obj5.GetComponent<UIEventScript>();
        script2.onPointerClickCallBack = ConfirmOnPointerClick;
        script3.onPointerClickCallBack = CancelOnPointerClick;
        script5.onPointerClickCallBack = CloseOnPointerClick;

        if (autoCloseTime != 0)
        {
            Transform transform = belongedFormScript.transform.Find("Content/closeTimer");
            if (transform != null)
            {
                UITimerScript script4 = transform.GetComponent<UITimerScript>();
                if (script4 != null)
                {
                    script4.timerUpCallBack = AutoCloseForm;
                    script4.SetTotalTime((float)autoCloseTime);
                    script4.StartTimer();
                }
            }
        }
    }


    public void AutoCloseForm()
    {
        Singleton<UIManager>.GetInstance().CloseForm(belongedFormScript);
    }

    public void ConfirmOnPointerClick(PointerEventData eventData)
    {
        if (confrimCallback != null)
        {
            confrimCallback();
        }
        Singleton<UIManager>.GetInstance().CloseForm(belongedFormScript);
    }

    public void CancelOnPointerClick(PointerEventData eventData)
    {
        if (cancelCallback != null)
        {
            cancelCallback();
        }
        Singleton<UIManager>.GetInstance().CloseForm(belongedFormScript);
    }

    public void CloseOnPointerClick(PointerEventData eventData)
    {
        if (closeCallback != null)
        {
            closeCallback();
        }
        Singleton<UIManager>.GetInstance().CloseForm(belongedFormScript);
    }

    public override void Close()
    {
        base.Close();
        confrimCallback = null;
        cancelCallback = null;
        closeCallback = null;
    }
}
