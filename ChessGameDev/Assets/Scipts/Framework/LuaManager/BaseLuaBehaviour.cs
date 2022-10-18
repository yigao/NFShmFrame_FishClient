using System;
using UnityEngine;
using UnityEngine.EventSystems;
using XLua;
using Object = System.Object;

public class BaseLuaBehaviour : MonoBehaviour
{
    protected Action AwakeFunction;
    protected Action StartFunction;
    protected Action UpdateFunction;
    protected Action FixedUpdateFunction;
    protected Action LateUpdateFunction;
    protected Action OnEnableFunction;
    protected Action OnDisableFunction;
    protected Action OnDestroyFunction;

    protected Action OnCollisionEnterFunction;
    protected Action OnCollisionStayFunction;
    protected Action OnCollisionExitFunction;

    protected Action OnTriggerEnterFunction;
    protected Action OnTriggerStayFunction;
    protected Action OnTriggerExitFunction;

    protected Action OnMouseDownFunction;
    protected Action OnMouseDragFunction;
    protected Action OnMouseEnterFunction;
    protected Action OnMouseExitFunction;
    protected Action OnMouseOverFunction;
    protected Action OnMouseUpFunction;

    protected Action OnBecameInvisibleFunction;
    protected Action OnBecameVisibleFunction;
        
    public LuaTable LuaScript { private set; get; }
    public string LuaScriptName;

    protected virtual void Awake()
    {
            
    }

    protected virtual void Start()
    {
       
    }

    void OnMouseDown()
    {
        if (OnMouseDownFunction != null) OnMouseDownFunction();
    }

    void OnMouseDrag()
    {
        if (OnMouseDragFunction != null) OnMouseDragFunction();
    }

    void OnMouseEnter()
    {
        if (OnMouseEnterFunction != null) OnMouseEnterFunction();
    }

    void OnMouseExit()
    {
        if (OnMouseExitFunction != null) OnMouseExitFunction();
    }

    void OnMouseOver()
    {
        if (OnMouseOverFunction != null) OnMouseOverFunction();
    }

    void OnMouseUp()
    {
        if (OnMouseUpFunction != null) OnMouseUpFunction();
    }


    protected void OnEnable()
    {
        if (OnEnableFunction != null) OnEnableFunction();
    }

    protected void OnDisable()
    {
        if (OnDisableFunction != null) OnDisableFunction();
    }

    /// <summary>
    /// 物体在/进入摄像机会调用一次，类似触发器OnTriggerEnter()
    /// </summary>
    protected void OnBecameVisible()
    {
        if (OnBecameVisibleFunction != null) OnBecameVisibleFunction();
    }

    /// <summary>
    /// 物体离开摄像机会调用一次，类似触发器OnTriggerExit(); 
    /// </summary>
    protected void OnBecameInvisible()
    {
        if (OnBecameInvisibleFunction != null) OnBecameInvisibleFunction();
    }
        
    protected void OnDestroy()
    {
        if (OnDestroyFunction != null) OnDestroyFunction();
    }

    //#region 碰撞
    ///// <summary>
    ///// 进入碰撞区域，触发一次
    ///// </summary>
    ///// <param name="col"></param>
    //protected virtual void OnCollisionEnter(Collision col)
    //{

    //}

    ///// <summary>
    /////  贮存碰撞区域，每帧执行
    ///// </summary>
    ///// <param name="col"></param>
    //protected virtual void OnCollisionStay(Collision col)
    //{

    //}

    ///// <summary>
    /////  出去碰撞区域，触发一次
    ///// </summary>
    ///// <param name="col"></param>
    //protected virtual void OnCollisionExit(Collision col)
    //{

    //}
    //#endregion


    //#region 触发器

    ///// <summary>
    ///// 进入触发器，触发一次
    ///// </summary>
    ///// <param name="col"></param>
    //protected virtual void OnTriggerEnter(Collider col)
    //{

    //}

    ///// <summary>
    ///// 贮存触发器，每帧执行
    ///// </summary>
    ///// <param name="col"></param>
    //protected void OnTriggerStay(Collider col)
    //{

    //}

    ///// <summary>
    ///// 退出触发器，触发一次
    ///// </summary>
    ///// <param name="col"></param>
    //protected void OnTriggerExit(Collider col)
    //{

    //}

    //#endregion
}