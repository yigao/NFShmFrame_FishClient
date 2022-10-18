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
    public class SpineUnitySkeletonAnimationWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(Spine.Unity.SkeletonAnimation);
			Utils.BeginObjectRegister(type, L, translator, 0, 6, 5, 4);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearState", _m_ClearState);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Initialize", _m_Initialize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Update", _m_Update);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateLocal", _e_UpdateLocal);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateWorld", _e_UpdateWorld);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateComplete", _e_UpdateComplete);
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "AnimationState", _g_get_AnimationState);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "AnimationName", _g_get_AnimationName);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "state", _g_get_state);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "loop", _g_get_loop);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "timeScale", _g_get_timeScale);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "AnimationName", _s_set_AnimationName);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "state", _s_set_state);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "loop", _s_set_loop);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "timeScale", _s_set_timeScale);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "AddToGameObject", _m_AddToGameObject_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "NewSkeletonAnimationGameObject", _m_NewSkeletonAnimationGameObject_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					Spine.Unity.SkeletonAnimation gen_ret = new Spine.Unity.SkeletonAnimation();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonAnimation constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddToGameObject_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.GameObject _gameObject = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    Spine.Unity.SkeletonDataAsset _skeletonDataAsset = (Spine.Unity.SkeletonDataAsset)translator.GetObject(L, 2, typeof(Spine.Unity.SkeletonDataAsset));
                    
                        Spine.Unity.SkeletonAnimation gen_ret = Spine.Unity.SkeletonAnimation.AddToGameObject( _gameObject, _skeletonDataAsset );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_NewSkeletonAnimationGameObject_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    Spine.Unity.SkeletonDataAsset _skeletonDataAsset = (Spine.Unity.SkeletonDataAsset)translator.GetObject(L, 1, typeof(Spine.Unity.SkeletonDataAsset));
                    
                        Spine.Unity.SkeletonAnimation gen_ret = Spine.Unity.SkeletonAnimation.NewSkeletonAnimationGameObject( _skeletonDataAsset );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearState(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearState(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Initialize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _overwrite = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.Initialize( _overwrite );
                    
                    
                    
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
            
            
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _deltaTime = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.Update( _deltaTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_AnimationState(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.AnimationState);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_AnimationName(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.AnimationName);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_state(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.state);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_loop(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.loop);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_timeScale(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.timeScale);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_AnimationName(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.AnimationName = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_state(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.state = (Spine.AnimationState)translator.GetObject(L, 2, typeof(Spine.AnimationState));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_loop(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.loop = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_timeScale(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.timeScale = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_UpdateLocal(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                Spine.Unity.UpdateBonesDelegate gen_delegate = translator.GetDelegate<Spine.Unity.UpdateBonesDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.Unity.UpdateBonesDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.UpdateLocal += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.UpdateLocal -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonAnimation.UpdateLocal!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_UpdateWorld(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                Spine.Unity.UpdateBonesDelegate gen_delegate = translator.GetDelegate<Spine.Unity.UpdateBonesDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.Unity.UpdateBonesDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.UpdateWorld += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.UpdateWorld -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonAnimation.UpdateWorld!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_UpdateComplete(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.Unity.SkeletonAnimation gen_to_be_invoked = (Spine.Unity.SkeletonAnimation)translator.FastGetCSObj(L, 1);
                Spine.Unity.UpdateBonesDelegate gen_delegate = translator.GetDelegate<Spine.Unity.UpdateBonesDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.Unity.UpdateBonesDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.UpdateComplete += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.UpdateComplete -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonAnimation.UpdateComplete!");
            return 0;
        }
        
		
		
    }
}
