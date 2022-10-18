using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[GameState]
public class LuaState : BaseState
{
    public override void OnStateEnter()
    {
        EnterLuaEnvironment(); 
    }

    private void EnterLuaEnvironment()
    {
        MonoSingleton<LuaManager>.GetInstance().Initialize();
    }

    public override void OnStateLeave()
    {

    }

    private void OnVersionUpdateComplete()
    {
        
    }
}
