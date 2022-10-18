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
    public class FileManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(FileManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 32, 2, 2);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "ClearDirectory", _m_ClearDirectory_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CombinePath", _m_CombinePath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CombinePaths", _m_CombinePaths_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CopyFile", _m_CopyFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CreateDirectory", _m_CreateDirectory_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "DeleteDirectory", _m_DeleteDirectory_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "DeleteFile", _m_DeleteFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EraseExtension", _m_EraseExtension_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCachePath", _m_GetCachePath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCachePathWithHeader", _m_GetCachePathWithHeader_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetExtension", _m_GetExtension_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFileLength", _m_GetFileLength_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFullDirectory", _m_GetFullDirectory_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFullName", _m_GetFullName_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetIFSExtractPath", _m_GetIFSExtractPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetBuildABPath", _m_GetBuildABPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFileMd5", _m_GetFileMd5_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetMd5", _m_GetMd5_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetStreamingAssetsPathWithHeader", _m_GetStreamingAssetsPathWithHeader_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsDirectoryExist", _m_IsDirectoryExist_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsFileExist", _m_IsFileExist_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ReadFile", _m_ReadFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "WriteFile", _m_WriteFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ReplacePathSymbol", _m_ReplacePathSymbol_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetAllFile", _m_GetAllFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetAllocateFile", _m_GetAllocateFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "StringSplit", _m_StringSplit_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetAllDirectoryHierarchyByPath", _m_GetAllDirectoryHierarchyByPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Encrypt", _m_Encrypt_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LoadABRs", _m_LoadABRs_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LoadABRsAsync", _m_LoadABRsAsync_xlua_st_);
            
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "s_ifsExtractFolder", _g_get_s_ifsExtractFolder);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "s_delegateOnOperateFileFail", _g_get_s_delegateOnOperateFileFail);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "s_ifsExtractFolder", _s_set_s_ifsExtractFolder);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "s_delegateOnOperateFileFail", _s_set_s_delegateOnOperateFileFail);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					FileManager gen_ret = new FileManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FileManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearDirectory_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _fullPath = LuaAPI.lua_tostring(L, 1);
                    
                        bool gen_ret = FileManager.ClearDirectory( _fullPath );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<string[]>(L, 2)&& translator.Assignable<string[]>(L, 3)) 
                {
                    string _fullPath = LuaAPI.lua_tostring(L, 1);
                    string[] _fileExtensionFilter = (string[])translator.GetObject(L, 2, typeof(string[]));
                    string[] _folderFilter = (string[])translator.GetObject(L, 3, typeof(string[]));
                    
                        bool gen_ret = FileManager.ClearDirectory( _fullPath, _fileExtensionFilter, _folderFilter );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FileManager.ClearDirectory!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CombinePath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _path1 = LuaAPI.lua_tostring(L, 1);
                    string _path2 = LuaAPI.lua_tostring(L, 2);
                    
                        string gen_ret = FileManager.CombinePath( _path1, _path2 );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CombinePaths_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string[] _values = translator.GetParams<string>(L, 1);
                    
                        string gen_ret = FileManager.CombinePaths( _values );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CopyFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _srcFile = LuaAPI.lua_tostring(L, 1);
                    string _dstFile = LuaAPI.lua_tostring(L, 2);
                    
                    FileManager.CopyFile( _srcFile, _dstFile );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateDirectory_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _directory = LuaAPI.lua_tostring(L, 1);
                    
                        bool gen_ret = FileManager.CreateDirectory( _directory );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DeleteDirectory_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _directory = LuaAPI.lua_tostring(L, 1);
                    
                        bool gen_ret = FileManager.DeleteDirectory( _directory );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DeleteFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    
                        bool gen_ret = FileManager.DeleteFile( _filePath );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EraseExtension_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _fullName = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.EraseExtension( _fullName );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCachePath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 0) 
                {
                    
                        string gen_ret = FileManager.GetCachePath(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _fileName = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.GetCachePath( _fileName );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FileManager.GetCachePath!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCachePathWithHeader_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _fileName = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.GetCachePathWithHeader( _fileName );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetExtension_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _fullName = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.GetExtension( _fullName );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFileLength_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    
                        long gen_ret = FileManager.GetFileLength( _filePath );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFullDirectory_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _fullPath = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.GetFullDirectory( _fullPath );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFullName_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _fullPath = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.GetFullName( _fullPath );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetIFSExtractPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        string gen_ret = FileManager.GetIFSExtractPath(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBuildABPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        string gen_ret = FileManager.GetBuildABPath(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFileMd5_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.GetFileMd5( _filePath );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMd5_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    byte[] _data = LuaAPI.lua_tobytes(L, 1);
                    
                        string gen_ret = FileManager.GetMd5( _data );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _str = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.GetMd5( _str );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FileManager.GetMd5!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetStreamingAssetsPathWithHeader_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _fileName = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.GetStreamingAssetsPathWithHeader( _fileName );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsDirectoryExist_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _directory = LuaAPI.lua_tostring(L, 1);
                    
                        bool gen_ret = FileManager.IsDirectoryExist( _directory );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsFileExist_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    
                        bool gen_ret = FileManager.IsFileExist( _filePath );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReadFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    
                        byte[] gen_ret = FileManager.ReadFile( _filePath );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WriteFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    byte[] _data = LuaAPI.lua_tobytes(L, 2);
                    
                        bool gen_ret = FileManager.WriteFile( _filePath, _data );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    byte[] _data = LuaAPI.lua_tobytes(L, 2);
                    int _offset = LuaAPI.xlua_tointeger(L, 3);
                    int _length = LuaAPI.xlua_tointeger(L, 4);
                    
                        bool gen_ret = FileManager.WriteFile( _filePath, _data, _offset, _length );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FileManager.WriteFile!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReplacePathSymbol_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    
                        string gen_ret = FileManager.ReplacePathSymbol( _filePath );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.List<string>>(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _dirctoryPath = LuaAPI.lua_tostring(L, 1);
                    System.Collections.Generic.List<string> _allFiles = (System.Collections.Generic.List<string>)translator.GetObject(L, 2, typeof(System.Collections.Generic.List<string>));
                    string _removePath = LuaAPI.lua_tostring(L, 3);
                    
                    FileManager.GetAllFile( _dirctoryPath, ref _allFiles, _removePath );
                    translator.Push(L, _allFiles);
                        
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.List<string>>(L, 2)) 
                {
                    string _dirctoryPath = LuaAPI.lua_tostring(L, 1);
                    System.Collections.Generic.List<string> _allFiles = (System.Collections.Generic.List<string>)translator.GetObject(L, 2, typeof(System.Collections.Generic.List<string>));
                    
                    FileManager.GetAllFile( _dirctoryPath, ref _allFiles );
                    translator.Push(L, _allFiles);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FileManager.GetAllFile!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllocateFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _dirctoryPath = LuaAPI.lua_tostring(L, 1);
                    string _extensionName = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.List<string> _allFiles = (System.Collections.Generic.List<string>)translator.GetObject(L, 3, typeof(System.Collections.Generic.List<string>));
                    
                    FileManager.GetAllocateFile( _dirctoryPath, _extensionName, ref _allFiles );
                    translator.Push(L, _allFiles);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StringSplit_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _str = LuaAPI.lua_tostring(L, 1);
                    string _splitStr = LuaAPI.lua_tostring(L, 2);
                    System.Action<string[]> _callBack = translator.GetDelegate<System.Action<string[]>>(L, 3);
                    
                    FileManager.StringSplit( _str, _splitStr, _callBack );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllDirectoryHierarchyByPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _directoryPath = LuaAPI.lua_tostring(L, 1);
                    System.Collections.Generic.List<string> _directoryHierarchyList = (System.Collections.Generic.List<string>)translator.GetObject(L, 2, typeof(System.Collections.Generic.List<string>));
                    
                    FileManager.GetAllDirectoryHierarchyByPath( _directoryPath, ref _directoryHierarchyList );
                    translator.Push(L, _directoryHierarchyList);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Encrypt_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    byte[] _text = LuaAPI.lua_tobytes(L, 1);
                    string _key = LuaAPI.lua_tostring(L, 2);
                    
                        byte[] gen_ret = FileManager.Encrypt( _text, _key );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadABRs_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    byte[] _abDataList = LuaAPI.lua_tobytes(L, 1);
                    
                        UnityEngine.AssetBundle gen_ret = FileManager.LoadABRs( _abDataList );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadABRsAsync_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    byte[] _abDataList = LuaAPI.lua_tobytes(L, 1);
                    
                        UnityEngine.AssetBundleCreateRequest gen_ret = FileManager.LoadABRsAsync( _abDataList );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_s_ifsExtractFolder(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushstring(L, FileManager.s_ifsExtractFolder);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_s_delegateOnOperateFileFail(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, FileManager.s_delegateOnOperateFileFail);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_s_ifsExtractFolder(RealStatePtr L)
        {
		    try {
                
			    FileManager.s_ifsExtractFolder = LuaAPI.lua_tostring(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_s_delegateOnOperateFileFail(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    FileManager.s_delegateOnOperateFileFail = translator.GetDelegate<FileManager.DelegateOnOperateFileFail>(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
