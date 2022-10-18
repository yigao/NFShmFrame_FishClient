using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BestHTTP;
using BestHTTP.Core;
using System.Threading;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;
using System.Xml;
using System.Text;



/// <summary>
/// 对比资源类型
/// </summary>
public enum CompareResType
{ 
    Config, //配置文件
    Lobby,  //大厅
    Game,  //游戏
}

/// <summary>
/// 资源类型
/// </summary>
public enum GameResType
{ 
    Apk = 1,
    Game = 2,     //游戏资源
}

public enum GameVersionStatus
{
    None = 0,
    Compare_Version                 = 1,            //对比版本文件
    Version_Error                   = 2,            //获取版本文件错误
    Wait_Download                   = 3,            //等待下载资源
    Downloading                     = 4,            //正在下载资源
    Download_Interrupted            = 5,            //下载中断
    Downloaded                      = 6,            //下载资源结束
    Download_Error                  = 7,            //下载资源出错
    Unzip                           = 8,            //解压资源
    Unzip_Error                     = 9,            //解压资源出错        
    Complete                        = 10,           //可以使用
}


public class VersionInfo
{
    public int appVersion;
    public int wholePackageVersion;
    public int incrementalVersion;
    public string zipWholeFileMD5;
    public int zipWholeFileSize;
    public string zipIncrementalMD5;
    public int zipIncrementalFileSize;

    public VersionInfo()
    {

    }

    public VersionInfo(int appVersion, int wholePackageVersion, int incrementalVersion, string zipWholeFileMD5, int zipWholeFileSize,string zipIncrementalMD5,int zipIncrementalFileSize)
    {
        this.appVersion = appVersion;
        this.wholePackageVersion = wholePackageVersion;
        this.incrementalVersion = incrementalVersion;
        this.zipWholeFileMD5 = zipWholeFileMD5;
        this.zipWholeFileSize = zipWholeFileSize;
        this.zipIncrementalMD5 = zipIncrementalMD5;
        this.zipIncrementalFileSize = zipIncrementalFileSize;
    }
}

public class GameResVersionInfo
{
    public const string Key_02 = "_DownloadLength";
    public const string Key_03 = "_BreakPointVersion";

    public int gameID;

    /// <summary>
    /// 下载游戏资源的路径
    /// </summary>
    public string downloadGameResUrl;

    /// <summary>
    /// 服务器版本号存放的路径
    /// </summary>
    public string serverVersionUrl;

    /// <summary>
    /// 服务器的版本号
    /// </summary>
    public VersionInfo serverVersion;

    /// <summary>
    /// 本地版本号存放的路径
    /// </summary>
    public string localVersionUrl;

    /// <summary>
    /// 本地的版本号
    /// </summary>
    public VersionInfo localVersion;
   
    /// <summary>
    /// 下载游戏资源保存的路径
    /// </summary>
    public string downloadSavePath;

    /// <summary>
    /// 解压游戏资源的路径
    /// </summary>
    public string unzipFilePath;

    public HTTPRequest request;

    public string downloadLengthKey;

    public string breakPointVersionKey;

    public GameVersionStatus gameVersionStatus = GameVersionStatus.None;

    public GameResType gameResType;

    public CompareResType compareResType;

    public bool isIncrementalUpdate;

    public Action<GameResVersionInfo> GameResInfoCallBack; 
 
    /// <summary>
    ///设置下载的起始点，用来做断点续传 
    /// </summary>
    private long m_downloadStartedAt = 0;

    /// <summary>
    /// 已经下载的资源占所需下载的资源百分比
    /// </summary>
    public float downloadedPercent;

    /// <summary>
    /// 当前已经解压的资源大小
    /// </summary>
    public long currentUnzipBytes;

    /// <summary>
    /// 压缩包的总大小
    /// </summary>
    public long unzipFileTotalBytes;

    /// <summary>
    /// 当前已经解压资源的百分比
    /// </summary>
    public float currentUnzipPercent;


    /// <summary>
    /// 所需下载资源的总大小
    /// </summary>
    protected long DownloadLength { get { return PlayerPrefs.GetInt(downloadLengthKey); } set {PlayerPrefs.SetInt(downloadLengthKey, (int)value); } }

    protected string BreakpointVersion {get { return PlayerPrefs.GetString(breakPointVersionKey); } set { PlayerPrefs.SetString(breakPointVersionKey, (string)value); } }

    public GameResVersionInfo(int gameID, Action<GameResVersionInfo> callBack)
    {
        this.gameID = gameID;
        this.isIncrementalUpdate = false;
        this.GameResInfoCallBack = callBack;
        this.serverVersionUrl = GetVersionFileUrl();
        this.localVersionUrl = GetLocalVersionUrl();
        this.downloadSavePath = GetDownloadSavePath();
        this.unzipFilePath = GetUnzipFilePath();
        this.compareResType = GetCompareResType();

        this.downloadLengthKey = gameID.ToString() + Key_02;
        this.breakPointVersionKey = gameID.ToString() + Key_03;
    }

    public CompareResType GetCompareResType()
    {
        if (this.gameID == 0)
        {
            return CompareResType.Lobby;
        }
        else if (this.gameID == 1)
        {
            return CompareResType.Config;
        }
        else
        {
            return CompareResType.Game;
        }
    }

    public void BeginCheckGameVersion()
    {
        this.gameVersionStatus = GameVersionStatus.Compare_Version;
        this.request = new HTTPRequest(new Uri(this.serverVersionUrl), GameVersionOnRequestFinished);
        //this.request.ConnectTimeout = new TimeSpan(0, 0, 3);
        this.request.DisableCache = true;
        this.request.Send();
    }

    protected void GameVersionOnRequestFinished(HTTPRequest req, HTTPResponse resp)
    {
        if (File.Exists(this.localVersionUrl))
        {
            this.localVersion = GetVersionXMLFile(File.ReadAllText(this.localVersionUrl));
        }
        else
        {
            this.localVersion = null;
        }
        switch (req.State)
        {
            case HTTPRequestStates.Finished:
            {
                if (resp.IsSuccess)
                {
                    this.serverVersion = GetVersionXMLFile(resp.DataAsText);

                    BeginCompareVersion();
                }
                else
                {
                    this.gameVersionStatus = GameVersionStatus.Version_Error;
                }
                break;
            }
            case HTTPRequestStates.Error:
            {
                this.gameVersionStatus = GameVersionStatus.Version_Error;
                break;
            }
            case HTTPRequestStates.Aborted:
            {
                this.gameVersionStatus = GameVersionStatus.Version_Error;
                break;
            }
            case HTTPRequestStates.ConnectionTimedOut:
            {
                this.gameVersionStatus = GameVersionStatus.Version_Error;
                break;
            }
            case HTTPRequestStates.TimedOut:
            {
                this.gameVersionStatus = GameVersionStatus.Version_Error;
                break;
            }
        }
        Singleton<VersionUpdateManager>.GetInstance().CompareVersionFinished(this);
        this.request = null;
    }

    public VersionInfo GetVersionXMLFile(string xmlContent)
    {
        XmlDocument xdt = new XmlDocument();
        xdt.LoadXml(xmlContent);
        XmlNode bootNode = xdt.SelectSingleNode("updateConfig");
        XmlNode firstNode = bootNode.SelectSingleNode("version");
        int appVersion = int.Parse(firstNode.Attributes["appVersion"].InnerText); 
        int wholePackageVersion = int.Parse(firstNode.Attributes["wholePackageVersion"].InnerText);
        int incrementalVersion = int.Parse(firstNode.Attributes["incrementalVersion"].InnerText);

        XmlNode secondNode = bootNode.SelectSingleNode("zipWholeFileMD5");
        string zipWholeFileMD5 = secondNode.Attributes["MD5"].InnerText;

        XmlNode thirdNode = bootNode.SelectSingleNode("zipWholeFileSize");
        int zipWholeFileSize = int.Parse(thirdNode.Attributes["Size"].InnerText);

        XmlNode fourNode = bootNode.SelectSingleNode("zipIncrementalFileMD5");
        string zipIncrementalMD5 = fourNode.Attributes["MD5"].InnerText;

        XmlNode fiveNode = bootNode.SelectSingleNode("zipIncrementalFileSize");
        int zipIncrementalFileSize = int.Parse(fiveNode.Attributes["Size"].InnerText);

        return new VersionInfo(appVersion, wholePackageVersion, incrementalVersion, zipWholeFileMD5, zipWholeFileSize, zipIncrementalMD5,zipIncrementalFileSize);
    }


    public void BeginCompareVersion()
    {
        if (this.compareResType == CompareResType.Config)
        {
            OnCompareConfigVersion();
        }
        else if (this.compareResType == CompareResType.Lobby)
        {
            OnCompareLobbyVersion();
        }
        else if (this.compareResType == CompareResType.Game)
        {
            OnCompareGameVersion();
        }
    }

    /// <summary>
    /// 对比配置版本文件,配置文件不存在增量更新，都是下载整个Zip包
    /// </summary>
    public void OnCompareConfigVersion()
    {
        this.gameResType = GameResType.Game;

        this.gameResType = GameResType.Game;

        if (this.localVersion == null)
        {
            this.isIncrementalUpdate = false;
            this.downloadGameResUrl = GetDownloadGameResUrl();
            this.gameVersionStatus = GameVersionStatus.Wait_Download;
            return;
        }

        //对比是否强制更新整个游戏的资源
        if (this.serverVersion.wholePackageVersion > this.localVersion.wholePackageVersion)
        {
            string useResPath = this.unzipFilePath + Singleton<GlobalConfigManager>.GetInstance().Game_Config.ToLower() + "/";
            if (Directory.Exists(useResPath))
            {
                Directory.Delete(useResPath);
            }
            this.isIncrementalUpdate = false;
            this.downloadGameResUrl = GetDownloadGameResUrl();
            this.gameVersionStatus = GameVersionStatus.Wait_Download;
            return;
        }
        else if (this.serverVersion.wholePackageVersion == this.localVersion.wholePackageVersion)
        {
            this.gameVersionStatus = GameVersionStatus.Complete;
        }
        else //服务器存放的版本文件错误
        {
            //容错机制考虑,使用原来的资源进入游戏
            this.gameVersionStatus = GameVersionStatus.Complete;
            return;
        }

        //对比是否增量更新游戏资源
        if (this.serverVersion.incrementalVersion > this.localVersion.incrementalVersion)
        {
            this.isIncrementalUpdate = true;
            this.downloadGameResUrl = GetDownloadGameResUrl();
            this.gameVersionStatus = GameVersionStatus.Wait_Download;
            return;
        }
        else if (this.serverVersion.incrementalVersion == this.localVersion.incrementalVersion)
        {
            this.gameVersionStatus = GameVersionStatus.Complete;
        }
        else//服务器存放的版本文件错误
        {
            //容错机制考虑,使用原来的资源进入游戏
            this.gameVersionStatus = GameVersionStatus.Complete;
            return;
        }
        return;
    }

    
    /// <summary>
    /// 对比大厅的版本文件
    /// </summary>
    public void OnCompareLobbyVersion()
    {

        if (this.localVersion == null)
        {
            this.isIncrementalUpdate = false; 
            this.downloadGameResUrl = GetDownloadGameResUrl();
            this.gameResType = GameResType.Game;
            this.gameVersionStatus = GameVersionStatus.Wait_Download;
            return;
        }

        //只有在更新大厅资源时才会对比Apk版本
        if (this.compareResType == CompareResType.Lobby)
        {
            if (this.serverVersion.appVersion > this.localVersion.appVersion)
            {
                this.gameResType = GameResType.Apk;
                this.gameVersionStatus = GameVersionStatus.Wait_Download;

                return;
            }
            else if (this.serverVersion.appVersion == this.localVersion.appVersion)
            {
                this.gameResType = GameResType.Apk;
                this.gameVersionStatus = GameVersionStatus.Complete;
            }
            else//服务器存放的版本文件错误
            {
                //容错机制考虑,使用原来的apk进入游戏
                this.gameResType = GameResType.Apk;
                this.gameVersionStatus = GameVersionStatus.Complete;
            }
        }

        this.gameResType = GameResType.Game;

        //对比是否强制更新整个游戏的资源
        if (this.serverVersion.wholePackageVersion > this.localVersion.wholePackageVersion)
        {
            string useResPath = this.unzipFilePath + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower();
            if (Directory.Exists(useResPath))
            {
                Directory.Delete(useResPath,true);
            }
            this.isIncrementalUpdate = false;
            this.downloadGameResUrl = GetDownloadGameResUrl();
            
            this.gameVersionStatus = GameVersionStatus.Wait_Download;

            return;
        }
        else if (this.serverVersion.wholePackageVersion == this.localVersion.wholePackageVersion)
        {
            this.gameVersionStatus = GameVersionStatus.Complete;
        }
        else //服务器存放的版本文件错误
        {
            //容错机制考虑,使用原来的资源进入游戏
            this.gameVersionStatus = GameVersionStatus.Complete;
            return;
        }

        //对比是否增量更新游戏资源
        if (this.serverVersion.incrementalVersion > this.localVersion.incrementalVersion)
        {
            this.isIncrementalUpdate = true;
            this.downloadGameResUrl = GetDownloadGameResUrl();
            this.downloadSavePath = GetDownloadSavePath();
            this.gameVersionStatus = GameVersionStatus.Wait_Download;
            return;
        }
        else if (this.serverVersion.incrementalVersion == this.localVersion.incrementalVersion)
        {
            this.gameVersionStatus = GameVersionStatus.Complete;
        }
        else//服务器存放的版本文件错误
        {
            //容错机制考虑,使用原来的资源进入游戏
            this.gameVersionStatus = GameVersionStatus.Complete;
            return;
        }
        return;
    }

    /// <summary>
    /// 对比游戏版本文件
    /// </summary>
    public void OnCompareGameVersion()
    {
        this.gameResType = GameResType.Game;

        if (this.localVersion == null)
        {
            this.isIncrementalUpdate = false;
            this.downloadGameResUrl = GetDownloadGameResUrl();
            this.gameVersionStatus = GameVersionStatus.Wait_Download;
            return;
        }

        //对比是否强制更新整个游戏的资源
        if (this.serverVersion.wholePackageVersion > this.localVersion.wholePackageVersion)
        {
            string useResPath = this.unzipFilePath + gameID.ToString() + "/";
            if (Directory.Exists(useResPath))
            {
                Directory.Exists(useResPath);
            }
            this.isIncrementalUpdate = false;
            this.downloadGameResUrl = GetDownloadGameResUrl();
            this.gameVersionStatus = GameVersionStatus.Wait_Download;
            return;
        }
        else if (this.serverVersion.wholePackageVersion == this.localVersion.wholePackageVersion)
        {
            this.gameVersionStatus = GameVersionStatus.Complete;
        }
        else //服务器存放的版本文件错误
        {
            //容错机制考虑,使用原来的资源进入游戏
            this.gameVersionStatus = GameVersionStatus.Complete;
            return;
        }

        //对比是否增量更新游戏资源
        if (this.serverVersion.incrementalVersion > this.localVersion.incrementalVersion)
        {
            this.isIncrementalUpdate = true;
            this.downloadGameResUrl = GetDownloadGameResUrl();
            this.gameVersionStatus = GameVersionStatus.Wait_Download;
            return;
        }
        else if (this.serverVersion.incrementalVersion > this.localVersion.incrementalVersion)
        {
            this.gameVersionStatus = GameVersionStatus.Complete;
        }
        else//服务器存放的版本文件错误
        {
            //容错机制考虑,使用原来的资源进入游戏
            this.gameVersionStatus = GameVersionStatus.Complete;
            return;
        }
        return;
    }

    public void BeginDownloadGameRes()
    {
        bool isDownloadRes = BeginCheckBreakpointResume();
        if (isDownloadRes)
        {
            request = new HTTPRequest(new Uri(downloadGameResUrl), OnDownloadGameResFinished);
            request.DisableCache = true;
            //request.ConnectTimeout = new TimeSpan(0, 0, 5);
            request.OnHeadersReceived += OnHeadersReceived;
            request.OnDownloadProgress += OnDownloadProgress;
            request.OnStreamingData += OnDataDownloaded;
            request.SetRangeHeader(m_downloadStartedAt);
            this.gameVersionStatus = GameVersionStatus.Downloading;
            request.Send();
        }
        else
        {
            this.gameVersionStatus = GameVersionStatus.Downloaded;
        }
    }

    /// <summary>
    /// 断点续传
    /// </summary>
    public bool BeginCheckBreakpointResume()
    {
        if (string.IsNullOrEmpty(this.BreakpointVersion) || this.BreakpointVersion != (this.serverVersion.wholePackageVersion + "," + this.serverVersion.incrementalVersion))
        {
            m_downloadStartedAt = 0;
            if (File.Exists(this.downloadSavePath))
            {
                File.Delete(this.downloadSavePath);
            }
            DeleteKeys();
            return true;
        }
        else
        {
            if (!File.Exists(this.downloadSavePath))
            {
                DeleteKeys();
            }
            long processedBytes = FileManager.GetFileLength(this.downloadSavePath);
      

            if (processedBytes < DownloadLength)
            {
                m_downloadStartedAt = processedBytes;
                return true;
            }
            else if (processedBytes == DownloadLength && DownloadLength > 0 && processedBytes > 0)
            {
                return false;
            }
            else
            {
                if (File.Exists(this.downloadSavePath))
                {
                    File.Delete(this.downloadSavePath);
                }
                DeleteKeys();
                return true;
            }
        }
    }

    protected void OnDownloadGameResFinished(HTTPRequest req, HTTPResponse resp)
    {
        switch (req.State)
        {
            case HTTPRequestStates.Finished:
                if (resp.IsSuccess)
                {
                    if (GameResInfoCallBack != null)
                    {
                        GameResInfoCallBack(this);
                    }
                    string md5 = FileManager.GetFileMd5(this.downloadSavePath);

                    if (!this.isIncrementalUpdate)
                    {
                        if (md5 == this.serverVersion.zipWholeFileMD5)
                        {
                            this.gameVersionStatus = GameVersionStatus.Downloaded;
                        }
                        else
                        {
                            this.gameVersionStatus = GameVersionStatus.Download_Error;
                            if (File.Exists(this.downloadSavePath))
                            {
                                File.Delete(this.downloadSavePath);
                            }
                            DeleteKeys();
                        }
                    }
                    else
                    {
                        if (md5 == this.serverVersion.zipIncrementalMD5)
                        {
                            this.gameVersionStatus = GameVersionStatus.Downloaded;
                        }
                        else
                        {
                            this.gameVersionStatus = GameVersionStatus.Download_Error;
                            if (File.Exists(this.downloadSavePath))
                            {
                                File.Delete(this.downloadSavePath);
                            }
                            DeleteKeys();
                        }
                    }
                }
                else
                {
                    this.gameVersionStatus = GameVersionStatus.Download_Interrupted;
                }
                break;
            case HTTPRequestStates.Error:
                this.gameVersionStatus = GameVersionStatus.Download_Interrupted;
                break;
            case HTTPRequestStates.Aborted:
                this.gameVersionStatus = GameVersionStatus.Download_Interrupted;
                break;
            case HTTPRequestStates.ConnectionTimedOut:
                this.gameVersionStatus = GameVersionStatus.Download_Interrupted;
                break;
            case HTTPRequestStates.TimedOut:
                this.gameVersionStatus = GameVersionStatus.Download_Interrupted;
                break;
        }
        request.OnHeadersReceived = null;
        request.OnDownloadProgress = null;
        request.OnStreamingData = null;
        request = null;
    }

    private void OnHeadersReceived(HTTPRequest req, HTTPResponse resp)
    {
        var range = resp.GetRange();
        if (range != null)
        {
            DownloadLength = range.ContentLength;
        }
        else
        {
            var contentLength = resp.GetFirstHeaderValue("content-length");
            if (contentLength != null)
            {
                long length = 0;
                if (long.TryParse(contentLength, out length))
                {
                    DownloadLength = length;
                }
            }
        }
    }

    protected void OnDownloadProgress(HTTPRequest originalRequest, long downloaded, long downloadLength)
    {
        downloadedPercent = ((downloaded + m_downloadStartedAt) / (float)DownloadLength);
    }

    protected bool OnDataDownloaded(HTTPRequest request, HTTPResponse response, byte[] dataFragment, int dataFragmentLength)
    {

        string downloadDirectory = Path.GetDirectoryName(this.downloadSavePath);

        if (!Directory.Exists(downloadDirectory))
        {
            Directory.CreateDirectory(downloadDirectory);
        }

        BreakpointVersion = this.serverVersion.wholePackageVersion+","+this.serverVersion.incrementalVersion;
        
        using (FileStream fs = new FileStream(this.downloadSavePath,FileMode.Append,FileAccess.Write))
        {
            fs.Write(dataFragment, 0, dataFragmentLength);
            fs.Flush();
            fs.Close();
            fs.Dispose();
        }
        return true;
    }

    private void DeleteKeys()
    {
        PlayerPrefs.DeleteKey(downloadLengthKey);
        PlayerPrefs.DeleteKey(breakPointVersionKey);
        PlayerPrefs.Save();
    }

    public void BeginUnZipFile()
    {
        if (!this.isIncrementalUpdate)
        {
            this.unzipFileTotalBytes = this.serverVersion.zipWholeFileSize;
        }
        else
        {
            this.unzipFileTotalBytes = this.serverVersion.zipIncrementalFileSize;
        }
      
        this.gameVersionStatus = GameVersionStatus.Unzip;
        Thread thread = new Thread(OnUnZipFile);
        thread.Start();
    }

    public void OnUnZipFile()
    {

        Encoding gbk = Encoding.GetEncoding("gbk");
        ICSharpCode.SharpZipLib.Zip.ZipConstants.DefaultCodePage = gbk.CodePage;
      
        using (ZipInputStream zipStream = new ZipInputStream(File.OpenRead(this.downloadSavePath)))
        {
            try
            {         
                ZipEntry zipEntry = null;
                while ((zipEntry = zipStream.GetNextEntry()) != null)
                {
                    if (!string.IsNullOrEmpty(zipEntry.Name) && !string.IsNullOrEmpty(Path.GetFileName(zipEntry.Name)))
                    {
                        string zipFilePath = FileManager.ReplacePathSymbol(zipEntry.Name).ToLower();
                        string directoryName = (Path.GetDirectoryName(zipFilePath)).ToLower();
                   
                        directoryName = directoryName.Replace("_full", "");
                        directoryName = directoryName.Replace("_incremental", "");
                        string fileName = Path.GetFileName(zipFilePath);
                   
                        string fileFullDirectory = this.unzipFilePath + directoryName;
                        fileFullDirectory = FileManager.ReplacePathSymbol(fileFullDirectory);

                        string useFileFullPath = fileFullDirectory +"/"+ fileName;
                        useFileFullPath = FileManager.ReplacePathSymbol(useFileFullPath);
                       
                        if (!Directory.Exists(fileFullDirectory))
                        {
                            Directory.CreateDirectory(fileFullDirectory);
                        }
                        using (FileStream sw = File.Create(useFileFullPath))
                        {
                            int size = 2048;
                            byte[] data = new byte[size];
                            while (true)
                            {
                                size = zipStream.Read(data, 0, data.Length);
                                if (size > 0)
                                {
                                    sw.Write(data, 0, size);
                                    currentUnzipBytes += size;
                                    currentUnzipPercent = currentUnzipBytes / (float)unzipFileTotalBytes; 
                                }
                                else
                                {
                                    break;
                                }
                            }
                            sw.Close();
                        }
                    }
                }            
                gameVersionStatus = GameVersionStatus.Complete;
            }
            catch (Exception e)
            {
                Log.Info("UnzipError :" + e.ToString());
                gameVersionStatus = GameVersionStatus.Unzip_Error;
            }
        }
    }

    public void UpdateGameResVersion()
    {
        DeleteKeys();
        File.Delete(this.downloadSavePath);
        WriteVersionXmlFile();
    }

    public void WriteVersionXmlFile()
    {
        string fileFullDirectory = FileManager.EraseExtension(this.localVersionUrl);
        if (!Directory.Exists(fileFullDirectory))
        {
            Directory.CreateDirectory(fileFullDirectory);
        }

        if (FileManager.IsFileExist(this.localVersionUrl))
        {
            FileManager.DeleteFile(this.localVersionUrl);
        }

        XmlDocument xdt = new XmlDocument();
        XmlElement rootXML = xdt.CreateElement("updateConfig");
        xdt.AppendChild(rootXML);

        XmlElement fristXML = xdt.CreateElement("version");
        
        fristXML.SetAttribute("appVersion", this.serverVersion.appVersion.ToString());
        if (this.gameResType == GameResType.Apk)
        {
            fristXML.SetAttribute("wholePackageVersion", "0");
            fristXML.SetAttribute("incrementalVersion", "0");
        }
        else
        {
            fristXML.SetAttribute("wholePackageVersion", this.serverVersion.wholePackageVersion.ToString());
            fristXML.SetAttribute("incrementalVersion", this.serverVersion.incrementalVersion.ToString());
        }
        rootXML.AppendChild(fristXML);

        XmlElement scendXML = xdt.CreateElement("zipWholeFileMD5");
        scendXML.SetAttribute("MD5", this.serverVersion.zipWholeFileMD5);
        rootXML.AppendChild(scendXML);

        XmlElement thirdXML = xdt.CreateElement("zipWholeFileSize");
        thirdXML.SetAttribute("Size", this.serverVersion.zipWholeFileSize.ToString());
        rootXML.AppendChild(thirdXML);


        XmlElement fourXML = xdt.CreateElement("zipIncrementalFileMD5");
        fourXML.SetAttribute("MD5", this.serverVersion.zipIncrementalMD5);
        rootXML.AppendChild(fourXML);

        XmlElement fiveXML = xdt.CreateElement("zipIncrementalFileSize");
        fiveXML.SetAttribute("Size", this.serverVersion.zipIncrementalFileSize.ToString());
        rootXML.AppendChild(fiveXML);

        xdt.Save(this.localVersionUrl);
    }

    public string GetVersionFileUrl()
    {
        if (this.gameID == 0)
        {
            return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "/" + "version.xml";
        }
        else if (this.gameID == 1)
        {
            return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName + "/" + Singleton<GlobalConfigManager>.GetInstance().Game_Config.ToLower() + "/" + "version.xml";
        }
        else
        {
            return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName +"/" + gameID.ToString() + "/" + "version.xml";
        }
    }

    public string GetLocalVersionUrl()
    {
        if (this.gameID == 0)
        {
            return FileManager.ReplacePathSymbol(PathDefine.AppPersistentDataPathPath() + (PathDefine.GetPlatformName  + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "/" + "version.xml").ToLower());
        }
        else if (this.gameID == 1)
        {
            return FileManager.ReplacePathSymbol(PathDefine.AppPersistentDataPathPath() + (PathDefine.GetPlatformName + "/" + Singleton<GlobalConfigManager>.GetInstance().Game_Config.ToLower() + "/" + "version.xml").ToLower());
        }
        else
        {
            return FileManager.ReplacePathSymbol(PathDefine.AppPersistentDataPathPath() + (PathDefine.GetPlatformName + "/" + gameID.ToString() + "/" + "version.xml").ToLower());
        }
    }

    public string GetDownloadGameResUrl()
    {
        if (this.gameID == 0)
        {
            if (!this.isIncrementalUpdate)
            {
                return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "_full" + ".zip";
            }
            else
            {
                return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "_incremental" + ".zip";
            }
        }
        else if (this.gameID == 1)
        {
            if (!this.isIncrementalUpdate)
            {
                return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName + "/" + Singleton<GlobalConfigManager>.GetInstance().Game_Config.ToLower() + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "_full" + ".zip";
            }
            else
            {
                return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName + "/" + Singleton<GlobalConfigManager>.GetInstance().Game_Config.ToLower() + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "_incremental" + ".zip";
            }
        }
        else
        {
            if (!this.isIncrementalUpdate)
            {
                return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName + "/" + gameID.ToString() + "/" + gameID.ToString() + "_full" + ".zip";
            }
            else
            {
                return Singleton<GlobalConfigManager>.GetInstance().Url_Path + "/" + PathDefine.GetRelativeGameAssetBundlePath + "/" + PathDefine.GetPlatformName + "/" + gameID.ToString() + "/" + gameID.ToString()  + "_incremental" + ".zip";
            }
        }
    }


    public string GetDownloadSavePath()
    {
        if (this.gameID == 0)
        {            
            return FileManager.ReplacePathSymbol(PathDefine.AppGameResDownloadPath()  + (Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + "/" + Singleton<GlobalConfigManager>.GetInstance().Hall_Name.ToLower() + ".zip").ToLower());
        }
        else if (this.gameID == 1)
        {
            return FileManager.ReplacePathSymbol(PathDefine.AppGameResDownloadPath()  + (Singleton<GlobalConfigManager>.GetInstance().Game_Config.ToLower() + "/" + Singleton<GlobalConfigManager>.GetInstance().Game_Config.ToLower() + ".zip").ToLower());
        }
        else
        {
            return FileManager.ReplacePathSymbol(PathDefine.AppGameResDownloadPath()  + (this.gameID.ToString() + "/" + this.gameID.ToString() + ".zip").ToLower());
        }
    }

    public string GetUnzipFilePath()
    {
        return FileManager.ReplacePathSymbol(PathDefine.AppPersistentDataPathPath() + (PathDefine.GetPlatformName + "/").ToLower());
    }
}
