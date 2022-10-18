LobbySettingSystem = Class()

local Instance=nil
function LobbySettingSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:InitData()
	self:Init()
end


function LobbySettingSystem.GetInstance()
	if Instance==nil then
		Instance=LobbySettingSystem.New()
	end
	return Instance
end

function LobbySettingSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbySetting/LobbySettingView",
	}
end


function LobbySettingSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end


function LobbySettingSystem:InitData()
	self.Shake_Key="Shake_Key"
	self.isOpenShake=CS.UnityEngine.PlayerPrefs.GetInt(self.Shake_Key,1)==1
end


function LobbySettingSystem:Init()
	self.settingView = LobbySettingView.New()
end


function LobbySettingSystem:GetMusicState()
	return LobbyAudioManager.GetInstance():GetMusicState()==1
end

function LobbySettingSystem:SetMusicState(isOpen)
	LobbyAudioManager.GetInstance():SetMusic(isOpen)
end


function LobbySettingSystem:GetSoundEffectState()
	return LobbyAudioManager.GetInstance():GetSoundState()==1
end


function LobbySettingSystem:SetSoundEffectState(isOpen)
	LobbyAudioManager.GetInstance():SetSound(isOpen)
end


function LobbySettingSystem:SetShake(isShake)
	self.isOpenShake=isShake
	if isShake then
		CS.UnityEngine.PlayerPrefs.SetInt(self.Shake_Key,1)
	else
		CS.UnityEngine.PlayerPrefs.SetInt(self.Shake_Key,0)
	end
	
end

function LobbySettingSystem:GetShake()
	return self.isOpenShake
end


function LobbySettingSystem:Open()
	self:ReInitData()
	self:OpenForm()
end

function LobbySettingSystem:ReInitData(  )

end

function LobbySettingSystem:OpenForm()
	if self.settingView then 
		self.settingView:OpenForm()
	end
end

function LobbySettingSystem:Close()
	self:CloseForm()
end

function LobbySettingSystem:CloseForm()
	if self.settingView then 
		self.settingView:CloseForm()
	end
end

function LobbySettingSystem:__delete()
	self:Close()
	self.settingView:Destroy()
	self.settingView = nil
	self.Instance = nil
end
