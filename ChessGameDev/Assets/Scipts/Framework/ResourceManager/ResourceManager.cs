using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public enum enResourceState
{
    Unload,
    Loading,
    Loaded
}

public enum enAssetBundleState
{
    Unload,
    Loading,
    Loaded
}

public class ResourceManager :  MonoSingleton<ResourceManager>
{
    /// <summary>
    /// 资源的设置信息
    /// </summary>
    private ResourcePackerInfoSet m_resourcePackerInfoSet;
    /// <summary>
    /// 缓存资源映射
    /// </summary>
    private Dictionary<int, ResourceBase> m_cachedResourceMap;

    protected override void Init()
    {
        base.Init();
        m_resourcePackerInfoSet = new ResourcePackerInfoSet();
        m_cachedResourceMap = new Dictionary<int, ResourceBase>();
    }

    public Dictionary<int, ResourceBase> GetCachedResourceMap()
    {
        return m_cachedResourceMap; 
    }

    /// <summary>
    /// 获取是否有缓存的资源
    /// </summary>
    /// <param name="fullPathInResources"></param>
    /// <returns></returns>
    public bool CheckCachedResource(string fullPathInResources)
    {
        string s = FileManager.EraseExtension(fullPathInResources);
        ResourceBase resourceInfo = null;
        return m_cachedResourceMap.TryGetValue(s.JavaHashCodeIgnoreCase(), out resourceInfo);
    }


    /// <summary>
    /// 加载资源的ManifestFile
    /// </summary>
    /// <param name="fullPathInResources"></param>
    public void LoadManifestFile(string fullPathInResources)
    {
        //调试模式使用本地assetbundle
        if (MonoSingleton<GameMain>.sIntance.DeveloperMode) return;
        string s = FileManager.EraseExtension(fullPathInResources);
        int key = s.JavaHashCodeIgnoreCase();
        string filePath = FileManager.CombinePath(FileManager.GetIFSExtractPath(), fullPathInResources);
        if (FileManager.IsFileExist(filePath))
        {
            string fileName = Path.GetFileNameWithoutExtension(filePath).ToLower();
            byte[] tempD = System.Text.UTF8Encoding.UTF8.GetBytes(fileName);
            AssetBundle bundle = AssetBundle.LoadFromFile(filePath, 0, (ulong)(tempD.Length + 1000));
            //AssetBundle bundle = AssetBundle.LoadFromFile(filePath);
            //byte[] data = File.ReadAllBytes(filePath);
            //AssetBundle bundle = FileManager.LoadABRs(data);
            AssetBundleManifest mainfest =  bundle.LoadAsset("AssetBundleManifest") as AssetBundleManifest;
            m_resourcePackerInfoSet.AnalysisManifest(key, mainfest);
            bundle.Unload(false);
            bundle = null;
        }else
            Log.Error("Manifest不存在==>" + filePath);
    }

    /// <summary>
    /// 同步获取资源基本数据结构对象
    /// </summary>
    /// <param name="fullPathInResources">资源在Resource文件夹下完整路径</param>
    /// <param name="resourceContentType">数据类型</param>
    /// <param name="needCached">是否需要缓存</param>
    /// <param name="unloadBelongedAssetBundleAfterLoaded">加载资源后是否卸载资源所在的AB包</param>
    /// <returns>资源基本数据</returns>
    public ResourceBase GetResource(string fullPathInResources, Type resourceContentType, bool needCached = false, bool unloadBelongedAssetBundleAfterLoaded = true)
    {
        if (string.IsNullOrEmpty(fullPathInResources))
        {
            Log.Error("resource path is empty");
            Log.Error(resourceContentType);
            return null;
        }
        string s = FileManager.EraseExtension(fullPathInResources).ToLower();
        int key = s.JavaHashCodeIgnoreCase();
        ResourceBase resourceBase = null;
        if (m_cachedResourceMap.TryGetValue(key, out resourceBase))
        {
            return resourceBase;
        }
        resourceBase = new ResourceBase(key, fullPathInResources, resourceContentType,unloadBelongedAssetBundleAfterLoaded);
        
        LoadResource(resourceBase);
        
        if (needCached)
        {
           m_cachedResourceMap.Add(key, resourceBase);
        }
        return resourceBase;
    }

    /// <summary>
    ///  异步获取资源基本数据结构对象
    /// </summary>
    /// <param name="fullPathInResources">资源在Resource文件夹下完整路径</param>
    /// <param name="resourceContentType">数据类型</param>
    /// <param name="callback">资源load成功的回调</param>
    /// <param name="needCached">是否需要缓存</param>
    /// <param name="unloadBelongedAssetBundleAfterLoaded">加载资源后是否卸载资源所在的AB包</param>
    /// <returns>资源基本数据</returns>
    public void AsyncGetResource(string fullPathInResources, Type resourceContentType, Action<ResourceBase,float> callback, bool needCached = false, bool unloadBelongedAssetBundleAfterLoaded = true)
    {
        if(string.IsNullOrEmpty(fullPathInResources))
        {
            Log.Error("resource path is empty");
            return;
        }
        string s = FileManager.EraseExtension(fullPathInResources).ToLower();
        int key = s.JavaHashCodeIgnoreCase();
        ResourceBase resourceBase = null;
        if (m_cachedResourceMap.TryGetValue(key, out resourceBase))
        {
            if (callback != null) callback(resourceBase,1.0f);
            return;
        }
        resourceBase = new ResourceBase(key, fullPathInResources, resourceContentType, unloadBelongedAssetBundleAfterLoaded);

        StartCoroutine(AsyncLoadResource(resourceBase,callback,needCached));
    }

    /// <summary>
    /// 加载资源,优先保证从AB包里面(Resources文件夹外部)加载,
    /// ,如果不存在AB包就通过Resources加载((Resources文件夹内存)).
    /// </summary>
    /// <param name="resourceBase">资源基本数据</param>
    private void LoadResource(ResourceBase resourceBase)
    {
        ResourcePackerInfo resourceBelongedPackerInfo = GetResourceBelongedPackerInfo(resourceBase);
        if (resourceBelongedPackerInfo != null)
        {
            if (!resourceBelongedPackerInfo.IsAssetBundleLoaded())
            {
                resourceBelongedPackerInfo.LoadAssetBundle(FileManager.GetIFSExtractPath());
            }
            
            resourceBase.LoadFromAssetBundle(resourceBelongedPackerInfo);

            if (resourceBase.unloadBelongedAssetBundleAfterLoaded)
            {
                resourceBelongedPackerInfo.UnloadAssetBundle(false);
            }
        }
        else
        {
            resourceBase.LoadAsset();
        }
    }



    /// <summary>
    /// 异步加载资源,优先保证从AB包里面(Resources文件夹外部)加载,
    /// ,如果不存在AB包就通过Resources加载((Resources文件夹内存)).
    /// </summary>
    /// <param name="resourceBase">资源基本数据</param>
    private IEnumerator AsyncLoadResource(ResourceBase resourceBase,Action<ResourceBase,float> callback,bool needCached)
    {
        ResourcePackerInfo resourceBelongedPackerInfo = GetResourceBelongedPackerInfo(resourceBase);
        if (resourceBelongedPackerInfo != null)
        {
            if (resourceBelongedPackerInfo.AssetBundleState == enAssetBundleState.Unload)
            {
                yield return resourceBelongedPackerInfo.AsyncLoadAssetBundle(FileManager.GetIFSExtractPath());
            }
            else if (resourceBelongedPackerInfo.AssetBundleState == enAssetBundleState.Loading)
            {
                resourceBelongedPackerInfo.Reference++;
                while (resourceBelongedPackerInfo.AssetBundleState == enAssetBundleState.Loading)
                {
                    yield return null;
                }
            }
            yield return StartCoroutine(resourceBase.AsyncLoadFromAssetBundle(resourceBelongedPackerInfo,callback));
                
            if (resourceBase.unloadBelongedAssetBundleAfterLoaded)
            {
                resourceBelongedPackerInfo.UnloadAssetBundle(false);
            }
        }
        else
        {
          //Editor下AssetDataBase无法异步加载，直接使用同步方式
            resourceBase.LoadAsset(callback);
        }

        if (needCached)
        {
            m_cachedResourceMap.Add(resourceBase.key, resourceBase);
        }
    }


    public ResourcePackerInfo GetResourceBelongedPackerInfo(string fullPathInResources)
    {
        if (string.IsNullOrEmpty(fullPathInResources))
        {
            return null;
        }
        if (m_resourcePackerInfoSet != null)
        {
            return m_resourcePackerInfoSet.GetResourceBelongedPackerInfo(FileManager.EraseExtension(fullPathInResources).JavaHashCodeIgnoreCase());
        }
        return null;
    }

    private ResourcePackerInfo GetResourceBelongedPackerInfo(ResourceBase resourceBase)
    {
        if (m_resourcePackerInfoSet != null)
        {
            ResourcePackerInfo resourceBelongedPackerInfo = m_resourcePackerInfoSet.GetResourceBelongedPackerInfo(resourceBase.key);
            return resourceBelongedPackerInfo;
        }
        return null;
    }

    //清除单个缓存的CachedResourceBase
    public void RemoveCachedResource(string fullPathInResources)
    {
        string s = FileManager.EraseExtension(fullPathInResources);
        int key = s.JavaHashCodeIgnoreCase();
        ResourceBase resourceBase = null;
        if (m_cachedResourceMap.TryGetValue(key, out resourceBase))
        {
            resourceBase.Unload();
            this.m_cachedResourceMap.Remove(key);
        }
    }

    //清除所有CachedResourceBase缓存
    private void UnloadAllCachedResourceBase()
    {
        foreach (KeyValuePair<int, ResourceBase> kvp in m_cachedResourceMap)
        {
            kvp.Value.Unload();
        }
        m_cachedResourceMap.Clear();
    }

    // 清除所有已缓存的AssetBundle
    private void UnloadAllCachedAssetBundles()
    {
        if (m_resourcePackerInfoSet == null)
        {
            return;
        }
        m_resourcePackerInfoSet.Dispose();

        Resources.UnloadUnusedAssets();

        GC.Collect();
    }



    //卸载单个资源
    public void UnloadBelongedAssetBundle(string fullPathInResources, bool force = false)
    {
        ResourcePackerInfo resourceBelongedPackerInfo = GetResourceBelongedPackerInfo(fullPathInResources);

        if (resourceBelongedPackerInfo != null && resourceBelongedPackerInfo.IsAssetBundleLoaded())
        {
            resourceBelongedPackerInfo.UnloadAssetBundle(force);

        }
        RemoveCachedResource(fullPathInResources);
    }

    //卸载当前Manifest中的所有资源
    public void UnloadManifestPackerAssetBundle(string manifestName,bool force=false)
    {
        //Log.Error("UnloadManifestPackerAssetBundle==>"+ manifestName);
        if (MonoSingleton<GameMain>.sIntance.DeveloperMode) return;
        string s = FileManager.EraseExtension(manifestName);
        int key = s.JavaHashCodeIgnoreCase();

        AssetBundleManifest manifest = m_resourcePackerInfoSet.GetAssetBundleManifest(key);

        string[] bundleInfo = manifest.GetAllAssetBundles();

        for (int i = 0; i < bundleInfo.Length; ++i)
        {
            ResourcePackerInfo resourceBelongedPackerInfo = GetResourceBelongedPackerInfo(bundleInfo[i]);

            if (resourceBelongedPackerInfo != null && resourceBelongedPackerInfo.IsAssetBundleLoaded())
            {
                resourceBelongedPackerInfo.UnloadAssetBundle(force);
                m_resourcePackerInfoSet.RemoveResourceBelongedPackerInfo(FileManager.EraseExtension(bundleInfo[i]).JavaHashCodeIgnoreCase());
            }
            RemoveCachedResource(bundleInfo[i]);
        }

        m_resourcePackerInfoSet.RemoveAssetBundleManifest(key);

        if (force)
        {
            Resources.UnloadUnusedAssets();
            GC.Collect();
        }
    }
}
