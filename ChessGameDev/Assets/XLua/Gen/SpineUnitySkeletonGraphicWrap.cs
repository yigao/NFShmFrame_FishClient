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
    public class SpineUnitySkeletonGraphicWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(Spine.Unity.SkeletonGraphic);
			Utils.BeginObjectRegister(type, L, translator, 0, 11, 17, 10);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Rebuild", _m_Rebuild);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Update", _m_Update);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LateUpdate", _m_LateUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLastMesh", _m_GetLastMesh);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Clear", _m_Clear);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Initialize", _m_Initialize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateMesh", _m_UpdateMesh);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateLocal", _e_UpdateLocal);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateWorld", _e_UpdateWorld);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateComplete", _e_UpdateComplete);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnPostProcessVertices", _e_OnPostProcessVertices);
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "SkeletonDataAsset", _g_get_SkeletonDataAsset);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OverrideTexture", _g_get_OverrideTexture);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mainTexture", _g_get_mainTexture);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Skeleton", _g_get_Skeleton);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "SkeletonData", _g_get_SkeletonData);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsValid", _g_get_IsValid);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "AnimationState", _g_get_AnimationState);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "MeshGenerator", _g_get_MeshGenerator);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "skeletonDataAsset", _g_get_skeletonDataAsset);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "initialSkinName", _g_get_initialSkinName);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "initialFlipX", _g_get_initialFlipX);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "initialFlipY", _g_get_initialFlipY);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "startingAnimation", _g_get_startingAnimation);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "startingLoop", _g_get_startingLoop);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "timeScale", _g_get_timeScale);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "freeze", _g_get_freeze);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "unscaledTime", _g_get_unscaledTime);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "OverrideTexture", _s_set_OverrideTexture);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "skeletonDataAsset", _s_set_skeletonDataAsset);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "initialSkinName", _s_set_initialSkinName);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "initialFlipX", _s_set_initialFlipX);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "initialFlipY", _s_set_initialFlipY);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "startingAnimation", _s_set_startingAnimation);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "startingLoop", _s_set_startingLoop);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "timeScale", _s_set_timeScale);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "freeze", _s_set_freeze);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "unscaledTime", _s_set_unscaledTime);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "NewSkeletonGraphicGameObject", _m_NewSkeletonGraphicGameObject_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AddSkeletonGraphicComponent", _m_AddSkeletonGraphicComponent_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					Spine.Unity.SkeletonGraphic gen_ret = new Spine.Unity.SkeletonGraphic();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonGraphic constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_NewSkeletonGraphicGameObject_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    Spine.Unity.SkeletonDataAsset _skeletonDataAsset = (Spine.Unity.SkeletonDataAsset)translator.GetObject(L, 1, typeof(Spine.Unity.SkeletonDataAsset));
                    UnityEngine.Transform _parent = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    
                        Spine.Unity.SkeletonGraphic gen_ret = Spine.Unity.SkeletonGraphic.NewSkeletonGraphicGameObject( _skeletonDataAsset, _parent );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddSkeletonGraphicComponent_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.GameObject _gameObject = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    Spine.Unity.SkeletonDataAsset _skeletonDataAsset = (Spine.Unity.SkeletonDataAsset)translator.GetObject(L, 2, typeof(Spine.Unity.SkeletonDataAsset));
                    
                        Spine.Unity.SkeletonGraphic gen_ret = Spine.Unity.SkeletonGraphic.AddSkeletonGraphicComponent( _gameObject, _skeletonDataAsset );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Rebuild(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.UI.CanvasUpdate _update;translator.Get(L, 2, out _update);
                    
                    gen_to_be_invoked.Rebuild( _update );
                    
                    
                    
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
            
            
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.Update(  );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _deltaTime = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.Update( _deltaTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonGraphic.Update!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LateUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.LateUpdate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLastMesh(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.Mesh gen_ret = gen_to_be_invoked.GetLastMesh(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Clear(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Clear(  );
                    
                    
                    
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
            
            
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
            
            
                
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
        static int _m_UpdateMesh(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UpdateMesh(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_SkeletonDataAsset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.SkeletonDataAsset);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OverrideTexture(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OverrideTexture);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mainTexture(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.mainTexture);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Skeleton(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.Skeleton);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_SkeletonData(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.SkeletonData);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsValid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsValid);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_AnimationState(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.AnimationState);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_MeshGenerator(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.MeshGenerator);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_skeletonDataAsset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.skeletonDataAsset);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_initialSkinName(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.initialSkinName);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_initialFlipX(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.initialFlipX);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_initialFlipY(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.initialFlipY);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_startingAnimation(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.startingAnimation);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_startingLoop(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.startingLoop);
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
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.timeScale);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_freeze(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.freeze);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_unscaledTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.unscaledTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OverrideTexture(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OverrideTexture = (UnityEngine.Texture)translator.GetObject(L, 2, typeof(UnityEngine.Texture));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_skeletonDataAsset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.skeletonDataAsset = (Spine.Unity.SkeletonDataAsset)translator.GetObject(L, 2, typeof(Spine.Unity.SkeletonDataAsset));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_initialSkinName(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.initialSkinName = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_initialFlipX(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.initialFlipX = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_initialFlipY(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.initialFlipY = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_startingAnimation(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.startingAnimation = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_startingLoop(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.startingLoop = LuaAPI.lua_toboolean(L, 2);
            
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
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.timeScale = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_freeze(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.freeze = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_unscaledTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.unscaledTime = LuaAPI.lua_toboolean(L, 2);
            
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
			Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
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
			LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonGraphic.UpdateLocal!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_UpdateWorld(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
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
			LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonGraphic.UpdateWorld!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_UpdateComplete(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
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
			LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonGraphic.UpdateComplete!");
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_OnPostProcessVertices(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			Spine.Unity.SkeletonGraphic gen_to_be_invoked = (Spine.Unity.SkeletonGraphic)translator.FastGetCSObj(L, 1);
                Spine.Unity.MeshGeneratorDelegate gen_delegate = translator.GetDelegate<Spine.Unity.MeshGeneratorDelegate>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need Spine.Unity.MeshGeneratorDelegate!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.OnPostProcessVertices += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.OnPostProcessVertices -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to Spine.Unity.SkeletonGraphic.OnPostProcessVertices!");
            return 0;
        }
        
		
		
    }
}
