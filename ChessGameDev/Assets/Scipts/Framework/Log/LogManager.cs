using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

public class LogManager:Singleton<LogManager>
{
    public string logFilePath = "";
    StringBuilder stb = new StringBuilder();
    public override void Init()
    {
        base.Init();
        CreteLogFile();
        AddLocalLogEvent();
    }

    public override void UnInit()
    {
        base.UnInit();
        Application.logMessageReceived -= LogHandle;
    }


    void CreteLogFile()
    {
        string logPath = FileManager.CombinePath(Application.persistentDataPath, "Log");
       // Debug.LogError(logPath);
        if (!FileManager.IsDirectoryExist(logPath))
            FileManager.CreateDirectory(logPath);
        logFilePath = FileManager.CombinePath(logPath, "unityerrorlog.txt");
        if(!FileManager.IsFileExist(logFilePath))
            File.Create(logFilePath);
    }

    void AddLocalLogEvent()
    {
        Application.logMessageReceived += LogHandle;
    }

    void LogHandle(string condition, string stackTrace, LogType type)
    {
            #if UNITY_EDITOR

            #else
             if (type==LogType.Exception)
             {
                 stb.Clear();
                 stb.Append(DateTime.Now.ToString()).Append(condition).Append(stackTrace).Append(System.Environment.NewLine);
                 ExecuteWriteLog(stb.ToString());
             }
            #endif


    }


    void ExecuteWriteLog(string text)
    {
        try
        {
            using (FileStream fs = new FileStream(logFilePath, FileMode.Append, FileAccess.Write))
            {
                byte[] tempData = System.Text.Encoding.UTF8.GetBytes(text);
                fs.Write(tempData, 0, tempData.Length);
                fs.Close();
                fs.Dispose();
            }
        }
        catch (System.Exception)
        {
               
        }
        
    }

}
