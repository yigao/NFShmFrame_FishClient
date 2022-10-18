LobbyDeskView = Class()

function LobbyDeskView:ctor()
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.deskItemList = nil
    self.closeEventScipt = nil
    self.deskItemParent = nil
	self.DeskForm_Path =CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyRoomForm/LobbyDeskForm.prefab"
end

function LobbyDeskView:OpenForm()
    self:GetUIComponent()
    self:ShowUIComponent()
    
end

function LobbyDeskView:GetUIComponent()
    local form = XLuaUIManager.GetInstance():OpenForm(self.DeskForm_Path,true)
    if form == nil then
        Debug.LogError("打开房间列表窗口失败："..self.DeskForm_Path)
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


    if self.deskItemParent == nil then
        self.deskItemParent = self.formTransform:Find("DeskItemPanel/ScrollView/Grid")
    end

    if self.closeEventScipt == nil then 
        local go = self.formTransform:Find("Close").gameObject
        self.closeEventScipt = go:GetComponent(typeof(CS.UIEventScript))
        if self.closeEventScipt == nil then
            self.closeEventScipt = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.closeEventScipt.onPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end

    if self.deskItemList == nil then
        self.deskItemList = {}
        for i = 1,#LobbyRoomSystem.GetInstance().deskVoList do
            local deskVo = LobbyRoomSystem.GetInstance().deskVoList[i]
            local deskItem =LobbyDeskItem.New()
            table.insert(self.deskItemList,deskItem)
        end
    end
end

function LobbyDeskView:ShowUIComponent()
    for i = 1,#LobbyRoomSystem.GetInstance().deskVoList do
        self.deskItemList[i]:Init(LobbyRoomSystem.GetInstance().deskVoList[i],self.deskItemParent)
    end   
end

function LobbyDeskView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    if self.deskItemList then
        for i=1,#self.deskItemList do 
            self.deskItemList[i]:Destroy()
        end
    end
    self.deskItemList = nil

    self.deskItemParent = nil

    if  self.closeEventScipt  ~= nil then
        self.closeEventScipt.onPointerClickCallBack  = nil
    end
    self.closeEventScipt = nil
end

function LobbyDeskView:CreateGameItemView()
    for i = 1,#LobbyRoomSystem.GetInstance().deskVoList do
        local deskVo = LobbyRoomSystem.GetInstance().deskVoList[i]
        local deskItem =LobbyDeskItem.New()
        deskItem:Init(deskVo,self.deskItemParent)
        table.insert(self.deskItemList,deskItem)
    end
end 

function LobbyDeskView:CloseOnPointerClick(eventData)
    LobbyRoomSystem.GetInstance():SendExitRoomReq()
end


function LobbyDeskView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyDeskView:__delete()
    self:RemoveUIComponent()
end