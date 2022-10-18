LobbyLoadingSystem = Class()

local Instance=nil
function LobbyLoadingSystem:ctor()
	Instance=self
	self:Init()
end

function LobbyLoadingSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyLoadingSystem.New()
	end
	return Instance
end


function LobbyLoadingSystem:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyLoadingSystem:InitData(  )
	self.progress = 0
	self.displayProgress = 0
	self.updateItemNum = -1
	self.isComplete = false
end

function LobbyLoadingSystem:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil

	self.tipsText = nil
	self.barText = nil
end

function LobbyLoadingSystem:ReInit(  )
	self.progress = 0
	self.displayProgress = 0
	self.isComplete = false
	self.updateItemNum = -1
	self.StartUpSystem = CS.StartUpSystem.instance
end

function LobbyLoadingSystem:Open()
	self:ReInit()
	self:AddEventListenner()
	self:OpenForm()
end

function LobbyLoadingSystem:Close()
	self:RemoveEventListenner()
	self:CloseForm()
	self.StartUpSystem:Close()
end


function LobbyLoadingSystem:AddEventListenner()
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.GameProgressBar_EventName,self.UpdateLoadingProgress,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.LoadLobbyAssetsComplete_EventName,self.LoadLobbyResComplete,self)
end

function LobbyLoadingSystem:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.GameProgressBar_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.LoadLobbyAssetsComplete_EventName)
end

function LobbyLoadingSystem:OpenForm()
	self:GetUIComponent()
	self:ShowUIComponent()
end

function LobbyLoadingSystem:GetUIComponent()
	self.StartUpSystem:Open()
	self.gameObject = self.StartUpSystem:GetFormObject()
	self.slider = self.gameObject.transform:Find("ProgressBar"):GetComponent(typeof(CS.UnityEngine.UI.Slider))
	self.barText = self.gameObject.transform:Find("ProgressBar/bar"):GetComponent(typeof(CS.UnityEngine.UI.Text))
end

function LobbyLoadingSystem:ShowUIComponent()
	self.barText.text = "0%"
	self.slider.value = 0
	if self.updateItemNum == -1 then
		self.updateItemNum = CommonHelper.AddUpdate(self)
	end
end

function LobbyLoadingSystem:RemoveUIComponent()
    self.gameObject = nil
	self.slider = nil
	self.barText = nil
	if self.updateItemNum ~= -1 then
		CommonHelper.RemoveUpdate(self.updateItemNum)
	end
	self.updateItemNum = -1
end

function LobbyLoadingSystem:CloseForm()
	self:RemoveUIComponent()
end

function LobbyLoadingSystem:Update(  )
	if self.isComplete == true and self.displayProgress == 100 then
		GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.EnteLobbyLogin_EventName)
		self:Close()
	end

	local toProgress = math.ceil(self.progress * 100)

	if self.displayProgress < toProgress then
		self.displayProgress = self.displayProgress + 1
		self.barText.text = self.displayProgress.."%"
		self.slider.value = self.displayProgress/100
	end
end


function LobbyLoadingSystem:UpdateLoadingProgress(progress)
	self.progress = progress
end

function LobbyLoadingSystem:LoadLobbyResComplete(roomExcelData)
	self.progress = 1.0
	self.isComplete = true
end

function LobbyLoadingSystem:__delete()
	self:Close()
end
