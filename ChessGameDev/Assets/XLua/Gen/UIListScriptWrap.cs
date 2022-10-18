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
    public class UIListScriptWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UIListScript);
			Utils.BeginObjectRegister(type, L, translator, 0, 21, 19, 19);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Initialize", _m_Initialize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetExternalElementPrefab", _m_SetExternalElementPrefab);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetElementAmount", _m_SetElementAmount);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SelectElement", _m_SelectElement);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetElementAmount", _m_GetElementAmount);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetElemenet", _m_GetElemenet);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSelectedElement", _m_GetSelectedElement);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLastSelectedElement", _m_GetLastSelectedElement);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetEelementDefaultSize", _m_GetEelementDefaultSize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSelectedIndex", _m_GetSelectedIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLastSelectedIndex", _m_GetLastSelectedIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsElementInScrollArea", _m_IsElementInScrollArea);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetContentSize", _m_GetContentSize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetScrollAreaSize", _m_GetScrollAreaSize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetContentPosition", _m_GetContentPosition);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsNeedScroll", _m_IsNeedScroll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResetContentPosition", _m_ResetContentPosition);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "MoveElementInScrollArea", _m_MoveElementInScrollArea);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsSelectedIndex", _m_IsSelectedIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "MoveContent", _m_MoveContent);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddElement", _m_AddElement);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "listType", _g_get_listType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "elementAmount", _g_get_elementAmount);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "elementSpacing", _g_get_elementSpacing);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "elementLayoutOffset", _g_get_elementLayoutOffset);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "autoInstantiateElement", _g_get_autoInstantiateElement);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "autoCenteredElements", _g_get_autoCenteredElements);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "autoCenteredBothSides", _g_get_autoCenteredBothSides);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "InstantiateElementCallback", _g_get_InstantiateElementCallback);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "scrollRect", _g_get_scrollRect);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "scrollAreaSize", _g_get_scrollAreaSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isInstantiateElementComplete", _g_get_isInstantiateElementComplete);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "useOptimized", _g_get_useOptimized);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "useExternalElement", _g_get_useExternalElement);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "externalElementPrefabPath", _g_get_externalElementPrefabPath);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "autoAdjustScrollAreaSize", _g_get_autoAdjustScrollAreaSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "scrollRectAreaMaxSize", _g_get_scrollRectAreaMaxSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "scrollExternal", _g_get_scrollExternal);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isDisableScrollRect", _g_get_isDisableScrollRect);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "fSpeed", _g_get_fSpeed);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "listType", _s_set_listType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "elementAmount", _s_set_elementAmount);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "elementSpacing", _s_set_elementSpacing);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "elementLayoutOffset", _s_set_elementLayoutOffset);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "autoInstantiateElement", _s_set_autoInstantiateElement);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "autoCenteredElements", _s_set_autoCenteredElements);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "autoCenteredBothSides", _s_set_autoCenteredBothSides);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "InstantiateElementCallback", _s_set_InstantiateElementCallback);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "scrollRect", _s_set_scrollRect);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "scrollAreaSize", _s_set_scrollAreaSize);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isInstantiateElementComplete", _s_set_isInstantiateElementComplete);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "useOptimized", _s_set_useOptimized);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "useExternalElement", _s_set_useExternalElement);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "externalElementPrefabPath", _s_set_externalElementPrefabPath);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "autoAdjustScrollAreaSize", _s_set_autoAdjustScrollAreaSize);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "scrollRectAreaMaxSize", _s_set_scrollRectAreaMaxSize);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "scrollExternal", _s_set_scrollExternal);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isDisableScrollRect", _s_set_isDisableScrollRect);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "fSpeed", _s_set_fSpeed);
            
			
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
					
					UIListScript gen_ret = new UIListScript();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UIListScript constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Initialize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UIFormScript _formScript = (UIFormScript)translator.GetObject(L, 2, typeof(UIFormScript));
                    
                    gen_to_be_invoked.Initialize( _formScript );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetExternalElementPrefab(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _externalElmtPrefPath = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.SetExternalElementPrefab( _externalElmtPrefPath );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetElementAmount(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _amount = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetElementAmount( _amount );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<System.Collections.Generic.List<UnityEngine.Vector2>>(L, 3)) 
                {
                    int _amount = LuaAPI.xlua_tointeger(L, 2);
                    System.Collections.Generic.List<UnityEngine.Vector2> _elementsSize = (System.Collections.Generic.List<UnityEngine.Vector2>)translator.GetObject(L, 3, typeof(System.Collections.Generic.List<UnityEngine.Vector2>));
                    
                    gen_to_be_invoked.SetElementAmount( _amount, _elementsSize );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIListScript.SetElementAmount!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SelectElement(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SelectElement( _index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetElementAmount(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        int gen_ret = gen_to_be_invoked.GetElementAmount(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetElemenet(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        UIListElementScript gen_ret = gen_to_be_invoked.GetElemenet( _index );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSelectedElement(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UIListElementScript gen_ret = gen_to_be_invoked.GetSelectedElement(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLastSelectedElement(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UIListElementScript gen_ret = gen_to_be_invoked.GetLastSelectedElement(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetEelementDefaultSize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.Vector2 gen_ret = gen_to_be_invoked.GetEelementDefaultSize(  );
                        translator.PushUnityEngineVector2(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSelectedIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        int gen_ret = gen_to_be_invoked.GetSelectedIndex(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLastSelectedIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        int gen_ret = gen_to_be_invoked.GetLastSelectedIndex(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsElementInScrollArea(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool gen_ret = gen_to_be_invoked.IsElementInScrollArea( _index );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetContentSize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.Vector2 gen_ret = gen_to_be_invoked.GetContentSize(  );
                        translator.PushUnityEngineVector2(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetScrollAreaSize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.Vector2 gen_ret = gen_to_be_invoked.GetScrollAreaSize(  );
                        translator.PushUnityEngineVector2(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetContentPosition(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.Vector2 gen_ret = gen_to_be_invoked.GetContentPosition(  );
                        translator.PushUnityEngineVector2(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsNeedScroll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsNeedScroll(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResetContentPosition(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ResetContentPosition(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_MoveElementInScrollArea(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    bool _moveImmediately = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.MoveElementInScrollArea( _index, _moveImmediately );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsSelectedIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool gen_ret = gen_to_be_invoked.IsSelectedIndex( _index );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_MoveContent(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2 _offset;translator.Get(L, 2, out _offset);
                    
                    gen_to_be_invoked.MoveContent( _offset );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddElement(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        UIListElementScript gen_ret = gen_to_be_invoked.AddElement( _index );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_listType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.listType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_elementAmount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.elementAmount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_elementSpacing(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.elementSpacing);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_elementLayoutOffset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.elementLayoutOffset);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_autoInstantiateElement(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.autoInstantiateElement);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_autoCenteredElements(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.autoCenteredElements);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_autoCenteredBothSides(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.autoCenteredBothSides);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_InstantiateElementCallback(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.InstantiateElementCallback);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_scrollRect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.scrollRect);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_scrollAreaSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.scrollAreaSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isInstantiateElementComplete(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isInstantiateElementComplete);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_useOptimized(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.useOptimized);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_useExternalElement(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.useExternalElement);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_externalElementPrefabPath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.externalElementPrefabPath);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_autoAdjustScrollAreaSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.autoAdjustScrollAreaSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_scrollRectAreaMaxSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.scrollRectAreaMaxSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_scrollExternal(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.scrollExternal);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isDisableScrollRect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isDisableScrollRect);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fSpeed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.fSpeed);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_listType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                enUIListType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.listType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_elementAmount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.elementAmount = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_elementSpacing(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.elementSpacing = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_elementLayoutOffset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.elementLayoutOffset = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_autoInstantiateElement(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.autoInstantiateElement = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_autoCenteredElements(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.autoCenteredElements = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_autoCenteredBothSides(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.autoCenteredBothSides = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_InstantiateElementCallback(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.InstantiateElementCallback = translator.GetDelegate<System.Action<UnityEngine.GameObject>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_scrollRect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.scrollRect = (UnityEngine.UI.ScrollRect)translator.GetObject(L, 2, typeof(UnityEngine.UI.ScrollRect));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_scrollAreaSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.scrollAreaSize = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isInstantiateElementComplete(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isInstantiateElementComplete = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_useOptimized(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.useOptimized = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_useExternalElement(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.useExternalElement = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_externalElementPrefabPath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.externalElementPrefabPath = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_autoAdjustScrollAreaSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.autoAdjustScrollAreaSize = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_scrollRectAreaMaxSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.scrollRectAreaMaxSize = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_scrollExternal(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.scrollExternal = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isDisableScrollRect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isDisableScrollRect = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fSpeed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListScript gen_to_be_invoked = (UIListScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.fSpeed = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
