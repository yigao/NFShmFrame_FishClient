NetworkWaitView = Class()

function NetworkWaitView:ctor()
    self.NetWaitForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/ComUI/NetworkWaitForm.prefab"	
    self:Init()
end

function NetworkWaitView:Init(  )
    self:InitData()
    self:InitView()
end

function NetworkWaitView:InitData(  )
	self.autoCloseTime = 0
	self.delayTime = 0
	self.timeElapse = 0
    self.callBack = nil
    self.updateItemNum = -1
end

function NetworkWaitView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil
    self.contentGameObject = nil
end

function NetworkWaitView:ReInit(autoCloseTime,delayTime,callBack)
	self.timeElapse = 0
	self.autoCloseTime = autoCloseTime
	self.delayTime = delayTime
    self.callBack = callBack
end

--初始化ui界面
function NetworkWaitView:OpenForm(autoCloseTime,delayTime,callBack)
    self:ReInit(autoCloseTime,delayTime,callBack)
	self:GetUIComponent()
	self:ShowUIComponent()
end


function NetworkWaitView:GetUIComponent()

    local form = CSScript.UIManager:OpenForm(self.NetWaitForm_Path,true)

    if form == nil then
        Debug.LogError("打开网络等待窗口失败："..self.NetWaitForm_Path)
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

    if self.contentGameObject == nil then
        self.contentGameObject = self.formTransform:Find("Context").gameObject
    end
end

function NetworkWaitView:ShowUIComponent()
    CommonHelper.SetActive(self.contentGameObject,false)
    if self.updateItemNum == -1 then
        self.updateItemNum = CommonHelper.AddUpdate(self)
    end
end

function NetworkWaitView:Update()
    self.timeElapse = self.timeElapse + CSScript.Time.deltaTime
    if self.timeElapse >= self.delayTime and  CommonHelper.IsActive(self.contentGameObject) == false then
        CommonHelper.SetActive(self.contentGameObject,true)
    end
    if self.timeElapse >= self.autoCloseTime and self.autoCloseTime>=0 then
        if self.callBack then
            self.callBack()
        end
        self:CloseForm()
    end
end

function NetworkWaitView:CloseForm()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end

    if self.updateItemNum ~= -1 then
        CommonHelper.RemoveUpdate(self.updateItemNum)
        self.updateItemNum = -1
    end
end

function NetworkWaitView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil
    self.contentGameObject = nil
end

function NetworkWaitView:__delete( )
    self:RemoveUIComponent()
end