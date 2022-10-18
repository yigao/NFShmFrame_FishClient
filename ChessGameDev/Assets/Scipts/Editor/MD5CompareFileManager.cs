using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MD5CompareFileManager
{
    public static string SerializeToJson(List<MD5Info> allMD5IndoList)
    {
        Dictionary<string, string> _tempDic = new Dictionary<string, string>();

        for (int i = 0; i < allMD5IndoList.Count; i++)
        {
            string key = allMD5IndoList[i].name;
            string md5InfoToJsonData = JsonUtility.ToJson(allMD5IndoList[i]);
            
            if(_tempDic.ContainsKey(key))
            {
                Debug.LogError("存在相同的Name==>");
                Debug.Log(JsonUtility.FromJson<MD5Info>( _tempDic[key]).relativePath);
                Debug.Log(allMD5IndoList[i].relativePath);
                return null;
            }
            else
                _tempDic.Add(key, md5InfoToJsonData);
        }
        JsonSerialization<string, string> _jsS = new JsonSerialization<string, string>(_tempDic);
        string toJsonData = JsonUtility.ToJson(_jsS);
        //Log.Error(toJsonData);
        return toJsonData;
    }

    public static Dictionary<string,MD5Info> SerializeToObject(string jsonData)
    {
        Dictionary<string, MD5Info> tempDic = new Dictionary<string, MD5Info>();
        JsonSerialization < string, string> _jsS = JsonUtility.FromJson<JsonSerialization<string, string>>(jsonData);
        Dictionary<string,string> baseData=_jsS.GetOnAfterDeserializeData();
        foreach (var item in baseData)
        {
            string key = item.Key;
            string value = item.Value;
            MD5Info md5Info=JsonUtility.FromJson<MD5Info>(value);
            tempDic.Add(key, md5Info);
        }

        return tempDic;
    }



    public static Dictionary<string ,MD5Info> CompareUpdateFileMD5(Dictionary<string, MD5Info> current, Dictionary<string, MD5Info> compare)
    {
        Dictionary<string, MD5Info> tempDic = new Dictionary<string, MD5Info>();
        foreach (var item in current)
        {
            string key = item.Key;
            string currentMd5 = item.Value.md5;
            if(compare.ContainsKey(key))
            {
                string compareMd5 = compare[key].md5;
                if (currentMd5 != compareMd5)
                {
                    tempDic.Add(key, item.Value);
                }
                compare.Remove(key);
            }else
            {
                tempDic.Add(key, item.Value);
            }
            

        }
        //if(compare.Count>0)
        //{
        //    foreach (var item in compare)
        //    {
        //        tempDic.Add(item.Key, item.Value);
        //    }
        //}
        return tempDic;
    }



}
