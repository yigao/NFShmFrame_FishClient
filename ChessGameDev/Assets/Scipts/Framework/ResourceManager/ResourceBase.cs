using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

/// <summary>
/// 资源基本数据结构,里面包含资源的内容、名字、
/// 路径、类型信息;并且提供加载资源方法
/// </summary>
public class ResourceBase 
{
    /// <summary>
    /// 键索引
    /// </summary>
    private int m_key;

    /// <summary>
    /// 资源名字
    /// </summary>
    private string m_name;

    /// <summary>
    /// 资源在Resource文件夹下完整路径
    /// </summary>
    private string m_fullPathInResources;

    /// <summary>
    /// 资源在Resource文件夹下完整路径,不包含资源后缀名
    /// </summary>
    private string m_fullPathInResourcesWithoutExtension;

    /// <summary>
    /// 资源的扩展名
    /// </summary>
    private string rsesourceExtensionName;

    /// <summary>
    /// 文件在Resource文件夹下完整路径
    /// </summary>
    private string m_fileFullPathInResources;

    /// <summary>
    /// 数据类型
    /// </summary>
    private Type m_contentType;

    /// <summary>
    /// 加载状态
    /// </summary>
    private enResourceState m_state;

    /// <summary>
    /// 加载资源后是否卸载资源所在的AB包
    /// </summary>
    private bool m_unloadBelongedAssetBundleAfterLoaded;

    /// <summary>
    /// 资源对象
    /// </summary>
    private UnityEngine.Object m_content;

    public int key
    {
        get
        {
            return m_key;
        }
    }

    public bool unloadBelongedAssetBundleAfterLoaded
    {
        get
        {
            return m_unloadBelongedAssetBundleAfterLoaded;
        }
    }

    public UnityEngine.Object content
    {
        get
        {
            return m_content;
        }
    }

    /// <summary>
    /// 构造函数
    /// </summary>
    /// <param name="keyHash">键索引</param>
    /// <param name="fullPathInResources">资源在Resource文件夹下完整路径</param>
    /// <param name="contentType">数据类型</param>
    /// <param name="unloadBelongedAssetBundleAfterLoaded"></param>
    public ResourceBase(int keyHash, string fullPathInResources, Type contentType, bool unloadBelongedAssetBundleAfterLoaded)
    {
        this.m_key = keyHash;
        this.m_fullPathInResources = fullPathInResources;
        // this.m_fullPathInResourcesWithoutExtension = FileManager.EraseExtension(this.m_fullPathInResources);
        this.m_name = Path.GetFileNameWithoutExtension(fullPathInResources); // FileManager.EraseExtension(FileManager.GetFullName(fullPathInResources));
       // this.rsesourceExtensionName = FileManager.GetExtension(fullPathInResources);
        this.m_state = enResourceState.Unload;
        this.m_contentType = contentType;
        this.m_unloadBelongedAssetBundleAfterLoaded = unloadBelongedAssetBundleAfterLoaded;
        this.m_content = null;
    }

    /// <summary>
    /// 同步用Unity的API加载AssetBundle中的资源
    /// </summary>
    public void LoadAsset(Action<ResourceBase, float> callback=null)
    {
        if (m_contentType == null)
            Log.Error("m_contentType==null");
        string loadPath = PathDefine.GetRelativeAssetBundlePath + m_fullPathInResources; //m_fullPathInResourcesWithoutExtension + rsesourceExtensionName;
        #if UNITY_EDITOR
        if (MonoSingleton<GameMain>.sIntance.DeveloperMode)
        {
            m_content = AssetDatabase.LoadAssetAtPath(loadPath, m_contentType);
        }
        else
        {
            m_content = Resources.Load(m_fullPathInResources, m_contentType);
        }
        #endif
        m_state = enResourceState.Loaded;
        if (m_content != null && m_content.GetType() == typeof(TextAsset))
        {
            BinaryObject binaryObject = ScriptableObject.CreateInstance<BinaryObject>();
            binaryObject.data = (m_content as TextAsset).bytes;
            m_content = binaryObject;
        }
        if (callback!=null)
        {
            callback(this,1);
        }
    }



    /// <summary>
    /// 同步从AssetBundle中加载资源
    /// </summary>
    /// <param name="resourcePackerInfo">AB资源包信息</param>
    public void LoadFromAssetBundle(ResourcePackerInfo resourcePackerInfo)
    {
        string name = FileManager.EraseExtension(m_name);
        if(m_contentType == null)
        {
            m_content = resourcePackerInfo.assetBundle.LoadAsset(name);    
        }
        else
        {
            m_content = resourcePackerInfo.assetBundle.LoadAsset(name, m_contentType);
        }
        m_state = enResourceState.Loaded;
       // Log.Error(m_content);
        if (m_content != null && m_content.GetType() == typeof(TextAsset))
        {
            BinaryObject binaryObject = ScriptableObject.CreateInstance<BinaryObject>();
            binaryObject.data = (m_content as TextAsset).bytes;
            m_content = binaryObject;
        }
    }

    /// <summary>
    /// 异步从AssetBundle中加载资源
    /// </summary>
    /// <param name="resourcePackerInfo"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    public IEnumerator AsyncLoadFromAssetBundle(ResourcePackerInfo resourcePackerInfo,Action<ResourceBase,float> callback)
    {
        string resName = FileManager.EraseExtension(m_name);

        m_state = enResourceState.Loading;

        AssetBundleRequest request = null;
        if (m_contentType == null)
        {
            request = resourcePackerInfo.assetBundle.LoadAssetAsync(resName); 
        }
        else
        {
            request = resourcePackerInfo.assetBundle.LoadAssetAsync(resName, m_contentType);
        }
        
        while (request != null && !request.isDone)
        {
           // if (callback != null) callback(null, request.progress);   //每一帧的回调

            yield return request.asset;

            m_content = request.asset;

            m_state = enResourceState.Loaded;
            
            if (m_content != null && m_content.GetType() == typeof(TextAsset))
            {
                BinaryObject binaryObject = ScriptableObject.CreateInstance<BinaryObject>();
                binaryObject.data = (m_content as TextAsset).bytes;
                m_content = binaryObject;
            }
            if (callback != null) callback(this, request.progress);    //加载完成后回调

            request = null;
        }
    }

    /// <summary>
    /// 卸载资源
    /// </summary>
    public void Unload()
    {
        if (m_state == enResourceState.Loaded)
        {
            m_content = null;
            m_state = enResourceState.Unload;
        }
        else if (m_state == enResourceState.Loading)
        {

        }
    }
}
