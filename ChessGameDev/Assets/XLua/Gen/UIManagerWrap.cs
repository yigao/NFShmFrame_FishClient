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
    public class UIManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UIManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 24, 3, 3);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Init", _m_Init);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Update", _m_Update);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LateUpdate", _m_LateUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OpenForm", _m_OpenForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CloseForm", _m_CloseForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CloseAllForm", _m_CloseAllForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RecycleForm", _m_RecycleForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearFormPool", _m_ClearFormPool);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetFormOpenOrder", _m_GetFormOpenOrder);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddToExistFormSequenceList", _m_AddToExistFormSequenceList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveFromExistFormSequenceList", _m_RemoveFromExistFormSequenceList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HasForm", _m_HasForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetForm", _m_GetForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetObjPool", _m_SetObjPool);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DisableInput", _m_DisableInput);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "EnableInput", _m_EnableInput);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTopForm", _m_GetTopForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetForms", _m_GetForms);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetEventSystem", _m_GetEventSystem);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OpenFromInResourceForm", _m_OpenFromInResourceForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OpenNetWaitForm", _m_OpenNetWaitForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CloseNetWaitForm", _m_CloseNetWaitForm);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OpenMessageBox", _m_OpenMessageBox);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CloseMessageBox", _m_CloseMessageBox);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "onFormSorted", _g_get_onFormSorted);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_uiRoot", _g_get_m_uiRoot);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "rootObj", _g_get_rootObj);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "onFormSorted", _s_set_onFormSorted);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_uiRoot", _s_set_m_uiRoot);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "rootObj", _s_set_rootObj);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 1, 1);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NetWaitForm_Path", UIManager.NetWaitForm_Path);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MessageBoxForm_Path", UIManager.MessageBoxForm_Path);
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "suiSystemRenderFrameCounter", _g_get_suiSystemRenderFrameCounter);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "suiSystemRenderFrameCounter", _s_set_suiSystemRenderFrameCounter);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					UIManager gen_ret = new UIManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UIManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Init(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Init(  );
                    
                    
                    
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
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Update(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LateUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.LateUpdate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OpenForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string _formPath = LuaAPI.lua_tostring(L, 2);
                    bool _useFormPool = LuaAPI.lua_toboolean(L, 3);
                    bool _useCameraRenderMode = LuaAPI.lua_toboolean(L, 4);
                    
                        UIFormScript gen_ret = gen_to_be_invoked.OpenForm( _formPath, _useFormPool, _useCameraRenderMode );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string _formPath = LuaAPI.lua_tostring(L, 2);
                    bool _useFormPool = LuaAPI.lua_toboolean(L, 3);
                    
                        UIFormScript gen_ret = gen_to_be_invoked.OpenForm( _formPath, _useFormPool );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIManager.OpenForm!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CloseForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _formSequence = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.CloseForm( _formSequence );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _formPath = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.CloseForm( _formPath );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<UIFormScript>(L, 2)) 
                {
                    UIFormScript _formScript = (UIFormScript)translator.GetObject(L, 2, typeof(UIFormScript));
                    
                    gen_to_be_invoked.CloseForm( _formScript );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIManager.CloseForm!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CloseAllForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<string[]>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string[] _exceptFormNames = (string[])translator.GetObject(L, 2, typeof(string[]));
                    bool _closeImmediately = LuaAPI.lua_toboolean(L, 3);
                    bool _clearFormPool = LuaAPI.lua_toboolean(L, 4);
                    
                    gen_to_be_invoked.CloseAllForm( _exceptFormNames, _closeImmediately, _clearFormPool );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<string[]>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string[] _exceptFormNames = (string[])translator.GetObject(L, 2, typeof(string[]));
                    bool _closeImmediately = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.CloseAllForm( _exceptFormNames, _closeImmediately );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<string[]>(L, 2)) 
                {
                    string[] _exceptFormNames = (string[])translator.GetObject(L, 2, typeof(string[]));
                    
                    gen_to_be_invoked.CloseAllForm( _exceptFormNames );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.CloseAllForm(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIManager.CloseAllForm!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RecycleForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UIFormScript _formScript = (UIFormScript)translator.GetObject(L, 2, typeof(UIFormScript));
                    
                    gen_to_be_invoked.RecycleForm( _formScript );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearFormPool(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearFormPool(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFormOpenOrder(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _formSequence = LuaAPI.xlua_tointeger(L, 2);
                    
                        int gen_ret = gen_to_be_invoked.GetFormOpenOrder( _formSequence );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddToExistFormSequenceList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _formSequence = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.AddToExistFormSequenceList( _formSequence );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveFromExistFormSequenceList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _formSequence = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.RemoveFromExistFormSequenceList( _formSequence );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HasForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.HasForm(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _formSequence = LuaAPI.xlua_tointeger(L, 2);
                    
                        UIFormScript gen_ret = gen_to_be_invoked.GetForm( _formSequence );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _formPath = LuaAPI.lua_tostring(L, 2);
                    
                        UIFormScript gen_ret = gen_to_be_invoked.GetForm( _formPath );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIManager.GetForm!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetObjPool(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _obj = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.SetObjPool( _obj );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DisableInput(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DisableInput(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnableInput(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.EnableInput(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTopForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UIFormScript gen_ret = gen_to_be_invoked.GetTopForm(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetForms(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        System.Collections.Generic.List<UIFormScript> gen_ret = gen_to_be_invoked.GetForms(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetEventSystem(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        UnityEngine.EventSystems.EventSystem gen_ret = gen_to_be_invoked.GetEventSystem(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OpenFromInResourceForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string _formPath = LuaAPI.lua_tostring(L, 2);
                    bool _useFormPool = LuaAPI.lua_toboolean(L, 3);
                    bool _useCameraRenderMode = LuaAPI.lua_toboolean(L, 4);
                    
                        UIFormScript gen_ret = gen_to_be_invoked.OpenFromInResourceForm( _formPath, _useFormPool, _useCameraRenderMode );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string _formPath = LuaAPI.lua_tostring(L, 2);
                    bool _useFormPool = LuaAPI.lua_toboolean(L, 3);
                    
                        UIFormScript gen_ret = gen_to_be_invoked.OpenFromInResourceForm( _formPath, _useFormPool );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIManager.OpenFromInResourceForm!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OpenNetWaitForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<System.Action>(L, 4)) 
                {
                    float _autoCloseTime = (float)LuaAPI.lua_tonumber(L, 2);
                    float _delayTime = (float)LuaAPI.lua_tonumber(L, 3);
                    System.Action _callBack = translator.GetDelegate<System.Action>(L, 4);
                    
                    gen_to_be_invoked.OpenNetWaitForm( _autoCloseTime, _delayTime, _callBack );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _autoCloseTime = (float)LuaAPI.lua_tonumber(L, 2);
                    float _delayTime = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.OpenNetWaitForm( _autoCloseTime, _delayTime );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _autoCloseTime = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.OpenNetWaitForm( _autoCloseTime );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.OpenNetWaitForm(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIManager.OpenNetWaitForm!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CloseNetWaitForm(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CloseNetWaitForm(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OpenMessageBox(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 11&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& translator.Assignable<System.Action>(L, 6)&& translator.Assignable<System.Action>(L, 7)&& translator.Assignable<System.Action>(L, 8)&& (LuaAPI.lua_isnil(L, 9) || LuaAPI.lua_type(L, 9) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 10) || LuaAPI.lua_type(L, 10) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 11)) 
                {
                    string _strContent = LuaAPI.lua_tostring(L, 2);
                    bool _isHaveConfirmBtn = LuaAPI.lua_toboolean(L, 3);
                    bool _isHaveCancelBtn = LuaAPI.lua_toboolean(L, 4);
                    bool _isHaveCloseBtn = LuaAPI.lua_toboolean(L, 5);
                    System.Action _confirmCallBack = translator.GetDelegate<System.Action>(L, 6);
                    System.Action _cancelCallBack = translator.GetDelegate<System.Action>(L, 7);
                    System.Action _closeCallBack = translator.GetDelegate<System.Action>(L, 8);
                    string _confirmStr = LuaAPI.lua_tostring(L, 9);
                    string _cancelStr = LuaAPI.lua_tostring(L, 10);
                    int _autoCloseTime = LuaAPI.xlua_tointeger(L, 11);
                    
                    gen_to_be_invoked.OpenMessageBox( _strContent, _isHaveConfirmBtn, _isHaveCancelBtn, _isHaveCloseBtn, _confirmCallBack, _cancelCallBack, _closeCallBack, _confirmStr, _cancelStr, _autoCloseTime );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 10&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& translator.Assignable<System.Action>(L, 6)&& translator.Assignable<System.Action>(L, 7)&& translator.Assignable<System.Action>(L, 8)&& (LuaAPI.lua_isnil(L, 9) || LuaAPI.lua_type(L, 9) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 10) || LuaAPI.lua_type(L, 10) == LuaTypes.LUA_TSTRING)) 
                {
                    string _strContent = LuaAPI.lua_tostring(L, 2);
                    bool _isHaveConfirmBtn = LuaAPI.lua_toboolean(L, 3);
                    bool _isHaveCancelBtn = LuaAPI.lua_toboolean(L, 4);
                    bool _isHaveCloseBtn = LuaAPI.lua_toboolean(L, 5);
                    System.Action _confirmCallBack = translator.GetDelegate<System.Action>(L, 6);
                    System.Action _cancelCallBack = translator.GetDelegate<System.Action>(L, 7);
                    System.Action _closeCallBack = translator.GetDelegate<System.Action>(L, 8);
                    string _confirmStr = LuaAPI.lua_tostring(L, 9);
                    string _cancelStr = LuaAPI.lua_tostring(L, 10);
                    
                    gen_to_be_invoked.OpenMessageBox( _strContent, _isHaveConfirmBtn, _isHaveCancelBtn, _isHaveCloseBtn, _confirmCallBack, _cancelCallBack, _closeCallBack, _confirmStr, _cancelStr );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 9&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& translator.Assignable<System.Action>(L, 6)&& translator.Assignable<System.Action>(L, 7)&& translator.Assignable<System.Action>(L, 8)&& (LuaAPI.lua_isnil(L, 9) || LuaAPI.lua_type(L, 9) == LuaTypes.LUA_TSTRING)) 
                {
                    string _strContent = LuaAPI.lua_tostring(L, 2);
                    bool _isHaveConfirmBtn = LuaAPI.lua_toboolean(L, 3);
                    bool _isHaveCancelBtn = LuaAPI.lua_toboolean(L, 4);
                    bool _isHaveCloseBtn = LuaAPI.lua_toboolean(L, 5);
                    System.Action _confirmCallBack = translator.GetDelegate<System.Action>(L, 6);
                    System.Action _cancelCallBack = translator.GetDelegate<System.Action>(L, 7);
                    System.Action _closeCallBack = translator.GetDelegate<System.Action>(L, 8);
                    string _confirmStr = LuaAPI.lua_tostring(L, 9);
                    
                    gen_to_be_invoked.OpenMessageBox( _strContent, _isHaveConfirmBtn, _isHaveCancelBtn, _isHaveCloseBtn, _confirmCallBack, _cancelCallBack, _closeCallBack, _confirmStr );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 8&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& translator.Assignable<System.Action>(L, 6)&& translator.Assignable<System.Action>(L, 7)&& translator.Assignable<System.Action>(L, 8)) 
                {
                    string _strContent = LuaAPI.lua_tostring(L, 2);
                    bool _isHaveConfirmBtn = LuaAPI.lua_toboolean(L, 3);
                    bool _isHaveCancelBtn = LuaAPI.lua_toboolean(L, 4);
                    bool _isHaveCloseBtn = LuaAPI.lua_toboolean(L, 5);
                    System.Action _confirmCallBack = translator.GetDelegate<System.Action>(L, 6);
                    System.Action _cancelCallBack = translator.GetDelegate<System.Action>(L, 7);
                    System.Action _closeCallBack = translator.GetDelegate<System.Action>(L, 8);
                    
                    gen_to_be_invoked.OpenMessageBox( _strContent, _isHaveConfirmBtn, _isHaveCancelBtn, _isHaveCloseBtn, _confirmCallBack, _cancelCallBack, _closeCallBack );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIManager.OpenMessageBox!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CloseMessageBox(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CloseMessageBox(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onFormSorted(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.onFormSorted);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_suiSystemRenderFrameCounter(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.xlua_pushinteger(L, UIManager.suiSystemRenderFrameCounter);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_uiRoot(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_uiRoot);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_rootObj(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.rootObj);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_onFormSorted(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.onFormSorted = translator.GetDelegate<UIManager.OnFormSorted>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_suiSystemRenderFrameCounter(RealStatePtr L)
        {
		    try {
                
			    UIManager.suiSystemRenderFrameCounter = LuaAPI.xlua_tointeger(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_uiRoot(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_uiRoot = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_rootObj(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIManager gen_to_be_invoked = (UIManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.rootObj = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
