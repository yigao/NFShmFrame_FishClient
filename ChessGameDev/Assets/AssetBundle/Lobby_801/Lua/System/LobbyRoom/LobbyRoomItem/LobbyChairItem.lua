LobbyChairItem = Class()

function LobbyChairItem:ctor()
    self.itemGameObject = nil
    self.itemTransform = nil
    self.chairVo = nil
    self.deskId = nil
    self.chairEventScipt = nil
    self.chairIdText = nil
    self.chairStatusText = nil
end

function LobbyChairItem:Init(deskId,chairData,chairItemTrans)
    self.chairVo = chairData
    self.deskId = deskId
    self:GetUIComponent(chairItemTrans)
    self:ShowUIComponent()
end


function LobbyChairItem:GetUIComponent(trans)

    if self.itemTransform~=nil and self.itemTransform ~= trans then
        self:RemoveUIComponent()
    end

    if self.itemTransform == nil then
        self.itemTransform = trans
    end

    if self.itemGameObject == nil then
        self.itemGameObject = self.itemTransform.gameObject
    end

    if self.chairIdText == nil then
        self.chairIdText = self.itemTransform:Find("ChairId"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.chairStatusText == nil then
        self.chairStatusText = self.itemTransform:Find("ChairStaus"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.chairEventScipt == nil then
        self.chairEventScipt = self.itemGameObject:GetComponent(typeof(CS.UIEventScript))
        if self.chairEventScipt == nil then 
            self.chairEventScipt = self.itemGameObject:AddComponent(typeof(CS.UIEventScript))
        end
        self.chairEventScipt.onPointerClickCallBack = function(pointerEventData) self:ChairOnPointerClick(pointerEventData) end
    end
end

function LobbyChairItem:ShowUIComponent()
   self:ShowChairIdUIText()
   self:ShowChairStatusUIText()
end

function LobbyChairItem:ShowChairIdUIText()
    self.chairIdText.text = tostring( self.chairVo.chairId)
end

function LobbyChairItem:ShowChairStatusUIText()
    if self.chairVo.chairStatus == 1 then
        self.chairStatusText.text = "有人"
    else
        self.chairStatusText.text = "无人"
    end
end

function LobbyChairItem:RemoveUIComponent()
    self.itemGameObject = nil
    self.itemTransform = nil
    if  self.chairEventScipt ~= nil then
        self.chairEventScipt.onPointerClickCallBack = nil
    end
    self.chairEventScipt = nil
    self.chairIdText = nil
    self.chairStatusText = nil
end

function LobbyChairItem:ChairOnPointerClick(eventData)
    LobbyRoomSystem.GetInstance():SendChairCheckReq(self.deskId,self.chairVo.chairId)
end

function LobbyChairItem:__delete()
	self:RemoveUIComponent()
end
