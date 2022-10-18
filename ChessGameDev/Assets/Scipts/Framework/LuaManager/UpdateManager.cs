using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateManager : MonoSingleton<UpdateManager>
{

    public class UpdateItem
    {
        public int itemNum = 0;
        GameObject targetObj = null;
        Action updateFunc = null;

        public UpdateItem(int itemNum, GameObject targetObj, Action updateFunc)
        {
            this.itemNum = itemNum;
            this.targetObj = targetObj;
            this.updateFunc = updateFunc;
        }

        public void Update()
        {
            if (targetObj != null && updateFunc != null)
            {
                updateFunc();
            }
            else
            {
               // Log.Error("自动移除Update==>" + itemNum);
                updateFunc = null;
                MonoSingleton<UpdateManager>.GetInstance().RemoveUpdateItem(itemNum);
            }

        }
    }


    public  bool isEnableUpdate = true;
    int updateMark = 0;
    List<UpdateItem> AllUpdateList = new List<UpdateItem>();
    void Start()
    {

    }

    int GetUpdateMark()
    {
        updateMark += 1;
        return updateMark;
    }

    public int AddUpdateItem(GameObject targetObj, Action callBackFunc)
    {
        if (targetObj == null || callBackFunc == null)
        {
            Log.Error("添加Update失败==>");
            return -1;
        }
        int tempNum = GetUpdateMark();
        UpdateItem tempUM = new UpdateItem(tempNum, targetObj, callBackFunc);
        AllUpdateList.Add(tempUM);
        return tempNum;
    }

    public void RemoveUpdateItem(int updateItemNum)
    {
        if (AllUpdateList.Count > 0)
        {
            for (int i = 0; i < AllUpdateList.Count; i++)
            {
                if (AllUpdateList[i].itemNum == updateItemNum)
                {
                    AllUpdateList.RemoveAt(i);
                }
            }
        }
    }

    void Update()
    {
        if (isEnableUpdate)
        {
            for (int i = 0; i < AllUpdateList.Count; i++)
            {
                if (AllUpdateList[i] != null)
                {
                    AllUpdateList[i].Update();
                }
            }
        }
    }
}
