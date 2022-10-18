using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CorotineManager : MonoSingleton<CorotineManager> {

    #region Lua协程管理

    Dictionary<string, Coroutine> corotineMap = new Dictionary<string, Coroutine>();
    public void YieldAndCallback(object to_yield, Action callback, string corotineName = null)
    {

        Coroutine tempC = StartCoroutine(CoBody(to_yield, callback, corotineName));
        if (!string.IsNullOrEmpty(corotineName))
        {
            if (!corotineMap.ContainsKey(corotineName))
            {
                Log.Error("开始运行协程：" + corotineName);
                corotineMap.Add(corotineName, tempC);
            }
            else
                Log.Error(corotineName + "：corotineMap中当前已经存在该key");

        }
    }

    private IEnumerator CoBody(object to_yield, Action callback, string corotineName)
    {
        if (to_yield is IEnumerator)
            yield return StartCoroutine((IEnumerator)to_yield);
        else
            yield return to_yield;
        
        if (!string.IsNullOrEmpty(corotineName))
        {
            Log.Error("自动移除协程：" + corotineName);
            corotineMap.Remove(corotineName);
        }
        if(callback!=null)
            callback();
    }

    public void StopCorotine(string corotineName)
    {
        Log.Error("手动开始移除协程：" + corotineName);
        Coroutine corotine = null;
        corotineMap.TryGetValue(corotineName, out corotine);
        if (corotine != null)
            StopCoroutine(corotine);
    }

    public void StopAllCorotine()
    {
        StopAllCoroutines();
        corotineMap.Clear();
    }

    protected override void OnDestroy()
    {
        base.OnDestroy();
        this.corotineMap.Clear();
    }

    #endregion
}
