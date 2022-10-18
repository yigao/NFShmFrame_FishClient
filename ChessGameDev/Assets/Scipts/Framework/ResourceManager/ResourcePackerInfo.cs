using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;


public class ResourcePackerInfo 
{
    private bool m_useAsyncLoadingData;

    public string m_pathInIFS;

    private enAssetBundleState m_assetBundleState;

    private AssetBundle m_assetBundle;

    private int m_reference = 1;

    private int totalReference = 1;

    public enAssetBundleState AssetBundleState
    {
        get { return m_assetBundleState; }
    }

    public int Reference
    {
        get { return m_reference; }
        set { m_reference = value; }
    }

    /// <summary>
    /// 当前资源所直接依赖的资源列表 List<ResourcePackerInfo>
    /// </summary>
    public List<ResourcePackerInfo> dependenciesBundle = new List<ResourcePackerInfo>(); // 依赖关系


    public AssetBundle assetBundle
    {
        get
        {
            return m_assetBundle;
        }
    }


    public bool IsAssetBundleLoaded()
    {
        return m_assetBundleState == enAssetBundleState.Loaded;
    }

    public ResourcePackerInfo(string path)
    {
        this.m_pathInIFS = path;

        this.m_reference = 1;

        this.m_assetBundleState = enAssetBundleState.Unload;
    }

    /// <summary>
    /// 设置直接依赖关系
    /// </summary>
    /// <param name="denpendencies"></param>
    /// <param name="resourcePackerMap"></param>
    public void DependenciesRelation(string[] denpendencies, Dictionary<int, ResourcePackerInfo> resourcePackerMap)
    {
        dependenciesBundle.Clear(); //重新清除
        for (int i = 0; i < denpendencies.Length; ++i)
        {
            int key = FileManager.EraseExtension(denpendencies[i]).JavaHashCodeIgnoreCase();

            ResourcePackerInfo resourcePackerInfo = null;
            if (!resourcePackerMap.TryGetValue(key, out resourcePackerInfo))
            {
                resourcePackerInfo = new ResourcePackerInfo(denpendencies[i]);
                resourcePackerMap.Add(key, resourcePackerInfo);
            }
            else
            {
               // resourcePackerInfo.m_reference++;
               // resourcePackerInfo.totalReference = resourcePackerInfo.m_reference;
            }
            dependenciesBundle.Add(resourcePackerInfo);
        }
       // totalReference = m_reference;       //保存初始化中的引用次数
    }

    public void LoadAssetBundle(string ifsExtractPath)
    { 
        if (m_assetBundleState != enAssetBundleState.Unload)
        {
            return;
        }

        if (dependenciesBundle != null)
        {
            for (int i = 0; i < dependenciesBundle.Count; ++i)//加载依赖
            {        
                dependenciesBundle[i].LoadAssetBundle(ifsExtractPath);
            }
        }

        m_useAsyncLoadingData = false;

        m_assetBundleState = enAssetBundleState.Loading;

        string filePath = FileManager.CombinePath(ifsExtractPath,m_pathInIFS);
        if (FileManager.IsFileExist(filePath))
		{
            string fileName = Path.GetFileNameWithoutExtension(filePath).ToLower();
            byte[] tempD = System.Text.UTF8Encoding.UTF8.GetBytes(fileName);
            m_assetBundle = AssetBundle.LoadFromFile(filePath, 0, (ulong)(tempD.Length + 1000));
            //byte[] data = File.ReadAllBytes(filePath);
            //m_assetBundle = FileManager.LoadABRs(data);
            //m_assetBundle =AssetBundle.LoadFromFile(filePath);//加载自己

            if (m_assetBundle == null) 
            {
                Log.Error("Load AssetBundle " + filePath + " Error!!!");
			}
		}
		else
		{
            Log.Error("File " + filePath + " can not be found!!!");
		}
		m_assetBundleState = enAssetBundleState.Loaded;
    }

    public IEnumerator AsyncLoadAssetBundle(string ifsExtractPath)
    {
        if (m_assetBundleState != enAssetBundleState.Unload)
        {
            yield break;
        }

        if (dependenciesBundle != null)
        {
            for (int i = 0; i < dependenciesBundle.Count; ++i)
            {
                if (dependenciesBundle[i].m_assetBundleState == enAssetBundleState.Loading)
                {
                    dependenciesBundle[i].m_reference++;
                    if (i == (dependenciesBundle.Count-1))     //添加依赖引用计数
                        yield return dependenciesBundle[i].assetBundle;
                }
                else if (dependenciesBundle[i].m_assetBundleState == enAssetBundleState.Loaded)
                {
                    dependenciesBundle[i].m_reference++;
                }
                else if (dependenciesBundle[i].m_assetBundleState == enAssetBundleState.Unload)
                {
                    yield return ResourceManager.sIntance.StartCoroutine(dependenciesBundle[i].AsyncLoadAssetBundle(ifsExtractPath));
                }
            }
        }

        m_assetBundleState = enAssetBundleState.Loading;

        string filePath = FileManager.CombinePath(ifsExtractPath, m_pathInIFS);

        AssetBundleCreateRequest request = null;

        if (FileManager.IsFileExist(filePath))
        {
            //byte[] data = File.ReadAllBytes(filePath);
            //request = FileManager.LoadABRsAsync(data);
            string fileName = Path.GetFileNameWithoutExtension(filePath).ToLower();
            byte[] tempD = System.Text.UTF8Encoding.UTF8.GetBytes(fileName);
            request = AssetBundle.LoadFromFileAsync(filePath, 0, (ulong)(tempD.Length + 1000));
            yield return request;

            if (request != null && request.isDone)
            {
                m_assetBundle = request.assetBundle;
            }else
                Log.Error("File " + filePath + " Load Fail!!!");
            m_assetBundleState = enAssetBundleState.Loaded;
        }
        else
        {
            m_assetBundleState = enAssetBundleState.Unload;
            Log.Error("File " + filePath + " can not be found!!!");
        }    
    }


    public void UnloadAssetBundle(bool force)
    {

        if (m_assetBundleState == enAssetBundleState.Loaded)
        {
           // Log.Error("开始卸载==》");
           // Log.Error(this.m_pathInIFS);
           // List<ResourcePackerInfo> removeResourcePackerInfoList = new List<ResourcePackerInfo>();
            for (int i = 0; i < dependenciesBundle.Count; ++i)
            {
              //  Log.Error("当前依赖项==>");
               // Log.Error(dependenciesBundle[i].assetBundle);
               // Log.Error(dependenciesBundle[i].m_pathInIFS);
               // Log.Error(dependenciesBundle[i].m_reference);
                dependenciesBundle[i].m_reference--;
                if (dependenciesBundle[i].m_reference <= 0 && dependenciesBundle[i].m_assetBundle!=null)
                {
                    dependenciesBundle[i].m_assetBundle.Unload(false);
                    dependenciesBundle[i].m_assetBundle = null;
                    dependenciesBundle[i].m_assetBundleState = enAssetBundleState.Unload;
                    dependenciesBundle[i].m_reference = 1;
                }else
                    dependenciesBundle[i].m_reference = 1;
            }

            //for(int i = 0;i<removeResourcePackerInfoList.Count;++i)
            //{
            //    dependenciesBundle.Remove(removeResourcePackerInfoList[i]);
            //}
            //removeResourcePackerInfoList.Clear();
            //removeResourcePackerInfoList = null;

            m_reference--;
           //Debug.LogError(m_pathInIFS);
            //Debug.LogError(m_reference);
           //Debug.LogError(m_assetBundle);
            if (m_reference<=0)
            {
                //Log.Error(m_assetBundle);
                m_assetBundle.Unload(force);
                m_assetBundle = null;
                m_reference = 1;//totalReference;
                m_assetBundleState = enAssetBundleState.Unload;
            }
           
        }
    }


    public void UnloadAllAssetBundle(bool force)
    {

    }
}
