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
    public class PoissonDiskSampleWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(PoissonDiskSample);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCoinCoordinate", _m_GetCoinCoordinate_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SampleVector", _m_SampleVector_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					PoissonDiskSample gen_ret = new PoissonDiskSample();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to PoissonDiskSample constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCoinCoordinate_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<UnityEngine.Transform>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)) 
                {
                    float _width = (float)LuaAPI.lua_tonumber(L, 1);
                    float _height = (float)LuaAPI.lua_tonumber(L, 2);
                    float _radius = (float)LuaAPI.lua_tonumber(L, 3);
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 4, typeof(UnityEngine.Transform));
                    float _yOffset = (float)LuaAPI.lua_tonumber(L, 5);
                    bool _isInitRand = LuaAPI.lua_toboolean(L, 6);
                    
                        System.Collections.Generic.List<UnityEngine.Vector3> gen_ret = PoissonDiskSample.GetCoinCoordinate( _width, _height, _radius, _trans, _yOffset, _isInitRand );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<UnityEngine.Transform>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    float _width = (float)LuaAPI.lua_tonumber(L, 1);
                    float _height = (float)LuaAPI.lua_tonumber(L, 2);
                    float _radius = (float)LuaAPI.lua_tonumber(L, 3);
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 4, typeof(UnityEngine.Transform));
                    float _yOffset = (float)LuaAPI.lua_tonumber(L, 5);
                    
                        System.Collections.Generic.List<UnityEngine.Vector3> gen_ret = PoissonDiskSample.GetCoinCoordinate( _width, _height, _radius, _trans, _yOffset );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<UnityEngine.Transform>(L, 4)) 
                {
                    float _width = (float)LuaAPI.lua_tonumber(L, 1);
                    float _height = (float)LuaAPI.lua_tonumber(L, 2);
                    float _radius = (float)LuaAPI.lua_tonumber(L, 3);
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 4, typeof(UnityEngine.Transform));
                    
                        System.Collections.Generic.List<UnityEngine.Vector3> gen_ret = PoissonDiskSample.GetCoinCoordinate( _width, _height, _radius, _trans );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to PoissonDiskSample.GetCoinCoordinate!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SampleVector_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    float _width = (float)LuaAPI.lua_tonumber(L, 1);
                    float _height = (float)LuaAPI.lua_tonumber(L, 2);
                    float _radius = (float)LuaAPI.lua_tonumber(L, 3);
                    bool _isInitRand = LuaAPI.lua_toboolean(L, 4);
                    int _k = LuaAPI.xlua_tointeger(L, 5);
                    
                        System.Collections.Generic.List<UnityEngine.Vector3> gen_ret = PoissonDiskSample.SampleVector( _width, _height, _radius, _isInitRand, _k );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    float _width = (float)LuaAPI.lua_tonumber(L, 1);
                    float _height = (float)LuaAPI.lua_tonumber(L, 2);
                    float _radius = (float)LuaAPI.lua_tonumber(L, 3);
                    bool _isInitRand = LuaAPI.lua_toboolean(L, 4);
                    
                        System.Collections.Generic.List<UnityEngine.Vector3> gen_ret = PoissonDiskSample.SampleVector( _width, _height, _radius, _isInitRand );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to PoissonDiskSample.SampleVector!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
