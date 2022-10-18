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
    public class TimerManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(TimerManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 15, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Init", _m_Init);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Update", _m_Update);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateTimer", _m_UpdateTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddTimer", _m_AddTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveTimer", _m_RemoveTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveTimerSafely", _m_RemoveTimerSafely);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "PauseTimer", _m_PauseTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResumeTimer", _m_ResumeTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResetTimer", _m_ResetTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResetTimerTotalTime", _m_ResetTimerTotalTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ModifyTimerTotalTime", _m_ModifyTimerTotalTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTimerCurrent", _m_GetTimerCurrent);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLeftTime", _m_GetLeftTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTimer", _m_GetTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveAllTimer", _m_RemoveAllTimer);
			
			
			
			
			
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
					
					TimerManager gen_ret = new TimerManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to TimerManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Init(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Init(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Update(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Update(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _delta = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.UpdateTimer( _delta );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _time = LuaAPI.xlua_tointeger(L, 2);
                    int _loop = LuaAPI.xlua_tointeger(L, 3);
                    Timer.OnTimeUpHandler _onTimeUpHandler = translator.GetDelegate<Timer.OnTimeUpHandler>(L, 4);
                    
                        int gen_ret = gen_to_be_invoked.AddTimer( _time, _loop, _onTimeUpHandler );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.RemoveTimer( _sequence );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<Timer.OnTimeUpHandler>(L, 2)) 
                {
                    Timer.OnTimeUpHandler _onTimeUpHandler = translator.GetDelegate<Timer.OnTimeUpHandler>(L, 2);
                    
                    gen_to_be_invoked.RemoveTimer( _onTimeUpHandler );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TimerManager.RemoveTimer!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveTimerSafely(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.RemoveTimerSafely( ref _sequence );
                    LuaAPI.xlua_pushinteger(L, _sequence);
                        
                    
                    
                    
                    return 1;
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
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.PauseTimer( _sequence );
                    
                    
                    
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
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.ResumeTimer( _sequence );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResetTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.ResetTimer( _sequence );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResetTimerTotalTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    int _totalTime = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.ResetTimerTotalTime( _sequence, _totalTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ModifyTimerTotalTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    int _totalTime = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.ModifyTimerTotalTime( _sequence, _totalTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTimerCurrent(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    
                        int gen_ret = gen_to_be_invoked.GetTimerCurrent( _sequence );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLeftTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    
                        float gen_ret = gen_to_be_invoked.GetLeftTime( _sequence );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    
                        Timer gen_ret = gen_to_be_invoked.GetTimer( _sequence );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveAllTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerManager gen_to_be_invoked = (TimerManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.RemoveAllTimer(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
