using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using System.Xml;
using static GlobalBuildABWindows;
using System;

public class BuildAssetBundle : Editor
{

    private static List<string> assetsPathList = new List<string>();
    private static List<string> luaPathList = new List<string>();
    private static List<string> manifestFilePathList = new List<string>();
    private static List<AssetBundleBuild> abMapList = new List<AssetBundleBuild>();
    private static List<AssetBundleBuild> luaMapList = new List<AssetBundleBuild>();
    static List<MD5Info> allFileMd5InfoList = new List<MD5Info>();

    static string abRootPath = Application.dataPath + "/AssetBundle/";
    static string outAssetBundlePath = FileManager.GetBuildABPath();
    static bool isIncrementalUpdate = false;    //是否使用增量更新方式
    static bool isIncrementalUpdateToWhole = false; //是否开启增量更新中的整包更新
    static bool isLocalAB = false;              //是否本地自己打包方式
                                                // static bool isBuildAssetAB = false;         //是否打包所有资源
    static string compareFileName = "MD5CompareFile";
    static string compareVersionFileSize = "";
    static string buildAllMD5JsonData = "";
    static string currentSeverCompareFilePath = ""; //md5对比文件
    static string currentSeverCompareVersionFilePath = "";  //vesion对比文件
    static string versionFile = "version.xml";
    static string md5CompareFilePath = "";



    public static void BuildAsset(List<BuildInfo> hallABList, List<BuildInfo> gameABList, bool isAssetBD, bool isIncrementalUpdate, bool isLocalAB = false)
    {
        BuildAssetBundle.isLocalAB = isLocalAB;
        BuildAssetBundle.isIncrementalUpdate = isIncrementalUpdate;
        // Debug.LogError("是否是增量更新==>>>");
        // Debug.LogError(isIncrementalUpdate);


        if (hallABList.Count > 0)
        {
            for (int i = 0; i < hallABList.Count; i++)
            {
                BuildAssetProcess(hallABList[i].gameId, isAssetBD, false);
            }
        }


        if (gameABList.Count > 0)
        {
            for (int i = 0; i < gameABList.Count; i++)
            {
                bool isFish = false;
                if (gameABList[i].gameType == GlobalBuildABWindows.GameType.Fishing)
                {
                    isFish = true;
                }
                BuildAssetProcess(gameABList[i].gameId, isAssetBD, isFish);
            }
        }

        GlobalBuildABWindows.CloseBuildABWindows();
    }


    public static void BuildAssetProcess(string assetID, bool isAssetBD, bool isFish)
    {
        luaPathList.Clear();
        assetsPathList.Clear();
        abMapList.Clear();
        luaMapList.Clear();
        manifestFilePathList.Clear();
        allFileMd5InfoList.Clear();
        isIncrementalUpdateToWhole = false;
        md5CompareFilePath = "";

        BuildAssetBundle.currentSeverCompareFilePath = "";
        BuildAssetBundle.currentSeverCompareVersionFilePath = "";
        string rootPath = outAssetBundlePath + "/ABUpdate/" + assetID;
        if (FileManager.IsDirectoryExist(rootPath))
            FileManager.DeleteDirectory(rootPath);
        string severCompareFilePath = rootPath + "/SeverCompareFile/";
        if (!FileManager.IsDirectoryExist(severCompareFilePath))
            FileManager.CreateDirectory(severCompareFilePath);

        if (BuildAssetBundle.isIncrementalUpdate)
        {

            BuildAssetBundle.currentSeverCompareFilePath = EditorUtility.OpenFilePanel(assetID + "增量更新方式==>请先选择<<MD5>>对比文件==>>>", severCompareFilePath, "txt").ToLower();
            if (string.IsNullOrEmpty(BuildAssetBundle.currentSeverCompareFilePath))
            {
                GlobalBuildABWindows.SetBuildTips("增量更新方式未发现MD5原始对比文件，请检查是否存在或第一次更新，第一次出包请使用 《整包更新》 方式打包");
                return;
            }

            BuildAssetBundle.currentSeverCompareVersionFilePath = EditorUtility.OpenFilePanel(assetID + "《《选择Version对比文件 》》===>(增量更新方式==>必须先选择<<VERSION>>对比文件==>>>)", severCompareFilePath, "xml").ToLower();
            if (string.IsNullOrEmpty(BuildAssetBundle.currentSeverCompareVersionFilePath))
            {
                GlobalBuildABWindows.SetBuildTips("增量更新方式未发现Version原始对比文件，请检查是否存在或第一次更新，第一次出包请使用 《整包更新》 方式打包");
                return;
            }

        }

        string abPath = abRootPath + assetID;
        if (isAssetBD)
        {
            FileManager.GetAllFile(abPath, ref assetsPathList, "Lua");
            BuildAssetsAB(assetID);
            BuildLuaAB(abPath, assetID);
            CopyManifestFileToGame(assetID);
        }
        else
        {
            BuildLuaAB(abPath, assetID);
        }
        ClearManifestFile(assetID);

        IsCopyFishTraceFile(abPath, assetID, isFish, isAssetBD);

        if (isAssetBD)
            AssetEncrypt(outAssetBundlePath, assetID, GlobalBuildABWindows.encryptList["AssetEncrypt"][0], GlobalBuildABWindows.encryptList["AssetEncrypt"][1]);
        else
            LuaAssetEncrypt(outAssetBundlePath, assetID, GlobalBuildABWindows.encryptList["AssetEncrypt"][0], GlobalBuildABWindows.encryptList["AssetEncrypt"][1]);

        BuildUpdateProcess(outAssetBundlePath, assetID);

        BuildIncrementalUpdateToWhole(outAssetBundlePath, assetID);


    }


    public static void IsCopyFishTraceFile(string abPath, string assetID, bool isFish, bool isBuildAssetAB)
    {
        if (isFish == false) return;
        if (isBuildAssetAB == false) return;
        string relactivePath = "Common/config/traces.pack";
        string tracePath = FileManager.CombinePath(abPath, relactivePath);
        string outPath = FileManager.CombinePaths(outAssetBundlePath, assetID, relactivePath);
        File.Copy(tracePath, outPath);
    }


    public static void BuildAssetsAB(string assetID)
    {
        AssetBundleBuild abbd = new AssetBundleBuild();
        abbd.assetBundleVariant = null;
        List<string> cacheABName = new List<string>();
        for (int j = 0; j < assetsPathList.Count; j++)
        {
            cacheABName.Clear();
            string assetsPath = assetsPathList[j].Substring(Application.dataPath.Length + 1);
            string tempPath = "Assets/" + assetsPath;
            string assetBDName = assetsPath.Replace(Path.GetExtension(assetsPath), PathDefine.ABSuffix);
            assetBDName = assetBDName.Substring("AssetBundle/".Length);
            abbd.assetBundleName = assetBDName;
            cacheABName.Add(tempPath);
            abbd.assetNames = cacheABName.ToArray();
            abMapList.Add(abbd);
            abbd.assetBundleName = null;
            abbd.assetNames = null;

        }
        if (!FileManager.IsDirectoryExist(outAssetBundlePath))
        {
            // Log.Error(outAssetBundlePath);
            FileManager.CreateDirectory(outAssetBundlePath);
        }
        string outABPath = outAssetBundlePath + "/" + assetID;
        //Log.Error(outABPath);
        if (FileManager.IsDirectoryExist(outABPath))
        {
            // Log.Error(outABPath);
            FileManager.DeleteDirectory(outABPath);
            // Directory.Delete(outABPath,true);
        }
        AssetBundleBuild[] tempAs = abMapList.ToArray();
        BuildPipeline.BuildAssetBundles(outAssetBundlePath, tempAs, BuildAssetBundleOptions.ChunkBasedCompression | BuildAssetBundleOptions.DeterministicAssetBundle, EditorUserBuildSettings.activeBuildTarget);
        AssetDatabase.Refresh();
    }

    public static void BuildLuaAB(string targetFilePath, string assetID)
    {
        if (Directory.Exists(targetFilePath))
        {
            List<string> copyLuaFilePathList = new List<string>();
            FileManager.GetAllocateFile(targetFilePath, ".lua", ref luaPathList);
            FileManager.GetAllocateFile(targetFilePath, ".proto", ref luaPathList);
            for (int i = 0; i < luaPathList.Count; i++)
            {
                if (File.Exists(luaPathList[i]))
                {
                    string copyPath = luaPathList[i] + ".bytes";
                    // File.Copy(luaPathList[i], copyPath, true);
                    fileEncrypt(luaPathList[i], copyPath, GlobalBuildABWindows.encryptList["LuaEncrypt"][0], GlobalBuildABWindows.encryptList["LuaEncrypt"][1]);
                    copyPath = "Assets/" + copyPath.Substring(Application.dataPath.Length + 1);
                    copyLuaFilePathList.Add(copyPath);
                }
            }


            AssetDatabase.Refresh();

            List<AssetBundleBuild> tempLuaMapList = new List<AssetBundleBuild>();
            AssetBundleBuild abb = new AssetBundleBuild();
            abb.assetBundleName = "lua_" + assetID + PathDefine.ABSuffix;
            abb.assetNames = copyLuaFilePathList.ToArray();
            tempLuaMapList.Add(abb);

            string outLuaABPath = FileManager.CombinePaths(outAssetBundlePath, assetID, "Lua").ToLower(); 

            if (FileManager.IsDirectoryExist(outLuaABPath))
            {
                FileManager.DeleteDirectory(outLuaABPath);
            }
            FileManager.CreateDirectory(outLuaABPath);
            AssetBundleBuild[] tempAs = tempLuaMapList.ToArray();
            BuildPipeline.BuildAssetBundles(outLuaABPath, tempAs, BuildAssetBundleOptions.ChunkBasedCompression | BuildAssetBundleOptions.DeterministicAssetBundle, EditorUserBuildSettings.activeBuildTarget);
            for (int i = 0; i < copyLuaFilePathList.Count; i++)
            {
                File.Delete(copyLuaFilePathList[i]);
            }
            AssetDatabase.Refresh();

            //删除luaManifest文件
            string luaManifestFile = FileManager.CombinePaths(outAssetBundlePath, assetID, "/lua/lua");//outAssetBundlePath + assetID + "/lua/lua";
            if (FileManager.IsFileExist(luaManifestFile))
            {
                File.Delete(luaManifestFile);
            }
            else
                Log.Error("No Exist:" + luaManifestFile);

        }
    }



    public static void fileEncrypt(string orsPath, string desPath, string key, string iv)
    {
        byte[] encryptData = null;
        using (FileStream fs = new FileStream(orsPath, FileMode.Open, FileAccess.Read))
        {
            byte[] tempData = new byte[fs.Length];
            fs.Read(tempData, 0, (int)fs.Length);
            string encryptStr = XLua.ObjectTranslator.OpenLib(new IntPtr(), tempData, key, iv);
            encryptData = System.Text.ASCIIEncoding.UTF8.GetBytes(encryptStr);
            fs.Close();
            fs.Dispose();
        }

        using (FileStream fs = new FileStream(desPath, FileMode.CreateNew, FileAccess.Write))
        {
            fs.Write(encryptData, 0, encryptData.Length);
            fs.Close();
            fs.Dispose();
        }


    }


    public static void AssetEncrypt(string rootPath, string gameID, string key, string iv)
    {
        string abPath = FileManager.CombinePath(rootPath, gameID);
        List<string> allABFilePathList = new List<string>();
        FileManager.GetAllFile(abPath, ref allABFilePathList);
        if (allABFilePathList.Count > 0)
        {
            for (int i = 0; i < allABFilePathList.Count; i++)
            {
                if (!(Path.GetExtension(allABFilePathList[i]) == ".pack"))
                {
                    byte[] rawData = File.ReadAllBytes(allABFilePathList[i]);
                    FileManager.DeleteFile(allABFilePathList[i]);
                    AssetEncript(allABFilePathList[i], rawData);
                }
            }

        }

    }


    public static void LuaAssetEncrypt(string rootPath, string gameID, string key, string iv)
    {
        string abPath = FileManager.CombinePaths(rootPath, gameID, "lua");
        List<string> allABFilePathList = new List<string>();
        FileManager.GetAllFile(abPath, ref allABFilePathList);
        if (allABFilePathList.Count > 0)
        {
            for (int i = 0; i < allABFilePathList.Count; i++)
            {
                if (!(Path.GetExtension(allABFilePathList[i]) == ".pack"))
                {
                    byte[] rawData = File.ReadAllBytes(allABFilePathList[i]);
                    FileManager.DeleteFile(allABFilePathList[i]);
                    AssetEncript(allABFilePathList[i], rawData);
                }
            }

        }

    }


    static void AssetEncript(string filePath, byte[] rawData)
    {
        string fileName = Path.GetFileNameWithoutExtension(filePath);
        // Log.Error(fileName);
        byte[] md5Byte = System.Text.UTF8Encoding.UTF8.GetBytes(fileName);
        byte[] copyData = new byte[md5Byte.Length + rawData.Length + 1000];
        int i = 0;
        byte[] tempHeadB = new byte[1000];
        for (int j = 0; j < 1000; j++)
        {
            tempHeadB[j] = rawData[j];
        }

        foreach (var item in tempHeadB)
        {
            copyData[i] = item;
            i += 1;
        }

        foreach (var item in md5Byte)
        {
            copyData[i] = item;
            i += 1;
        }

        foreach (var item in rawData)
        {
            copyData[i] = item;
            i += 1;
        }
        using (FileStream fs = new FileStream(filePath, FileMode.Create, FileAccess.Write))
        {
            fs.Write(copyData, 0, copyData.Length);
            fs.Close();
            fs.Dispose();
        }
    }





    public static void CopyManifestFileToGame(string assetID)
    {
        string manifestFilePath = FileManager.CombinePath(outAssetBundlePath, PathDefine.GetPlatformName);
        string toPath = outAssetBundlePath + "/" + assetID + "/" + assetID;//(assetID=="Lobby"?"0001":assetID);
        if (FileManager.IsFileExist(toPath))
        {
            FileManager.DeleteFile(toPath);
        }
        if (FileManager.IsFileExist(manifestFilePath))
            FileManager.CopyFile(manifestFilePath, toPath.ToLower());
    }


    public static void ClearManifestFile(string gameID)
    {
        FileManager.GetAllocateFile(FileManager.CombinePath(outAssetBundlePath, gameID), ".manifest", ref manifestFilePathList);
        for (int i = 0; i < manifestFilePathList.Count; i++)
        {
            if (File.Exists(manifestFilePathList[i]))
            {
                File.Delete(manifestFilePathList[i]);
            }
        }
    }


    public static void BuildUpdateProcess(string rootPath, string gameID)
    {
        if (BuildAssetBundle.isLocalAB) return;
        md5CompareFilePath = CreateMD5CompareFile(rootPath, gameID);
        bool isScucess = SetCompareUpdateProcess(rootPath, gameID, md5CompareFilePath);
        if (isScucess == false) return;
        SetIncrementalUpdateProcess(rootPath, gameID);

    }


    public static void BuildIncrementalUpdateToWhole(string rootPath, string gameID)
    {
        if (isIncrementalUpdate)
        {
            isIncrementalUpdate = false;
            bool isScucess = SetCompareUpdateProcess(rootPath, gameID, md5CompareFilePath);
            if (isScucess == false) return;
            SetIncrementalUpdateProcess(rootPath, gameID);
        }
        isIncrementalUpdateToWhole = false;
    }

    public static string CreateMD5CompareFile(string rootPath, string gameID)
    {
        string fullPath = FileManager.CombinePath(rootPath, gameID);
        // Log.Error(fullPath);
        List<string> allFiles = new List<string>();
        FileManager.GetAllFile(fullPath, ref allFiles);
        if (allFiles.Count > 0)
        {
            // List<MD5Info> allMD5InfoList = new List<MD5Info>();
            string tempCompareFileName = (compareFileName + "_" + gameID + ".txt").ToLower();
            for (int i = 0; i < allFiles.Count; i++)
            {
                string name = Path.GetFileName(allFiles[i]).ToLower();
                if (name != tempCompareFileName) //过滤对比文件
                {
                    //Log.Error(name);
                    string relativePath = allFiles[i].Substring(rootPath.Length + 1).ToLower();
                    // Log.Error(relativePath);
                    string md5 = FileManager.GetFileMd5(allFiles[i]);
                    // Log.Error(md5);
                    long size = FileManager.GetFileLength(allFiles[i]);
                    //Log.Error(size);
                    MD5Info _md5Info = new MD5Info(name, relativePath, md5, size);
                    // string jsonData=JsonUtility.ToJson(_md5Info);
                    //Log.Error(jsonData);
                    allFileMd5InfoList.Add(_md5Info);
                }

            }

            BuildAssetBundle.buildAllMD5JsonData = MD5CompareFileManager.SerializeToJson(allFileMd5InfoList);

            string compareFilePath = FileManager.CombinePath(fullPath, compareFileName + "_" + gameID + ".txt");
            //Log.Error(compareFilePath);
            if (File.Exists(compareFilePath))
            {
                File.Delete(compareFilePath);
            }
            using (FileStream fs = new FileStream(compareFilePath, FileMode.CreateNew, FileAccess.ReadWrite))
            {
                byte[] md5Data = System.Text.Encoding.UTF8.GetBytes(BuildAssetBundle.buildAllMD5JsonData);
                fs.Write(md5Data, 0, md5Data.Length);
                fs.Dispose();
                fs.Close();
            }

            return compareFilePath;


        }
        return null;
    }

    public static bool SetCompareUpdateProcess(string rootPath, string gameID, string originalCompareFilePath)
    {
        string updatePath = FileManager.CombinePaths(rootPath, "ABUpdate");
        //Log.Error(updatePath);
        if (FileManager.IsDirectoryExist(updatePath) == false)
        {
            FileManager.CreateDirectory(updatePath);
        }
        updatePath = FileManager.CombinePaths(rootPath, "ABUpdate", gameID);
        // Log.Error(updatePath);
        if (FileManager.IsDirectoryExist(updatePath) == false)
        {
            FileManager.CreateDirectory(updatePath);
        }

        updatePath = FileManager.CombinePaths(updatePath, "ABFile");
        // Log.Error(updatePath);
        if (FileManager.IsDirectoryExist(updatePath) == false)
        {
            FileManager.CreateDirectory(updatePath);
        }

        if (isIncrementalUpdate)
        {
            string severCompareFilePath = BuildAssetBundle.currentSeverCompareFilePath;
            if (FileManager.IsFileExist(severCompareFilePath) == false)
            {
                Log.Error("增量更新方式未发现原始MD5对比文件，请检查是否存在或第一次更新改游戏包请使用整包更新方式打包");
                GlobalBuildABWindows.SetBuildTips("增量更新方式未发现原始MD5对比文件，请检查是否存在或第一次更新改游戏包请使用整包更新方式打包，并选择所有资源打包类型");
                return false;
            }
            StreamReader sr = new StreamReader(severCompareFilePath);
            string compareData = sr.ReadLine();
            //Log.Error(compareData);
            Dictionary<string, MD5Info> serverCompareDic = MD5CompareFileManager.SerializeToObject(compareData);
            Dictionary<string, MD5Info> currentCompareDic = MD5CompareFileManager.SerializeToObject(BuildAssetBundle.buildAllMD5JsonData);

            Dictionary<string, MD5Info> newCompareDic = MD5CompareFileManager.CompareUpdateFileMD5(currentCompareDic, serverCompareDic);
            if (newCompareDic.Count > 0)
            {
                List<MD5Info> tempCompareMd5List = new List<MD5Info>();
                foreach (var item in newCompareDic)
                {
                    tempCompareMd5List.Add(item.Value);
                }
                // updatePath = FileManager.CombinePath(updatePath, "");
                BuildIncrementalABFile(tempCompareMd5List, updatePath);
            }
            else
            {
                Log.Error("当前增量更新包并无修改，请检查是否有资源需要更新====>" + gameID);
                GlobalBuildABWindows.SetBuildTips("当前增量更新包并无修改，请检查是否有资源需要更新====>" + gameID);
                return false;
            }
            isIncrementalUpdateToWhole = true;
        }
        else
        {
            string comparePath = FileManager.CombinePaths(rootPath, "ABUpdate", gameID);
            string newUpdatePath = FileManager.CombinePath(comparePath, (compareFileName + "_" + gameID + ".txt"));
            //if (FileManager.IsFileExist(newUpdatePath))
            //    FileManager.DeleteFile(newUpdatePath);
            File.Copy(originalCompareFilePath, newUpdatePath);
            string outUpdateABPath = FileManager.CombinePath(updatePath, gameID);
            //if (FileManager.IsDirectoryExist(outUpdateABPath))
            //    FileManager.DeleteDirectory(outUpdateABPath);
            BuildIncrementalABFile(allFileMd5InfoList, updatePath);
        }

        return true;
    }


    public static void BuildIncrementalABFile(List<MD5Info> updateFileMd5List, string compareDirectoryPath)
    {
        long fileToltalSize = 0;
        foreach (var item in updateFileMd5List)
        {
            string originalFilePath = FileManager.CombinePath(outAssetBundlePath, item.relativePath);
            // Log.Error(originalFilePath);
            string outPath = FileManager.CombinePath(compareDirectoryPath, item.relativePath);

            if (FileManager.IsFileExist(outPath))
            {
                FileManager.DeleteFile(outPath);
            }

            string directoryPath = Path.GetDirectoryName(item.relativePath);
            // Log.Error(directoryPath);
            directoryPath = FileManager.ReplacePathSymbol(directoryPath);
            //Log.Error(directoryPath);
            List<string> directoryHierarchyList = new List<string>();
            FileManager.GetAllDirectoryHierarchyByPath(directoryPath, ref directoryHierarchyList);

            if (directoryHierarchyList.Count > 0)
            {
                string buildPath = compareDirectoryPath;
                for (int i = 0; i < directoryHierarchyList.Count; i++)
                {
                    // Log.Error(directoryHierarchyList[i]);
                    buildPath = FileManager.CombinePath(buildPath, directoryHierarchyList[i]);
                    // Log.Error(buildPath);
                    FileManager.CreateDirectory(buildPath);
                    //  fileToltalSize+= directoryHierarchyList[i].
                }
            }
            File.Copy(originalFilePath, outPath);
            fileToltalSize += item.size;
        }
        compareVersionFileSize = fileToltalSize.ToString();

    }


    public static List<string> BuildIncrementalZipFileProcess(string updateDirectoryRootPath, string gameId)
    {
        string inputZipDirectoryPath = FileManager.CombinePath(updateDirectoryRootPath, gameId);
        inputZipDirectoryPath = FileManager.ReplacePathSymbol(inputZipDirectoryPath).ToLower();
        //string endStr = "";
        //if (isIncrementalUpdate)
        //    endStr = "_incremental.zip";
        //else
        //    endStr = "_full.zip";
        //string outZipDirectoryPath = FileManager.CombinePaths(updateDirectoryRootPath,gameId+ endStr);
        //outZipDirectoryPath = FileManager.ReplacePathSymbol(outZipDirectoryPath).ToLower();

        //string otherPath = "";
        //if (isIncrementalUpdate)
        //    otherPath= FileManager.CombinePaths(updateDirectoryRootPath, gameId + "_full.zip");
        //else
        //    otherPath = FileManager.CombinePaths(updateDirectoryRootPath, gameId + "_incremental.zip");

        //if (FileManager.IsFileExist(otherPath))
        //    FileManager.DeleteFile(otherPath);

        //if (FileManager.IsFileExist(outZipDirectoryPath))
        //    FileManager.DeleteFile(outZipDirectoryPath);

        string outZipDirectoryPath = "";
        string endStr1 = "_incremental.zip";
        string endStr2 = "_full.zip";
        string endStr = "";
        if (isIncrementalUpdate)
        {
            endStr = endStr1;
        }
        else
        {
            endStr = endStr2;
        }
        outZipDirectoryPath = FileManager.CombinePaths(updateDirectoryRootPath, gameId + endStr);
        outZipDirectoryPath = FileManager.ReplacePathSymbol(outZipDirectoryPath).ToLower();
        if (FileManager.IsFileExist(outZipDirectoryPath))
            FileManager.DeleteFile(outZipDirectoryPath);

        string newZipOutPath = FileManager.CombinePath(updateDirectoryRootPath, "New");
        // Log.Error(newZipOutPath);
        if (FileManager.IsDirectoryExist(newZipOutPath))
            FileManager.DeleteDirectory(newZipOutPath);
        FileManager.CreateDirectory(newZipOutPath);
        Directory.Move(inputZipDirectoryPath, FileManager.CombinePath(newZipOutPath, gameId));
        ZipHelper.ZipFile(newZipOutPath, outZipDirectoryPath);
        FileManager.DeleteDirectory(newZipOutPath);

        string md5 = FileManager.GetFileMd5(outZipDirectoryPath).ToLower();
        string size = compareVersionFileSize;//FileManager.GetFileLength(outZipDirectoryPath).ToString();

        List<string> fileInfo = new List<string>();
        fileInfo.Add(md5);
        fileInfo.Add(size);
        return fileInfo;
    }

    public static void BuildIncrementalXMLFile(string xmlPath, List<string> zipInfo)
    {
        string updateXmlfilePath = FileManager.CombinePaths(xmlPath, versionFile);
        bool isExict = FileManager.IsFileExist(currentSeverCompareVersionFilePath);

        if (isIncrementalUpdate == false && isIncrementalUpdateToWhole == false)
        {
            int wholeVersion = 1;
            if (isExict)
            {
                XmlDocument xdt1 = new XmlDocument();
                xdt1.Load(currentSeverCompareVersionFilePath);
                XmlNode rootN = xdt1.SelectSingleNode("updateConfig");
                XmlNodeList allNList = rootN.ChildNodes;
                foreach (XmlNode item in allNList)
                {
                    XmlAttributeCollection aList = item.Attributes;
                    foreach (XmlAttribute xat in aList)
                    {
                        if (xat.Name == "wholePackageVersion")
                        {
                            wholeVersion = Convert.ToInt32(xat.Value);
                            wholeVersion += 1;
                        }

                    }
                }
                FileManager.DeleteFile(currentSeverCompareVersionFilePath);
            }

            XmlDocument xdt = new XmlDocument();
            XmlElement rootXML = xdt.CreateElement("updateConfig");
            xdt.AppendChild(rootXML);
            XmlElement fristXML = xdt.CreateElement("version");
            fristXML.SetAttribute("appVersion", "0");

            fristXML.SetAttribute("wholePackageVersion", wholeVersion.ToString());

            fristXML.SetAttribute("incrementalVersion", "0");

            rootXML.AppendChild(fristXML);

            XmlElement scendXML = xdt.CreateElement("zipWholeFileMD5");
            scendXML.SetAttribute("MD5", zipInfo[0]);
            rootXML.AppendChild(scendXML);

            XmlElement thirdXML = xdt.CreateElement("zipWholeFileSize");
            thirdXML.SetAttribute("Size", zipInfo[1]);
            rootXML.AppendChild(thirdXML);

            XmlElement fourXML = xdt.CreateElement("zipIncrementalFileMD5");
            fourXML.SetAttribute("MD5", "0");
            rootXML.AppendChild(fourXML);

            XmlElement fiveXML = xdt.CreateElement("zipIncrementalFileSize");
            fiveXML.SetAttribute("Size", "0");
            rootXML.AppendChild(fiveXML);

            xdt.Save(updateXmlfilePath);

        }
        else
        {

            if (isIncrementalUpdate && isIncrementalUpdateToWhole)
            {
                XmlDocument xdt1 = new XmlDocument();
                xdt1.Load(currentSeverCompareVersionFilePath);
                XmlNode rootN = xdt1.SelectSingleNode("updateConfig");
                XmlNodeList allNList = rootN.ChildNodes;
                int tempValue = 1;
                foreach (XmlNode item in allNList)
                {
                    XmlAttributeCollection aList = item.Attributes;

                    if (item.Name == "zipIncrementalFileMD5")
                    {
                        item.Attributes["MD5"].Value = zipInfo[0];
                    }

                    if (item.Name == "zipIncrementalFileSize")
                    {
                        item.Attributes["Size"].Value = zipInfo[1];
                    }

                    foreach (XmlAttribute xat in aList)
                    {
                        if (xat.Name == "incrementalVersion")
                        {
                            tempValue = Convert.ToInt32(xat.Value);
                            tempValue += 1;
                            xat.Value = tempValue.ToString();
                        }



                    }
                }
                xdt1.Save(updateXmlfilePath);

                // File.Copy(currentSeverCompareVersionFilePath, updateXmlfilePath);
            }
            else
            {
                XmlDocument xdt1 = new XmlDocument();
                xdt1.Load(updateXmlfilePath);
                XmlNode rootN = xdt1.SelectSingleNode("updateConfig");
                XmlNodeList allNList = rootN.ChildNodes;
                foreach (XmlNode item in allNList)
                {
                    XmlAttributeCollection aList = item.Attributes;

                    if (item.Name == "zipWholeFileMD5")
                    {
                        item.Attributes["MD5"].Value = zipInfo[0];
                    }

                    if (item.Name == "zipWholeFileSize")
                    {
                        item.Attributes["Size"].Value = zipInfo[1];
                    }
                }
                xdt1.Save(updateXmlfilePath);

            }


        }


    }


    public static void SetIncrementalUpdateProcess(string rootPath, string gameID)
    {
        string updatefileRootPath = FileManager.CombinePaths(rootPath, "ABUpdate", gameID);
        string updateComparefileRootPath = FileManager.CombinePaths(updatefileRootPath, "ABFile");
        List<string> zipInfo = BuildIncrementalZipFileProcess(updateComparefileRootPath, gameID);
        BuildIncrementalXMLFile(updatefileRootPath, zipInfo);



    }





}
