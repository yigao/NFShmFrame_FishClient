using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;
using XLua;

public class LuaManager : MonoSingleton<LuaManager>
{
    public const string GameLua_Path = "H/Lua/GameLua";
    const string LuaEntrance = "loader.Main";
    const string luaABSuffix = ".bytes";
    const string luaExtension = ".lua";
    const string protoExtension = ".proto";
    const string luaName = "1w4@P90";
    public bool IsOpenLuaLog = true;
    public bool DeveloperMode = false;
    public bool isLoadLua = false;
    public Action<bool> onApplicationFocus = null;
    private LuaEnv m_luaEnv;
    private float m_mLastGcTime = 0;
    public const float GcInterval = 10; 
    private Dictionary<string, AssetBundle> m_bundleMap = new Dictionary<string, AssetBundle>();
    private Dictionary<string, List<string>> m_luaFileMap = new Dictionary<string, List<string>>();

    #region 初始化

    public LuaEnv luaEnv
    {
        get { return m_luaEnv; }
    }

    protected override void Init()
    {
        m_bundleMap.Clear();
        m_luaFileMap.Clear();
        IsOpenLuaLog = MonoSingleton<GameMain>.GetInstance().DebugMode;
        DeveloperMode = MonoSingleton<GameMain>.GetInstance().DeveloperMode;
    }

    public void Initialize()
    {
        m_luaEnv = new LuaEnv();

        //添加第三方库
       // m_luaEnv.AddBuildin("rapidjson", XLua.LuaDLL.Lua.LoadRapidJson);
        m_luaEnv.AddBuildin("pb", XLua.LuaDLL.Lua.LoadLuaProfobuf);

        //自定义加载lua
        m_luaEnv.AddLoader(CustomLoader);

        LuaTable tempLuaT = RunLuaScriptOnNewTable(GameLua_Path);
        Action LuaMain = tempLuaT.GetInPath<Action>(LuaEntrance);
        if (LuaMain != null)
        {
            LuaMain();
        }
    }

    #endregion

    
    #region  lua加载

    public object[] DoString(string fileName)
    {
        return m_luaEnv.DoString(string.Format("require '{0}'",fileName));
    }

    public LuaTable RunLuaScriptOnNewTable(string luaScriptName,string chunkName = "chunk")
    {
        string fileName = string.Format("require '{0}'", luaScriptName);
        LuaTable luaTable = m_luaEnv.NewTable();
        LuaTable meta = m_luaEnv.NewTable();
        meta.Set("__index", m_luaEnv.Global);
        luaTable.SetMetaTable(meta);
        meta.Dispose();
        m_luaEnv.DoString(fileName, chunkName);
        return luaTable;
    }

    private byte[] CustomLoader(ref string fileName)
    {
        if (string.IsNullOrEmpty(fileName))
        {
            Log.Error("Lua file name is empty");
            return null;
        }
        isLoadLua = true;
        byte[] data= LoadFileRes(fileName, luaExtension);
        return data;
    }

   

    public string GetProtoFile(string fileName)
    {
        if (string.IsNullOrEmpty(fileName))
        {
            Log.Error("Lua file name is empty");
            return null;
        }
        byte[] data = LoadFileRes(fileName, protoExtension);
        if (data != null)
        {
            return System.Text.Encoding.UTF8.GetString(data);
        }
        else
        {
            return null;
        }
    }


    private byte[] LoadFileRes(string fileName, string extension)
    {
        if (string.IsNullOrEmpty(fileName))
        {
            Log.Error("Lua file name is empty");
            return null;
        }
        string key = string.Empty;
        string filePath = string.Empty;
        AssetBundle bundle = null;
        string luaFlag = fileName.Substring(0, fileName.IndexOf("/"));
        string str = fileName.Substring(fileName.IndexOf("/") + 1).ToLower();
        if (luaFlag.Equals("H"))
        {
            key = Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower();
            filePath = FileManager.CombinePath(Singleton<GlobalConfigManager>.GetInstance().Hall_Name, str).ToLower();
            //Log.Error(filePath);
        }
        else if (luaFlag.Equals("G"))
        {
            key = str.Substring(0, str.IndexOf("/"));
            filePath = str;
        }
        if (MonoSingleton<GameMain>.GetInstance().DeveloperMode)
        {
            string fullFilePath = FileManager.CombinePath(PathDefine.GetSourceAssetBundlePath, filePath);
           // Log.Error(fullFilePath);
            if (!fullFilePath.EndsWith(extension))
            {
                fullFilePath += extension;
            }
            return FileManager.ReadFile(fullFilePath);
        }
        else
        {
            m_bundleMap.TryGetValue(key, out bundle);
            if (bundle==null)
                bundle=LoadLuaBundle(key);
            if(bundle!=null)
            {
               
                string luaFileName = new StringBuilder().Append(filePath.Substring(filePath.LastIndexOf("/") + 1)).Append(extension).Append(luaABSuffix).ToString();
                TextAsset luaScipt = bundle.LoadAsset<TextAsset>(luaFileName);
                if (luaScipt != null)
                {
                    return luaScipt.bytes;
                }
                else
                {
                    Log.Error("file path is error" + fileName);
                }
            }else
                Log.Error("luaABFile path is error" + key);



            return null;
        }
    }


    public AssetBundle LoadLuaBundle(string key)
    {
    
        AssetBundle bundle = null;
        if (string.IsNullOrEmpty(key))
        {
            Log.Error("lua asset bundle path is empty");
            return null;
        }
        string abPath = ( key + "/lua/lua_"+key+PathDefine.ABSuffix).ToLower();
        string filePath = FileManager.ReplacePathSymbol( FileManager.CombinePath(FileManager.GetIFSExtractPath(), abPath));
        string fileName = Path.GetFileNameWithoutExtension(filePath).ToLower();
        byte[] tempD = System.Text.UTF8Encoding.UTF8.GetBytes(fileName);
        bundle = AssetBundle.LoadFromFile(filePath, 0, (ulong)(tempD.Length + 1000));
        if (bundle != null)
        {
            m_bundleMap.Add(key, bundle);
            return bundle;
        }
        else
        {
            Log.Warning("Load assetbunle is fail,please check out luafile path");
        }
        return null;
    }


    public void RemoveGameLuaBundle(string gameId)
    {
        if(m_bundleMap.ContainsKey(gameId))
        {
            AssetBundle ab = null;
            m_bundleMap.TryGetValue(gameId,out ab);
            if(ab!=null)
            {
                ab.Unload(true);
            }
            m_bundleMap.Remove(gameId);
        }
    }


    public string GetLuaName()
    {
        return luaName;
    }

    #endregion


    #region Update事件


    void Update()
    {
        if (Time.time - m_mLastGcTime > GcInterval && m_luaEnv != null)
        {
            m_luaEnv.Tick();
            m_mLastGcTime = Time.time;
        }
    }


    protected override void OnDestroy()
    {
        foreach (KeyValuePair<string, AssetBundle> bundle in m_bundleMap)
        {
            bundle.Value.Unload(false);
        }

        m_bundleMap.Clear();
        Resources.UnloadUnusedAssets();
        #if UNITY_EDITOR

        #else
             m_luaEnv.Dispose(); 
        #endif
        m_luaEnv = null;
        GC.Collect();

    }

    #endregion


    #region  游戏功能

    /// <summary>
    /// 设置帧率
    /// </summary>
    /// <param name="CurrentFrameRate"></param>
    public void SetGameFrameRate(int CurrentFrameRate)
    {
        Application.targetFrameRate = CurrentFrameRate;
    }

    /// <summary>
    /// 设置横竖屏
    /// </summary>
    /// <param name="isPortrait">是否竖屏</param>
    public void SetScreenOrientation(bool isPortrait)
    {
        if(isPortrait)
        {
            Screen.orientation = ScreenOrientation.Portrait;
            Screen.autorotateToLandscapeLeft = false;
            Screen.autorotateToLandscapeRight = false;
            Screen.autorotateToPortrait = true;
            Screen.autorotateToPortraitUpsideDown = true;
            
        }
        else
        {
            Screen.orientation = ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
           
        }

        Screen.orientation = ScreenOrientation.AutoRotation;


    }


    /// <summary>
    /// 切后台广播
    /// </summary>
    /// <param name="isFocus"></param>
    void OnApplicationFocus(bool isFocus)
    {
        #if UNITY_EDITOR
            return;

        #else
            if (onApplicationFocus != null)
                onApplicationFocus(isFocus);
        #endif

    }


    /// <summary>
    /// 获取AnimationState
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="animName"></param>
    /// <returns></returns>
    public AnimationState GetAnimationState(Animation anim,string animName)
    {
        AnimationState anims=anim[animName];
        if (anims)
            return anims;
        return null;
    }

    /// <summary>
    /// 获取动画状态是否正在播放
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="animName"></param>
    /// <returns></returns>
    public bool CheckCurrentAnimationIsPlaying(Animation anim, string animName)
    {
        if (anim == null || string.IsNullOrEmpty(animName)) return false;
        return anim.IsPlaying(animName);
    }


    public string GetMD5(string strContent)
    {
        return FileManager.GetMd5(strContent);
    }


    public void QuitGame()
    {
        Application.Quit();
    }



    #endregion



}
