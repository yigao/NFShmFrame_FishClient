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
    public class SpineAnimationStateWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(Spine.AnimationState);
			Utils.BeginObjectRegister(type, L, translator, 0, 17, 3, 1);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Update", _m_Update);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Apply", _m_Apply);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearTracks", _m_ClearTracks);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearTrack", _m_ClearTrack);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetAnimation", _m_SetAnimation);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddAnimation", _m_AddAnimation);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetEmptyAnimation", _m_SetEmptyAnimation);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddEmptyAnimation", _m_AddEmptyAnimation);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetEmptyAnimations", _m_SetEmptyAnimations);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCurrent", _m_GetCurrent);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ToString", _m_ToString);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Start", _e_Start);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Interrupt", _e_Interrupt);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "End", _e_End);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Dispose", _e_Dispose);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Complete", _e_Complete);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Event", _e_Event);
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "Data", _g_get_Data);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Tracks", _g_get_Tracks);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "TimeScale", _g_get_TimeScale);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "TimeScale", _s_set_TimeScale);
            
			
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
				if(LuaAPI.lua_gettop(L) == 2 && translator.Assignable<Spine.AnimationStateData>(L, 2))
				{
					Spine.AnimationStateData _data = (Spine.AnimationStateData)translator.GetObject(L, 2, typeof(Spine.AnimationStateData));
					
					Spine.AnimationState gen_ret = new Spine.AnimationState(_data);
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Update(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _delta = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.Update( _delta );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Apply(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Spine.Skeleton _skeleton = (Spine.Skeleton)translator.GetObject(L, 2, typeof(Spine.Skeleton));
                    
                        bool gen_ret = gen_to_be_invoked.Apply( _skeleton );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearTracks(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearTracks(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearTrack(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _trackIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.ClearTrack( _trackIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetAnimation(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    int _trackIndex = LuaAPI.xlua_tointeger(L, 2);
                    string _animationName = LuaAPI.lua_tostring(L, 3);
                    bool _loop = LuaAPI.lua_toboolean(L, 4);
                    
                        Spine.TrackEntry gen_ret = gen_to_be_invoked.SetAnimation( _trackIndex, _animationName, _loop );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<Spine.Animation>(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    int _trackIndex = LuaAPI.xlua_tointeger(L, 2);
                    Spine.Animation _animation = (Spine.Animation)translator.GetObject(L, 3, typeof(Spine.Animation));
                    bool _loop = LuaAPI.lua_toboolean(L, 4);
                    
                        Spine.TrackEntry gen_ret = gen_to_be_invoked.SetAnimation( _trackIndex, _animation, _loop );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState.SetAnimation!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddAnimation(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    int _trackIndex = LuaAPI.xlua_tointeger(L, 2);
                    string _animationName = LuaAPI.lua_tostring(L, 3);
                    bool _loop = LuaAPI.lua_toboolean(L, 4);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 5);
                    
                        Spine.TrackEntry gen_ret = gen_to_be_invoked.AddAnimation( _trackIndex, _animationName, _loop, _delay );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<Spine.Animation>(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    int _trackIndex = LuaAPI.xlua_tointeger(L, 2);
                    Spine.Animation _animation = (Spine.Animation)translator.GetObject(L, 3, typeof(Spine.Animation));
                    bool _loop = LuaAPI.lua_toboolean(L, 4);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 5);
                    
                        Spine.TrackEntry gen_ret = gen_to_be_invoked.AddAnimation( _trackIndex, _animation, _loop, _delay );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState.AddAnimation!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetEmptyAnimation(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _trackIndex = LuaAPI.xlua_tointeger(L, 2);
                    float _mixDuration = (float)LuaAPI.lua_tonumber(L, 3);
                    
                        Spine.TrackEntry gen_ret = gen_to_be_invoked.SetEmptyAnimation( _trackIndex, _mixDuration );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddEmptyAnimation(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _trackIndex = LuaAPI.xlua_tointeger(L, 2);
                    float _mixDuration = (float)LuaAPI.lua_tonumber(L, 3);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        Spine.TrackEntry gen_ret = gen_to_be_invoked.AddEmptyAnimation( _trackIndex, _mixDuration, _delay );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetEmptyAnimations(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _mixDuration = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetEmptyAnimations( _mixDuration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCurrent(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _trackIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        Spine.TrackEntry gen_ret = gen_to_be_invoked.GetCurrent( _trackIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ToString(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        string gen_ret = gen_to_be_invoked.ToString(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Data(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.Data);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Tracks(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.Tracks);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TimeScale(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.TimeScale);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_TimeScale(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.TimeScale = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_Start(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                Spine.AnimationState.TrackEntryDelegate gen_delegate = translator.GetDelegate<Spine.AnimationState.TrackEntryDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.AnimationState.TrackEntryDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.Start += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.Start -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState.Start!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_Interrupt(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                Spine.AnimationState.TrackEntryDelegate gen_delegate = translator.GetDelegate<Spine.AnimationState.TrackEntryDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.AnimationState.TrackEntryDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.Interrupt += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.Interrupt -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState.Interrupt!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_End(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                Spine.AnimationState.TrackEntryDelegate gen_delegate = translator.GetDelegate<Spine.AnimationState.TrackEntryDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.AnimationState.TrackEntryDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.End += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.End -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState.End!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_Dispose(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                Spine.AnimationState.TrackEntryDelegate gen_delegate = translator.GetDelegate<Spine.AnimationState.TrackEntryDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.AnimationState.TrackEntryDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.Dispose += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.Dispose -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState.Dispose!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_Complete(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                Spine.AnimationState.TrackEntryDelegate gen_delegate = translator.GetDelegate<Spine.AnimationState.TrackEntryDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.AnimationState.TrackEntryDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.Complete += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.Complete -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState.Complete!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_Event(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.AnimationState gen_to_be_invoked = (Spine.AnimationState)translator.FastGetCSObj(L, 1);
                Spine.AnimationState.TrackEntryEventDelegate gen_delegate = translator.GetDelegate<Spine.AnimationState.TrackEntryEventDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.AnimationState.TrackEntryEventDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.Event += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.Event -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.AnimationState.Event!");
            return 0;
        }
        
		
		
    }
}
