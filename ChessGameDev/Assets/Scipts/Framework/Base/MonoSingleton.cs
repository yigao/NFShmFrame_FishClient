using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonoSingleton<T> : MonoBehaviour where T : Component 
{
    private static T s_instance;

    public static T sIntance
    {
        get
        {
            return s_instance;
        }
    }

    protected virtual void Awake()
    {
        if ((MonoSingleton<T>.s_instance != null) && (MonoSingleton<T>.s_instance.gameObject != gameObject))
        {
            if (Application.isPlaying)
            {
                UnityEngine.Object.Destroy(gameObject);
            }
            else
            {
                UnityEngine.Object.DestroyImmediate(gameObject);
            }
        }
        else if (MonoSingleton<T>.s_instance == null)
        {
            MonoSingleton<T>.s_instance = GetComponent<T>();
        }
        UnityEngine.Object.DontDestroyOnLoad(gameObject);

        Init();
    }


    public static void DestroyInstance()
    {
        if (MonoSingleton<T>.s_instance != null)
        {
            UnityEngine.Object.Destroy(MonoSingleton<T>.s_instance.gameObject);
        }
        MonoSingleton<T>.s_instance = null;
    }

    public static T GetInstance()
    {
        if ((MonoSingleton<T>.s_instance == null))
        {
            Type type = typeof(T);
            MonoSingleton<T>.s_instance = (T)UnityEngine.Object.FindObjectOfType(type);
            if (MonoSingleton<T>.s_instance == null)
            {
                GameObject obj2 = new GameObject(typeof(T).Name);
                MonoSingleton<T>.s_instance = obj2.AddComponent<T>();
                GameObject obj3 = GameObject.Find("BootObj");
                if (obj3 != null)
                {
                    obj2.transform.SetParent(obj3.transform);
                }
            }
        }
        return MonoSingleton<T>.s_instance;
    }

    public static bool HasInstance()
    {
        return (MonoSingleton<T>.s_instance != null);
    }

    protected virtual void Init()
    { 
    
    }

    protected virtual void OnDestroy()
    {
        if ((MonoSingleton<T>.s_instance != null) && (MonoSingleton<T>.s_instance.gameObject == gameObject))
        {
            MonoSingleton<T>.s_instance = null;
        }
    }
}
