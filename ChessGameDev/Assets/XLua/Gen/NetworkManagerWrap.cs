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
    public class NetworkManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(NetworkManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 7, 14, 14);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnApplicationFocus", _m_OnApplicationFocus);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SendNetworkMsgLua", _m_SendNetworkMsgLua);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "NetworkOffline", _m_NetworkOffline);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LuaLaunchNetwork", _m_LuaLaunchNetwork);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CloseNetwork", _m_CloseNetwork);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnHeartBeatReq", _m_OnHeartBeatReq);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearRecieveMsgQueue", _m_ClearRecieveMsgQueue);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "ReceiveNetworkMsg", _g_get_ReceiveNetworkMsg);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "LauchNetworkCallBack", _g_get_LauchNetworkCallBack);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Max_Message_Num_Per_Frame", _g_get_Max_Message_Num_Per_Frame);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "HeartBeat_Response_Timeout", _g_get_HeartBeat_Response_Timeout);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "HeartBeat_Send_Interval", _g_get_HeartBeat_Send_Interval);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Reconnected_Max_Time_Interval", _g_get_Reconnected_Max_Time_Interval);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "lastHeartTime", _g_get_lastHeartTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "heartBeatResWaitTime", _g_get_heartBeatResWaitTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "heartBeatTimeElapsed", _g_get_heartBeatTimeElapsed);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isWaittingHeartRes", _g_get_isWaittingHeartRes);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "lastConnectedTime", _g_get_lastConnectedTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isReconectedNetwork", _g_get_isReconectedNetwork);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "reconnectedTimeElapsed", _g_get_reconnectedTimeElapsed);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isNetworkOffline", _g_get_isNetworkOffline);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "ReceiveNetworkMsg", _s_set_ReceiveNetworkMsg);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "LauchNetworkCallBack", _s_set_LauchNetworkCallBack);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Max_Message_Num_Per_Frame", _s_set_Max_Message_Num_Per_Frame);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "HeartBeat_Response_Timeout", _s_set_HeartBeat_Response_Timeout);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "HeartBeat_Send_Interval", _s_set_HeartBeat_Send_Interval);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Reconnected_Max_Time_Interval", _s_set_Reconnected_Max_Time_Interval);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "lastHeartTime", _s_set_lastHeartTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "heartBeatResWaitTime", _s_set_heartBeatResWaitTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "heartBeatTimeElapsed", _s_set_heartBeatTimeElapsed);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isWaittingHeartRes", _s_set_isWaittingHeartRes);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "lastConnectedTime", _s_set_lastConnectedTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isReconectedNetwork", _s_set_isReconectedNetwork);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "reconnectedTimeElapsed", _s_set_reconnectedTimeElapsed);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isNetworkOffline", _s_set_isNetworkOffline);
            
			
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
					
					NetworkManager gen_ret = new NetworkManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to NetworkManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnApplicationFocus(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _focusStatus = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.OnApplicationFocus( _focusStatus );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendNetworkMsgLua(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _mainMsgCode = LuaAPI.xlua_tointeger(L, 2);
                    int _subMsgCode = LuaAPI.xlua_tointeger(L, 3);
                    byte[] _msg = LuaAPI.lua_tobytes(L, 4);
                    
                    gen_to_be_invoked.SendNetworkMsgLua( _mainMsgCode, _subMsgCode, _msg );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_NetworkOffline(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.NetworkOffline(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LuaLaunchNetwork(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Net.IPEndPoint _iPEndPoint = (System.Net.IPEndPoint)translator.GetObject(L, 2, typeof(System.Net.IPEndPoint));
                    TcpLcStateNotifyCallBack _tcpStateCallBack = translator.GetDelegate<TcpLcStateNotifyCallBack>(L, 3);
                    
                    gen_to_be_invoked.LuaLaunchNetwork( _iPEndPoint, _tcpStateCallBack );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CloseNetwork(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CloseNetwork(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnHeartBeatReq(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnHeartBeatReq(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearRecieveMsgQueue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearRecieveMsgQueue(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ReceiveNetworkMsg(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.ReceiveNetworkMsg);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_LauchNetworkCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.LauchNetworkCallBack);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Max_Message_Num_Per_Frame(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.Max_Message_Num_Per_Frame);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_HeartBeat_Response_Timeout(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.HeartBeat_Response_Timeout);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_HeartBeat_Send_Interval(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.HeartBeat_Send_Interval);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Reconnected_Max_Time_Interval(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.Reconnected_Max_Time_Interval);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_lastHeartTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.lastHeartTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_heartBeatResWaitTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.heartBeatResWaitTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_heartBeatTimeElapsed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.heartBeatTimeElapsed);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isWaittingHeartRes(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isWaittingHeartRes);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_lastConnectedTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.lastConnectedTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isReconectedNetwork(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isReconectedNetwork);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_reconnectedTimeElapsed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.reconnectedTimeElapsed);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isNetworkOffline(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isNetworkOffline);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ReceiveNetworkMsg(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.ReceiveNetworkMsg = translator.GetDelegate<System.Action<MsgNode>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_LauchNetworkCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.LauchNetworkCallBack = translator.GetDelegate<TcpLcStateNotifyCallBack>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Max_Message_Num_Per_Frame(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Max_Message_Num_Per_Frame = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_HeartBeat_Response_Timeout(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.HeartBeat_Response_Timeout = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_HeartBeat_Send_Interval(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.HeartBeat_Send_Interval = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Reconnected_Max_Time_Interval(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Reconnected_Max_Time_Interval = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_lastHeartTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.lastHeartTime = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_heartBeatResWaitTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.heartBeatResWaitTime = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_heartBeatTimeElapsed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.heartBeatTimeElapsed = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isWaittingHeartRes(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isWaittingHeartRes = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_lastConnectedTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.lastConnectedTime = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isReconectedNetwork(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isReconectedNetwork = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_reconnectedTimeElapsed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.reconnectedTimeElapsed = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isNetworkOffline(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                NetworkManager gen_to_be_invoked = (NetworkManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isNetworkOffline = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
