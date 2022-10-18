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
    public class ResourceBaseWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(ResourceBase);
			Utils.BeginObjectRegister(type, L, translator, 0, 4, 3, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAsset", _m_LoadAsset);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadFromAssetBundle", _m_LoadFromAssetBundle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AsyncLoadFromAssetBundle", _m_AsyncLoadFromAssetBundle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Unload", _m_Unload);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "key", _g_get_key);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "unloadBelongedAssetBundleAfterLoaded", _g_get_unloadBelongedAssetBundleAfterLoaded);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "content", _g_get_content);
            
			
			
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
				if(LuaAPI.lua_gettop(L) == 5 && LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) && (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && translator.Assignable<System.Type>(L, 4) && LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5))
				{
					int _keyHash = LuaAPI.xlua_tointeger(L, 2);
					string _fullPathInResources = LuaAPI.lua_tostring(L, 3);
					System.Type _contentType = (System.Type)translator.GetObject(L, 4, typeof(System.Type));
					bool _unloadBelongedAssetBundleAfterLoaded = LuaAPI.lua_toboolean(L, 5);
					
					ResourceBase gen_ret = new ResourceBase(_keyHash, _fullPathInResources, _contentType, _unloadBelongedAssetBundleAfterLoaded);
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to ResourceBase constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAsset(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceBase gen_to_be_invoked = (ResourceBase)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<System.Action<ResourceBase, float>>(L, 2)) 
                {
                    System.Action<ResourceBase, float> _callback = translator.GetDelegate<System.Action<ResourceBase, float>>(L, 2);
                    
                    gen_to_be_invoked.LoadAsset( _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.LoadAsset(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to ResourceBase.LoadAsset!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadFromAssetBundle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceBase gen_to_be_invoked = (ResourceBase)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    ResourcePackerInfo _resourcePackerInfo = (ResourcePackerInfo)translator.GetObject(L, 2, typeof(ResourcePackerInfo));
                    
                    gen_to_be_invoked.LoadFromAssetBundle( _resourcePackerInfo );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AsyncLoadFromAssetBundle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceBase gen_to_be_invoked = (ResourceBase)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    ResourcePackerInfo _resourcePackerInfo = (ResourcePackerInfo)translator.GetObject(L, 2, typeof(ResourcePackerInfo));
                    System.Action<ResourceBase, float> _callback = translator.GetDelegate<System.Action<ResourceBase, float>>(L, 3);
                    
                        System.Collections.IEnumerator gen_ret = gen_to_be_invoked.AsyncLoadFromAssetBundle( _resourcePackerInfo, _callback );
                        translator.PushAny(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Unload(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceBase gen_to_be_invoked = (ResourceBase)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Unload(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_key(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ResourceBase gen_to_be_invoked = (ResourceBase)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.key);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_unloadBelongedAssetBundleAfterLoaded(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ResourceBase gen_to_be_invoked = (ResourceBase)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.unloadBelongedAssetBundleAfterLoaded);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_content(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ResourceBase gen_to_be_invoked = (ResourceBase)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.content);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
		
		
		
		
    }
}
