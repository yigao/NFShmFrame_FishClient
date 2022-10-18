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
    public class FishLuaBehaviourWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(FishLuaBehaviour);
			Utils.BeginObjectRegister(type, L, translator, 0, 18, 18, 18);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnPointerDown", _m_OnPointerDown);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnPointerUp", _m_OnPointerUp);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FishBeginMove", _m_FishBeginMove);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetFishMoveData", _m_SetFishMoveData);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AnimatorsEnableStatus", _m_AnimatorsEnableStatus);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FishMoving", _m_FishMoving);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Fish3DMoving", _m_Fish3DMoving);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Set3DFishRotationState", _m_Set3DFishRotationState);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Set45Tilt", _m_Set45Tilt);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FishQuickOutScene", _m_FishQuickOutScene);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetFishRotateAngle", _m_GetFishRotateAngle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CheckBoundValid", _m_CheckBoundValid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OutOfBounds", _m_OutOfBounds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetPosition", _m_SetPosition);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetEulerAngles", _m_SetEulerAngles);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetLocalScale", _m_SetLocalScale);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BulletBeginMove", _m_BulletBeginMove);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BulletMoving", _m_BulletMoving);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "Smooth", _g_get_Smooth);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onTriggerCallBack", _g_get_onTriggerCallBack);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onUpdate", _g_get_onUpdate);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onPressCallBack", _g_get_onPressCallBack);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_luaTable", _g_get_m_luaTable);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_targetTrans", _g_get_m_targetTrans);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "curFishStatus", _g_get_curFishStatus);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_direction", _g_get_m_direction);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "fishPointSmooth", _g_get_fishPointSmooth);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "RotationIndexInterval", _g_get_RotationIndexInterval);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "MoveIndexInterval", _g_get_MoveIndexInterval);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CachedGo", _g_get_CachedGo);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CachedTrans", _g_get_CachedTrans);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ResolutionWidthHalf", _g_get_ResolutionWidthHalf);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ResolutionHeightHalf", _g_get_ResolutionHeightHalf);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "is3DFishRotation", _g_get_is3DFishRotation);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "childRotationPoint", _g_get_childRotationPoint);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "label", _g_get_label);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "Smooth", _s_set_Smooth);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "onTriggerCallBack", _s_set_onTriggerCallBack);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "onUpdate", _s_set_onUpdate);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "onPressCallBack", _s_set_onPressCallBack);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_luaTable", _s_set_m_luaTable);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_targetTrans", _s_set_m_targetTrans);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "curFishStatus", _s_set_curFishStatus);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_direction", _s_set_m_direction);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "fishPointSmooth", _s_set_fishPointSmooth);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "RotationIndexInterval", _s_set_RotationIndexInterval);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "MoveIndexInterval", _s_set_MoveIndexInterval);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "CachedGo", _s_set_CachedGo);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "CachedTrans", _s_set_CachedTrans);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "ResolutionWidthHalf", _s_set_ResolutionWidthHalf);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "ResolutionHeightHalf", _s_set_ResolutionHeightHalf);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "is3DFishRotation", _s_set_is3DFishRotation);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "childRotationPoint", _s_set_childRotationPoint);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "label", _s_set_label);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 2, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "AngleAroundAxis", _m_AngleAroundAxis_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					FishLuaBehaviour gen_ret = new FishLuaBehaviour();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FishLuaBehaviour constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnPointerDown(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnPointerDown( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnPointerUp(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnPointerUp( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FishBeginMove(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 10&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 8)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 9)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 10)) 
                {
                    int _traceNumber = LuaAPI.xlua_tointeger(L, 2);
                    float _traceOffsetPosX = (float)LuaAPI.lua_tonumber(L, 3);
                    float _traceOffsetPosY = (float)LuaAPI.lua_tonumber(L, 4);
                    float _fishWidth = (float)LuaAPI.lua_tonumber(L, 5);
                    float _fishHeight = (float)LuaAPI.lua_tonumber(L, 6);
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 7);
                    int _delayBornTime = LuaAPI.xlua_tointeger(L, 8);
                    int _usGroupId = LuaAPI.xlua_tointeger(L, 9);
                    float _fishZ = (float)LuaAPI.lua_tonumber(L, 10);
                    
                    gen_to_be_invoked.FishBeginMove( _traceNumber, _traceOffsetPosX, _traceOffsetPosY, _fishWidth, _fishHeight, _pointIndex, _delayBornTime, _usGroupId, _fishZ );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 9&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 8)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 9)) 
                {
                    int _traceNumber = LuaAPI.xlua_tointeger(L, 2);
                    float _traceOffsetPosX = (float)LuaAPI.lua_tonumber(L, 3);
                    float _traceOffsetPosY = (float)LuaAPI.lua_tonumber(L, 4);
                    float _fishWidth = (float)LuaAPI.lua_tonumber(L, 5);
                    float _fishHeight = (float)LuaAPI.lua_tonumber(L, 6);
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 7);
                    int _delayBornTime = LuaAPI.xlua_tointeger(L, 8);
                    int _usGroupId = LuaAPI.xlua_tointeger(L, 9);
                    
                    gen_to_be_invoked.FishBeginMove( _traceNumber, _traceOffsetPosX, _traceOffsetPosY, _fishWidth, _fishHeight, _pointIndex, _delayBornTime, _usGroupId );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 8&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 8)) 
                {
                    int _traceNumber = LuaAPI.xlua_tointeger(L, 2);
                    float _traceOffsetPosX = (float)LuaAPI.lua_tonumber(L, 3);
                    float _traceOffsetPosY = (float)LuaAPI.lua_tonumber(L, 4);
                    float _fishWidth = (float)LuaAPI.lua_tonumber(L, 5);
                    float _fishHeight = (float)LuaAPI.lua_tonumber(L, 6);
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 7);
                    int _delayBornTime = LuaAPI.xlua_tointeger(L, 8);
                    
                    gen_to_be_invoked.FishBeginMove( _traceNumber, _traceOffsetPosX, _traceOffsetPosY, _fishWidth, _fishHeight, _pointIndex, _delayBornTime );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7)) 
                {
                    int _traceNumber = LuaAPI.xlua_tointeger(L, 2);
                    float _traceOffsetPosX = (float)LuaAPI.lua_tonumber(L, 3);
                    float _traceOffsetPosY = (float)LuaAPI.lua_tonumber(L, 4);
                    float _fishWidth = (float)LuaAPI.lua_tonumber(L, 5);
                    float _fishHeight = (float)LuaAPI.lua_tonumber(L, 6);
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 7);
                    
                    gen_to_be_invoked.FishBeginMove( _traceNumber, _traceOffsetPosX, _traceOffsetPosY, _fishWidth, _fishHeight, _pointIndex );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    int _traceNumber = LuaAPI.xlua_tointeger(L, 2);
                    float _traceOffsetPosX = (float)LuaAPI.lua_tonumber(L, 3);
                    float _traceOffsetPosY = (float)LuaAPI.lua_tonumber(L, 4);
                    float _fishWidth = (float)LuaAPI.lua_tonumber(L, 5);
                    float _fishHeight = (float)LuaAPI.lua_tonumber(L, 6);
                    
                    gen_to_be_invoked.FishBeginMove( _traceNumber, _traceOffsetPosX, _traceOffsetPosY, _fishWidth, _fishHeight );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishLuaBehaviour.FishBeginMove!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetFishMoveData(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.SetFishMoveData(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AnimatorsEnableStatus(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.AnimatorsEnableStatus(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FishMoving(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _deltaTime = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.FishMoving( _deltaTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Fish3DMoving(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _deltaTime = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.Fish3DMoving( _deltaTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Set3DFishRotationState(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _isRotation = LuaAPI.lua_toboolean(L, 2);
                    UnityEngine.Transform _targetTF = (UnityEngine.Transform)translator.GetObject(L, 3, typeof(UnityEngine.Transform));
                    
                    gen_to_be_invoked.Set3DFishRotationState( _isRotation, _targetTF );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Set45Tilt(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _isTilt = LuaAPI.lua_toboolean(L, 2);
                    UnityEngine.Transform _targetTF = (UnityEngine.Transform)translator.GetObject(L, 3, typeof(UnityEngine.Transform));
                    
                    gen_to_be_invoked.Set45Tilt( _isTilt, _targetTF );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FishQuickOutScene(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _changInterval = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.FishQuickOutScene( _changInterval );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.FishQuickOutScene(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FishLuaBehaviour.FishQuickOutScene!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFishRotateAngle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _moveDirection;translator.Get(L, 2, out _moveDirection);
                    
                        float gen_ret = gen_to_be_invoked.GetFishRotateAngle( _moveDirection );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CheckBoundValid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.CheckBoundValid(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OutOfBounds(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        bool gen_ret = gen_to_be_invoked.OutOfBounds(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetPosition(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.SetPosition( _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetEulerAngles(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.SetEulerAngles( _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetLocalScale(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.SetLocalScale( _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AngleAroundAxis_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Vector3 _dirA;translator.Get(L, 1, out _dirA);
                    UnityEngine.Vector3 _dirB;translator.Get(L, 2, out _dirB);
                    UnityEngine.Vector3 _axis;translator.Get(L, 3, out _axis);
                    
                        float gen_ret = FishLuaBehaviour.AngleAroundAxis( _dirA, _dirB, _axis );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BulletBeginMove(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _bulletSpeed = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.BulletBeginMove( _bulletSpeed );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BulletMoving(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.BulletMoving(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Smooth(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.Smooth);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onTriggerCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.onTriggerCallBack);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onUpdate(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.onUpdate);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onPressCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.onPressCallBack);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_luaTable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_luaTable);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_targetTrans(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_targetTrans);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_curFishStatus(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.PushFishLuaBehaviourFishStatus(L, gen_to_be_invoked.curFishStatus);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_direction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.m_direction);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fishPointSmooth(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.fishPointSmooth);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_RotationIndexInterval(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.RotationIndexInterval);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_MoveIndexInterval(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.MoveIndexInterval);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CachedGo(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.CachedGo);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CachedTrans(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.CachedTrans);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ResolutionWidthHalf(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.ResolutionWidthHalf);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ResolutionHeightHalf(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.ResolutionHeightHalf);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_is3DFishRotation(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.is3DFishRotation);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_childRotationPoint(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.childRotationPoint);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_label(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.label);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Smooth(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Smooth = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_onTriggerCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.onTriggerCallBack = translator.GetDelegate<System.Action<UnityEngine.Collider>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_onUpdate(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.onUpdate = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_onPressCallBack(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.onPressCallBack = translator.GetDelegate<System.Action<bool>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_luaTable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_luaTable = (XLua.LuaTable)translator.GetObject(L, 2, typeof(XLua.LuaTable));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_targetTrans(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_targetTrans = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_curFishStatus(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                FishLuaBehaviour.FishStatus gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.curFishStatus = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_direction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector3 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.m_direction = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fishPointSmooth(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.fishPointSmooth = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_RotationIndexInterval(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.RotationIndexInterval = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_MoveIndexInterval(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.MoveIndexInterval = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_CachedGo(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.CachedGo = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_CachedTrans(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.CachedTrans = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ResolutionWidthHalf(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.ResolutionWidthHalf = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ResolutionHeightHalf(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.ResolutionHeightHalf = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_is3DFishRotation(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.is3DFishRotation = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_childRotationPoint(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.childRotationPoint = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_label(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FishLuaBehaviour gen_to_be_invoked = (FishLuaBehaviour)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.label = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
