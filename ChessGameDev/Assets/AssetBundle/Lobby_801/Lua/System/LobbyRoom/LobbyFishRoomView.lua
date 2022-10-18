LobbyFishRoomView = Class()

function LobbyFishRoomView:ctor()
    self.Room_Com_Path =CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyRoomForm/LobbyRoomForm_"
    self:Init()
end

function LobbyFishRoomView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyFishRoomView:InitData(  )
    self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
    self.Ease = CS.DG.Tweening.Ease
    self.UpdateType = CS.DG.Tweening.UpdateType
	self.DOTween = CS.DG.Tweening.DOTween
    self.TweenExtensions = CS.DG.Tweening.TweenExtensions
    self.Vector2 = CS.UnityEngine.Vector2
 
    self.animationCurve = CS.UnityEngine.AnimationCurve()
    self.animationCurve:AddKey(CS.UnityEngine.Keyframe(0,-0.0046,3.1270,3.1270))
    self.animationCurve:AddKey(CS.UnityEngine.Keyframe(0.4413,0.9922,0.2997817,0.2997817))
    self.animationCurve:AddKey(CS.UnityEngine.Keyframe(0.7179,1.041279,0.0155,0.0155))
    self.animationCurve:AddKey(CS.UnityEngine.Keyframe(1,1, 0.2432,0.2432))

    self.tween1 = nil
    self.tween2 = nil
end

function LobbyFishRoomView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.roomItemListTrans = nil
    self.scrollRect = nil
    self.contentRectTrans = nil
    self.horizontalLayoutGroup = nil
    self.roomItemList = nil
    self.roomItemParent = nil
    self.closeEventScript = nil
    self.introductionEventScipt = nil
end

function LobbyFishRoomView:OpenForm()
    self:GetUIComponent()
    self:ShowUIComponent()
end

function LobbyFishRoomView:GetUIComponent()

    local room_path =self.Room_Com_Path..LobbyRoomSystem.GetInstance().gameItemVo.id..".prefab"

    
    local form = XLuaUIManager.GetInstance():OpenForm(room_path,true)

    if form == nil then
        Debug.LogError("打开房间列表窗口失败："..room_path)
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

    if self.roomItemListTrans == nil then
        self.roomItemListTrans = self.formTransform:Find("RoomItemPanel")
    end

    if self.scrollRect == nil then
        self.scrollRect = self.formTransform:Find("RoomItemPanel/ScrollView"):GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
    end

    if self.contentRectTrans == nil then
        self.contentRectTrans = self.formTransform:Find("RoomItemPanel/ScrollView/Viewport/Content"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    end
    
    if self.horizontalLayoutGroup == nil then
        self.horizontalLayoutGroup = self.formTransform:Find("RoomItemPanel/ScrollView/Viewport/Content"):GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
    end

    if self.roomItemParent == nil then
        self.roomItemParent = self.formTransform:Find("RoomItemPanel/ScrollView/Viewport/Content").transform
    end

    if self.titleTrans == nil then
        self.titleTrans = self.formTransform:Find("TopPanel/Title")
    end

    if self.closeEventScript == nil then 
        local go = self.formTransform:Find("TopPanel/Return_Btn").gameObject
        self.closeEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScript == nil then
            self.closeEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    
    if  self.closeEventScript ~= nil and self.closeEventScript.onMiniPointerClickCallBack==nil then
        self.closeEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end

    if self.introductionEventScipt == nil then
        local go = self.formTransform:Find("TopPanel/Tips_Btn").gameObject
        self.introductionEventScipt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.introductionEventScipt == nil then
            self.introductionEventScipt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if  self.introductionEventScipt ~= nil and self.introductionEventScipt.onMiniPointerClickCallBack==nil then
        self.introductionEventScipt.onMiniPointerClickCallBack = function(pointerEventData) self:IntroductionPointerClick(pointerEventData) end
    end

    if self.roomItemList == nil then
        --判断是不是有体验场
        local begin = 2
        for i = 1,#LobbyRoomSystem.GetInstance().roomVoList do
            if LobbyRoomSystem.GetInstance().roomVoList[i].enter_min == 0 then
                begin = 1
                break
            end
        end
        ----------------------
        local index = 1
        self.roomItemList = {}
        for i=1,self.roomItemParent.childCount do
            local room_item_transform = self.roomItemParent:GetChild(i-1)
            local room_item_gameObject = room_item_transform.gameObject
            if i >= begin then
                if index <= #LobbyRoomSystem.GetInstance().roomVoList then
                    local roomVo = LobbyRoomSystem.GetInstance().roomVoList[index]
                    local roomItem =LobbyRoomItem.New(roomVo,room_item_gameObject,self.scrollRect,self.uiFormScript)
                    table.insert(self.roomItemList,roomItem)
                    index = index + 1
                end
            end
            CommonHelper.SetActive(room_item_gameObject,false)
        end
    end
end

function LobbyFishRoomView:ShowUIComponent()
    if self.tween1 ~= nil then
        self.tween1:Kill()
        self.tween1 = nil
    end

    if self.tween2 ~= nil then
        self.tween2:Kill()
        self.tween2 = nil
    end

    if self.titleTrans then
        self.titleTrans.localPosition = CSScript.Vector3(0,115,0)
    end

    if self.roomItemListTrans then
        self.roomItemListTrans.localPosition = CSScript.Vector3(280,-45,0)
    end
    self:SetHorizontalLayoutGroupParam()
    if self.roomItemList ~= nil then
        for i=1,#self.roomItemList do 
            self.roomItemList[i]:DisplayRoomItem()
        end
    end
  
    self:PlayAnimation()
end

function LobbyFishRoomView:SetHorizontalLayoutGroupParam( ... )
    if #self.roomItemList <= 4 then
        self.horizontalLayoutGroup.padding.left = 0
        self.horizontalLayoutGroup.padding.right = 0
        self.horizontalLayoutGroup.padding.bottom = 0
        self.horizontalLayoutGroup.padding.top = 0
        self.horizontalLayoutGroup.childAlignment = CS.UnityEngine.TextAnchor.UpperCenter
        self.contentRectTrans.pivot = self.Vector2(0.5,0.5)
    else
        self.horizontalLayoutGroup.padding.left = 0
        self.horizontalLayoutGroup.padding.right = 0
        self.horizontalLayoutGroup.padding.bottom = 0
        self.horizontalLayoutGroup.padding.top = 0
        self.horizontalLayoutGroup.childAlignment = CS.UnityEngine.TextAnchor.UpperLeft
        self.contentRectTrans.pivot = self.Vector2(0,0.5)
    end
end

function LobbyFishRoomView:PlayAnimation(  )
    self.tween1 = self.roomItemListTrans:DOLocalMoveX(0,0.42)
    self.tween1:SetEase(self.animationCurve)
    self.tween2 = self.titleTrans:DOLocalMoveY(0,0.42)
    self.tween2:SetEase(self.Ease.OutCubic)
    local time = 0
    for i = 1,#self.roomItemList do
        self.roomItemList[i]:PlayAnimation(time)
        time = time + 0.04
    end
end

function LobbyFishRoomView:IntroductionPointerClick(eventData)
    GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.OpenGameIntroduction_EventName)
end

function LobbyFishRoomView:CloseOnPointerClick(eventData)
    LobbyRoomSystem.GetInstance():RoomSwitchToLobby()
end

function LobbyFishRoomView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.roomItemListTrans = nil
    self.scrollRect = nil
    self.contentRectTrans = nil
    self.horizontalLayoutGroup = nil
    if self.roomItemList then
        for i = 1,#self.roomItemList do 
            self.roomItemList[i]:Destroy()
        end
    end
    self.roomItemList = nil
    self.roomItemParent = nil
    self.titleTrans = nil
    if self.closeEventScript ~= nil then
        self.closeEventScript.onMiniPointerClickCallBack = nil
    end
    self.closeEventScript = nil

    if self.introductionEventScipt ~= nil then
        self.introductionEventScipt.onMiniPointerClickCallBack = nil
    end
    self.introductionEventScipt = nil
end

function LobbyFishRoomView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyFishRoomView:__delete()
	self:RemoveUIComponent()
end