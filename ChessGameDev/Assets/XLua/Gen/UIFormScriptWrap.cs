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
    public class UIFormScriptWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UIFormScript);
			Utils.BeginObjectRegister(type, L, translator, 0, 36, 18, 18);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "InitializeCanvas", _m_InitializeCanvas);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "MatchScreen", _m_MatchScreen);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CustomUpdate", _m_CustomUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CustomLateUpdate", _m_CustomLateUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Appear", _m_Appear);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetActive", _m_SetActive);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Hide", _m_Hide);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Open", _m_Open);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Close", _m_Close);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CalculateSortingOrder", _m_CalculateSortingOrder);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetDisplayOrder", _m_SetDisplayOrder);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Initialize", _m_Initialize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "InitializeComponent", _m_InitializeComponent);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetPriority", _m_SetPriority);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RestorePriority", _m_RestorePriority);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSequence", _m_GetSequence);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CompareTo", _m_CompareTo);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetWidget", _m_GetWidget);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCamera", _m_GetCamera);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsHided", _m_IsHided);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsClosed", _m_IsClosed);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsNeedClose", _m_IsNeedClose);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TurnToClosed", _m_TurnToClosed);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsNeedFadeIn", _m_IsNeedFadeIn);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsNeedFadeOut", _m_IsNeedFadeOut);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsCanvasEnabled", _m_IsCanvasEnabled);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsInFadeIn", _m_IsInFadeIn);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsInFadeOut", _m_IsInFadeOut);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetReferenceResolution", _m_GetReferenceResolution);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSortingOrder", _m_GetSortingOrder);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetGraphicRaycaster", _m_GetGraphicRaycaster);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetScreenScaleValue", _m_GetScreenScaleValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddUIComponent", _m_AddUIComponent);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveUIComponent", _m_RemoveUIComponent);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ChangeScreenValueToForm", _m_ChangeScreenValueToForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ChangeFormValueToScreen", _m_ChangeFormValueToScreen);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "referenceResolution", _g_get_referenceResolution);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "fullScreenBG", _g_get_fullScreenBG);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isSingleton", _g_get_isSingleton);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "hideUnderForms", _g_get_hideUnderForms);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "disableInput", _g_get_disableInput);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isModal", _g_get_isModal);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "formWidgets", _g_get_formWidgets);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "priority", _g_get_priority);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "alwaysKeepVisible", _g_get_alwaysKeepVisible);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "enableMultiClickedEvent", _g_get_enableMultiClickedEvent);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "formFadeInAnimationName", _g_get_formFadeInAnimationName);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "formFadeInAnimationType", _g_get_formFadeInAnimationType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "formFadeOutAnimationName", _g_get_formFadeOutAnimationName);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "formFadeOutAnimationType", _g_get_formFadeOutAnimationType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "canvasScaler", _g_get_canvasScaler);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "formPath", _g_get_formPath);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "useFormPool", _g_get_useFormPool);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "clickedEventDispatchedCounter", _g_get_clickedEventDispatchedCounter);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "referenceResolution", _s_set_referenceResolution);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "fullScreenBG", _s_set_fullScreenBG);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isSingleton", _s_set_isSingleton);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "hideUnderForms", _s_set_hideUnderForms);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "disableInput", _s_set_disableInput);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isModal", _s_set_isModal);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "formWidgets", _s_set_formWidgets);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "priority", _s_set_priority);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "alwaysKeepVisible", _s_set_alwaysKeepVisible);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "enableMultiClickedEvent", _s_set_enableMultiClickedEvent);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "formFadeInAnimationName", _s_set_formFadeInAnimationName);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "formFadeInAnimationType", _s_set_formFadeInAnimationType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "formFadeOutAnimationName", _s_set_formFadeOutAnimationName);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "formFadeOutAnimationType", _s_set_formFadeOutAnimationType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "canvasScaler", _s_set_canvasScaler);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "formPath", _s_set_formPath);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "useFormPool", _s_set_useFormPool);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "clickedEventDispatchedCounter", _s_set_clickedEventDispatchedCounter);
            
			
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
					
					UIFormScript gen_ret = new UIFormScript();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UIFormScript constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InitializeCanvas(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.InitializeCanvas(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_MatchScreen(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.MatchScreen(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CustomUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CustomUpdate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CustomLateUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CustomLateUpdate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Appear(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<enFormHideFlag>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    enFormHideFlag _hideFlag;translator.Get(L, 2, out _hideFlag);
                    bool _dispatchVisibleChangedEvent = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.Appear( _hideFlag, _dispatchVisibleChangedEvent );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<enFormHideFlag>(L, 2)) 
                {
                    enFormHideFlag _hideFlag;translator.Get(L, 2, out _hideFlag);
                    
                    gen_to_be_invoked.Appear( _hideFlag );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.Appear(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIFormScript.Appear!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetActive(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _active = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetActive( _active );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Hide(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<enFormHideFlag>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    enFormHideFlag _hideFlag;translator.Get(L, 2, out _hideFlag);
                    bool _dispatchVisibleChangedEvent = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.Hide( _hideFlag, _dispatchVisibleChangedEvent );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<enFormHideFlag>(L, 2)) 
                {
                    enFormHideFlag _hideFlag;translator.Get(L, 2, out _hideFlag);
                    
                    gen_to_be_invoked.Hide( _hideFlag );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.Hide(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIFormScript.Hide!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Open(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    int _sequence = LuaAPI.xlua_tointeger(L, 2);
                    bool _exist = LuaAPI.lua_toboolean(L, 3);
                    int _openOrder = LuaAPI.xlua_tointeger(L, 4);
                    
                    gen_to_be_invoked.Open( _sequence, _exist, _openOrder );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Camera>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _inFormPath = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.Camera _camera = (UnityEngine.Camera)translator.GetObject(L, 3, typeof(UnityEngine.Camera));
                    int _sequence = LuaAPI.xlua_tointeger(L, 4);
                    bool _exist = LuaAPI.lua_toboolean(L, 5);
                    int _openOrder = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.Open( _inFormPath, _camera, _sequence, _exist, _openOrder );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIFormScript.Open!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Close(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Close(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CalculateSortingOrder(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    enFormPriority _priority;translator.Get(L, 2, out _priority);
                    int _openOrder = LuaAPI.xlua_tointeger(L, 3);
                    
                        int gen_ret = gen_to_be_invoked.CalculateSortingOrder( _priority, _openOrder );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetDisplayOrder(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _openOrder = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetDisplayOrder( _openOrder );
                    
                    
                    
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
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Initialize(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InitializeComponent(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _root = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.InitializeComponent( _root );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetPriority(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    enFormPriority _formPriority;translator.Get(L, 2, out _formPriority);
                    
                    gen_to_be_invoked.SetPriority( _formPriority );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RestorePriority(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.RestorePriority(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSequence(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        int gen_ret = gen_to_be_invoked.GetSequence(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CompareTo(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    object _obj = translator.GetObject(L, 2, typeof(object));
                    
                        int gen_ret = gen_to_be_invoked.CompareTo( _obj );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetWidget(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        UnityEngine.GameObject gen_ret = gen_to_be_invoked.GetWidget( _index );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCamera(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.Camera gen_ret = gen_to_be_invoked.GetCamera(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsHided(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsHided(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsClosed(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsClosed(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsNeedClose(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsNeedClose(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TurnToClosed(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _ignoreFadeOut = LuaAPI.lua_toboolean(L, 2);
                    
                        bool gen_ret = gen_to_be_invoked.TurnToClosed( _ignoreFadeOut );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsNeedFadeIn(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsNeedFadeIn(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsNeedFadeOut(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsNeedFadeOut(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsCanvasEnabled(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsCanvasEnabled(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsInFadeIn(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsInFadeIn(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsInFadeOut(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.IsInFadeOut(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetReferenceResolution(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.Vector2 gen_ret = gen_to_be_invoked.GetReferenceResolution(  );
                        translator.PushUnityEngineVector2(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSortingOrder(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        int gen_ret = gen_to_be_invoked.GetSortingOrder(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGraphicRaycaster(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.UI.GraphicRaycaster gen_ret = gen_to_be_invoked.GetGraphicRaycaster(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetScreenScaleValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        float gen_ret = gen_to_be_invoked.GetScreenScaleValue(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddUIComponent(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UIComponent _uiComponent = (UIComponent)translator.GetObject(L, 2, typeof(UIComponent));
                    
                    gen_to_be_invoked.AddUIComponent( _uiComponent );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveUIComponent(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UIComponent _uiComponent = (UIComponent)translator.GetObject(L, 2, typeof(UIComponent));
                    
                    gen_to_be_invoked.RemoveUIComponent( _uiComponent );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeScreenValueToForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _value = (float)LuaAPI.lua_tonumber(L, 2);
                    
                        float gen_ret = gen_to_be_invoked.ChangeScreenValueToForm( _value );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeFormValueToScreen(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _value = (float)LuaAPI.lua_tonumber(L, 2);
                    
                        float gen_ret = gen_to_be_invoked.ChangeFormValueToScreen( _value );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_referenceResolution(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.referenceResolution);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fullScreenBG(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.fullScreenBG);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isSingleton(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isSingleton);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_hideUnderForms(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.hideUnderForms);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_disableInput(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.disableInput);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isModal(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isModal);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_formWidgets(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.formWidgets);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_priority(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.priority);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_alwaysKeepVisible(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.alwaysKeepVisible);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_enableMultiClickedEvent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.enableMultiClickedEvent);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_formFadeInAnimationName(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.formFadeInAnimationName);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_formFadeInAnimationType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.formFadeInAnimationType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_formFadeOutAnimationName(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.formFadeOutAnimationName);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_formFadeOutAnimationType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.formFadeOutAnimationType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_canvasScaler(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.canvasScaler);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_formPath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.formPath);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_useFormPool(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.useFormPool);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_clickedEventDispatchedCounter(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.clickedEventDispatchedCounter);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_referenceResolution(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.referenceResolution = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fullScreenBG(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.fullScreenBG = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isSingleton(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isSingleton = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_hideUnderForms(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.hideUnderForms = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_disableInput(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.disableInput = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isModal(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isModal = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_formWidgets(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.formWidgets = (UnityEngine.GameObject[])translator.GetObject(L, 2, typeof(UnityEngine.GameObject[]));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_priority(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                enFormPriority gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.priority = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_alwaysKeepVisible(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.alwaysKeepVisible = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_enableMultiClickedEvent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.enableMultiClickedEvent = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_formFadeInAnimationName(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.formFadeInAnimationName = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_formFadeInAnimationType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                enFormFadeAnimationType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.formFadeInAnimationType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_formFadeOutAnimationName(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.formFadeOutAnimationName = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_formFadeOutAnimationType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                enFormFadeAnimationType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.formFadeOutAnimationType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_canvasScaler(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.canvasScaler = (UnityEngine.UI.CanvasScaler)translator.GetObject(L, 2, typeof(UnityEngine.UI.CanvasScaler));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_formPath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.formPath = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_useFormPool(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.useFormPool = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_clickedEventDispatchedCounter(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIFormScript gen_to_be_invoked = (UIFormScript)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.clickedEventDispatchedCounter = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
