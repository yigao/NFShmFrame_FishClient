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
    public class GlobalConfigManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GlobalConfigManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 6, 7, 7);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDeviceUniqueIdentifier", _m_GetDeviceUniqueIdentifier);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetAccountLoginIPEndPoint", _m_SetAccountLoginIPEndPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetAccountLoginIPEndPoint", _m_GetAccountLoginIPEndPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetUserLoginGameIPEndPoint", _m_SetUserLoginGameIPEndPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetUserLoginGameIPEndPoint", _m_GetUserLoginGameIPEndPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearUserLoginGameIPEndPoint", _m_ClearUserLoginGameIPEndPoint);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "Hall_Name", _g_get_Hall_Name);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Game_Config", _g_get_Game_Config);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Contract_Number", _g_get_Contract_Number);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Account_Login_Ip", _g_get_Account_Login_Ip);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Account_Login_Port", _g_get_Account_Login_Port);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_accountLoginIPEndPoint", _g_get_m_accountLoginIPEndPoint);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Url_Path", _g_get_Url_Path);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "Hall_Name", _s_set_Hall_Name);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Game_Config", _s_set_Game_Config);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Contract_Number", _s_set_Contract_Number);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Account_Login_Ip", _s_set_Account_Login_Ip);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Account_Login_Port", _s_set_Account_Login_Port);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_accountLoginIPEndPoint", _s_set_m_accountLoginIPEndPoint);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Url_Path", _s_set_Url_Path);
            
			
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
					
					GlobalConfigManager gen_ret = new GlobalConfigManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GlobalConfigManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDeviceUniqueIdentifier(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        string gen_ret = gen_to_be_invoked.GetDeviceUniqueIdentifier(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetAccountLoginIPEndPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _ip = LuaAPI.lua_tostring(L, 2);
                    int _port = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.SetAccountLoginIPEndPoint( _ip, _port );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAccountLoginIPEndPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        System.Net.IPEndPoint gen_ret = gen_to_be_invoked.GetAccountLoginIPEndPoint(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetUserLoginGameIPEndPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _ip = LuaAPI.lua_tostring(L, 2);
                    int _port = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.SetUserLoginGameIPEndPoint( _ip, _port );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetUserLoginGameIPEndPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        System.Net.IPEndPoint gen_ret = gen_to_be_invoked.GetUserLoginGameIPEndPoint(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearUserLoginGameIPEndPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearUserLoginGameIPEndPoint(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Hall_Name(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.Hall_Name);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Game_Config(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.Game_Config);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Contract_Number(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.Contract_Number);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Account_Login_Ip(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.Account_Login_Ip);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Account_Login_Port(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.Account_Login_Port);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_accountLoginIPEndPoint(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_accountLoginIPEndPoint);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Url_Path(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.Url_Path);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Hall_Name(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Hall_Name = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Game_Config(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Game_Config = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Contract_Number(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Contract_Number = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Account_Login_Ip(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Account_Login_Ip = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Account_Login_Port(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Account_Login_Port = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_accountLoginIPEndPoint(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_accountLoginIPEndPoint = (System.Net.IPEndPoint)translator.GetObject(L, 2, typeof(System.Net.IPEndPoint));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Url_Path(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalConfigManager gen_to_be_invoked = (GlobalConfigManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Url_Path = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
