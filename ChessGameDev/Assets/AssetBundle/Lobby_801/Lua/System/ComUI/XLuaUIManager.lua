XLuaUIManager = Class()

local Instance=nil
function XLuaUIManager:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:AddEventListenner()
end


function XLuaUIManager.GetInstance()
	if Instance==nil then
		Instance=XLuaUIManager.New()
	end
	return Instance
end

function XLuaUIManager:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/ComUI/TipsSystem/TipsSystem",
		"H/Lua/System/ComUI/MessageBoxSystem/MessageBoxSystem",
		"H/Lua/System/ComUI/NetworkWaitSystem/NetworkWaitSystem",
	}
end


function XLuaUIManager:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function XLuaUIManager:AddEventListenner(  )
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.GameEventOpenTipsForm_EventName,self.EventOpenUITipsForm,self)
end

function XLuaUIManager:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.GameEventOpenTipsForm_EventName)
end


function XLuaUIManager:EventOpenUITipsForm(strContent,lifeTime)
	if strContent == nil then return end
	self:OpenTipsFormContent(strContent,lifeTime)
end

function XLuaUIManager:OpenForm(formPath,useFormPool,useCameraRenderMode)
	if useCameraRenderMode == nil then
		useCameraRenderMode = true
	end
	return CSScript.UIManager:OpenForm(formPath,useFormPool,useCameraRenderMode)
end

function XLuaUIManager:CloseForm(formScript)
	CSScript.UIManager:CloseForm(formScript)
end

function XLuaUIManager:CloseAllForm()
	CSScript.UIManager:CloseAllForm(nil,true,false)
end

function XLuaUIManager:OpenNetWaitForm(autoCloseTime,delayTime,callBack)
	NetworkWaitSystem.GetInstance():OpenForm(autoCloseTime,delayTime,callBack)
end

function XLuaUIManager:CloseNetWaitForm()
	NetworkWaitSystem.GetInstance():CloseForm()
end

function XLuaUIManager:OpenMessageBox(strContent,isHaveConfirmBtn,isHaveCancelBtn,isHaveCloseBtn,confirmCallBack,cancelCallBack,closeCallBack,confirmStr,cancelStr,autoCloseTime)
	MessageBoxSystem.GetInstance():OpenForm(strContent,isHaveConfirmBtn,isHaveCancelBtn,isHaveCloseBtn,confirmCallBack,cancelCallBack,closeCallBack,confirmStr,cancelStr,autoCloseTime)
	
end

function XLuaUIManager:CloseMessageBox()
	MessageBoxSystem.GetInstance():CloseForm()
end

function XLuaUIManager:OpenTipsForm(tipID,prefix,suffix,lifeTime)
	if tipID == nil then return end
	TipsSystem.GetInstance():OpenForm(tipID,prefix,suffix,lifeTime)
end

function XLuaUIManager:OpenTipsFormContent(strContent,lifeTime)
	TipsSystem.GetInstance():OpenTipsFormContent(strContent,lifeTime)
end


function XLuaUIManager:CloseAllTipsForm()
	TipsSystem.GetInstance():CloseAllForm()
end

function XLuaUIManager:__delete()
	self:RemoveEventListenner()
	self.Instance = nil
end