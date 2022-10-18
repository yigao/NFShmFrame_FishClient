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
    public class UIListElementScriptWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UIListElementScript);
			Utils.BeginObjectRegister(type, L, translator, 0, 7, 7, 7);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Initialize", _m_Initialize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Enable", _m_Enable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Disable", _m_Disable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnSelected", _m_OnSelected);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ChangeDisplay", _m_ChangeDisplay);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetComponentBelongedList", _m_SetComponentBelongedList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetRect", _m_SetRect);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_defaultSize", _g_get_m_defaultSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_index", _g_get_m_index);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_pivotType", _g_get_m_pivotType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnEnableElement", _g_get_OnEnableElement);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_rect", _g_get_m_rect);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_useSetActiveForDisplay", _g_get_m_useSetActiveForDisplay);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onSelected", _g_get_onSelected);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_defaultSize", _s_set_m_defaultSize);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_index", _s_set_m_index);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_pivotType", _s_set_m_pivotType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnEnableElement", _s_set_OnEnableElement);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_rect", _s_set_m_rect);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_useSetActiveForDisplay", _s_set_m_useSetActiveForDisplay);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "onSelected", _s_set_onSelected);
            
			
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
					
					UIListElementScript gen_ret = new UIListElementScript();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UIListElementScript constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Initialize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
            
            
                
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
        static int _m_Enable(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UIListScript _belongedList = (UIListScript)translator.GetObject(L, 2, typeof(UIListScript));
                    int _index = LuaAPI.xlua_tointeger(L, 3);
                    string _name = LuaAPI.lua_tostring(L, 4);
                    stRect _rect;translator.Get(L, 5, out _rect);
                    bool _selected = LuaAPI.lua_toboolean(L, 6);
                    
                    gen_to_be_invoked.Enable( _belongedList, _index, _name, ref _rect, _selected );
                    translator.Push(L, _rect);
                        translator.Update(L, 5, _rect);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Disable(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Disable(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnSelected(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.BaseEventData _baseEventData = (UnityEngine.EventSystems.BaseEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.BaseEventData));
                    
                    gen_to_be_invoked.OnSelected( _baseEventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeDisplay(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _selected = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.ChangeDisplay( _selected );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetComponentBelongedList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _gameObject = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.SetComponentBelongedList( _gameObject );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetRect(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    stRect _rect;translator.Get(L, 2, out _rect);
                    
                    gen_to_be_invoked.SetRect( ref _rect );
                    translator.Push(L, _rect);
                        translator.Update(L, 2, _rect);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_defaultSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.m_defaultSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_index(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.m_index);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_pivotType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_pivotType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnEnableElement(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnEnableElement);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_rect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_rect);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_useSetActiveForDisplay(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.m_useSetActiveForDisplay);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onSelected(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.onSelected);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_defaultSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.m_defaultSize = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_index(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_index = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_pivotType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                enPivotType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.m_pivotType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnEnableElement(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnEnableElement = translator.GetDelegate<System.Action<int>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_rect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                stRect gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.m_rect = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_useSetActiveForDisplay(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_useSetActiveForDisplay = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_onSelected(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIListElementScript gen_to_be_invoked = (UIListElementScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.onSelected = translator.GetDelegate<UIListElementScript.OnSelectedDelegate>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
