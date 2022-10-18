using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class GlobalBuildABWindows : EditorWindow
{

    public enum BuildUpdateType
    {
        LocalABUpdate=1,        //本地自己测试打包
        WholePackageUpdate=2,   //整包更新
        IncrementalUpdateType = 3,//增量更新
    }

    public enum BuildABType
    {
        AllAssetBuild=1,
        LuaAssetBuild=2,
    }
    public enum GameType
    {
        Hall=0,
        ConnectionMachine=1,
        Fishing=2,
        ScoreMachine=3,
    }

    public class BuildInfo
    {
        public string buildName;
        public string gameId;
        public GameType gameType = GameType.ConnectionMachine;

        public BuildInfo(string Id, string name, GameType gameType=GameType.ConnectionMachine)
        {
            buildName = name;
            gameId = Id;
            this.gameType = gameType;
        }
    }

    Vector2 scrollVector = Vector2.zero;
    BuildABType selectBuildType = BuildABType.AllAssetBuild;
    BuildUpdateType selectUpateType = BuildUpdateType.LocalABUpdate;

    static List<BuildInfo> hallBuildList = new List<BuildInfo>();
    static List<BuildInfo> gameBuildList = new List<BuildInfo>();
    static List<bool> selectHallList = new List<bool>();
    static List<bool> selectGameList = new List<bool>();

    static GlobalBuildABWindows buildABWindows = null;
    static bool isBuild = false;
    static bool isTips = false;
    static string tipsContext = "";

    public static Dictionary<string, List<string>> encryptList = new Dictionary<string, List<string>>();

    [MenuItem("BuildWindows/BuildABWindows")]
    public static void BuildABWindows()
    {
        InitData();
        buildABWindows = EditorWindow.GetWindowWithRect<GlobalBuildABWindows>(new Rect(0, 0, 1000, 500), true, "资源打包工具窗口界面");

    }

    static void InitData()
    {
        isTips = false;
        isBuild = true;
        encryptList.Clear();
        hallBuildList.Clear();
        gameBuildList.Clear();
        ReadLocalEncryptConfig();
        ReadLocalConfig();
        InitBuildData();
    }

    static void ReadLocalEncryptConfig()
    {
        string configPath = Application.dataPath + "/Editor/EncryptConfig.txt";
        if (File.Exists(configPath))
        {
            string[] allContext = File.ReadAllLines(configPath, System.Text.Encoding.UTF8);
            if (allContext.Length > 0)
            {
                for (int i = 0; i < allContext.Length; i++)
                {
                    string[] tempContext = allContext[i].Trim().Split('|');
                    if (tempContext.Length > 1)
                    {
                        if (encryptList.ContainsKey(tempContext[0]) == false)
                        {
                            encryptList.Add(tempContext[0],new List<string>());
                            for (int j = 1; j < tempContext.Length; j++)
                            {
                                encryptList[tempContext[0]].Add(tempContext[j]);
                            }
                        }
                        else
                            Log.Error("encryptList已经存在key==>>>" + tempContext[0]);
                       
                       
                    }

                }

            }

        }
        else
            Debug.LogError("本地配置文件不存在");

    }


    static void ReadLocalConfig()
    {
        string configPath = Application.dataPath + "/Editor/GameDefine.txt";
        if (File.Exists(configPath))
        {
            string[] allContext=File.ReadAllLines(configPath, System.Text.Encoding.UTF8);
            if(allContext.Length>0)
            {
                for (int i = 0; i < allContext.Length; i++)
                {
                    string[] tempContext=allContext[i].Trim().Split(',');
                    if(tempContext.Length>1)
                    {
                        int gameType = Convert.ToInt32(tempContext[2]);
                        if (gameType == (int)GameType.Hall)
                        {
                            BuildInfo tempBuildInfo = new BuildInfo(tempContext[0],tempContext[1],  GameType.Hall);
                            hallBuildList.Add(tempBuildInfo);
                        }
                        else
                        {
                            GameType tempType = GameType.ConnectionMachine;
                            switch (gameType)
                            {
                                case (int)GameType.Fishing: tempType = GameType.Fishing; break;
                                case (int)GameType.ScoreMachine: tempType = GameType.ScoreMachine; break;
                            }
                            BuildInfo tempBuildInfo = new BuildInfo(tempContext[0], tempContext[1], tempType);
                            gameBuildList.Add(tempBuildInfo);
                        }
                    }

                }

            }
            
        }
        else
            Debug.LogError("本地配置文件不存在");

    }


    static void InitBuildData()
    {
        selectHallList.Clear();
        selectGameList.Clear();
        InitSelectState();

    }

    static void InitSelectState()
    {
        if(hallBuildList.Count>0)
        {
            for (int i = 0; i < hallBuildList.Count; i++)
            {
                selectHallList.Add(false);
            }
        }

        if(gameBuildList.Count>0)
        {
            for (int j = 0; j < gameBuildList.Count; j++)
            {
                selectGameList.Add(false);
            }
        }
    }
    

    void OnGUI()
    {
        if (isBuild)
        {
            scrollVector = EditorGUILayout.BeginScrollView(scrollVector);
            EditorGUILayout.LabelField("==============================================选择更新模式（1.本地 2整包 3增量）===========================================");
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            selectUpateType = (BuildUpdateType)EditorGUILayout.EnumPopup("选择更新模式", selectUpateType);
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("==============================================Start========================================================================");
            EditorGUILayout.BeginHorizontal();

            BuildHallWindow();
            BuildGameWindow();

            EditorGUILayout.EndHorizontal();
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            //EditorGUILayout.LabelField("==============================================End===========================================");
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("==============================================选择资源打包模式（1.所有2.lua）=============================================");
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            selectBuildType = (BuildABType)EditorGUILayout.EnumPopup("选择资源打包模式", selectBuildType);

            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            BuildABPackage();


            EditorGUILayout.EndScrollView();
        }
        else
        {
            for (int i = 0; i < 30; i++)
            {
                EditorGUILayout.Space();
            }
            if (isTips)
            {
                EditorGUILayout.LabelField("==============================================错误提示======================================================");
                EditorGUILayout.Space();
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("                                    "+tipsContext);
            }
            else
            {
                EditorGUILayout.LabelField("==============================================打包完成===========================================");
                EditorGUILayout.Space();
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("==============================================END=============================================");
            }
        }
        



    }

    void BuildHallWindow()
    {
        EditorGUILayout.BeginVertical();
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.LabelField("选择需要打包的大厅");
        EditorGUILayout.Space();

        if(hallBuildList.Count>0)
        {
            for (int i = 0; i < hallBuildList.Count; i++)
            {
                selectHallList[i] = EditorGUILayout.Toggle(hallBuildList[i].buildName, selectHallList[i]);
            }
        }

        EditorGUILayout.EndVertical();
    }

    void BuildGameWindow()
    {
        EditorGUILayout.BeginVertical();
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.LabelField("选择需要打包的游戏");
        EditorGUILayout.Space();
        if (gameBuildList.Count > 0)
        {
            for (int i = 0; i < gameBuildList.Count; i++)
            {
                selectGameList[i] = EditorGUILayout.Toggle(gameBuildList[i].buildName, selectGameList[i]);
            }
        }


        EditorGUILayout.EndVertical();
    }


    void BuildABPackage()
    {
        if (GUILayout.Button("点击开始打包"))
        {
            BuildABAssets();
        }
    }

    List<BuildInfo> GetSelectBuildState(List<bool> selectList, List<BuildInfo> targetList)
    {
        List<BuildInfo> tempResult = new List<BuildInfo>();
        for (int i = 0; i < selectList.Count; i++)
        {
            if (selectList[i])
                tempResult.Add(targetList[i]);
        }
        return tempResult;
    }

    void BuildABAssets()
    {
        List<BuildInfo> hallAB = GetSelectBuildState(selectHallList, hallBuildList);
        List<BuildInfo> gameAB = GetSelectBuildState(selectGameList, gameBuildList);
        bool isIncrementalUpdate = false;
        bool isLocalAB = false;
        switch (selectBuildType)
        {

            case BuildABType.AllAssetBuild:
                switch(selectUpateType)
                {
                    case BuildUpdateType.LocalABUpdate:
                        isLocalAB = true;
                        break;
                    case BuildUpdateType.WholePackageUpdate:
                        isIncrementalUpdate = false;
                        break;
                    case BuildUpdateType.IncrementalUpdateType:
                        isIncrementalUpdate = true;
                        break;
                }
                BuildAssetBundle.BuildAsset(hallAB, gameAB, true,isIncrementalUpdate, isLocalAB);
                break;
            case BuildABType.LuaAssetBuild:
                switch (selectUpateType)
                {
                    case BuildUpdateType.LocalABUpdate:
                        isLocalAB = true;
                        break;
                    case BuildUpdateType.WholePackageUpdate:
                        isIncrementalUpdate = false;
                        break;
                    case BuildUpdateType.IncrementalUpdateType:
                        isIncrementalUpdate = true;
                        break;
                }
                BuildAssetBundle.BuildAsset(hallAB, gameAB, false, isIncrementalUpdate, isLocalAB);
                break;
            default:
                break;
        }
    }

    public static void CloseBuildABWindows()
    {
       // buildABWindows.Close();
        isBuild = false;
    }


    public static void SetBuildTips(string tipscontext)
    {
        isTips = true;
        tipsContext = tipscontext;
    }


}
