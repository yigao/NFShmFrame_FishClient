
loader={}
this=loader

CSScript = {
	Log=CS.Log,
	GameObject = CS.UnityEngine.GameObject,
	Vector3=CS.UnityEngine.Vector3,
	LuaManager = CS.LuaManager.sIntance,
	NetworkManager = CS.NetworkManager.sIntance,
	CorotineManager=CS.CorotineManager.sIntance,
	ResourceManager=CS.ResourceManager.sIntance,
	UIManager = CS.UIManager.instance,
	UpdateManager=CS.UpdateManager.sIntance,
	GlobalConfigManager = CS.GlobalConfigManager.instance,
	VersionUpdateManager = CS.VersionUpdateManager.instance,
	XTable=CS.XLua.Utils.RegisterFuncs,
	Input=CS.UnityEngine.Input,
	FishManager=CS.FishManager,
	Screen=CS.UnityEngine.Screen,
	Quaternion=CS.UnityEngine.Quaternion,
	Time=CS.UnityEngine.Time,
	
} 

local InitBaseScritps={
	"H/Lua/Base/BaseClass",
	"H/Lua/Base/Tools/memory",
	"H/Lua/Base/Tools/profiler",
	"H/Lua/Base/Common/CommonHelper",
	"H/Lua/Base/Log/LogManager",
	"H/Lua/Base/LuaUtil",
	"H/Lua/Common/HallLuaDefine",
	"H/Lua/Network/LuaNetwork",
	"H/Lua/LuaLib/Pb/LuaProtoBufManager",
	"H/Lua/Manager/GameBaseController",
	
	"H/Lua/Base/Event/LuaEventManager",
	"H/Lua/Base/Event/PrototypeEvent",
	"H/Lua/Base/Event/LuaEventParams",
	"H/Lua/Base/Event/CSEventManager",
	"H/Lua/Base/Event/GlobalEventManager",
	"H/Lua/Base/Timer/TimerManager",
	"H/Lua/Base/Timer/PrototypeTimer",
	
	"H/Lua/LobbyConfig/LobbyCommonConfig",
	"H/Lua/Audio/LobbyAudioManager",
	"H/Lua/Manager/LobbyResourceManager",
	"H/Lua/Manager/LobbyManager",
	"H/Lua/System/ComUI/XLuaUIManager",
	"H/Lua/System/LobbyHallCore/LobbyHallCoreSystem",
	"H/Lua/System/LobbyLogin/LobbyLoginSystem",
	"H/Lua/System/ComUI/GameLoadingSystem",
	"H/Lua/System/ComUI/LobbyLoadingSystem",
	"H/Lua/LuaStateMachine/StateCom/LuaStateControl",
	"H/Lua/Network/LuaHeartBeat",
}


function this.Main(args)
	collectgarbage("setpause",100)
	collectgarbage("setstepmul",200)
	this.LoaderLuaScripts(InitBaseScritps)
	LobbyManager.New():Init()	
end


this.LoaderLuaScripts=function(allScritps)
	if allScritps  then
		if #allScritps>0 then
			for i=1,#allScritps do
				require(allScritps[i])
			end
		end
	end
end


return this