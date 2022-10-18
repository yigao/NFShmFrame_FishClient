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
    public class TcpLcClientWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(TcpLcClient);
			Utils.BeginObjectRegister(type, L, translator, 0, 12, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetStateCB", _m_SetStateCB);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "getLcClient", _m_getLcClient);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "getSendMsgQueueLen", _m_getSendMsgQueueLen);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "getRecvMsgQueueLen", _m_getRecvMsgQueueLen);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearRecvmsgQueue", _m_ClearRecvmsgQueue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WriteSendMsgQueue", _m_WriteSendMsgQueue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ReadSendMsgQueue", _m_ReadSendMsgQueue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WriteRecvMsgQueue", _m_WriteRecvMsgQueue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ReadRecvMsgQueue", _m_ReadRecvMsgQueue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ConnectProc", _m_ConnectProc);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Connect", _m_Connect);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ForceToClose", _m_ForceToClose);
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 2, 2);
			
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "NetEncodeKey", _g_get_NetEncodeKey);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "NetCheckCode", _g_get_NetCheckCode);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "NetEncodeKey", _s_set_NetEncodeKey);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "NetCheckCode", _s_set_NetCheckCode);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					TcpLcClient gen_ret = new TcpLcClient();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to TcpLcClient constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetStateCB(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    TcpLcClient.NetworkStateCB _cb = (TcpLcClient.NetworkStateCB)translator.GetObject(L, 2, typeof(TcpLcClient.NetworkStateCB));
                    
                    gen_to_be_invoked.SetStateCB( _cb );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_getLcClient(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        System.Net.Sockets.TcpClient gen_ret = gen_to_be_invoked.getLcClient(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_getSendMsgQueueLen(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        int gen_ret = gen_to_be_invoked.getSendMsgQueueLen(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_getRecvMsgQueueLen(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        int gen_ret = gen_to_be_invoked.getRecvMsgQueueLen(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearRecvmsgQueue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearRecvmsgQueue(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WriteSendMsgQueue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<MsgNode>(L, 2)) 
                {
                    MsgNode _node = (MsgNode)translator.GetObject(L, 2, typeof(MsgNode));
                    
                    gen_to_be_invoked.WriteSendMsgQueue( _node );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& (LuaAPI.lua_isnil(L, 5) || LuaAPI.lua_type(L, 5) == LuaTypes.LUA_TSTRING)) 
                {
                    short _mainMsgID = (short)LuaAPI.xlua_tointeger(L, 2);
                    short _subMsgID = (short)LuaAPI.xlua_tointeger(L, 3);
                    int _protobufLen = LuaAPI.xlua_tointeger(L, 4);
                    byte[] _msg = LuaAPI.lua_tobytes(L, 5);
                    
                    gen_to_be_invoked.WriteSendMsgQueue( _mainMsgID, _subMsgID, _protobufLen, _msg );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TcpLcClient.WriteSendMsgQueue!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReadSendMsgQueue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        MsgNode gen_ret = gen_to_be_invoked.ReadSendMsgQueue(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WriteRecvMsgQueue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<MsgNode>(L, 2)) 
                {
                    MsgNode _node = (MsgNode)translator.GetObject(L, 2, typeof(MsgNode));
                    
                    gen_to_be_invoked.WriteRecvMsgQueue( _node );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& translator.Assignable<char[]>(L, 6)&& (LuaAPI.lua_isnil(L, 7) || LuaAPI.lua_type(L, 7) == LuaTypes.LUA_TSTRING)) 
                {
                    short _mainMsgID = (short)LuaAPI.xlua_tointeger(L, 2);
                    short _subMsgID = (short)LuaAPI.xlua_tointeger(L, 3);
                    int _protobufLen = LuaAPI.xlua_tointeger(L, 4);
                    short _reserved = (short)LuaAPI.xlua_tointeger(L, 5);
                    char[] _head = (char[])translator.GetObject(L, 6, typeof(char[]));
                    byte[] _msg = LuaAPI.lua_tobytes(L, 7);
                    
                    gen_to_be_invoked.WriteRecvMsgQueue( _mainMsgID, _subMsgID, _protobufLen, _reserved, _head, _msg );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TcpLcClient.WriteRecvMsgQueue!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReadRecvMsgQueue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        MsgNode gen_ret = gen_to_be_invoked.ReadRecvMsgQueue(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ConnectProc(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ConnectProc(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Connect(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Net.IPEndPoint _iPEndPoint = (System.Net.IPEndPoint)translator.GetObject(L, 2, typeof(System.Net.IPEndPoint));
                    
                    gen_to_be_invoked.Connect( _iPEndPoint );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ForceToClose(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TcpLcClient gen_to_be_invoked = (TcpLcClient)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ForceToClose(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_NetEncodeKey(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushstring(L, TcpLcClient.NetEncodeKey);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_NetCheckCode(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.xlua_pushinteger(L, TcpLcClient.NetCheckCode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_NetEncodeKey(RealStatePtr L)
        {
		    try {
                
			    TcpLcClient.NetEncodeKey = LuaAPI.lua_tobytes(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_NetCheckCode(RealStatePtr L)
        {
		    try {
                
			    TcpLcClient.NetCheckCode = (short)LuaAPI.xlua_tointeger(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
