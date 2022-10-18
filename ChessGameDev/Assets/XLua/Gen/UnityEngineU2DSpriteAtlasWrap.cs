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
    public class UnityEngineU2DSpriteAtlasWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UnityEngine.U2D.SpriteAtlas);
			Utils.BeginObjectRegister(type, L, translator, 0, 3, 3, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CanBindTo", _m_CanBindTo);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSprite", _m_GetSprite);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSprites", _m_GetSprites);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "isVariant", _g_get_isVariant);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "tag", _g_get_tag);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "spriteCount", _g_get_spriteCount);
            
			
			
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
					
					UnityEngine.U2D.SpriteAtlas gen_ret = new UnityEngine.U2D.SpriteAtlas();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UnityEngine.U2D.SpriteAtlas constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CanBindTo(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UnityEngine.U2D.SpriteAtlas gen_to_be_invoked = (UnityEngine.U2D.SpriteAtlas)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Sprite _sprite = (UnityEngine.Sprite)translator.GetObject(L, 2, typeof(UnityEngine.Sprite));
                    
                        bool gen_ret = gen_to_be_invoked.CanBindTo( _sprite );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSprite(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UnityEngine.U2D.SpriteAtlas gen_to_be_invoked = (UnityEngine.U2D.SpriteAtlas)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _name = LuaAPI.lua_tostring(L, 2);
                    
                        UnityEngine.Sprite gen_ret = gen_to_be_invoked.GetSprite( _name );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSprites(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UnityEngine.U2D.SpriteAtlas gen_to_be_invoked = (UnityEngine.U2D.SpriteAtlas)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Sprite[]>(L, 2)) 
                {
                    UnityEngine.Sprite[] _sprites = (UnityEngine.Sprite[])translator.GetObject(L, 2, typeof(UnityEngine.Sprite[]));
                    
                        int gen_ret = gen_to_be_invoked.GetSprites( _sprites );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Sprite[]>(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    UnityEngine.Sprite[] _sprites = (UnityEngine.Sprite[])translator.GetObject(L, 2, typeof(UnityEngine.Sprite[]));
                    string _name = LuaAPI.lua_tostring(L, 3);
                    
                        int gen_ret = gen_to_be_invoked.GetSprites( _sprites, _name );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UnityEngine.U2D.SpriteAtlas.GetSprites!");
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isVariant(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UnityEngine.U2D.SpriteAtlas gen_to_be_invoked = (UnityEngine.U2D.SpriteAtlas)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isVariant);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_tag(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UnityEngine.U2D.SpriteAtlas gen_to_be_invoked = (UnityEngine.U2D.SpriteAtlas)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.tag);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_spriteCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UnityEngine.U2D.SpriteAtlas gen_to_be_invoked = (UnityEngine.U2D.SpriteAtlas)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.spriteCount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
		
		
		
		
    }
}
