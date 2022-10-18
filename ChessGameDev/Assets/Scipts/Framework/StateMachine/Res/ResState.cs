using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[GameState]
public class ResState : BaseState
{
    public override void OnStateEnter()
    {
        if (MonoSingleton<GameMain>.GetInstance().DeveloperMode)
        {
            OnVersionUpdateComplete();
        }
        else
        {
            Singleton<UIManager>.GetInstance().OpenNetWaitForm(-1, 0.5f, null);
            BeginStartUpGameRes();
        }
    }

    public override void OnStateLeave()
    {

    }

    public void BeginStartUpGameRes()
    {
        if (!MonoSingleton<GameMain>.GetInstance().UseLocalAssetBundle)
        {
            Singleton<VersionUpdateManager>.GetInstance().StartCheckGameVersion(0, GameResProcessCallBack);
        }
        else
        {
            OnVersionUpdateComplete();
        }
    }

    public IEnumerator DelayBeginStartUpGameRes()
    {
        Singleton<UIManager>.GetInstance().OpenNetWaitForm(-1, 0.5f, null);
        yield return new WaitForSeconds(2.0f);
        BeginStartUpGameRes();
    }


    public void GameResProcessCallBack(GameResVersionInfo gameResVersionInfo)
    {
        Singleton<UIManager>.GetInstance().CloseNetWaitForm();
        switch (gameResVersionInfo.gameVersionStatus)
        {
            case GameVersionStatus.Version_Error:
            {
                if (Application.internetReachability == NetworkReachability.NotReachable)
                {
                    Singleton<UIManager>.GetInstance().OpenMessageBox("网络出问题了，请检查您的网络！", true, false, false, () => { MonoSingleton<GameMain>.GetInstance().StartCoroutine(DelayBeginStartUpGameRes()); }, null, null);
                }
                else
                { 
                    Singleton<UIManager>.GetInstance().OpenMessageBox("网络出问题了，请检查您的网络！", true, false, false, () => { MonoSingleton<GameMain>.GetInstance().StartCoroutine(DelayBeginStartUpGameRes()); }, null, null);
                }
                break;
            }
            case GameVersionStatus.Download_Interrupted:
            {
                if (Application.internetReachability == NetworkReachability.NotReachable)
                {
                    Singleton<UIManager>.GetInstance().OpenMessageBox("网络出问题了，请检查您的网络！", true, false, false, () => { MonoSingleton<GameMain>.GetInstance().StartCoroutine(DelayBeginStartUpGameRes()); }, null, null);
                }
                else
                {
                    Singleton<UIManager>.GetInstance().OpenMessageBox("网络出问题了，请检查您的网络！", true, false, false, () => { MonoSingleton<GameMain>.GetInstance().StartCoroutine(DelayBeginStartUpGameRes()); }, null, null);
                }
                break;
            }
            case GameVersionStatus.Download_Error:
            {
                Singleton<UIManager>.GetInstance().OpenMessageBox("下载资源出错，请重新下载资源。", true, false, false, () => { MonoSingleton<GameMain>.GetInstance().StartCoroutine(DelayBeginStartUpGameRes()); }, null, null);
                break;
            }
            case GameVersionStatus.Unzip_Error:
            {
                Singleton<UIManager>.GetInstance().OpenMessageBox("解压资源出错，请重新解压资源。", true, false, false, () => { MonoSingleton<GameMain>.GetInstance().StartCoroutine(DelayBeginStartUpGameRes()); }, null, null);
                break;
            }
            case GameVersionStatus.Downloading:
            {
                Singleton<StartUpSystem>.GetInstance().RefreshUIComponet(gameResVersionInfo);
                break;
            }
            case GameVersionStatus.Unzip:
            {
                Singleton<StartUpSystem>.GetInstance().RefreshUIComponet(gameResVersionInfo);
                break;
            }
            case GameVersionStatus.Complete:
            {
                OnVersionUpdateComplete();
                break;
            }
        }
    }

    private void OnVersionUpdateComplete()
    {
        GameStateCtrl.GetInstance().GotoState("LuaState");
    }
}
