LobbyGameItem = Class()

function LobbyGameItem:ctor(parent,scrollRect01,scrollRect02,itemData)
    self.ItemVo = itemData
    self.parent = parent
    self.scrollRect01 = scrollRect01
    self.scrollRect02 = scrollRect02
    self.GameItem_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/GameItem/"..self.ItemVo.id..".prefab"
    self:Init()
end

function LobbyGameItem:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyGameItem:InitData(  )
    self.Vector2 = CS.UnityEngine.Vector2
    self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
    self.TweenExtensions = CS.DG.Tweening.TweenExtensions

    self.isDownloadingOrUnzip = false
    self.canClick = false
    self.downPosition = self.Vector2(0,0)
end

function LobbyGameItem:InitView(  )
    self.sequence = nil
    self.canvasGroup = nil
    self.itemGameObject = nil
    self.itemTransform = nil
    self.itemEventScipt = nil
    self.download_gameObject = nil
    self.download_icon_image = nil
    self.download_text = nil
end

function LobbyGameItem:ReInit(  )
    self.canClick = false
    self.isDownloadingOrUnzip = false
    self.downPosition =  self.Vector2(0,0) 
end

function LobbyGameItem:DisplayGameItem()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
end

function LobbyGameItem:GetUIComponent()
    if self.itemGameObject == nil then
        if LobbyManager.GetInstance().gameData.GameItemResList[tostring(self.ItemVo.id)] == nil then
            local prefab = CSScript.ResourceManager:GetResource(self.GameItem_Path,typeof(CSScript.GameObject),false,false).content
            self.itemGameObject = CSScript.GameObject.Instantiate(prefab)
        else
            self.itemGameObject = LobbyManager.GetInstance().gameData.GameItemResList[tostring(self.ItemVo.id)]
        end
    end
   
    if self.itemTransform == nil then
        self.itemTransform = self.itemGameObject.transform
        self.itemTransform:SetParent(self.parent)
        self.itemTransform.localPosition = CSScript.Vector3.zero
        self.itemTransform.localScale= CSScript.Vector3.one
        self.itemTransform.localEulerAngles = CSScript.Vector3.zero
    end

    if self.canvasGroup == nil then
        self.canvasGroup = self.itemTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    end

    if self.download_gameObject == nil then
        self.download_gameObject = self.itemTransform:Find("download").gameObject
    end
 
    if self.download_icon_image == nil then
        self.download_icon_image = self.itemTransform:Find("download/download_icon"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    end

    if self.download_text == nil then
        self.download_text = self.itemTransform:Find("download/down_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
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

function LobbyGameItem:ShowUIComponent()
    if self.sequence ~= nil then
        self.sequence:Kill()
        self.sequence = nil
    end
    self.canvasGroup.alpha = 0
    CommonHelper.SetActive(self.download_gameObject,false)
end

function LobbyGameItem:PlayAnimation(time)
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

function LobbyGameItem:RemoveUIComponent()
    if self.itemGameObject ~= nil then
        CSScript.GameObject:DestroyImmediate(self.itemGameObject)
    end
    self.itemGameObject = nil
    self.itemTransform = nil
    self.canvasGroup = nil 
    self.download_gameObject = nil
    self.download_icon_image = nil
    self.download_text = nil
    if self.itemEventScipt ~= nil then
        self.itemEventScipt.onPointerDownCallBack = nil
        self.itemEventScipt.onPointerClickCallBack = nil
        self.itemEventScipt.onBeginDragCallBack = nil
        self.itemEventScipt.onDragCallBack = nil
        self.itemEventScipt.onEndDragCallBack = nil
    end
    self.itemEventScipt = nil
end

function LobbyGameItem:UpdateGameVersionInfo(gameResVersionInfo,isSelfBtn)
    if gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Wait_Download then
        if CommonHelper.IsActive(self.download_gameObject)  == false then
            CommonHelper.SetActive(self.download_gameObject,true)
        end
        self.download_text.text = "0%" 
        if isSelfBtn == true then
            XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.Game_Downloading_Enter_Queue,"["..self.ItemVo.gameName.."]",nil)
        end   
    elseif gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Downloading then
        self.isDownloadingOrUnzip = true
        if CommonHelper.IsActive(self.download_gameObject)  == false then
            CommonHelper.SetActive(self.download_gameObject,true)
        end
        self.download_text.text = math.ceil(tonumber(gameResVersionInfo.downloadedPercent * 100)).."%" 
    elseif gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Unzip then
        self.isDownloadingOrUnzip = true
        if CommonHelper.IsActive(self.download_gameObject)  == false then
            CommonHelper.SetActive(self.download_gameObject,true)
        end
        self.download_text.text = math.ceil(tonumber(gameResVersionInfo.currentUnzipPercent * 100)).."%" 
    elseif gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Complete then
        CommonHelper.SetActive(self.download_gameObject,false)
        if self.isDownloadingOrUnzip == true then
            if isSelfBtn == true then
                XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.Game_Asset_Download_Succeed,"["..self.ItemVo.gameName.."]",nil)
            end
        else
            if isSelfBtn == true then
                LobbyHallCoreSystem.GetInstance():GetGameRoomInfo(self.ItemVo)
            end
        end
        self.isDownloadingOrUnzip = false
    elseif gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Version_Error then
        if isSelfBtn == true then
            XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.C_Game_Version_File_Error,"["..self.ItemVo.gameName.."]",nil)
        end
    else 
        if isSelfBtn == true then
            XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Download_Game_Asset_Error,"["..self.ItemVo.gameName.."]",nil)
        end
    end
end

function LobbyGameItem:ItemOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if self.canClick == false then return end
    if CS.GameMain.sIntance.DeveloperMode == true then
        LobbyHallCoreSystem.GetInstance():GetGameRoomInfo(self.ItemVo)
    else
        if CS.GameMain.sIntance.UseLocalAssetBundle == false then
            local callback = function (gameResVersionInfo)
                if LobbyHallCoreSystem.GetInstance().hallCoreView.hotGameItemVo and LobbyHallCoreSystem.GetInstance().hallCoreView.hotGameItemVo.id == self.ItemVo.id  then
                    LobbyHallCoreSystem.GetInstance().hallCoreView:UpdateGameVersionInfo(gameResVersionInfo,false)
                end
                self:UpdateGameVersionInfo(gameResVersionInfo,true)
            end
            CSScript.VersionUpdateManager:StartCheckGameVersion(self.ItemVo.id,callback)
        else
            LobbyHallCoreSystem.GetInstance():GetGameRoomInfo(self.ItemVo)
        end
    end
end

function LobbyGameItem:ItemOnPointerDown(eventData)
    self.canClick = true
    self.downPosition = eventData.position
end

function LobbyGameItem:ItemOnBeginDrag(eventData)
    if (self.canClick == true and LobbyHallCoreSystem.GetInstance().hallCoreView.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end
    if self.scrollRect01 ~= nil then
        self.scrollRect01:OnBeginDrag(eventData)
    end
    if self.scrollRect02 ~= nil then
        self.scrollRect02:OnBeginDrag(eventData)
    end
end

function LobbyGameItem:ItemOnDrag(eventData)
    if (self.canClick == true and LobbyHallCoreSystem.GetInstance().hallCoreView.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end
    
    if self.scrollRect01 ~= nil then
        self.scrollRect01:OnDrag(eventData)
    end
    if self.scrollRect02 ~= nil then
        self.scrollRect02:OnDrag(eventData)
    end
end

function LobbyGameItem:ItemOnEndDrag(eventData)
    if (self.canClick == true and LobbyHallCoreSystem.GetInstance().hallCoreView.uiFormScript:ChangeScreenValueToForm(self.Vector2.Distance(eventData.position,self.downPosition)) > 40) then
        self.canClick = false
    end

    if self.scrollRect01 ~= nil then
        self.scrollRect01:OnEndDrag(eventData)
    end
    if self.scrollRect02 ~= nil then
        self.scrollRect02:OnEndDrag(eventData)
    end
end

function LobbyGameItem:__delete()
    self:RemoveUIComponent()
end
