NetworkWaitSystem = Class()

local Instance=nil
function NetworkWaitSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function NetworkWaitSystem.GetInstance()
	if Instance==nil then
		Instance=NetworkWaitSystem.New()
	end
	return Instance
end

function NetworkWaitSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/ComUI/NetworkWaitSystem/NetworkWaitView",
	}
end


function NetworkWaitSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function NetworkWaitSystem:Init()
	self:InitData()
	self:InitView()
end

function NetworkWaitSystem:InitData()
	self.networkWaitView = NetworkWaitView.New()
end

function NetworkWaitSystem:InitView()
	
end


function NetworkWaitSystem:OpenForm(autoCloseTime,delayTime,callBack)
	if autoCloseTime == nil then
		autoCloseTime = -1
	end

	if delayTime == nil then
		delayTime = 0
	end

	if self.networkWaitView then 
		self.networkWaitView:OpenForm(autoCloseTime,delayTime,callBack)
	end
end

function NetworkWaitSystem:CloseForm()
	if self.networkWaitView then 
		self.networkWaitView:CloseForm()
	end
end

function NetworkWaitSystem:__delete()
	self:Close()
	self.networkWaitView:Destroy()
	self.networkWaitView = nil
end
