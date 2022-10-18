using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class PathDefine
{
    public const string HallName = "Lobby";

    public const string ABSuffix = ".unity3d";

    public static string GetPlatformName
    {
        get
        {
            string result = string.Empty;
            #if UNITY_STANDALONE_WIN
                result = "PC";
            #elif UNITY_ANDROID
                result = "Android";
            #elif UNITY_IPHONE
                result = "IOS";
            #endif
            return result;
        }
    }


    public static string GetRelativeAssetBundlePath
    {
        get
        {
            return "Assets/AssetBundle/";
        }
    }


    public static string GetRelativeGameAssetBundlePath
    {
        get
        {
            return "GameAssetBundle/";
        }
    }

    public static string GetSourceAssetBundlePath
    {
        get
        {
            return Application.dataPath + "/AssetBundle";
        }
    }

    public static string GetDataPath
    {
        get
        {
            return Application.dataPath;
        }
    }

    public static string GetPersistentDataPath
    {
        get
        {
            return Application.persistentDataPath;
        }
    }

    public static string AppStreamingAssetsPath()
    {
        string result = string.Empty;
        RuntimePlatform platform = Application.platform;
        if (platform != RuntimePlatform.Android)
        {
            if (platform != RuntimePlatform.IPhonePlayer)
            {
                result = Application.dataPath + "/StreamingAssets/";
            }
            else
            {
                result = Application.dataPath + "/Raw/";
            }
        }
        else
        {
            result = "jar:file://" + Application.dataPath + "!/assets/";
        }
        return result;
    }

    public static string AppGameResDownloadPath()
    {
        string result = AppPersistentDataPathPath() + ("Download/" + GetPlatformName + "/").ToLower();
        return result;
    }

    public static string ABResPersistentDataPathPath()
    {
         string result = string.Empty;
        #if UNITY_EDITOR
            string[] dris = Environment.GetLogicalDrives();
            result = dris[dris.Length - 1] + "ABResources" +"/AssetBundle/";
        #endif
        return result;
    }

    public static string AppPersistentDataPathPath()
    {
        string result = string.Empty;
        #if UNITY_EDITOR
            string[] dris = Environment.GetLogicalDrives();
            result = dris[dris.Length - 1] + "AssetBundle/";
            // result = Application.streamingAssetsPath + "/AssetBundle/";
        #else
             result= Application.persistentDataPath+ "/assetbundle/";
        #endif

        return result;
    }
}

