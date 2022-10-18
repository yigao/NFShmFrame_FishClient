using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StartUpView
{
    public const string StartUpLoading_Form_Path = "Prefab/StartUpLoadingForm";

    private UIFormScript m_uiForm;

    private Slider m_slider;

    private Text m_bar_text;

    private Text m_tips_info_text;

    [HideInInspector][System.NonSerialized] public GameObject CacheObject;

    [HideInInspector][System.NonSerialized] public Transform CacheTrans;


    public void OpenForm()
    {
        GetUIComponent();
        ShowUIComponet();
    }

    public void CloseForm()
    {
        Singleton<UIManager>.GetInstance().CloseForm(m_uiForm);
    }

    public void GetUIComponent()
    {
        UIFormScript form = Singleton<UIManager>.GetInstance().OpenFromInResourceForm(StartUpLoading_Form_Path, true);
        if (form == null)
        {
            Log.Error("打开启动窗口失败 :" + StartUpLoading_Form_Path);
            return;
        }

        if (this.m_uiForm != null && this.m_uiForm != form)
        {
            RemoveUIComponent();
        }

        if (this.m_uiForm == null)
        {
            this.m_uiForm = form;
        }

        if (this.CacheObject == null)
        {
            this.CacheObject = m_uiForm.gameObject;
        }

        if (this.CacheTrans == null)
        {
            this.CacheTrans = m_uiForm.transform;
        }

        if (m_slider == null)
        {
            this.m_slider = this.CacheTrans.Find("ProgressBar").GetComponent<Slider>();

        }

        if (m_bar_text == null)
        {
            this.m_bar_text = this.CacheTrans.Find("ProgressBar/bar").GetComponent<Text>();
        }

        if (m_tips_info_text == null)
        {
            this.m_tips_info_text = this.CacheTrans.Find("tips_content").GetComponent<Text>();
        }
    }


    public void RemoveUIComponent()
    {   
        this.m_uiForm = null;
        
        this.CacheObject = null;
        
        this.CacheTrans = null;
        
        this.m_slider = null;
        
        this.m_bar_text = null;
        
        this.m_tips_info_text = null;
    }

    public void ShowUIComponet()
    {
        m_slider.value = 0;
        m_bar_text.text = ((int)m_slider.value * 100).ToString() + "%";

    }

    public void RefreshUIComponet(float value)
    {
        m_slider.value = value;
        m_bar_text.text = ((int)(m_slider.value * 100)).ToString() + "%";
    }
}
