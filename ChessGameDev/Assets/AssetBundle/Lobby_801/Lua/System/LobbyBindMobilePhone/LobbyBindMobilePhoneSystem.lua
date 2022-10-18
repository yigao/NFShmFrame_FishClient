LobbyBindMobilePhoneSystem = Class()

local Instance=nil
function LobbyBindMobilePhoneSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end

function LobbyBindMobilePhoneSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyBindMobilePhoneSystem.New()
	end
	return Instance
end

function LobbyBindMobilePhoneSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbyBindMobilePhone/LobbyBindMobilePhoneView",
	}
end


function LobbyBindMobilePhoneSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function LobbyBindMobilePhoneSystem:Init()
	self:InitData()
	self:InitView()
end

function LobbyBindMobilePhoneSystem:InitData(  )
	self.bindMobilePhoneView = LobbyBindMobilePhoneView.New()
end

function LobbyBindMobilePhoneSystem:InitView(  )
	
end

function LobbyBindMobilePhoneSystem:OpenForm()
	if self.bindMobilePhoneView then 
		self.bindMobilePhoneView:OpenForm()
	end
end


function LobbyBindMobilePhoneSystem:CloseForm()
	if self.bindMobilePhoneView then 
		self.bindMobilePhoneView:CloseForm()
	end
end



function LobbyBindMobilePhoneSystem:__delete()
	self:CloseForm()
	self.bindMobilePhoneView:Destroy()
	self.bindMobilePhoneView = nil
	self.Instance = nil
end
