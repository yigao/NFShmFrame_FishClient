using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
public class UINetWaitForm : UIComponent 
{
    private Action m_callBack;

    private float m_autoCloseTime;

    private float m_delayTime;

    private float m_timeElapse;

    private GameObject m_contextObject;


    public void ShowNetWaitForm(float autoCloseTime = 5,float delayTime = 0,Action callBack = null)
    {
        m_autoCloseTime = autoCloseTime;
        m_delayTime = delayTime;
        m_callBack = callBack;
        m_timeElapse = 0;
        m_contextObject = belongedFormScript.transform.Find("Context").gameObject;
        m_contextObject.SetActive(false);
    }

    public  void Update()
    {
        m_timeElapse += Time.deltaTime;
        if (m_timeElapse >= m_delayTime && !m_contextObject.activeInHierarchy)
        {
            m_contextObject.SetActive(true);
        }

        if (m_timeElapse >= m_autoCloseTime && m_autoCloseTime>=0)
        {
            if (m_callBack != null)
            {
                m_callBack();
            }
            CloseNetWaitForm();
        }
    }

    public void CloseNetWaitForm()
    {
        Singleton<UIManager>.GetInstance().CloseForm(belongedFormScript);
    }


    public override void Close()
    {
        base.Close();
        m_autoCloseTime = 0;
        m_delayTime = 0;
        m_callBack = null;
        m_timeElapse = 0;
        m_contextObject.SetActive(false);
    }
}
