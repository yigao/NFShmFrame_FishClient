using System;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using UnityEngine;
using BestHTTP;

public class VersionUpdateManager : Singleton<VersionUpdateManager>
{
    private GameResVersionInfo m_currentGameResInfo;
    
    private Dictionary<int, GameResVersionInfo> m_gameVersionInfoMap = new Dictionary<int, GameResVersionInfo>();

    private Queue<GameResVersionInfo> m_queue = new Queue<GameResVersionInfo>();

    public delegate void OnVersionUpdateComplete();

    private OnVersionUpdateComplete m_onVersionUpdateComplete;

    public override void Init()
    {
        base.Init();
        m_currentGameResInfo = null;
        m_gameVersionInfoMap.Clear();
       
        m_queue.Clear();
    }

    public void StartVersionUpdate(OnVersionUpdateComplete onVersionUpdateComplete)
    {
        if (onVersionUpdateComplete != null)
        {
            onVersionUpdateComplete();
        }
    }

    public void StartCheckGameVersion(int gameID,Action<GameResVersionInfo> callBack)
    {
        if (m_gameVersionInfoMap.ContainsKey(gameID))
        {
            if (m_gameVersionInfoMap[gameID].gameVersionStatus == GameVersionStatus.Wait_Download)
            {
                m_gameVersionInfoMap[gameID].GameResInfoCallBack(m_gameVersionInfoMap[gameID]);
            }
            return;
        }
        GameResVersionInfo gameResVersionInfo = new GameResVersionInfo(gameID, callBack);

        m_gameVersionInfoMap.Add(gameID, gameResVersionInfo);

        gameResVersionInfo.BeginCheckGameVersion();
    }

    public void CompareVersionFinished(GameResVersionInfo gameResVersionInfo)
    {
        gameResVersionInfo.GameResInfoCallBack(gameResVersionInfo);
        if (gameResVersionInfo.gameVersionStatus == GameVersionStatus.Version_Error)
        {
            m_gameVersionInfoMap.Remove(gameResVersionInfo.gameID);
        }
        else
        {
            if (gameResVersionInfo.gameVersionStatus == GameVersionStatus.Complete)
            {
                m_gameVersionInfoMap.Remove(gameResVersionInfo.gameID);
                return;
            }
            m_queue.Enqueue(gameResVersionInfo);
        }
    }

    public void Update()
    {
        if (m_queue.Count > 0)
        {
            m_currentGameResInfo = m_queue.Peek();
            switch (m_currentGameResInfo.gameVersionStatus)
            {
                case GameVersionStatus.Wait_Download:
                    {
                        m_currentGameResInfo.BeginDownloadGameRes();
                        break;
                    }
                case GameVersionStatus.Downloading:
                    {
                        if (m_currentGameResInfo.GameResInfoCallBack != null)
                        {
                            m_currentGameResInfo.GameResInfoCallBack(m_currentGameResInfo);
                        }
                        break;
                    }
                case GameVersionStatus.Download_Interrupted:
                    {
                        m_gameVersionInfoMap.Remove(m_currentGameResInfo.gameID);
                        m_queue.Dequeue();
                        if (m_currentGameResInfo.GameResInfoCallBack != null)
                        {
                            m_currentGameResInfo.GameResInfoCallBack(m_currentGameResInfo);
                        }
                        m_currentGameResInfo = null;
                        break;
                    }
                case GameVersionStatus.Downloaded:
                    {
                        m_currentGameResInfo.BeginUnZipFile();
                        break;
                    }
                case GameVersionStatus.Download_Error:
                    {
                        m_gameVersionInfoMap.Remove(m_currentGameResInfo.gameID);
                        m_queue.Dequeue();
                        if (m_currentGameResInfo.GameResInfoCallBack != null)
                        {
                            m_currentGameResInfo.GameResInfoCallBack(m_currentGameResInfo);
                        }
                        m_currentGameResInfo = null;
                        break;
                    }
                case GameVersionStatus.Unzip:
                    {
                        if (m_currentGameResInfo.GameResInfoCallBack != null)
                        {
                            m_currentGameResInfo.GameResInfoCallBack(m_currentGameResInfo);
                        }
                        break;
                    }
                case GameVersionStatus.Unzip_Error:
                    {
                        m_gameVersionInfoMap.Remove(m_currentGameResInfo.gameID);
                        m_queue.Dequeue();
                        if (m_currentGameResInfo.GameResInfoCallBack != null)
                        {
                            m_currentGameResInfo.GameResInfoCallBack(m_currentGameResInfo);
                        }
                        m_currentGameResInfo = null;
                        break;
                    }
                case GameVersionStatus.Complete:
                    {
                        m_queue.Dequeue();
                        m_gameVersionInfoMap.Remove(m_currentGameResInfo.gameID);
                        m_currentGameResInfo.UpdateGameResVersion();
                        if (m_currentGameResInfo.GameResInfoCallBack != null)
                        {
                            m_currentGameResInfo.GameResInfoCallBack(m_currentGameResInfo);
                        }
                        m_currentGameResInfo = null;
                        break;
                    }
            }
        }
    }
}
