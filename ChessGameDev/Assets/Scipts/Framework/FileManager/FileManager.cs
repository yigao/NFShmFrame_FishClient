using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

public enum enFileOperation
{
    ReadFile,
    WriteFile,
    DeleteFile,
    CreateDirectory,
    DeleteDirectory
}

public class FileManager
{
    public delegate void DelegateOnOperateFileFail(string fullPath, enFileOperation fileOperation);

    private static string s_cachePath = null;

    public static string s_ifsExtractFolder = "AssetBundle";

    private static string s_ifsExtractPath = null;

    private static string ab_buildPath = null;

    private static MD5CryptoServiceProvider s_md5Provider = new MD5CryptoServiceProvider();

    public static FileManager.DelegateOnOperateFileFail s_delegateOnOperateFileFail = delegate
    {
   
    };

    public static bool ClearDirectory(string fullPath)
    {
        bool result;
        try
        {
            string[] files = Directory.GetFiles(fullPath);
            for (int i = 0; i < files.Length; i++)
            {
                File.Delete(files[i]);
            }
            string[] directories = Directory.GetDirectories(fullPath);
            for (int j = 0; j < directories.Length; j++)
            {
                //Directory.Delete(directories[j], true);
            }
            result = true;
        }
        catch (Exception)
        {
            result = false;
        }
        return result;
    }

    public static bool ClearDirectory(string fullPath, string[] fileExtensionFilter, string[] folderFilter)
    {
        bool result;
        try
        {
            if (fileExtensionFilter != null)
            {
                string[] files = Directory.GetFiles(fullPath);
                for (int i = 0; i < files.Length; i++)
                {
                    if (fileExtensionFilter != null && fileExtensionFilter.Length > 0)
                    {
                        for (int j = 0; j < fileExtensionFilter.Length; j++)
                        {
                            if (files[i].Contains(fileExtensionFilter[j]))
                            {
                                FileManager.DeleteFile(files[i]);
                                break;
                            }
                        }
                    }
                }
            }
            if (folderFilter != null)
            {
                string[] directories = Directory.GetDirectories(fullPath);
                for (int k = 0; k < directories.Length; k++)
                {
                    if (folderFilter != null && folderFilter.Length > 0)
                    {
                        for (int l = 0; l < folderFilter.Length; l++)
                        {
                            if (directories[k].Contains(folderFilter[l]))
                            {
                                FileManager.DeleteDirectory(directories[k]);
                                break;
                            }
                        }
                    }
                }
            }
            result = true;
        }
        catch (Exception)
        {
            result = false;
        }
        return result;
    }

    public static string CombinePath(string path1, string path2)
    {
        StringBuilder sb= new StringBuilder();
        sb.Append(path1);
        sb.Append("/");
        sb.Append(path2);
        return ReplacePathSymbol(sb.ToString());
    }

    public static string CombinePaths(params string[] values)
    {
        if (values.Length <= 0)
        {
            return string.Empty;
        }
        if (values.Length == 1)
        {
            return FileManager.CombinePath(values[0], string.Empty);
        }
        if (values.Length > 1)
        {
            string text = FileManager.CombinePath(values[0], values[1]);
            for (int i = 2; i < values.Length; i++)
            {
                text = FileManager.CombinePath(text, values[i]);
            }
            return text;
        }
        return string.Empty;
    }

    public static void CopyFile(string srcFile, string dstFile)
    {
        File.Copy(srcFile, dstFile, true);
    }

    public static bool CreateDirectory(string directory)
    {
        if (FileManager.IsDirectoryExist(directory))
        {
            return true;
        }
        int num = 0;
        bool result;
        while (true)
        {
            try
            {
                Directory.CreateDirectory(directory);
                result = true;
                break;
            }
            catch (Exception ex)
            {
                num++;
                if (num >= 3)
                {
                    Debug.Log("Create Directory " + directory + " Error! Exception = " + ex.ToString());
                    FileManager.s_delegateOnOperateFileFail(directory, enFileOperation.CreateDirectory);
                    result = false;
                    break;
                }
            }
        }
        return result;
    }

    public static bool DeleteDirectory(string directory)
    {
        if (!FileManager.IsDirectoryExist(directory))
        {
            return true;
        }
        int num = 0;
        bool result;
        while (true)
        {
            try
            {
                Directory.Delete(directory, true);
                result = true;
                break;
            }
            catch (Exception ex)
            {
                num++;
                if (num >= 3)
                {
                    Debug.Log("Delete Directory " + directory + " Error! Exception = " + ex.ToString());
                    FileManager.s_delegateOnOperateFileFail(directory, enFileOperation.DeleteDirectory);
                    result = false;
                    break;
                }
            }
        }
        return result;
    }

    public static bool DeleteFile(string filePath)
    {
        if (!FileManager.IsFileExist(filePath))
        {
            return true;
        }
        int num = 0;
        bool result;
        while (true)
        {
            try
            {
                File.Delete(filePath);
                result = true;
                break;
            }
            catch (Exception ex)
            {
                num++;
                if (num >= 3)
                {
                    Debug.Log("Delete File " + filePath + " Error! Exception = " + ex.ToString());
                    FileManager.s_delegateOnOperateFileFail(filePath, enFileOperation.DeleteFile);
                    result = false;
                    break;
                }
            }
        }
        return result;
    }

    public static string EraseExtension(string fullName)
    {
        if (fullName == null)
        {
            return null;
        }
        int num = fullName.LastIndexOf('.');
        if (num > 0)
        {
            return fullName.Substring(0, num);
        }
        return fullName;
    }

    public static string GetCachePath(string fileName)
    {
        return FileManager.CombinePath(FileManager.GetCachePath(), fileName);
    }

    public static string GetCachePath()
    {
        if (FileManager.s_cachePath == null)
        {
            //#if UNITY_STANDALONE_WIN
             //    FileManager.s_cachePath = CombinePath(Application.streamingAssetsPath, "AssetBundle/"); //特殊处理
            //#else
                FileManager.s_cachePath = PathDefine.AppPersistentDataPathPath();
            //#endif
        }
        return FileManager.s_cachePath;
    }

    public static string GetCachePathWithHeader(string fileName)
    {
        return FileManager.GetLocalPathHeader() + FileManager.GetCachePath(fileName);
    }

    public static string GetExtension(string fullName)
    {
        int num = fullName.LastIndexOf('.');
        if (num > 0 && num + 1 < fullName.Length)
        {
            return fullName.Substring(num);
        }
        return string.Empty;
    }

    public static long GetFileLength(string filePath)
    {
        if (!FileManager.IsFileExist(filePath))
        {
            return 0;
        }
        int num = 0;
        long result = 0;
        while (true)
        {
            try
            {
                FileInfo fileInfo = new FileInfo(filePath);
                result = fileInfo.Length;
                break;
            }
            catch (Exception ex)
            {
                num++;
                if (num >= 3)
                {
                    Debug.Log("Get FileLength of " + filePath + " Error! Exception = " + ex.ToString());
                    result = 0;
                    break;
                }
            }
        }
        return result;
    }

    public static string GetFullDirectory(string fullPath)
    {
        return Path.GetDirectoryName(fullPath);
    }

    public static string GetFullName(string fullPath)
    {
        if (fullPath == null)
        {
            return null;
        }
        int num = fullPath.LastIndexOf("/");
        if (num > 0)
        {
            return fullPath.Substring(num + 1, fullPath.Length - num - 1);
        }
        return fullPath;
    }

    /// <summary>
    /// 获取持久化路径persistentDataPath
    /// </summary>
    /// <returns></returns>
    public static string GetIFSExtractPath()
    {
        if (FileManager.s_ifsExtractPath == null)
        {
            FileManager.s_ifsExtractPath = Path.Combine(FileManager.GetCachePath(), PathDefine.GetPlatformName.ToLower()); //FileManager.CombinePath(FileManager.GetCachePath(), PathDefine.GetPlatformName.ToLower()); //FileManager.s_ifsExtractFolder);
        }
        return FileManager.s_ifsExtractPath;
    }

    /// <summary>
    /// 获取打包路径
    /// </summary>
    /// <returns></returns>
    public static string GetBuildABPath()
    {
        if (FileManager.ab_buildPath == null)
        {
            FileManager.ab_buildPath = FileManager.CombinePath(PathDefine.ABResPersistentDataPathPath(), PathDefine.GetPlatformName); //FileManager.s_ifsExtractFolder);
        }
        return FileManager.ab_buildPath;
    }


    private static string GetLocalPathHeader()
    {
        return "file://";
    }

    public static string GetFileMd5(string filePath)
    {
        if (!FileManager.IsFileExist(filePath))
        {
            return string.Empty;
        }
        return BitConverter.ToString(FileManager.s_md5Provider.ComputeHash(FileManager.ReadFile(filePath))).Replace("-", string.Empty).ToLower();
    }

    public static string GetMd5(byte[] data)
    {
        return BitConverter.ToString(FileManager.s_md5Provider.ComputeHash(data)).Replace("-", string.Empty).ToLower();
    }

    public static string GetMd5(string str)
    {
        return BitConverter.ToString(FileManager.s_md5Provider.ComputeHash(Encoding.UTF8.GetBytes(str))).Replace("-", string.Empty).ToLower();
    }

    public static string GetStreamingAssetsPathWithHeader(string fileName)
    {
        return Path.Combine(Application.streamingAssetsPath, fileName);
    }

    public static bool IsDirectoryExist(string directory)
    {
        return Directory.Exists(directory);
    }

    public static bool IsFileExist(string filePath)
    {
//#if UNITY_EDITOR
            return File.Exists(filePath);
//#endif

    //    return true;
    }

    public static byte[] ReadFile(string filePath)
    {
        if (!FileManager.IsFileExist(filePath))
        {
            Log.Error("file path is not exit :" + filePath);
            return null;
        }
        byte[] array = null;
        try
        {
            array = File.ReadAllBytes(filePath);
        }
        catch (Exception ex)
        {

            Log.Error(string.Concat(new object[] {
				"Read File ",
				filePath,
				" Error! Exception = ",
				ex.ToString (),
			}));
            array = null;
        }

        if (array != null && array.Length > 0)
        {
            return array;
        }
        return null;
    }

    public static bool WriteFile(string filePath, byte[] data, int offset, int length)
    {
        FileStream fileStream = null;
        int num = 0;
        bool result;
        while (true)
        {
            try
            {
                fileStream = new FileStream(filePath, FileMode.OpenOrCreate, FileAccess.Write, FileShare.ReadWrite);
                fileStream.Write(data, offset, length);
                fileStream.Close();
                result = true;
                break;
            }
            catch (Exception ex)
            {
                if (fileStream != null)
                {
                    fileStream.Close();
                }
                num++;
                if (num >= 3)
                {
                    Debug.Log("Write File " + filePath + " Error! Exception = " + ex.ToString());
                    FileManager.DeleteFile(filePath);
                    FileManager.s_delegateOnOperateFileFail(filePath, enFileOperation.WriteFile);
                    result = false;
                    break;
                }
            }
        }
        return result;
    }

    public static bool WriteFile(string filePath, byte[] data)
    {
        int num = 0;
        bool result;
        while (true)
        {
            try
            {
                File.WriteAllBytes(filePath, data);
                result = true;
                break;
            }
            catch (Exception ex)
            {
                num++;
                if (num >= 3)
                {
                    Debug.Log("Write File " + filePath + " Error! Exception = " + ex.ToString());
                    FileManager.DeleteFile(filePath);
                    FileManager.s_delegateOnOperateFileFail(filePath, enFileOperation.WriteFile);
                    result = false;
                    break;
                }
            }
        }
        return result;
    }

    /// <summary>
    /// 统一路径符号
    /// </summary>
    /// <param name="filePath"></param>
    /// <returns></returns>
    public static string ReplacePathSymbol(string filePath)
    {
        return new StringBuilder(filePath).Replace("//", "/").Replace('\\', '/').ToString();
    }

    /// <summary>
    /// 获取unity中指定路径中的所有文件，可选择忽略指定文件夹中文件
    /// </summary>
    /// <param name="dirctoryPath"></param>
    /// <param name="allFiles"></param>
    /// <param name="removePath"></param>
    public static void GetAllFile(string dirctoryPath, ref List<string> allFiles, string removePath = null)
    {
        if (Directory.Exists(dirctoryPath))
        {
            string[] allFiles1 = Directory.GetFiles(dirctoryPath);
            for (int i = 0; i < allFiles1.Length; i++)
            {
                if (!allFiles1[i].EndsWith(".meta"))
                {
                    string filePathName = allFiles1[i];
                    filePathName = ReplacePathSymbol(filePathName);
                    allFiles.Add(filePathName);
                }

            }
            string[] allDirctory = Directory.GetDirectories(dirctoryPath);
            if (allDirctory.Length > 0)
            {
                for (int j = 0; j < allDirctory.Length; j++)
                {
                    string filePathName = FileManager.EraseExtension(allDirctory[j]); 
                    filePathName = ReplacePathSymbol(filePathName);
                    if (removePath != null)
                    {
                        // Debug.LogError(fileName);
                        string fileName = filePathName.Substring(filePathName.LastIndexOf("/") + 1);

                        if (fileName == removePath)
                            continue;
                    }
                    GetAllFile(filePathName, ref allFiles, removePath);
                }
            }
        }

    }


    /// <summary>
    /// 获取路径中指定扩展名的所有文件
    /// </summary>
    /// <param name="dirctoryPath"></param>
    /// <param name="extensionName"></param>
    /// <param name="allFiles"></param>
    public static void GetAllocateFile(string dirctoryPath, string extensionName, ref List<string> allFiles)
    {
        if (Directory.Exists(dirctoryPath))
        {
            string[] allFiles1 = Directory.GetFiles(dirctoryPath);
            for (int i = 0; i < allFiles1.Length; i++)
            {
                if (allFiles1[i].EndsWith(extensionName))
                {
                    string filePathName = allFiles1[i];
                    filePathName = ReplacePathSymbol(filePathName);
                    allFiles.Add(filePathName);
                }

            }

            string[] allDirctory = Directory.GetDirectories(dirctoryPath);
            if (allDirctory.Length > 0)
            {
                for (int j = 0; j < allDirctory.Length; j++)
                {
                    string filePathName = FileManager.EraseExtension(allDirctory[j]);
                    filePathName = ReplacePathSymbol(filePathName);
                    GetAllocateFile(filePathName, extensionName, ref allFiles);
                }
            }

        }
    }



    /// <summary>
    /// 分割字符串
    /// </summary>
    /// <param name="str"></param>
    /// <param name="splitStr"></param>
    /// <param name="callBack"></param>
    public static void StringSplit(string str,string splitStr,Action<string[]> callBack)
    {
        string[] splitList= str.Trim().Split(splitStr.ToCharArray());
        if (callBack!=null)
            callBack(splitList);
    }


    /// <summary>
    /// 获取路径中的所有文件夹列表
    /// </summary>
    /// <param name="directoryPath"></param>
    /// <param name="directoryHierarchyList"></param>
    public static void GetAllDirectoryHierarchyByPath(string directoryPath,ref List<string> directoryHierarchyList)
    {
        int pos = directoryPath.IndexOf("/");
        if (pos>=0)
        {
            string tempDir = directoryPath.Substring(0, pos);
            directoryHierarchyList.Add(tempDir);
            tempDir = directoryPath.Substring(pos+1);
            GetAllDirectoryHierarchyByPath(tempDir,ref directoryHierarchyList);
        }
        else
        {
            directoryHierarchyList.Add(directoryPath);
            return;
        }
        
       
    }


    public static byte[] Encrypt(byte[] text, string key)
    {
        byte[] keyData = System.Text.UTF8Encoding.UTF8.GetBytes(key);
        for (int i = 0; i < text.Length; i++)
        {
            for (int j = 0; j < keyData.Length; j++)
            {
                text[i] = (byte)(text[i]^ keyData[j]);
            }

        }
        return text;
    }

    public static AssetBundle LoadABRs(byte[] abDataList)
    {
        var endData = FileManager.Encrypt(abDataList, LuaManager.GetInstance().GetLuaName());
        return AssetBundle.LoadFromMemory(endData);
    }

    public static AssetBundleCreateRequest LoadABRsAsync(byte[] abDataList)
    {
        var endData = FileManager.Encrypt(abDataList, LuaManager.GetInstance().GetLuaName());
        return AssetBundle.LoadFromMemoryAsync(endData);
    }







}
