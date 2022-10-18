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
    public class FishManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(FishManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 18, 12, 12);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Init", _m_Init_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetTraceBasePath", _m_GetTraceBasePath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetTraceFileCount", _m_GetTraceFileCount_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LoadBinaryTraceFile", _m_LoadBinaryTraceFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ParseBinaryTraceFile", _m_ParseBinaryTraceFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AccordingDeskLoadBinaryTraceFile", _m_AccordingDeskLoadBinaryTraceFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetRealWidthRatio", _m_GetRealWidthRatio_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetRealHeightRatio", _m_GetRealHeightRatio_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LimitTracePoint", _m_LimitTracePoint_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ScreenPointToRealPoint", _m_ScreenPointToRealPoint_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "RealPointToScreenPoint", _m_RealPointToScreenPoint_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetPosition", _m_SetPosition_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetLocalPosition", _m_SetLocalPosition_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetEulerAngles", _m_SetEulerAngles_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetLocalEulerAngles", _m_SetLocalEulerAngles_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetLocalScale", _m_SetLocalScale_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "FromToRotation", _m_FromToRotation_xlua_st_);
            
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "DefaultResolutionWidth", _g_get_DefaultResolutionWidth);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "DefaultesolutionHeight", _g_get_DefaultesolutionHeight);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "curResolutionWidth", _g_get_curResolutionWidth);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "curResolutionHeight", _g_get_curResolutionHeight);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "isLockShoot", _g_get_isLockShoot);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "m_desk", _g_get_m_desk);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "m_Fish3D", _g_get_m_Fish3D);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "luaFunction", _g_get_luaFunction);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "tracePointList", _g_get_tracePointList);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "fileList", _g_get_fileList);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "tracePointMap", _g_get_tracePointMap);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "headerMap", _g_get_headerMap);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "DefaultResolutionWidth", _s_set_DefaultResolutionWidth);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "DefaultesolutionHeight", _s_set_DefaultesolutionHeight);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "curResolutionWidth", _s_set_curResolutionWidth);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "curResolutionHeight", _s_set_curResolutionHeight);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "isLockShoot", _s_set_isLockShoot);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "m_desk", _s_set_m_desk);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "m_Fish3D", _s_set_m_Fish3D);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "luaFunction", _s_set_luaFunction);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "tracePointList", _s_set_tracePointList);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "fileList", _s_set_fileList);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "tracePointMap", _s_set_tracePointMap);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "headerMap", _s_set_headerMap);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					FishManager gen_ret = new FishManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FishManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Init_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _resolutionWidth = (float)LuaAPI.lua_tonumber(L, 1);
                    float _resolutionHeight = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    FishManager.Init( _resolutionWidth, _resolutionHeight );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTraceBasePath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _gameId = LuaAPI.xlua_tointeger(L, 1);
                    
                        string gen_ret = FishManager.GetTraceBasePath( _gameId );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTraceFileCount_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _gameID = LuaAPI.xlua_tointeger(L, 1);
                    
                        int gen_ret = FishManager.GetTraceFileCount( _gameID );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadBinaryTraceFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    
                        System.Collections.IEnumerator gen_ret = FishManager.LoadBinaryTraceFile(  );
                        translator.PushAny(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ParseBinaryTraceFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    System.IO.FileStream _strem = (System.IO.FileStream)translator.GetObject(L, 1, typeof(System.IO.FileStream));
                    
                    FishManager.ParseBinaryTraceFile( _strem );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AccordingDeskLoadBinaryTraceFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TFUNCTION)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    int _gameID = LuaAPI.xlua_tointeger(L, 1);
                    bool _isRotationPoint = LuaAPI.lua_toboolean(L, 2);
                    XLua.LuaFunction _callBack = (XLua.LuaFunction)translator.GetObject(L, 3, typeof(XLua.LuaFunction));
                    bool _isFish3D = LuaAPI.lua_toboolean(L, 4);
                    
                    FishManager.AccordingDeskLoadBinaryTraceFile( _gameID, _isRotationPoint, _callBack, _isFish3D );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TFUNCTION)) 
                {
                    int _gameID = LuaAPI.xlua_tointeger(L, 1);
                    bool _isRotationPoint = LuaAPI.lua_toboolean(L, 2);
                    XLua.LuaFunction _callBack = (XLua.LuaFunction)translator.GetObject(L, 3, typeof(XLua.LuaFunction));
                    
                    FishManager.AccordingDeskLoadBinaryTraceFile( _gameID, _isRotationPoint, _callBack );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishManager.AccordingDeskLoadBinaryTraceFile!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRealWidthRatio_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        float gen_ret = FishManager.GetRealWidthRatio(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRealHeightRatio_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        float gen_ret = FishManager.GetRealHeightRatio(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LimitTracePoint_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _trace = LuaAPI.xlua_tointeger(L, 1);
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool gen_ret = FishManager.LimitTracePoint( _trace, _index );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ScreenPointToRealPoint_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 1);
                    float _y = (float)LuaAPI.lua_tonumber(L, 2);
                    
                        UnityEngine.Vector3 gen_ret = FishManager.ScreenPointToRealPoint( _x, _y );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RealPointToScreenPoint_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 1);
                    float _y = (float)LuaAPI.lua_tonumber(L, 2);
                    
                        UnityEngine.Vector3 gen_ret = FishManager.RealPointToScreenPoint( _x, _y );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetPosition_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.GameObject>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetPosition( _go, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Transform>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetPosition( _trans, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishManager.SetPosition!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetLocalPosition_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.GameObject>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetLocalPosition( _go, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Transform>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetLocalPosition( _trans, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishManager.SetLocalPosition!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetEulerAngles_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.GameObject>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetEulerAngles( _go, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Transform>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetEulerAngles( _trans, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishManager.SetEulerAngles!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetLocalEulerAngles_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.GameObject>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetLocalEulerAngles( _go, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Transform>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetLocalEulerAngles( _trans, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishManager.SetLocalEulerAngles!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetLocalScale_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.GameObject>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetLocalScale( _go, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Transform>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    FishManager.SetLocalScale( _trans, _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishManager.SetLocalScale!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FromToRotation_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 7&& translator.Assignable<UnityEngine.GameObject>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7)) 
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    float _x1 = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y1 = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z1 = (float)LuaAPI.lua_tonumber(L, 4);
                    float _x2 = (float)LuaAPI.lua_tonumber(L, 5);
                    float _y2 = (float)LuaAPI.lua_tonumber(L, 6);
                    float _z2 = (float)LuaAPI.lua_tonumber(L, 7);
                    
                    FishManager.FromToRotation( _go, _x1, _y1, _z1, _x2, _y2, _z2 );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& translator.Assignable<UnityEngine.Transform>(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7)) 
                {
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    float _x1 = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y1 = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z1 = (float)LuaAPI.lua_tonumber(L, 4);
                    float _x2 = (float)LuaAPI.lua_tonumber(L, 5);
                    float _y2 = (float)LuaAPI.lua_tonumber(L, 6);
                    float _z2 = (float)LuaAPI.lua_tonumber(L, 7);
                    
                    FishManager.FromToRotation( _trans, _x1, _y1, _z1, _x2, _y2, _z2 );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishManager.FromToRotation!");
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DefaultResolutionWidth(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, FishManager.DefaultResolutionWidth);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DefaultesolutionHeight(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, FishManager.DefaultesolutionHeight);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_curResolutionWidth(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, FishManager.curResolutionWidth);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_curResolutionHeight(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, FishManager.curResolutionHeight);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isLockShoot(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushboolean(L, FishManager.isLockShoot);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_desk(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.xlua_pushinteger(L, FishManager.m_desk);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_Fish3D(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushboolean(L, FishManager.m_Fish3D);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_luaFunction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, FishManager.luaFunction);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_tracePointList(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, FishManager.tracePointList);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fileList(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, FishManager.fileList);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_tracePointMap(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, FishManager.tracePointMap);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_headerMap(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, FishManager.headerMap);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_DefaultResolutionWidth(RealStatePtr L)
        {
		    try {
                
			    FishManager.DefaultResolutionWidth = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_DefaultesolutionHeight(RealStatePtr L)
        {
		    try {
                
			    FishManager.DefaultesolutionHeight = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_curResolutionWidth(RealStatePtr L)
        {
		    try {
                
			    FishManager.curResolutionWidth = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_curResolutionHeight(RealStatePtr L)
        {
		    try {
                
			    FishManager.curResolutionHeight = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isLockShoot(RealStatePtr L)
        {
		    try {
                
			    FishManager.isLockShoot = LuaAPI.lua_toboolean(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_desk(RealStatePtr L)
        {
		    try {
                
			    FishManager.m_desk = LuaAPI.xlua_tointeger(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_Fish3D(RealStatePtr L)
        {
		    try {
                
			    FishManager.m_Fish3D = LuaAPI.lua_toboolean(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_luaFunction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    FishManager.luaFunction = (XLua.LuaFunction)translator.GetObject(L, 1, typeof(XLua.LuaFunction));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_tracePointList(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    FishManager.tracePointList = (System.Collections.Generic.List<TracePoint>)translator.GetObject(L, 1, typeof(System.Collections.Generic.List<TracePoint>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fileList(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    FishManager.fileList = (System.Collections.Generic.List<string>)translator.GetObject(L, 1, typeof(System.Collections.Generic.List<string>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_tracePointMap(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    FishManager.tracePointMap = (System.Collections.Generic.Dictionary<int, System.Collections.Generic.List<TracePoint>>)translator.GetObject(L, 1, typeof(System.Collections.Generic.Dictionary<int, System.Collections.Generic.List<TracePoint>>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_headerMap(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    FishManager.headerMap = (System.Collections.Generic.Dictionary<int, TraceHeader>)translator.GetObject(L, 1, typeof(System.Collections.Generic.Dictionary<int, TraceHeader>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
