#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class UITimerScriptWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UITimerScript);
			Utils.BeginObjectRegister(type, L, translator, 0, 13, 7, 7);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Initialize", _m_Initialize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Close", _m_Close);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetTotalTime", _m_SetTotalTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetCurrentTime", _m_SetCurrentTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCurrentTime", _m_GetCurrentTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetOnChangedIntervalTime", _m_SetOnChangedIntervalTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StartTimer", _m_StartTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ReStartTimer", _m_ReStartTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnApplicationPause", _m_OnApplicationPause);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "PauseTimer", _m_PauseTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResumeTimer", _m_ResumeTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "EndTimer", _m_EndTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResetTime", _m_ResetTime);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "timerType", _g_get_timerType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "timerDisplayType", _g_get_timerDisplayType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "pausedWhenAppPaused", _g_get_pausedWhenAppPaused);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "closeBelongedFormWhenTimeup", _g_get_closeBelongedFormWhenTimeup);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "timerStartCallBack", _g_get_timerStartCallBack);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "timerChangeCallBack", _g_get_timerChangeCallBack);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "timerUpCallBack", _g_get_timerUpCallBack);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "timerType", _s_set_timerType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "timerDisplayType", _s_set_timerDisplayType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "pausedWhenAppPaused", _s_set_pausedWhenAppPaused);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "closeBelongedFormWhenTimeup", _s_set_closeBelongedFormWhenTimeup);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "timerStartCallBack", _s_set_timerStartCallBack);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "timerChangeCallBack", _s_set_timerChangeCallBack);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "timerUpCallBack", _s_set_timerUpCallBack);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					UITimerScript gen_ret = new UITimerScript();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UITimerScript constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Initialize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UIFormScript _formScript = (UIFormScript)translator.GetObject(L, 2, typeof(UIFormScript));
                    
                    gen_to_be_invoked.Initialize( _formScript );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Close(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Close(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetTotalTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _time = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetTotalTime( _time );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCurrentTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _time = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetCurrentTime( _time );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCurrentTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        float gen_ret = gen_to_be_invoked.GetCurrentTime(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetOnChangedIntervalTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _intervalTime = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetOnChangedIntervalTime( _intervalTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StartTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.StartTimer(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReStartTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ReStartTimer(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnApplicationPause(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _pause = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.OnApplicationPause( _pause );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_PauseTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.PauseTimer(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResumeTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ResumeTimer(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EndTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.EndTimer(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResetTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ResetTime(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_timerType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.timerType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_timerDisplayType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.timerDisplayType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_pausedWhenAppPaused(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.pausedWhenAppPaused);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_closeBelongedFormWhenTimeup(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.closeBelongedFormWhenTimeup);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_timerStartCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.timerStartCallBack);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_timerChangeCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.timerChangeCallBack);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_timerUpCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.timerUpCallBack);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_timerType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                enTimerType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.timerType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_timerDisplayType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                enTimerDisplayType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.timerDisplayType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_pausedWhenAppPaused(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.pausedWhenAppPaused = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_closeBelongedFormWhenTimeup(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.closeBelongedFormWhenTimeup = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_timerStartCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.timerStartCallBack = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_timerChangeCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.timerChangeCallBack = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_timerUpCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UITimerScript gen_to_be_invoked = (UITimerScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.timerUpCallBack = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
