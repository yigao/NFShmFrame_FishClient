LobbyRoomItem = Class()

function LobbyRoomItem:ctor(roomData,gameObject,scrollRect,uiFormScript)
    self:Init(roomData,gameObject,scrollRect,uiFormScript)
end

function LobbyRoomItem:Init(roomData,gameObject,scrollRect,uiFormScript)
    self:InitData(roomData)
    self:InitView(gameObject,scrollRect,uiFormScript)
end

function LobbyRoomItem:InitData(roomData)
    self.roomData = roomData
    
    self.Vector2 = CS.UnityEngine.Vector2
    self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
    self.TweenExtensions = CS.DG.Tweening.TweenExtensions

    self.canClick = false
    self.downPosition =  self.Vector2(0,0)
end

function LobbyRoomItem:InitView(gameObject,scrollRect,uiFormScript)
    if self.itemGameObject~=nil and self.itemGameObject ~= gameObject then
        self:RemoveUIComponent()
    end
    self.uiFormScript = uiFormScript
    self.itemGameObject = gameObject
    self.itemTransform = gameObject.transform
    self.scrollRect = scrollRect
end


function LobbyRoomItem:ReInit(  )
    self.canClick = false
    self.downPosition =  self.Vector2(0,0) 
end


function LobbyRoomItem:DisplayRoomItem()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
end

function LobbyRoomItem:GetUIComponent()
    if self.canvasGroup == nil then
        self.canvasGroup = self.itemTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    end

    if self.money_text == nil then
        self.money_text = self.itemTransform:Find("money_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.staus_description == nil then
        self.staus_description = self.itemTransform:Find("staus_description"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.room_status_01_gameObject == nil then
        self.room_status_01_gameObject = self.itemTransform:Find("status_icon_01").gameObject
    end

    if self.room_status_02_gameObject == nil then
        self.room_status_02_gameObject = self.itemTransform:Find("status_icon_02").gameObject
    end

    if self.room_status_03_gameObject == nil then
        self.room_status_03_gameObject = self.itemTransform:Find("status_icon_03").gameObject
    end

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

function LobbyRoomItem:ShowUIComponent()
    self.canvasGroup.alpha = 0

    if self.itemGameObject ~= nil then
        CommonHelper.SetActive(self.itemGameObject,true)
    end
    if self.money_text then
        if self.roomData.enter_min == 0 or self.roomData.enter_min == nil then
            self.money_text.text = "免费体验"
        else
            self.money_text.text = self.roomData.enter_min
        end
    end

    local status = self:GetRoomStatus()
    if status == 1 then
        if self.staus_description then
            self.staus_description.text = "空闲"
        end
        CommonHelper.SetActive(self.room_status_01_gameObject,true)
        CommonHelper.SetActive(self.room_status_02_gameObject,false)
        CommonHelper.SetActive(self.room_status_03_gameObject,false)
    elseif status == 2 then
        if self.staus_description then
            self.staus_description.text = "拥挤"
        end
        CommonHelper.SetActive(self.room_status_01_gameObject,false)
        CommonHelper.SetActive(self.room_status_02_gameObject,true)
        CommonHelper.SetActive(self.room_status_03_gameObject,false)
    elseif status == 3 then
        if self.staus_description then
            self.staus_description.text = "火爆"
        end
        CommonHelper.SetActive(self.room_status_01_gameObject,false)
        CommonHelper.SetActive(self.room_status_02_gameObject,false)
        CommonHelper.SetActive(self.room_status_03_gameObject,true)
    end
end

function LobbyRoomItem:GetRoomStatus(  )
    local status = 1
    local rand = math.random(1,100)
    local time  =math.ceil(tonumber(os.date("%H"))) 
    
    if time >2 and time < 12 then
        if rand>=1 and rand<=80 then
            status = 1
        elseif rand>80 and rand<=90 then
            status = 2
        else
            status = 3
        end
    elseif time >=12 and time<=18 then
        if rand>=1 and rand<=80 then
            status = 2
       elseif rand>80 and rand<=90 then
            status = 1
       else
            status = 3
       end
    else
        if rand>=1 and rand<=80 then
            status = 3
       elseif rand>80 and rand<=90 then
            status = 2
       else
            status = 1
       end
    end
    return status
end


function LobbyRoomItem:PlayAnimation(time)
    self.sequence = self.DOTween.Sequence()
    self.sequence:PrependInterval(time)
    local tempColor = CS.UnityEngine.Color(1,1,1,0)
    local callBack1 = function (  )
		return tempColor
	end
    local callBack2 = function (v)
		tempColor = v
    end
    local alPhaTweener = self.DOTween.ToAlpha(callBack1,callBack2,1,(0.3 + time)) 
    alPhaTweener.onUpdate = function (  )
        self.canvasGroup.alpha = tempColor.a 
    end
    self.sequence:Append(alPhaTweener)
end


function LobbyRoomItem:RemoveUIComponent()
    self.uiFormScript = nil
    self.itemGameObject = nil
    self.itemTransform = nil
    self.canvasGroup = nil
    self.money_text = nil
    self.staus_description = nil
    self.room_status_01_gameObject = nil
    self.room_status_02_gameObject = nil
    self.room_status_03_gameObject = nil 
    
    if self.itemEventScipt ~= nil then
        self.itemEventScipt.onPointerDownCallBack = nil
        self.itemEventScipt.onPointerClickCallBack = nil
        self.itemEventScipt.onBeginDragCallBack = nil
        self.itemEventScipt.onDragCallBack = nil
        self.itemEventScipt.onEndDragCallBack = nil
    end
    self.itemEventScipt = nil
end




function LobbyRoomItem:ItemOnPointerClick(eventData)
    if self.canClick == false then return end
    LobbyRoomSystem.GetInstance():SendDeskListReq(self.roomData.room_id)
end

function LobbyRoomItem:ItemOnPointerDown(eventData)
    self.canClick = true
    self.downPosition = eventData.position
end

function LobbyRoomItem:ItemOnBeginDrag(eventData)
    
    if (self.canClick == true and self.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end
    if self.scrollRect ~= nil then
        self.scrollRect:OnBeginDrag(eventData)
    end
end

function LobbyRoomItem:ItemOnDrag(eventData)
    if (self.canClick == true and self.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end
    
    if self.scrollRect ~= nil then
        self.scrollRect:OnDrag(eventData)
    end
end

function LobbyRoomItem:ItemOnEndDrag(eventData)
    if (self.canClick == true and self.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end

    if self.scrollRect ~= nil then
        self.scrollRect:OnEndDrag(eventData)
    end
end

function LobbyRoomItem:__delete()
    self:RemoveUIComponent()
end
