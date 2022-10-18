LobbyManager=Class(GameBaseController)

local Instance=nil
function LobbyManager:ctor()
	Instance=self
	self.gameId= 0
	self:InitAddScripts()
end 

function LobbyManager.GetInstance()
	return Instance
end

function LobbyManager:InitAddScripts()
	self:AddScriptsPath("Common/Vo/GameData")
	self:AddScriptsPath("Common/LobbyConfig")

end

function LobbyManager:Init()
	self:BaseInit()
	self:InitData()
	self:InitView()
	self:InitInstance()
end

function LobbyManager:InitData()
	self.gameData=nil
end

function LobbyManager:InitView()
	self.StartUpSystem = CS.StartUpSystem.instance
	self.StartUpSystem:Open()
	self:AddEventListenner()
end

function LobbyManager:InitInstance()
	self:LoadManifestFile(self.gameId)
	self.gameData=GameData.New()
	self.gameData.LobbyConfig = LobbyConfig.New()
	LobbyResourceManager.GetInstance():CorotineLoadResources()
end

function LobbyManager:AddEventListenner()
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.EnteLobbyLogin_EventName,self.BeginEnterLobbyLogin,self)
end

function LobbyManager:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.EnteLobbyLogin_EventName)
end


function LobbyManager:BeginEnterLobbyLogin()
	LuaStateControl.GetInstance():GotoState(LuaStateControl.StateType.Login)
	LobbyAudioManager.GetInstance():PlayBGAudio(1)
end

function LobbyManager:__delete()
	LobbyResourceManager.GetInstance():RemoveCurrenLobbySpriteAtlas()
	self:RemoveEventListenner()
	LobbyResourceManager.GetInstance():Destroy()
	Instance = nil
end


