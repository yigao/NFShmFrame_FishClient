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
    public class ResourceManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(ResourceManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 9, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCachedResourceMap", _m_GetCachedResourceMap);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CheckCachedResource", _m_CheckCachedResource);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadManifestFile", _m_LoadManifestFile);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetResource", _m_GetResource);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AsyncGetResource", _m_AsyncGetResource);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetResourceBelongedPackerInfo", _m_GetResourceBelongedPackerInfo);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveCachedResource", _m_RemoveCachedResource);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UnloadBelongedAssetBundle", _m_UnloadBelongedAssetBundle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UnloadManifestPackerAssetBundle", _m_UnloadManifestPackerAssetBundle);
			
			
			
			
			
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
					
					ResourceManager gen_ret = new ResourceManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to ResourceManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCachedResourceMap(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        System.Collections.Generic.Dictionary<int, ResourceBase> gen_ret = gen_to_be_invoked.GetCachedResourceMap(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CheckCachedResource(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    
                        bool gen_ret = gen_to_be_invoked.CheckCachedResource( _fullPathInResources );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadManifestFile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.LoadManifestFile( _fullPathInResources );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResource(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Type>(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)) 
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    System.Type _resourceContentType = (System.Type)translator.GetObject(L, 3, typeof(System.Type));
                    bool _needCached = LuaAPI.lua_toboolean(L, 4);
                    bool _unloadBelongedAssetBundleAfterLoaded = LuaAPI.lua_toboolean(L, 5);
                    
                        ResourceBase gen_ret = gen_to_be_invoked.GetResource( _fullPathInResources, _resourceContentType, _needCached, _unloadBelongedAssetBundleAfterLoaded );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Type>(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    System.Type _resourceContentType = (System.Type)translator.GetObject(L, 3, typeof(System.Type));
                    bool _needCached = LuaAPI.lua_toboolean(L, 4);
                    
                        ResourceBase gen_ret = gen_to_be_invoked.GetResource( _fullPathInResources, _resourceContentType, _needCached );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Type>(L, 3)) 
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    System.Type _resourceContentType = (System.Type)translator.GetObject(L, 3, typeof(System.Type));
                    
                        ResourceBase gen_ret = gen_to_be_invoked.GetResource( _fullPathInResources, _resourceContentType );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to ResourceManager.GetResource!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AsyncGetResource(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Type>(L, 3)&& translator.Assignable<System.Action<ResourceBase, float>>(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)) 
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    System.Type _resourceContentType = (System.Type)translator.GetObject(L, 3, typeof(System.Type));
                    System.Action<ResourceBase, float> _callback = translator.GetDelegate<System.Action<ResourceBase, float>>(L, 4);
                    bool _needCached = LuaAPI.lua_toboolean(L, 5);
                    bool _unloadBelongedAssetBundleAfterLoaded = LuaAPI.lua_toboolean(L, 6);
                    
                    gen_to_be_invoked.AsyncGetResource( _fullPathInResources, _resourceContentType, _callback, _needCached, _unloadBelongedAssetBundleAfterLoaded );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Type>(L, 3)&& translator.Assignable<System.Action<ResourceBase, float>>(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)) 
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    System.Type _resourceContentType = (System.Type)translator.GetObject(L, 3, typeof(System.Type));
                    System.Action<ResourceBase, float> _callback = translator.GetDelegate<System.Action<ResourceBase, float>>(L, 4);
                    bool _needCached = LuaAPI.lua_toboolean(L, 5);
                    
                    gen_to_be_invoked.AsyncGetResource( _fullPathInResources, _resourceContentType, _callback, _needCached );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Type>(L, 3)&& translator.Assignable<System.Action<ResourceBase, float>>(L, 4)) 
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    System.Type _resourceContentType = (System.Type)translator.GetObject(L, 3, typeof(System.Type));
                    System.Action<ResourceBase, float> _callback = translator.GetDelegate<System.Action<ResourceBase, float>>(L, 4);
                    
                    gen_to_be_invoked.AsyncGetResource( _fullPathInResources, _resourceContentType, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to ResourceManager.AsyncGetResource!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResourceBelongedPackerInfo(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    
                        ResourcePackerInfo gen_ret = gen_to_be_invoked.GetResourceBelongedPackerInfo( _fullPathInResources );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveCachedResource(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.RemoveCachedResource( _fullPathInResources );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UnloadBelongedAssetBundle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    bool _force = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.UnloadBelongedAssetBundle( _fullPathInResources, _force );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _fullPathInResources = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.UnloadBelongedAssetBundle( _fullPathInResources );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to ResourceManager.UnloadBelongedAssetBundle!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UnloadManifestPackerAssetBundle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ResourceManager gen_to_be_invoked = (ResourceManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string _manifestName = LuaAPI.lua_tostring(L, 2);
                    bool _force = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.UnloadManifestPackerAssetBundle( _manifestName, _force );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _manifestName = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.UnloadManifestPackerAssetBundle( _manifestName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to ResourceManager.UnloadManifestPackerAssetBundle!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
