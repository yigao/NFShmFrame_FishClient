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
    public class LuaManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(LuaManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 13, 5, 4);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Initialize", _m_Initialize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DoString", _m_DoString);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RunLuaScriptOnNewTable", _m_RunLuaScriptOnNewTable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetProtoFile", _m_GetProtoFile);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadLuaBundle", _m_LoadLuaBundle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveGameLuaBundle", _m_RemoveGameLuaBundle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLuaName", _m_GetLuaName);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetGameFrameRate", _m_SetGameFrameRate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetScreenOrientation", _m_SetScreenOrientation);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetAnimationState", _m_GetAnimationState);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CheckCurrentAnimationIsPlaying", _m_CheckCurrentAnimationIsPlaying);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetMD5", _m_GetMD5);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "QuitGame", _m_QuitGame);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "luaEnv", _g_get_luaEnv);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsOpenLuaLog", _g_get_IsOpenLuaLog);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "DeveloperMode", _g_get_DeveloperMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isLoadLua", _g_get_isLoadLua);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onApplicationFocus", _g_get_onApplicationFocus);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "IsOpenLuaLog", _s_set_IsOpenLuaLog);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "DeveloperMode", _s_set_DeveloperMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isLoadLua", _s_set_isLoadLua);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "onApplicationFocus", _s_set_onApplicationFocus);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GameLua_Path", LuaManager.GameLua_Path);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GcInterval", LuaManager.GcInterval);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					LuaManager gen_ret = new LuaManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LuaManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Initialize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Initialize(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DoString(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _fileName = LuaAPI.lua_tostring(L, 2);
                    
                        object[] gen_ret = gen_to_be_invoked.DoString( _fileName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RunLuaScriptOnNewTable(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _luaScriptName = LuaAPI.lua_tostring(L, 2);
                    string _chunkName = LuaAPI.lua_tostring(L, 3);
                    
                        XLua.LuaTable gen_ret = gen_to_be_invoked.RunLuaScriptOnNewTable( _luaScriptName, _chunkName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _luaScriptName = LuaAPI.lua_tostring(L, 2);
                    
                        XLua.LuaTable gen_ret = gen_to_be_invoked.RunLuaScriptOnNewTable( _luaScriptName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LuaManager.RunLuaScriptOnNewTable!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetProtoFile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _fileName = LuaAPI.lua_tostring(L, 2);
                    
                        string gen_ret = gen_to_be_invoked.GetProtoFile( _fileName );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadLuaBundle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _key = LuaAPI.lua_tostring(L, 2);
                    
                        UnityEngine.AssetBundle gen_ret = gen_to_be_invoked.LoadLuaBundle( _key );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveGameLuaBundle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _gameId = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.RemoveGameLuaBundle( _gameId );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLuaName(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        string gen_ret = gen_to_be_invoked.GetLuaName(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetGameFrameRate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _CurrentFrameRate = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetGameFrameRate( _CurrentFrameRate );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetScreenOrientation(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _isPortrait = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetScreenOrientation( _isPortrait );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAnimationState(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Animation _anim = (UnityEngine.Animation)translator.GetObject(L, 2, typeof(UnityEngine.Animation));
                    string _animName = LuaAPI.lua_tostring(L, 3);
                    
                        UnityEngine.AnimationState gen_ret = gen_to_be_invoked.GetAnimationState( _anim, _animName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CheckCurrentAnimationIsPlaying(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Animation _anim = (UnityEngine.Animation)translator.GetObject(L, 2, typeof(UnityEngine.Animation));
                    string _animName = LuaAPI.lua_tostring(L, 3);
                    
                        bool gen_ret = gen_to_be_invoked.CheckCurrentAnimationIsPlaying( _anim, _animName );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMD5(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _strContent = LuaAPI.lua_tostring(L, 2);
                    
                        string gen_ret = gen_to_be_invoked.GetMD5( _strContent );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_QuitGame(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.QuitGame(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_luaEnv(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.luaEnv);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsOpenLuaLog(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsOpenLuaLog);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DeveloperMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.DeveloperMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isLoadLua(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isLoadLua);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onApplicationFocus(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.onApplicationFocus);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_IsOpenLuaLog(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.IsOpenLuaLog = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_DeveloperMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.DeveloperMode = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isLoadLua(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isLoadLua = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_onApplicationFocus(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaManager gen_to_be_invoked = (LuaManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.onApplicationFocus = translator.GetDelegate<System.Action<bool>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
