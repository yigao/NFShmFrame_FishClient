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
    
    public class UnityEngineTextAnchorWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.TextAnchor), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.TextAnchor), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.TextAnchor), L, null, 10, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UpperLeft", UnityEngine.TextAnchor.UpperLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UpperCenter", UnityEngine.TextAnchor.UpperCenter);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UpperRight", UnityEngine.TextAnchor.UpperRight);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MiddleLeft", UnityEngine.TextAnchor.MiddleLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MiddleCenter", UnityEngine.TextAnchor.MiddleCenter);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MiddleRight", UnityEngine.TextAnchor.MiddleRight);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LowerLeft", UnityEngine.TextAnchor.LowerLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LowerCenter", UnityEngine.TextAnchor.LowerCenter);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LowerRight", UnityEngine.TextAnchor.LowerRight);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.TextAnchor), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineTextAnchor(L, (UnityEngine.TextAnchor)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "UpperLeft"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.UpperLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "UpperCenter"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.UpperCenter);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "UpperRight"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.UpperRight);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MiddleLeft"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.MiddleLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MiddleCenter"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.MiddleCenter);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MiddleRight"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.MiddleRight);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "LowerLeft"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.LowerLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "LowerCenter"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.LowerCenter);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "LowerRight"))
                {
                    translator.PushUnityEngineTextAnchor(L, UnityEngine.TextAnchor.LowerRight);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.TextAnchor!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.TextAnchor! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class TcpLcClientNetworkStatusWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(TcpLcClient.NetworkStatus), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(TcpLcClient.NetworkStatus), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(TcpLcClient.NetworkStatus), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E_LC_NETWORK_STATE_IDLE", TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_IDLE);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E_LC_NETWORK_STATE_CONNECTING", TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTING);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E_LC_NETWORK_STATE_CONNECTED", TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTED);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E_LC_NETWORK_STATE_ERROR", TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_ERROR);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E_LC_NETWORK_STATE_LOGIN_FAILED", TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_LOGIN_FAILED);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(TcpLcClient.NetworkStatus), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushTcpLcClientNetworkStatus(L, (TcpLcClient.NetworkStatus)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "E_LC_NETWORK_STATE_IDLE"))
                {
                    translator.PushTcpLcClientNetworkStatus(L, TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_IDLE);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "E_LC_NETWORK_STATE_CONNECTING"))
                {
                    translator.PushTcpLcClientNetworkStatus(L, TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTING);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "E_LC_NETWORK_STATE_CONNECTED"))
                {
                    translator.PushTcpLcClientNetworkStatus(L, TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTED);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "E_LC_NETWORK_STATE_ERROR"))
                {
                    translator.PushTcpLcClientNetworkStatus(L, TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_ERROR);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "E_LC_NETWORK_STATE_LOGIN_FAILED"))
                {
                    translator.PushTcpLcClientNetworkStatus(L, TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_LOGIN_FAILED);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for TcpLcClient.NetworkStatus!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for TcpLcClient.NetworkStatus! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class FishLuaBehaviourFishStatusWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(FishLuaBehaviour.FishStatus), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(FishLuaBehaviour.FishStatus), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(FishLuaBehaviour.FishStatus), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Born", FishLuaBehaviour.FishStatus.Born);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Move", FishLuaBehaviour.FishStatus.Move);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Pause", FishLuaBehaviour.FishStatus.Pause);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Stop", FishLuaBehaviour.FishStatus.Stop);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(FishLuaBehaviour.FishStatus), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushFishLuaBehaviourFishStatus(L, (FishLuaBehaviour.FishStatus)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Born"))
                {
                    translator.PushFishLuaBehaviourFishStatus(L, FishLuaBehaviour.FishStatus.Born);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Move"))
                {
                    translator.PushFishLuaBehaviourFishStatus(L, FishLuaBehaviour.FishStatus.Move);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Pause"))
                {
                    translator.PushFishLuaBehaviourFishStatus(L, FishLuaBehaviour.FishStatus.Pause);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Stop"))
                {
                    translator.PushFishLuaBehaviourFishStatus(L, FishLuaBehaviour.FishStatus.Stop);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for FishLuaBehaviour.FishStatus!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for FishLuaBehaviour.FishStatus! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class GameVersionStatusWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(GameVersionStatus), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(GameVersionStatus), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(GameVersionStatus), L, null, 12, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", GameVersionStatus.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Compare_Version", GameVersionStatus.Compare_Version);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Version_Error", GameVersionStatus.Version_Error);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Wait_Download", GameVersionStatus.Wait_Download);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Downloading", GameVersionStatus.Downloading);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Download_Interrupted", GameVersionStatus.Download_Interrupted);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Downloaded", GameVersionStatus.Downloaded);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Download_Error", GameVersionStatus.Download_Error);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Unzip", GameVersionStatus.Unzip);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Unzip_Error", GameVersionStatus.Unzip_Error);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Complete", GameVersionStatus.Complete);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(GameVersionStatus), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushGameVersionStatus(L, (GameVersionStatus)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Compare_Version"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Compare_Version);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Version_Error"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Version_Error);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Wait_Download"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Wait_Download);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Downloading"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Downloading);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Download_Interrupted"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Download_Interrupted);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Downloaded"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Downloaded);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Download_Error"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Download_Error);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Unzip"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Unzip);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Unzip_Error"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Unzip_Error);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Complete"))
                {
                    translator.PushGameVersionStatus(L, GameVersionStatus.Complete);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for GameVersionStatus!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for GameVersionStatus! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningAutoPlayWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.AutoPlay), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.AutoPlay), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.AutoPlay), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.AutoPlay.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoPlaySequences", DG.Tweening.AutoPlay.AutoPlaySequences);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoPlayTweeners", DG.Tweening.AutoPlay.AutoPlayTweeners);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "All", DG.Tweening.AutoPlay.All);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.AutoPlay), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningAutoPlay(L, (DG.Tweening.AutoPlay)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningAutoPlay(L, DG.Tweening.AutoPlay.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoPlaySequences"))
                {
                    translator.PushDGTweeningAutoPlay(L, DG.Tweening.AutoPlay.AutoPlaySequences);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoPlayTweeners"))
                {
                    translator.PushDGTweeningAutoPlay(L, DG.Tweening.AutoPlay.AutoPlayTweeners);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "All"))
                {
                    translator.PushDGTweeningAutoPlay(L, DG.Tweening.AutoPlay.All);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.AutoPlay!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.AutoPlay! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningAxisConstraintWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.AxisConstraint), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.AxisConstraint), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.AxisConstraint), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.AxisConstraint.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "X", DG.Tweening.AxisConstraint.X);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Y", DG.Tweening.AxisConstraint.Y);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Z", DG.Tweening.AxisConstraint.Z);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "W", DG.Tweening.AxisConstraint.W);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.AxisConstraint), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningAxisConstraint(L, (DG.Tweening.AxisConstraint)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "X"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.X);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Y"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.Y);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Z"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.Z);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "W"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.W);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.AxisConstraint!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.AxisConstraint! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningEaseWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Ease), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Ease), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Ease), L, null, 39, 0, 0);

            Utils.RegisterEnumType(L, typeof(DG.Tweening.Ease));

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Ease), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningEase(L, (DG.Tweening.Ease)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

                try
				{
                    translator.TranslateToEnumToTop(L, typeof(DG.Tweening.Ease), 1);
				}
				catch (System.Exception e)
				{
					return LuaAPI.luaL_error(L, "cast to " + typeof(DG.Tweening.Ease) + " exception:" + e);
				}

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Ease! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningLogBehaviourWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.LogBehaviour), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.LogBehaviour), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.LogBehaviour), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Default", DG.Tweening.LogBehaviour.Default);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Verbose", DG.Tweening.LogBehaviour.Verbose);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ErrorsOnly", DG.Tweening.LogBehaviour.ErrorsOnly);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.LogBehaviour), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningLogBehaviour(L, (DG.Tweening.LogBehaviour)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Default"))
                {
                    translator.PushDGTweeningLogBehaviour(L, DG.Tweening.LogBehaviour.Default);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Verbose"))
                {
                    translator.PushDGTweeningLogBehaviour(L, DG.Tweening.LogBehaviour.Verbose);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ErrorsOnly"))
                {
                    translator.PushDGTweeningLogBehaviour(L, DG.Tweening.LogBehaviour.ErrorsOnly);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.LogBehaviour!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.LogBehaviour! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningLoopTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.LoopType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.LoopType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.LoopType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Restart", DG.Tweening.LoopType.Restart);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Yoyo", DG.Tweening.LoopType.Yoyo);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Incremental", DG.Tweening.LoopType.Incremental);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.LoopType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningLoopType(L, (DG.Tweening.LoopType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Restart"))
                {
                    translator.PushDGTweeningLoopType(L, DG.Tweening.LoopType.Restart);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Yoyo"))
                {
                    translator.PushDGTweeningLoopType(L, DG.Tweening.LoopType.Yoyo);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Incremental"))
                {
                    translator.PushDGTweeningLoopType(L, DG.Tweening.LoopType.Incremental);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.LoopType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.LoopType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningPathModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.PathMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.PathMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.PathMode), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Ignore", DG.Tweening.PathMode.Ignore);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Full3D", DG.Tweening.PathMode.Full3D);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopDown2D", DG.Tweening.PathMode.TopDown2D);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Sidescroller2D", DG.Tweening.PathMode.Sidescroller2D);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.PathMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningPathMode(L, (DG.Tweening.PathMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Ignore"))
                {
                    translator.PushDGTweeningPathMode(L, DG.Tweening.PathMode.Ignore);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Full3D"))
                {
                    translator.PushDGTweeningPathMode(L, DG.Tweening.PathMode.Full3D);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TopDown2D"))
                {
                    translator.PushDGTweeningPathMode(L, DG.Tweening.PathMode.TopDown2D);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Sidescroller2D"))
                {
                    translator.PushDGTweeningPathMode(L, DG.Tweening.PathMode.Sidescroller2D);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.PathMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.PathMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningPathTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.PathType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.PathType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.PathType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Linear", DG.Tweening.PathType.Linear);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CatmullRom", DG.Tweening.PathType.CatmullRom);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CubicBezier", DG.Tweening.PathType.CubicBezier);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.PathType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningPathType(L, (DG.Tweening.PathType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Linear"))
                {
                    translator.PushDGTweeningPathType(L, DG.Tweening.PathType.Linear);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "CatmullRom"))
                {
                    translator.PushDGTweeningPathType(L, DG.Tweening.PathType.CatmullRom);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "CubicBezier"))
                {
                    translator.PushDGTweeningPathType(L, DG.Tweening.PathType.CubicBezier);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.PathType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.PathType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningRotateModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.RotateMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.RotateMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.RotateMode), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Fast", DG.Tweening.RotateMode.Fast);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FastBeyond360", DG.Tweening.RotateMode.FastBeyond360);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldAxisAdd", DG.Tweening.RotateMode.WorldAxisAdd);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LocalAxisAdd", DG.Tweening.RotateMode.LocalAxisAdd);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.RotateMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningRotateMode(L, (DG.Tweening.RotateMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Fast"))
                {
                    translator.PushDGTweeningRotateMode(L, DG.Tweening.RotateMode.Fast);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "FastBeyond360"))
                {
                    translator.PushDGTweeningRotateMode(L, DG.Tweening.RotateMode.FastBeyond360);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "WorldAxisAdd"))
                {
                    translator.PushDGTweeningRotateMode(L, DG.Tweening.RotateMode.WorldAxisAdd);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "LocalAxisAdd"))
                {
                    translator.PushDGTweeningRotateMode(L, DG.Tweening.RotateMode.LocalAxisAdd);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.RotateMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.RotateMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningScrambleModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.ScrambleMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.ScrambleMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.ScrambleMode), L, null, 7, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.ScrambleMode.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "All", DG.Tweening.ScrambleMode.All);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Uppercase", DG.Tweening.ScrambleMode.Uppercase);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Lowercase", DG.Tweening.ScrambleMode.Lowercase);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Numerals", DG.Tweening.ScrambleMode.Numerals);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Custom", DG.Tweening.ScrambleMode.Custom);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.ScrambleMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningScrambleMode(L, (DG.Tweening.ScrambleMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "All"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.All);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Uppercase"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.Uppercase);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Lowercase"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.Lowercase);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Numerals"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.Numerals);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Custom"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.Custom);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.ScrambleMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.ScrambleMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningTweenTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.TweenType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.TweenType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.TweenType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Tweener", DG.Tweening.TweenType.Tweener);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Sequence", DG.Tweening.TweenType.Sequence);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Callback", DG.Tweening.TweenType.Callback);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.TweenType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningTweenType(L, (DG.Tweening.TweenType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Tweener"))
                {
                    translator.PushDGTweeningTweenType(L, DG.Tweening.TweenType.Tweener);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Sequence"))
                {
                    translator.PushDGTweeningTweenType(L, DG.Tweening.TweenType.Sequence);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Callback"))
                {
                    translator.PushDGTweeningTweenType(L, DG.Tweening.TweenType.Callback);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.TweenType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.TweenType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningUpdateTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.UpdateType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.UpdateType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.UpdateType), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Normal", DG.Tweening.UpdateType.Normal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Late", DG.Tweening.UpdateType.Late);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Fixed", DG.Tweening.UpdateType.Fixed);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Manual", DG.Tweening.UpdateType.Manual);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.UpdateType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningUpdateType(L, (DG.Tweening.UpdateType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Normal"))
                {
                    translator.PushDGTweeningUpdateType(L, DG.Tweening.UpdateType.Normal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Late"))
                {
                    translator.PushDGTweeningUpdateType(L, DG.Tweening.UpdateType.Late);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Fixed"))
                {
                    translator.PushDGTweeningUpdateType(L, DG.Tweening.UpdateType.Fixed);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Manual"))
                {
                    translator.PushDGTweeningUpdateType(L, DG.Tweening.UpdateType.Manual);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.UpdateType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.UpdateType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
}