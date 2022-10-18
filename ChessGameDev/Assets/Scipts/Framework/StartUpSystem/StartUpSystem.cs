using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartUpSystem : Singleton<StartUpSystem>
{
    private StartUpView m_startUpView;

    public override void Init()
    {
        base.Init();
        m_startUpView = new StartUpView();
    }

    public void Open()
    {
        if (m_startUpView != null)
        {
            m_startUpView.OpenForm();
        }
    }

    public void Close()
    {
        if (m_startUpView != null)
        {
            m_startUpView.CloseForm();
        }
    }

    public GameObject GetFormObject()
    {
        return m_startUpView.CacheObject;
    }

    public void RefreshUIComponet(GameResVersionInfo gameResVersionInfo)
    {
        if (gameResVersionInfo != null)
        {
            if (gameResVersionInfo.gameVersionStatus == GameVersionStatus.Downloading)
            {
                m_startUpView.RefreshUIComponet(gameResVersionInfo.downloadedPercent);
            }
            else if (gameResVersionInfo.gameVersionStatus == GameVersionStatus.Unzip)
            {
                m_startUpView.RefreshUIComponet(gameResVersionInfo.currentUnzipPercent);
            }
        }
    }
}
