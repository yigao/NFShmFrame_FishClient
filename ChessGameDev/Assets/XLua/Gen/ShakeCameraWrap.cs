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
    public class ShakeCameraWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(ShakeCamera);
			Utils.BeginObjectRegister(type, L, translator, 0, 2, 9, 9);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Restart", _m_Restart);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "PhoneVibrate", _m_PhoneVibrate);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "positionShake", _g_get_positionShake);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "angleShake", _g_get_angleShake);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "cycleTime", _g_get_cycleTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "cycleCount", _g_get_cycleCount);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "fixShake", _g_get_fixShake);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "unscaleTime", _g_get_unscaleTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "bothDir", _g_get_bothDir);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "fCycleCount", _g_get_fCycleCount);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "autoDisable", _g_get_autoDisable);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "positionShake", _s_set_positionShake);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "angleShake", _s_set_angleShake);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "cycleTime", _s_set_cycleTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "cycleCount", _s_set_cycleCount);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "fixShake", _s_set_fixShake);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "unscaleTime", _s_set_unscaleTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "bothDir", _s_set_bothDir);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "fCycleCount", _s_set_fCycleCount);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "autoDisable", _s_set_autoDisable);
            
			
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
					
					ShakeCamera gen_ret = new ShakeCamera();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to ShakeCamera constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Restart(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)) 
                {
                    UnityEngine.Vector3 _positionShakeT;translator.Get(L, 2, out _positionShakeT);
                    UnityEngine.Vector3 _angleShakeT;translator.Get(L, 3, out _angleShakeT);
                    float _cycleTimeT = (float)LuaAPI.lua_tonumber(L, 4);
                    int _cycleCountT = LuaAPI.xlua_tointeger(L, 5);
                    bool _isVibrate = LuaAPI.lua_toboolean(L, 6);
                    
                    gen_to_be_invoked.Restart( _positionShakeT, _angleShakeT, _cycleTimeT, _cycleCountT, _isVibrate );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    UnityEngine.Vector3 _positionShakeT;translator.Get(L, 2, out _positionShakeT);
                    UnityEngine.Vector3 _angleShakeT;translator.Get(L, 3, out _angleShakeT);
                    float _cycleTimeT = (float)LuaAPI.lua_tonumber(L, 4);
                    int _cycleCountT = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Restart( _positionShakeT, _angleShakeT, _cycleTimeT, _cycleCountT );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to ShakeCamera.Restart!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_PhoneVibrate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.PhoneVibrate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_positionShake(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.positionShake);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_angleShake(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.angleShake);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_cycleTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.cycleTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_cycleCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.cycleCount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fixShake(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.fixShake);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_unscaleTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.unscaleTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_bothDir(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.bothDir);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fCycleCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.fCycleCount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_autoDisable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.autoDisable);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_positionShake(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector3 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.positionShake = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_angleShake(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector3 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.angleShake = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_cycleTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.cycleTime = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_cycleCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.cycleCount = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fixShake(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.fixShake = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_unscaleTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.unscaleTime = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_bothDir(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.bothDir = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fCycleCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.fCycleCount = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_autoDisable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ShakeCamera gen_to_be_invoked = (ShakeCamera)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.autoDisable = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
