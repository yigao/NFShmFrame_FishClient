using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameMain : MonoSingleton<GameMain>
{
    public bool DeveloperMode = true;
    public bool UseLocalAssetBundle = true;
    public bool DebugMode = true;
    protected override void Init()
    {
        #if UNITY_EDITOR
            //UnityEditor.AssetDatabase.Refresh();
        #else
            DeveloperMode = false;
            UseLocalAssetBundle = false;
        #endif
        base.Init();
        Log.IsOpen = DebugMode;
        if(DebugMode==false)
            Debug.unityLogger.logEnabled = false;
    }


    private void Start()
    {
        Screen.orientation = ScreenOrientation.AutoRotation;
        Screen.autorotateToLandscapeLeft = true;
        Screen.autorotateToLandscapeRight = true;
        Screen.autorotateToPortrait = false;
        Screen.autorotateToPortraitUpsideDown = false;
       
        Screen.sleepTimeout = SleepTimeout.NeverSleep;

        SetGameFrameRate(60);
        InitBaseSys();
        if (!DeveloperMode)
        {
            Singleton<StartUpSystem>.GetInstance().Open();
        }
        Singleton<GameStateCtrl>.GetInstance().GotoState("LaunchState");
    }


    public void SetGameFrameRate(int CurrentFrameRate )
    {
        Application.targetFrameRate = CurrentFrameRate;
    }


    protected void InitBaseSys()
    {
        MonoSingleton<ResourceManager>.GetInstance();

        MonoSingleton<NetworkManager>.GetInstance();

        Singleton<UIManager>.CreateInstance();

        Singleton<VersionUpdateManager>.GetInstance();

        MonoSingleton<LuaManager>.GetInstance();

        MonoSingleton<CorotineManager>.GetInstance();

        MonoSingleton<UpdateManager>.GetInstance();

        Singleton<TimerManager>.CreateInstance();

        Singleton<TextManager>.CreateInstance();

        Singleton<GlobalConfigManager>.CreateInstance();

        Singleton<StartUpSystem>.CreateInstance();

        Singleton<GameStateCtrl>.CreateInstance();

        Singleton<GameStateCtrl>.GetInstance().Initialize();

        Singleton<EventManager>.GetInstance();

        Singleton<AtlasManager>.GetInstance();

        Singleton<LogManager>.GetInstance();

    }

    private void Update()
    {
        Singleton<TimerManager>.GetInstance().Update();
        Singleton<UIManager>.GetInstance().Update();
        Singleton<VersionUpdateManager>.GetInstance().Update();
    }

    private void LateUpdate()
    {
        Singleton<UIManager>.GetInstance().LateUpdate();
    }

    protected override void OnDestroy()
    {
        base.OnDestroy();
        DestroyBaseSys();
    }

    protected void DestroyBaseSys()
    {
        MonoSingleton<ResourceManager>.DestroyInstance();

        Singleton<UIManager>.DestroyInstance();

        MonoSingleton<NetworkManager>.DestroyInstance();

        Singleton<VersionUpdateManager>.DestroyInstance();

        MonoSingleton<LuaManager>.DestroyInstance();

        Singleton<TimerManager>.DestroyInstance();

        Singleton<TextManager>.DestroyInstance();

        Singleton<GlobalConfigManager>.DestroyInstance();

        Singleton<GameStateCtrl>.DestroyInstance();

        MonoSingleton<CorotineManager>.DestroyInstance();

        Singleton<EventManager>.DestroyInstance();

        Singleton<AtlasManager>.DestroyInstance();

        Singleton<LogManager>.DestroyInstance();
    }
}