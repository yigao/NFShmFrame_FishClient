LobbyPersonalChangeHeadIconSystem = Class()

local Instance=nil
function LobbyPersonalChangeHeadIconSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function LobbyPersonalChangeHeadIconSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyPersonalChangeHeadIconSystem.New()
	end
	return Instance
end

function LobbyPersonalChangeHeadIconSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbyPersonalChangeHeadIcon/HeadIconItem/HeadIconItem",
		"H/Lua/System/LobbyPersonalChangeHeadIcon/LobbyPersonalChangeHeadIconView",
	}
end


function LobbyPersonalChangeHeadIconSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end


function LobbyPersonalChangeHeadIconSystem:Init()
	self.personalChangeHeadIconView = LobbyPersonalChangeHeadIconView.New()
end

function LobbyPersonalChangeHeadIconSystem:Open()
	self:ReInitData()
	self:OpenForm()
end

function LobbyPersonalChangeHeadIconSystem:ReInitData(  )

end

function LobbyPersonalChangeHeadIconSystem:OpenForm()
	if self.personalChangeHeadIconView then 
		self.personalChangeHeadIconView:OpenForm()
	end
end

function LobbyPersonalChangeHeadIconSystem:Close()
	self:CloseForm()
end

function LobbyPersonalChangeHeadIconSystem:CloseForm()
	if self.personalChangeHeadIconView then 
		self.personalChangeHeadIconView:CloseForm()
	end
end

function LobbyPersonalChangeHeadIconSystem:__delete()
	self:Close()
	self.personalChangeHeadIconView:Destroy()
	self.personalChangeHeadIconView = nil
	self.Instance = nil
end
