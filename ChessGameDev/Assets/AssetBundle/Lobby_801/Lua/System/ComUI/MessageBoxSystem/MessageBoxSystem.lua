MessageBoxSystem = Class()

local Instance=nil
function MessageBoxSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function MessageBoxSystem.GetInstance()
	if Instance==nil then
		Instance=MessageBoxSystem.New()
	end
	return Instance
end

function MessageBoxSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/ComUI/MessageBoxSystem/MessageBoxView",
	}
end


function MessageBoxSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function MessageBoxSystem:Init()
	self:InitData()
end

function MessageBoxSystem:InitData()
	self.messageBoxView = MessageBoxView.New()
end

function MessageBoxSystem:OpenForm(tipsID,isHaveConfirmBtn,isHaveCancelBtn,isHaveCloseBtn,confirmCallBack,cancelCallBack,closeCallBack,confirmStr,cancelStr,autoCloseTime)
	if confirmStr == nil then
		confirmStr = ""
	end

	if cancelStr == nil then
		cancelStr = ""
	end

	if autoCloseTime == nil then
		autoCloseTime = 0
	end
	local strContent = HallLuaDefine.Tips_Info_Str[tipsID]
	if self.messageBoxView then 
		self.messageBoxView:OpenForm(strContent,isHaveConfirmBtn,isHaveCancelBtn,isHaveCloseBtn,confirmCallBack,cancelCallBack,closeCallBack,confirmStr,cancelStr,autoCloseTime)
	end
end

function MessageBoxSystem:CloseForm()
	if self.messageBoxView then 
		self.messageBoxView:CloseForm()
	end
end

function MessageBoxSystem:__delete()
	self:Close()
	self.messageBoxView:Destroy()
	self.messageBoxView = nil
end
