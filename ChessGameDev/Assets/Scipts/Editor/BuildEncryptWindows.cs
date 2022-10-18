using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class BuildEncryptWindows : EditorWindow
{
    static BuildEncryptWindows buildEncriptWindows = null;
    public static Dictionary<string, List<string>> encryptList = new Dictionary<string, List<string>>();
    public static Dictionary<string, List<byte>> encryptByteList = new Dictionary<string, List<byte>>();
   
    static bool isBuild = false;
    Vector2 scrollVector = Vector2.zero;
    static string keyStr = "";
    static string ivStr = "";
    static string criptsPath = "";

    [MenuItem("Tools/BuildEncrypt")]
    public static void BuildABWindows()
    {
        InitData();
        buildEncriptWindows = EditorWindow.GetWindowWithRect<BuildEncryptWindows>(new Rect(0, 0, 500, 500), true, "加密窗口界面");

    }


    static void InitData()
    {  
        isBuild = true;
        encryptList.Clear();
        encryptByteList.Clear();
        ReadLocalEncryptConfig();
        CaculateEncryptByte();
        criptsPath = Application.dataPath + "/XLua/Src/ObjectCasters.cs";
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
                            encryptList.Add(tempContext[0], new List<string>());
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
            Debug.LogError("本地加密配置文件不存在");

    }


    static void CaculateEncryptByte()
    {
        for (int i = 0; i < encryptList["LuaEncrypt"].Count; i++)
        {
            byte[] pBts = System.Text.Encoding.UTF8.GetBytes(encryptList["LuaEncrypt"][i]);
            //byte[] kBts = new byte[16];
            //int len = pBts.Length;
            //if (len > kBts.Length) len = kBts.Length;
            //System.Array.Copy(pBts, kBts, len);
            string tempStr = "";
            for (int j = 0; j < pBts.Length; j++)
            {
                tempStr = tempStr + " " + pBts[j];
               // if(j<16)
               // {
                    if(i==0)
                    {
                        if (encryptByteList.ContainsKey("LuaEncryptKey") == false)
                            encryptByteList.Add("LuaEncryptKey", new List<byte>());
                        encryptByteList["LuaEncryptKey"].Add(pBts[j]);
                    }else
                    {
                        if (encryptByteList.ContainsKey("LuaEncryptIv") == false)
                            encryptByteList.Add("LuaEncryptIv", new List<byte>());
                        encryptByteList["LuaEncryptIv"].Add(pBts[j]);
                    }
                   
               // }
            }
            if (i == 0)
                keyStr = tempStr;
            else
                ivStr = tempStr;
        }
    }
    
    void OnGUI()
    {
        if (isBuild)
        {
            scrollVector = EditorGUILayout.BeginScrollView(scrollVector);
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("==========================确认加密密码==============================");
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Key:==>>>      "+ encryptList["LuaEncrypt"][0]);
            EditorGUILayout.LabelField("key的长度必须等于16 ===>>>"+ encryptByteList["LuaEncryptKey"].Count );
            EditorGUILayout.LabelField(keyStr);

            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("IV:==>>>      " + encryptList["LuaEncrypt"][1]);
            EditorGUILayout.LabelField("IV的长度必须等于16 ===>>>" + encryptByteList["LuaEncryptIv"].Count);
            EditorGUILayout.LabelField(ivStr);
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            BuildEncryptGUI();


            EditorGUILayout.EndScrollView();
        }
        else
        {
            for (int i = 0; i < 30; i++)
            {
                EditorGUILayout.Space();
            }
          
           EditorGUILayout.LabelField("==========================加密完成======================");
           EditorGUILayout.Space();
           EditorGUILayout.Space();
           EditorGUILayout.LabelField("==========================END=======================");
        }




    }


    void BuildEncryptGUI()
    {
        if (GUILayout.Button("点击开始加密处理"))
        {
            WriteScriptsProcess();
        }
    }


    void WriteScriptsProcess()
    {
        string tempContent=File.ReadAllText(criptsPath);
        string[] tempContentS = File.ReadAllLines(criptsPath);
       // Log.Error(tempContentS[425]);
       // Log.Error(tempContentS[426]);
        byte[] keyStr = encryptByteList["LuaEncryptKey"].ToArray();
        byte[] ivStr = encryptByteList["LuaEncryptIv"].ToArray();
        string newStr="            int[] casterTr = new int[] { " + string.Format("{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}, {14}, {15}", keyStr[0], keyStr[1], keyStr[2], keyStr[3], keyStr[4], keyStr[5], keyStr[6], keyStr[7], keyStr[8], keyStr[9], keyStr[10], keyStr[11], keyStr[12], keyStr[13], keyStr[14], keyStr[15])+ " };";
       // Log.Error(newStr);

        string newStr1 = "            int[] casterTo = new int[] { " + string.Format("{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}, {14}, {15}", ivStr[0], ivStr[1], ivStr[2], ivStr[3], ivStr[4], ivStr[5], ivStr[6], ivStr[7], ivStr[8], ivStr[9], ivStr[10], ivStr[11], ivStr[12], ivStr[13], ivStr[14], ivStr[15]) + " };";
       // Log.Error(newStr1);

        tempContent =tempContent.Replace(tempContentS[425], newStr);
        tempContent = tempContent.Replace(tempContentS[426], newStr1);
        File.WriteAllText(criptsPath, tempContent);
        isBuild = false;
    }


}
