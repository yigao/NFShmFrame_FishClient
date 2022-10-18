using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[Serializable]
public class MD5Info
{
    public string name;
    public string relativePath;
    public string md5;
    public long size;   //字节大小

    public MD5Info(string name, string relativePath, string md5, long size)
    {
        this.name = name;
        this.relativePath = relativePath;
        this.md5 = md5;
        this.size = size;
    }
}


public class JsonSerialization<TKey,TValue> : ISerializationCallbackReceiver
{
    [SerializeField]
    List<TKey> _keys;
    [SerializeField]
    List<TValue> _values;
    [SerializeField]
    Dictionary<TKey, TValue> originalDicData;

    public JsonSerialization (Dictionary<TKey,TValue> buildData)
    {
        originalDicData = buildData;
    }

    public Dictionary<TKey,TValue> GetOnAfterDeserializeData()
    {
        return originalDicData;
    }

    public void OnAfterDeserialize()
    {
        originalDicData = new Dictionary<TKey, TValue>();
        int count = Math.Min(_keys.Count, _values.Count);
        for (int i = 0; i < count; i++)
        {
            originalDicData.Add(_keys[i], _values[i]);
        }
    }

    public void OnBeforeSerialize()
    {
        _keys = new List<TKey>(originalDicData.Keys);
        _values = new List<TValue>(originalDicData.Values);
    }

   
}
