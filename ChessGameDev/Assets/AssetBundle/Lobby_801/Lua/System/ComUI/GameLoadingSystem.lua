GameLoadingSystem = Class()

local Instance=nil
local GameLoadingForm_Path =CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/ComUI/GameLoadingForm" 
function GameLoadingSystem:ctor()
	Instance=self
	self:Init()
end

function GameLoadingSystem.GetInstance()
	if Instance==nil then
		Instance=GameLoadingSystem.New()
	end
	return Instance
end


function GameLoadingSystem:Init(  )
    self:InitData()
    self:InitView()
end

function GameLoadingSystem:InitData(  )
	self.progress = 0
	self.displayProgress = 0
	self.updateItemNum = -1
	self.isComplete = false
	self.roomExcelData = nil
end

function GameLoadingSystem:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil
	self.loadingFullPath = nil
	self.tipsText = nil
	self.barText = nil
end

function GameLoadingSystem:ReInit( resName )
	self.progress = 0
	self.displayProgress = 0
	self.isComplete = false
	self.updateItemNum = -1
	self.roomExcelData = nil
	self.loadingFullPath = GameLoadingForm_Path.."_"..resName..".prefab"
end

function GameLoadingSystem:Open(resName)
	self:ReInit(resName)

	self:AddEventListenner()
	self:OpenForm()
end

function GameLoadingSystem:Close()
	self:RemoveEventListenner()
	self:CloseForm()
end


function GameLoadingSystem:AddEventListenner()
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.GameProgressBar_EventName,self.UpdateLoadingProgress,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.LoadGameAssetsComplete_EventName,self.LoadGameResComplete,self)
end

function GameLoadingSystem:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.GameProgressBar_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.LoadGameAssetsComplete_EventName)
end



function GameLoadingSystem:OpenForm()
	self:GetUIComponent()
	self:ShowUIComponent()
end

function GameLoadingSystem:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.loadingFullPath,true)

    if form == nil then
        Debug.LogError("打开加载窗口失败："..GameLoadingForm_Path)
        return 
    end

    if self.uiFormScript~=nil and self.uiFormScript ~= form then
        self:RemoveUIComponent()
    end

    if self.uiFormScript == nil then
        self.uiFormScript = form
    end

    if self.formTransform == nil then
        self.formTransform = self.uiFormScript.transform
    end

    if self.formGameObject == nil then
        self.formGameObject = self.uiFormScript.gameObject
    end

    if self.gameObject == nil then
        self.gameObject = self.formGameObject
    end

	if self.tipsText == nil then
		self.tipsText = self.formTransform:Find("tips_content"):GetComponent(typeof(CS.UnityEngine.UI.Text))
	end

	if self.barText == nil then
		self.barText = self.formTransform:Find("tips_content/Loading_TX/Percent"):GetComponent(typeof(CS.UnityEngine.UI.Text))
	end
end

function GameLoadingSystem:ShowUIComponent()
	self.barText.text = "0%"
	if self.updateItemNum == -1 then
		self.updateItemNum = CommonHelper.AddUpdate(self)
	end
end

function GameLoadingSystem:RemoveUIComponent()
    if self.uiFormScript ~= nil then
         XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil
	self.tipsText = nil
	self.barText = nil
	if self.updateItemNum ~= -1 then
		CommonHelper.RemoveUpdate(self.updateItemNum)
	end
	self.updateItemNum = -1
end

function GameLoadingSystem:CloseForm()
	self:RemoveUIComponent()
end

function GameLoadingSystem:Update(  )
	if self.isComplete == true and self.displayProgress == 100 then
		GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.EnteGameRoom_EventName,false,self.roomExcelData)
		self:Close()
	end

	local toProgress = math.ceil(self.progress * 100)

	if self.displayProgress < toProgress then
		self.displayProgress = self.displayProgress + 1
		self.barText.text =self.displayProgress.."%"
	end
end


function GameLoadingSystem:UpdateLoadingProgress(progress)
	self.progress = progress
end

function GameLoadingSystem:LoadGameResComplete(roomExcelData)
	self.progress = 1.0
	self.isComplete = true
	self.roomExcelData = roomExcelData
end

function GameLoadingSystem:__delete()
	self:Close()
end
