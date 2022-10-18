HeadIconItem = Class()

function HeadIconItem:ctor(go,id,scrollRect)
    self:Init(go,id,scrollRect)
end

function HeadIconItem:Init(go,id,scrollRect)
    self:InitData(id)
    self:InitView(go,scrollRect)
end

function HeadIconItem:InitData(id)
    self.id = id
    self.Vector2 = CS.UnityEngine.Vector2
    self.canClick = false
    self.downPosition = self.Vector2(0,0)
end

function HeadIconItem:InitView(go,scrollRect)
    self.itemGameObject = go
    self.itemTransform = go.transform
    self.scrollRect = scrollRect
    self:GetUIComponent()
end

function HeadIconItem:GetUIComponent()
    self.xuanzhong_gameObject = self.itemTransform:Find("Xuanzhong").gameObject

    if self.itemEventScipt == nil then
        self.itemEventScipt = self.itemGameObject:GetComponent(typeof(CS.UIEventScript))
        if self.itemEventScipt == nil then 
            self.itemEventScipt = self.itemGameObject:AddComponent(typeof(CS.UIEventScript))
        end
    end

    if self.itemEventScipt ~= nil and self.itemEventScipt.onPointerDownCallBack == nil then
        self.itemEventScipt.onPointerDownCallBack = function(pointerEventData) self:ItemOnPointerDown(pointerEventData) end
    end

    if self.itemEventScipt ~= nil and self.itemEventScipt.onPointerClickCallBack == nil then
        self.itemEventScipt.onPointerClickCallBack = function(pointerEventData) self:ItemOnPointerClick(pointerEventData) end
    end

    if self.itemEventScipt ~= nil and self.itemEventScipt.onBeginDragCallBack == nil then
        self.itemEventScipt.onBeginDragCallBack = function(pointerEventData) self:ItemOnBeginDrag(pointerEventData) end
    end

    if self.itemEventScipt ~= nil and self.itemEventScipt.onDragCallBack == nil then
        self.itemEventScipt.onDragCallBack = function(pointerEventData) self:ItemOnDrag(pointerEventData) end 
    end

    if self.itemEventScipt ~= nil and self.itemEventScipt.onEndDragCallBack == nil then
        self.itemEventScipt.onEndDragCallBack = function(pointerEventData) self:ItemOnEndDrag(pointerEventData) end
    end
end

function HeadIconItem:ReInit()
    self.canClick = false
    self.downPosition =  self.Vector2(0,0)
end

function HeadIconItem:ShowHeadIconKung(  )
    CommonHelper.SetActive(self.xuanzhong_gameObject,true)
end

function HeadIconItem:HideHeadIconKuang(  )
    CommonHelper.SetActive(self.xuanzhong_gameObject,false)
end

function HeadIconItem:ItemOnPointerClick(eventData)
    if self.canClick == false then return end
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyPersonalChangeHeadIconSystem.GetInstance().personalChangeHeadIconView:ShowHeadIconItem(self.id)
    LobbyHallCoreSystem.GetInstance():RequestHeadImageMsg(self.id)
end

function HeadIconItem:ItemOnPointerDown(eventData)
    self.canClick = true
    self.downPosition = eventData.position
end

function HeadIconItem:ItemOnBeginDrag(eventData)
    if (self.canClick == true and LobbyPersonalChangeHeadIconSystem.GetInstance().personalChangeHeadIconView.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end
    if self.scrollRect ~= nil then
        self.scrollRect:OnBeginDrag(eventData)
    end
end

function HeadIconItem:ItemOnDrag(eventData)
    if (self.canClick == true and LobbyPersonalChangeHeadIconSystem.GetInstance().personalChangeHeadIconView.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end
    
    if self.scrollRect ~= nil then
        self.scrollRect:OnDrag(eventData)
    end
end

function HeadIconItem:ItemOnEndDrag(eventData)
    if (self.canClick == true and LobbyPersonalChangeHeadIconSystem.GetInstance().personalChangeHeadIconView.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end

    if self.scrollRect ~= nil then
        self.scrollRect:OnEndDrag(eventData)
    end
end

function HeadIconItem:RemoveUIComponent()
    self.itemGameObject = nil
    self.itemTransform = nil
   
    self.xuanzhong_gameObject = nil

    if self.itemEventScipt ~= nil then
        self.itemEventScipt.onPointerDownCallBack = nil
        self.itemEventScipt.onPointerClickCallBack = nil
        self.itemEventScipt.onBeginDragCallBack = nil
        self.itemEventScipt.onDragCallBack = nil
        self.itemEventScipt.onEndDragCallBack = nil
    end
    self.itemEventScipt = nil
end

function HeadIconItem:__delete()
	self:RemoveUIComponent()
end
