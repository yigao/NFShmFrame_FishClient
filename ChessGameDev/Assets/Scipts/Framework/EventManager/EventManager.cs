using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

public delegate void EventHandle_Unit(params object[] ps);
public class EventManager : Singleton<EventManager>
{
    Dictionary<string, List<EventHandle_Unit>> eventMap = null;
    public override void Init()
    {
        base.Init();
        eventMap = new Dictionary<string, List<EventHandle_Unit>>();
    }


    public void AddEvent(string eventName, EventHandle_Unit eventUnit)
    {
        if (!eventMap.ContainsKey(eventName))
            eventMap[eventName] = new List<EventHandle_Unit>();
        eventMap[eventName].Add(eventUnit);
    }


    public void RemoveSingleEvent(string eventName, EventHandle_Unit eventUnit)
    {
        if (eventMap.ContainsKey(eventName))
        {
            if (eventUnit == null) return;
            if (eventMap[eventName].Contains(eventUnit))
            {
                // Log.Error("移除事件" + eventName);
                eventMap[eventName].Remove(eventUnit);
            }
            else
                Log.Error("不存在的移除事件" + eventName);
        }
    }

    public void RemoveEvent(string eventName)
    {
        if (eventMap.ContainsKey(eventName))
            eventMap.Remove(eventName);
    }

    public void DispatchEvent(string eventName, params object[] eventParams)
    {
        List<EventHandle_Unit> outPas = null;
        eventMap.TryGetValue(eventName, out outPas);
        if (outPas != null)
        {
            foreach (var itemEvent in outPas)
            {
                itemEvent(eventParams);
            }
        }
    }

    public bool IsContainsKey(string eventName)
    {
        if (!string.IsNullOrEmpty(eventName))
        {
            if (eventMap.ContainsKey(eventName))
                return true;
            else
                return false;
        }
        return false;
    }
}
