using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResourcePackerInfoSet 
{
    /// <summary>
    /// AssetBundleMap Form ResourcePackerInfo
    /// </summary>
    private Dictionary<int, ResourcePackerInfo> m_resourceMap = new Dictionary<int, ResourcePackerInfo>();

    /// <summary>
    /// mainifestMap
    /// </summary>
    private Dictionary<int, AssetBundleManifest> m_manifestMap = new Dictionary<int, AssetBundleManifest>();


    /// <summary>
    /// 分析资源的Manifest并生成资源依赖信息
    /// </summary>
    /// <param name="manifestKey"></param>
    /// <param name="manifest"></param>
    public void AnalysisManifest(int manifestKey,AssetBundleManifest manifest)
    {
        if (!m_manifestMap.ContainsKey(manifestKey))
        {
            m_manifestMap.Add(manifestKey, manifest);
        }

        string[]  bundleInfos = manifest.GetAllAssetBundles();
        for (int i = 0; i < bundleInfos.Length; ++i)
        {
            int key = FileManager.EraseExtension(bundleInfos[i]).JavaHashCodeIgnoreCase();

            ResourcePackerInfo resourcePackerInfo = null;

            if (!m_resourceMap.TryGetValue(key, out resourcePackerInfo))
            {
                resourcePackerInfo = new ResourcePackerInfo(bundleInfos[i]);
                m_resourceMap.Add(key, resourcePackerInfo);
            }

            string[] bundleDependencies = manifest.GetDirectDependencies(bundleInfos[i]);
            if (bundleDependencies.Length > 0)
            {
                resourcePackerInfo.DependenciesRelation(bundleDependencies, m_resourceMap);
            }
        }
    }

    public ResourcePackerInfo GetResourceBelongedPackerInfo(int resourceKeyHash)
    {
        
        ResourcePackerInfo info = null;
      
        if (m_resourceMap.TryGetValue(resourceKeyHash, out info))
        {
            return info;
        }
        return null;
    }


    public void RemoveResourceBelongedPackerInfo(int resourceKeyHash)
    {

        if (m_resourceMap.ContainsKey(resourceKeyHash))
        {
            m_resourceMap.Remove(resourceKeyHash);
        }
       
    }


    public bool RemoveAssetBundleManifest(int key)
    {
        if (m_manifestMap.ContainsKey(key))
        {
            m_manifestMap.Remove(key);
            return true;
        }
        return false;
    }

    public AssetBundleManifest GetAssetBundleManifest(int key)
    {
        AssetBundleManifest manifest = null;

        if (m_manifestMap.TryGetValue(key, out manifest))
        {
            return manifest;
        }
        return null;
    }

    public void Dispose()
    {
        foreach (KeyValuePair<int, ResourcePackerInfo> kvp in m_resourceMap)
        {
            if (kvp.Value.IsAssetBundleLoaded())
            {
                kvp.Value.UnloadAssetBundle(false);
            }
        }
        m_resourceMap.Clear();

        m_manifestMap.Clear();
    }



}
