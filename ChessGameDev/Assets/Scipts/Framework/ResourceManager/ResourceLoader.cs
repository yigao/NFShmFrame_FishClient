using System;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ResourceLoader : Singleton<ResourceLoader>
{
    public delegate void LoadCompletedDelegate();

    public delegate void BinLoadCompletedDelegate(ref byte[] rawData);

    public void LoadScene(string name, ResourceLoader.LoadCompletedDelegate finishDelegate)
    {
        SceneManager.LoadScene(name);
        if (finishDelegate != null)
        {
            finishDelegate();
        }
    }

    //public void LoadDatabin(string name, ResourceLoader.BinLoadCompletedDelegate finishDelegate)
    //{
    //    BinaryObject binaryObject = Singleton<ResourceManager>.GetInstance().GetResource(name, typeof(TextAsset), enResourceType.Numeric, false, false).content as BinaryObject;
    //    //DebugHelper.Assert(cBinaryObject != null, "load databin fail {0}", new object[]
    //    //{
    //    //    name
    //    //});
    //    byte[] data = binaryObject.data;
    //    if (finishDelegate != null)
    //    {
    //        finishDelegate(ref data);
    //    }
    //    Singleton<ResourceManager>.GetInstance().RemoveCachedResource(name);
    //}

    //public static string GetDatabinPath(string name)
    //{
    //    return string.Format("jar:file://{0}!/assets/databin/{1}", Application.dataPath, name);
    //}
}