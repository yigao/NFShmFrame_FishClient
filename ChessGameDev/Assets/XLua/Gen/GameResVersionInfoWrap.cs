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
    public class GameResVersionInfoWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameResVersionInfo);
			Utils.BeginObjectRegister(type, L, translator, 0, 18, 20, 20);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCompareResType", _m_GetCompareResType);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BeginCheckGameVersion", _m_BeginCheckGameVersion);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetVersionXMLFile", _m_GetVersionXMLFile);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BeginCompareVersion", _m_BeginCompareVersion);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnCompareConfigVersion", _m_OnCompareConfigVersion);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnCompareLobbyVersion", _m_OnCompareLobbyVersion);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnCompareGameVersion", _m_OnCompareGameVersion);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BeginDownloadGameRes", _m_BeginDownloadGameRes);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BeginCheckBreakpointResume", _m_BeginCheckBreakpointResume);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BeginUnZipFile", _m_BeginUnZipFile);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnUnZipFile", _m_OnUnZipFile);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateGameResVersion", _m_UpdateGameResVersion);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WriteVersionXmlFile", _m_WriteVersionXmlFile);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetVersionFileUrl", _m_GetVersionFileUrl);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLocalVersionUrl", _m_GetLocalVersionUrl);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDownloadGameResUrl", _m_GetDownloadGameResUrl);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDownloadSavePath", _m_GetDownloadSavePath);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetUnzipFilePath", _m_GetUnzipFilePath);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "gameID", _g_get_gameID);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "downloadGameResUrl", _g_get_downloadGameResUrl);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "serverVersionUrl", _g_get_serverVersionUrl);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "serverVersion", _g_get_serverVersion);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "localVersionUrl", _g_get_localVersionUrl);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "localVersion", _g_get_localVersion);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "downloadSavePath", _g_get_downloadSavePath);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "unzipFilePath", _g_get_unzipFilePath);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "request", _g_get_request);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "downloadLengthKey", _g_get_downloadLengthKey);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "breakPointVersionKey", _g_get_breakPointVersionKey);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "gameVersionStatus", _g_get_gameVersionStatus);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "gameResType", _g_get_gameResType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "compareResType", _g_get_compareResType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isIncrementalUpdate", _g_get_isIncrementalUpdate);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GameResInfoCallBack", _g_get_GameResInfoCallBack);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "downloadedPercent", _g_get_downloadedPercent);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "currentUnzipBytes", _g_get_currentUnzipBytes);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "unzipFileTotalBytes", _g_get_unzipFileTotalBytes);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "currentUnzipPercent", _g_get_currentUnzipPercent);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "gameID", _s_set_gameID);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "downloadGameResUrl", _s_set_downloadGameResUrl);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "serverVersionUrl", _s_set_serverVersionUrl);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "serverVersion", _s_set_serverVersion);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "localVersionUrl", _s_set_localVersionUrl);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "localVersion", _s_set_localVersion);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "downloadSavePath", _s_set_downloadSavePath);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "unzipFilePath", _s_set_unzipFilePath);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "request", _s_set_request);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "downloadLengthKey", _s_set_downloadLengthKey);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "breakPointVersionKey", _s_set_breakPointVersionKey);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "gameVersionStatus", _s_set_gameVersionStatus);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "gameResType", _s_set_gameResType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "compareResType", _s_set_compareResType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isIncrementalUpdate", _s_set_isIncrementalUpdate);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "GameResInfoCallBack", _s_set_GameResInfoCallBack);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "downloadedPercent", _s_set_downloadedPercent);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "currentUnzipBytes", _s_set_currentUnzipBytes);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "unzipFileTotalBytes", _s_set_unzipFileTotalBytes);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "currentUnzipPercent", _s_set_currentUnzipPercent);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Key_02", GameResVersionInfo.Key_02);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Key_03", GameResVersionInfo.Key_03);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 3 && LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) && translator.Assignable<System.Action<GameResVersionInfo>>(L, 3))
				{
					int _gameID = LuaAPI.xlua_tointeger(L, 2);
					System.Action<GameResVersionInfo> _callBack = translator.GetDelegate<System.Action<GameResVersionInfo>>(L, 3);
					
					GameResVersionInfo gen_ret = new GameResVersionInfo(_gameID, _callBack);
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameResVersionInfo constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCompareResType(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        CompareResType gen_ret = gen_to_be_invoked.GetCompareResType(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BeginCheckGameVersion(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.BeginCheckGameVersion(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetVersionXMLFile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _xmlContent = LuaAPI.lua_tostring(L, 2);
                    
                        VersionInfo gen_ret = gen_to_be_invoked.GetVersionXMLFile( _xmlContent );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BeginCompareVersion(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.BeginCompareVersion(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnCompareConfigVersion(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnCompareConfigVersion(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnCompareLobbyVersion(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnCompareLobbyVersion(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnCompareGameVersion(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnCompareGameVersion(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BeginDownloadGameRes(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.BeginDownloadGameRes(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BeginCheckBreakpointResume(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.BeginCheckBreakpointResume(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BeginUnZipFile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.BeginUnZipFile(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnUnZipFile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnUnZipFile(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateGameResVersion(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UpdateGameResVersion(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WriteVersionXmlFile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.WriteVersionXmlFile(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetVersionFileUrl(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        string gen_ret = gen_to_be_invoked.GetVersionFileUrl(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLocalVersionUrl(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        string gen_ret = gen_to_be_invoked.GetLocalVersionUrl(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDownloadGameResUrl(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        string gen_ret = gen_to_be_invoked.GetDownloadGameResUrl(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDownloadSavePath(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        string gen_ret = gen_to_be_invoked.GetDownloadSavePath(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetUnzipFilePath(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        string gen_ret = gen_to_be_invoked.GetUnzipFilePath(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_gameID(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.gameID);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_downloadGameResUrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.downloadGameResUrl);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_serverVersionUrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.serverVersionUrl);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_serverVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.serverVersion);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_localVersionUrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.localVersionUrl);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_localVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.localVersion);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_downloadSavePath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.downloadSavePath);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_unzipFilePath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.unzipFilePath);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_request(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.request);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_downloadLengthKey(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.downloadLengthKey);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_breakPointVersionKey(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.breakPointVersionKey);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_gameVersionStatus(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                translator.PushGameVersionStatus(L, gen_to_be_invoked.gameVersionStatus);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_gameResType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.gameResType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_compareResType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.compareResType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isIncrementalUpdate(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isIncrementalUpdate);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GameResInfoCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.GameResInfoCallBack);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_downloadedPercent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.downloadedPercent);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_currentUnzipBytes(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushint64(L, gen_to_be_invoked.currentUnzipBytes);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_unzipFileTotalBytes(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushint64(L, gen_to_be_invoked.unzipFileTotalBytes);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_currentUnzipPercent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.currentUnzipPercent);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_gameID(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.gameID = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_downloadGameResUrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.downloadGameResUrl = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_serverVersionUrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.serverVersionUrl = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_serverVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.serverVersion = (VersionInfo)translator.GetObject(L, 2, typeof(VersionInfo));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_localVersionUrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.localVersionUrl = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_localVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.localVersion = (VersionInfo)translator.GetObject(L, 2, typeof(VersionInfo));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_downloadSavePath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.downloadSavePath = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_unzipFilePath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.unzipFilePath = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_request(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.request = (BestHTTP.HTTPRequest)translator.GetObject(L, 2, typeof(BestHTTP.HTTPRequest));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_downloadLengthKey(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.downloadLengthKey = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_breakPointVersionKey(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.breakPointVersionKey = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_gameVersionStatus(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                GameVersionStatus gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.gameVersionStatus = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_gameResType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                GameResType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.gameResType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_compareResType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                CompareResType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.compareResType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isIncrementalUpdate(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isIncrementalUpdate = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_GameResInfoCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.GameResInfoCallBack = translator.GetDelegate<System.Action<GameResVersionInfo>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_downloadedPercent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.downloadedPercent = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_currentUnzipBytes(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.currentUnzipBytes = LuaAPI.lua_toint64(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_unzipFileTotalBytes(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.unzipFileTotalBytes = LuaAPI.lua_toint64(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_currentUnzipPercent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameResVersionInfo gen_to_be_invoked = (GameResVersionInfo)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.currentUnzipPercent = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
