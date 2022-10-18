LobbyBankGiftRecordPanel = Class()

function LobbyBankGiftRecordPanel:ctor()
    self:Init()
end

function LobbyBankGiftRecordPanel:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyBankGiftRecordPanel:InitData(  )
    self.beginIndex = 1
    self.endIndex = 1000
    self.giftRecordList = nil
    self.recordItemList = {}
end

function LobbyBankGiftRecordPanel:InitView(  )
    self.panelTransform = nil
    self.panelGameObject = nil
end

function LobbyBankGiftRecordPanel:ReInit(  )
    self.giftRecordList = nil
end

function LobbyBankGiftRecordPanel:OpenUIPanel(go)
    self:ReInit()
    self:GetUIComponent(go)
    self.uiListScript:ResetContentPosition()
    LobbyBankSystem.GetInstance():RequestBankGiftRecordMsg(self.beginIndex,self.endIndex)
end

function LobbyBankGiftRecordPanel:GetUIComponent(go)
    if self.panelGameObject~=nil and self.panelGameObject~=go then
        self:RemoveUIComponent()
    end

    if self.panelGameObject == nil then
        self.panelGameObject = go
    end

    if self.panelTransform == nil then
        self.panelTransform = self.panelGameObject.transform
    end


    if self.empty_gameObject == nil then
        self.empty_gameObject = self.panelTransform:Find("Empty").gameObject
    end

    if  self.empty_gameObject ~= nil then
        self.empty_gameObject:SetActive(false)
    end
   
    if self.listRecord_gameObject == nil then
        self.listRecord_gameObject = self.panelTransform:Find("RecordItemList").gameObject
    end

    if self.listRecord_gameObject ~= nil then
        self.listRecord_gameObject:SetActive(false)
    end

    if self.uiListScript == nil then
        self.uiListScript = self.panelTransform:Find("RecordItemList"):GetComponent(typeof(CS.UIListScript))
        self.uiListScript.InstantiateElementCallback = function (go) self:CreateRecordItem(go) end
    end

    if self.uiListScript ~= nil then
        self.uiListScript:ResetContentPosition()
    end
end

function LobbyBankGiftRecordPanel:CreateRecordItem(go)
    local recordItem = RecordItem.New(go)
    table.insert(self.recordItemList,recordItem)
end

function LobbyBankGiftRecordPanel:IsDisplayRecordItem(isDisplay)
    CommonHelper.SetActive(self.listRecord_gameObject,isDisplay)
    CommonHelper.SetActive(self.empty_gameObject,not isDisplay)
end

function LobbyBankGiftRecordPanel:ShowUIComponent(giftRecodList)
    self.giftRecordList  = giftRecodList
    if self.giftRecordList ~= nil and #self.giftRecordList > 0 then
        self:IsDisplayRecordItem(true)
        self.uiListScript:SetElementAmount(#self.giftRecordList)
    else
        self:IsDisplayRecordItem(false)
    end
end

function LobbyBankGiftRecordPanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
end

function LobbyBankGiftRecordPanel:CloseForm()
    
end

function LobbyBankGiftRecordPanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
    self.empty_gameObject = nil
   
    self.listRecord_gameObject = nil

    if self.uiListScript ~= nil then
        self.uiListScript.InstantiateElementCallback = nil 
    end
    self.uiListScript = nil

    for i =1,#self.recordItemList do
        self.recordItemList[i]:Destroy()
    end
    self.recordItemList = {}
end

function LobbyBankGiftRecordPanel:__delete()
    self:RemoveUIComponent()
end