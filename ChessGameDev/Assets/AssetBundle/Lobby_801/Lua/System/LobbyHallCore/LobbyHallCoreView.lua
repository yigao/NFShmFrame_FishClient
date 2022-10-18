LobbyHallCoreView = Class()

function LobbyHallCoreView:ctor()
    self.HallCoreForm_Path =CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyHallCoreForm/LobbyHallCoreForm.prefab"
    self:Init()
end

function LobbyHallCoreView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyHallCoreView:InitData(  )
    self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
    self.TweenExtensions = CS.DG.Tweening.TweenExtensions
    self.animationCurve = CS.UnityEngine.AnimationCurve()
    self.animationCurve:AddKey(CS.UnityEngine.Keyframe(0,-0.0046,3.1270,3.1270))
    self.animationCurve:AddKey(CS.UnityEngine.Keyframe(0.6413,0.9922,0.0080,0.0080))
    self.animationCurve:AddKey(CS.UnityEngine.Keyframe(0.8179,0.9702,0.0155,0.0155))
    self.animationCurve:AddKey(CS.UnityEngine.Keyframe(1,1, 0.2432,0.2432))
   
    self.tween1 = nil
    self.tween2 = nil
    self.tween3 = nil
    self.alphaSequence = nil
    self.particleSequence = nil
    self.hotGameItemVo = nil
end

function LobbyHallCoreView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.RightPanel = nil
    self.RightFunctionBtnTrans = nil
    self.RightFunctionBtnCanvaGroup = nil
    self.TopPanel = nil
    self.TopFunctionBtnTrans = nil
    self.CenterPanel = nil
    self.CenterPanelTrans = nil
    self.BottomPanel = nil
    self.GamePanel = nil
    self.FishModulePanel = nil
    self.ArcadeModulePanel = nil
    self.ChessModulePanel = nil

    self.moduleParticleList = nil
    self.moduleCanvasGroupList = nil
    self.RecommendModule_GameObject = nil
    self.FishModule_GameObject = nil
    self.ArcadeModule_GameObject = nil
    self.ChessModule_GameObject = nil
    self.recommendModuleEventScript = nil 
    self.fishModuleEventScript = nil 
    self.arcadeModuleEventScript = nil
    self.chessModuleEventScript = nil 

    self.settingEventScript = nil
    
    self.serviceEventScript = nil
    self.rankEventScript = nil
    self.bankEventScript = nil
    self.activityEventScript = nil
    self.emialPoint_gameObject = nil
    self.emailEventScript = nil
    self.rechargelEventScript  = nil
    self.userHeadEventScript = nil
    self.user_name_text = nil
    self.head_image = nil
    self.itemParent = nil
    self.gameItemMap = nil
end

function LobbyHallCoreView:OpenForm()

    self:GetUIComponent()

    self:ShowUIComponent()
end

function LobbyHallCoreView:GetUIComponent()
    local form = CSScript.UIManager:OpenForm(self.HallCoreForm_Path,true)

    if form == nil then
        Debug.LogError("打开主界面窗口失败："..self.HallCoreForm_Path)
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

    if self.RightPanel == nil then
        self.RightPanel = self.formTransform:Find("RightPanel").gameObject
    end

    if self.RightFunctionBtnTrans == nil then
        self.RightFunctionBtnTrans = self.formTransform:Find("RightPanel/FunctionBtn")
    end

    if self.RightFunctionBtnCanvaGroup == nil then
        self.RightFunctionBtnCanvaGroup = self.RightFunctionBtnTrans:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    end

    if self.TopPanel == nil then
        self.TopPanel = self.formTransform:Find("TopPanel").gameObject
    end

    if self.TopFunctionBtnTrans == nil then
        self.TopFunctionBtnTrans = self.formTransform:Find("TopPanel/FunctionBtn")
    end

    if self.CenterPanel == nil then
        self.CenterPanel = self.formTransform:Find("CenterPanel").gameObject
        self.CenterPanelTrans  = self.CenterPanel.transform
    end
    
    if self.BottomPanel == nil then
        self.BottomPanel = self.formTransform:Find("BottomPanel").gameObject
    end
    
    if self.GamePanel == nil then
        self.GamePanel = self.formTransform:Find("GamePanel").gameObject
    end

    if self.FishModulePanel == nil then
        self.FishModulePanel = self.formTransform:Find("GamePanel/FishModulePanel").gameObject
    end

    if self.ArcadeModulePanel == nil then
        self.ArcadeModulePanel = self.formTransform:Find("GamePanel/ArcadeModulePanel").gameObject
    end

    if self.ChessModulePanel == nil then
        self.ChessModulePanel = self.formTransform:Find("GamePanel/ChessModulePanel").gameObject
    end

    self.recommend_download_gameObject = self.formTransform:Find("CenterPanel/RecommendModule/download").gameObject
    self.recommend_download_iamge = self.recommend_download_gameObject:GetComponent(typeof(CS.UnityEngine.UI.Image))

    self.recommend_unzip_gameObject = self.formTransform:Find("CenterPanel/RecommendModule/unzip").gameObject
    self.recommend_unzip_text = self.formTransform:Find("CenterPanel/RecommendModule/unzip/unzip_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))

    if self.recommendModuleEventScript == nil then
        local go = self.formTransform:Find("CenterPanel/RecommendModule").gameObject
        self.RecommendModule_GameObject = go
        self.recommendModuleEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.recommendModuleEventScript == nil then 
            self.recommendModuleEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.recommendModuleEventScript ~= nil and self.recommendModuleEventScript.onMiniPointerClickCallBack == nil then
        self.recommendModuleEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:RecommendModuleOnPointerClick(pointerEventData) end
    end

    if self.fishModuleEventScript == nil then
        local go = self.formTransform:Find("CenterPanel/FishModule").gameObject
        self.FishModule_GameObject = go
        self.fishModuleEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.fishModuleEventScript == nil then 
            self.fishModuleEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.fishModuleEventScript ~= nil and self.fishModuleEventScript.onMiniPointerClickCallBack == nil then
        self.fishModuleEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:FishModuleOnPointerClick(pointerEventData) end
    end

    if self.arcadeModuleEventScript == nil then
        local go = self.formTransform:Find("CenterPanel/ArcadeModule").gameObject
        self.ArcadeModule_GameObject = go
        self.arcadeModuleEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.arcadeModuleEventScript == nil then 
            self.arcadeModuleEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.arcadeModuleEventScript ~= nil and self.arcadeModuleEventScript.onMiniPointerClickCallBack == nil then
        self.arcadeModuleEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ArcadeModuleOnPointerClick(pointerEventData) end
    end

    if self.chessModuleEventScript == nil then
        local go = self.formTransform:Find("CenterPanel/ChessModule").gameObject
        self.ChessModule_GameObject = go
        self.chessModuleEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.chessModuleEventScript == nil then 
            self.chessModuleEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.chessModuleEventScript ~= nil and self.chessModuleEventScript.onMiniPointerClickCallBack == nil then
        self.chessModuleEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ChessModuleOnPointerClick(pointerEventData) end
    end

    self.moduleParticleList = {}
    self.moduleCanvasGroupList = {}
    if self.RecommendModule_GameObject ~= nil then
        local canvasGroup = self.RecommendModule_GameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
        if canvasGroup == nil then
            canvasGroup = self.RecommendModule_GameObject:AddComponent(typeof(CS.UnityEngine.CanvasGroup))
        end
        table.insert(self.moduleCanvasGroupList,canvasGroup)
    end

    
    if self.FishModule_GameObject ~= nil then
        local canvasGroup = self.FishModule_GameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
        if canvasGroup == nil then
            canvasGroup = self.FishModule_GameObject:AddComponent(typeof(CS.UnityEngine.CanvasGroup))
        end
        table.insert(self.moduleCanvasGroupList,canvasGroup)
    end

    if self.ArcadeModule_GameObject ~= nil then
        local canvasGroup = self.ArcadeModule_GameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
        if canvasGroup == nil then
            canvasGroup = self.ArcadeModule_GameObject:AddComponent(typeof(CS.UnityEngine.CanvasGroup))
        end
        table.insert(self.moduleCanvasGroupList,canvasGroup)
    end

    if self.ArcadeModule_GameObject ~= nil then
        local go1 = self.ArcadeModule_GameObject.transform:Find("Animator/JJ_71").gameObject
        local go2 = self.ArcadeModule_GameObject.transform:Find("Animator/JJ_72").gameObject
        local go3 = self.ArcadeModule_GameObject.transform:Find("Animator/JJ_73").gameObject
        table.insert(self.moduleParticleList,go1)
        table.insert(self.moduleParticleList,go2)
        table.insert(self.moduleParticleList,go3)
    end

    if self.ChessModule_GameObject ~= nil then
        local canvasGroup = self.ChessModule_GameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
        if canvasGroup == nil then
            canvasGroup = self.ChessModule_GameObject:AddComponent(typeof(CS.UnityEngine.CanvasGroup))
        end
        table.insert(self.moduleCanvasGroupList,canvasGroup)
    end

    
    if self.settingEventScript == nil then
        local go = self.formTransform:Find("TopPanel/FunctionBtn/Setting_Btn").gameObject
        self.settingEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.settingEventScript == nil then 
            self.settingEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.settingEventScript ~= nil and self.settingEventScript.onMiniPointerClickCallBack == nil then
        self.settingEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:SettingOnPointerClick(pointerEventData) end
    end

    if self.serviceEventScript == nil then
        local go = self.formTransform:Find("RightPanel/FunctionBtn/Service_Btn").gameObject
        self.serviceEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.serviceEventScript == nil then 
            self.serviceEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.serviceEventScript ~= nil and self.serviceEventScript.onMiniPointerClickCallBack == nil then
        self.serviceEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ServiceOnPointerClick(pointerEventData) end
    end

    if self.rankEventScript == nil then
        local go = self.formTransform:Find("RightPanel/FunctionBtn/Rank_Btn").gameObject
        self.rankEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.rankEventScript == nil then 
            self.rankEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.rankEventScript ~= nil and self.rankEventScript.onMiniPointerClickCallBack == nil then
        self.rankEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:RankOnPointerClick(pointerEventData) end
    end


    if self.bankEventScript == nil then
        local go = self.formTransform:Find("RightPanel/FunctionBtn/Bank_Btn").gameObject
        self.bankEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.bankEventScript == nil then 
            self.bankEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.bankEventScript ~= nil and self.bankEventScript.onMiniPointerClickCallBack == nil then
        self.bankEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:BankOnPointerClick(pointerEventData) end
    end

    if self.activityEventScript == nil then
        local go = self.formTransform:Find("RightPanel/FunctionBtn/Activity_Btn").gameObject
        self.activityEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.activityEventScript == nil then 
            self.activityEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.activityEventScript ~= nil and self.activityEventScript.onMiniPointerClickCallBack == nil then
        self.activityEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ActivityOnPointerClick(pointerEventData) end
    end
    

    if  self.emialPoint_gameObject == nil then
        self.emialPoint_gameObject = self.formTransform:Find("RightPanel/FunctionBtn/Email_Btn/point").gameObject
        self.emialPoint_gameObject:SetActive(false)
    end

    if self.emailEventScript == nil then
        local go = self.formTransform:Find("RightPanel/FunctionBtn/Email_Btn").gameObject
        self.emailEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.emailEventScript == nil then 
            self.emailEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.emailEventScript ~= nil and self.emailEventScript.onMiniPointerClickCallBack == nil then
        self.emailEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:EmailOnPointerClick(pointerEventData) end
    end

    if self.rechargelEventScript == nil then
        local go = self.formTransform:Find("BottomPanel/Rechargel_Btn").gameObject
        self.rechargelEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.rechargelEventScript == nil then 
            self.rechargelEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.rechargelEventScript ~= nil and self.rechargelEventScript.onMiniPointerClickCallBack == nil then
        self.rechargelEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:RechargelOnPointerClick(pointerEventData) end
    end

    if self.userHeadEventScript == nil then
        local go = self.formTransform:Find("BottomPanel/UserInfo/Head_btn").gameObject
        self.userHeadEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.userHeadEventScript == nil then 
            self.userHeadEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.userHeadEventScript ~= nil and  self.userHeadEventScript.onMiniPointerClickCallBack == nil then
        self.userHeadEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:UserHeadOnPointerClick(pointerEventData) end
    end

    if self.user_name_text == nil then
        self.user_name_text = self.formTransform:Find("BottomPanel/UserInfo/user_name_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.head_image == nil then
        self.head_image = self.formTransform:Find("BottomPanel/UserInfo/Head_btn/head_image"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    end

    if self.gameMoney_text == nil then
        self.gameMoney_text = self.formTransform:Find("BottomPanel/UserInfo/GameMoney/money_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.bankMoney_text == nil then
        self.bankMoney_text = self.formTransform:Find("BottomPanel/UserInfo/BankMoney/money_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end
end

function LobbyHallCoreView:ShowUIComponent()
    CommonHelper.SetActive(self.recommend_download_gameObject,false)
    CommonHelper.SetActive(self.recommend_unzip_gameObject,false)
    self.hotGameItemVo = LobbyHallCoreSystem.GetInstance():GetHotGameItemData()
    self:IsShowFunctionPanel(true)
    self:ShowMoneyPanel()
    self:ShowUserInfoPanel()
    self:PlayAnimation()
end


function LobbyHallCoreView:RecommendModuleOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
   
    if self.hotGameItemVo == nil then return end
   
    if self.hotGameItemVo.gameType == 1 then
        LobbyHallCoreSystem.GetInstance().curSelectGameType = LobbyHallCoreSystem.GetInstance().GameType.Arcade
    elseif  self.hotGameItemVo.gameType == 2 then
        LobbyHallCoreSystem.GetInstance().curSelectGameType = LobbyHallCoreSystem.GetInstance().GameType.Fish
    elseif self.hotGameItemVo.gameType == 3 or self.hotGameItemVo.gameType == 4 then
        LobbyHallCoreSystem.GetInstance().curSelectGameType = LobbyHallCoreSystem.GetInstance().GameType.Chess
    end
  
    if CS.GameMain.sIntance.DeveloperMode == true then
        LobbyHallCoreSystem.GetInstance():GetGameRoomInfo(self.hotGameItemVo)
    else
        if CS.GameMain.sIntance.UseLocalAssetBundle == false then
            local callback = function (gameResVersionInfo)
                local hotGameItemView  = LobbyHallCoreSystem.GetInstance():GetHotGameItemView(self.hotGameItemVo.id)
                if hotGameItemView and hotGameItemView.ItemVo.id == self.hotGameItemVo.id then
                    hotGameItemView:UpdateGameVersionInfo(gameResVersionInfo,false)
                end
                self:UpdateGameVersionInfo(gameResVersionInfo,true)
            end
            CSScript.VersionUpdateManager:StartCheckGameVersion(self.hotGameItemVo.id,callback)
        else
            LobbyHallCoreSystem.GetInstance():GetGameRoomInfo(self.hotGameItemVo)
        end
    end
end

function LobbyHallCoreView:UpdateGameVersionInfo(gameResVersionInfo,isSelfBtn)
    if gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Wait_Download then
        if CommonHelper.IsActive(self.recommend_download_gameObject)  == false then
            CommonHelper.SetActive(self.recommend_download_gameObject,true)
        end
        self.recommend_download_iamge.fillAmount = 1
        if isSelfBtn == true then
            XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.Game_Downloading_Enter_Queue,"["..self.hotGameItemVo.gameName.."]",nil)
        end
    elseif gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Downloading then
        self.isDownloadingOrUnzip = true
        if CommonHelper.IsActive(self.recommend_download_gameObject)  == false then
            CommonHelper.SetActive(self.recommend_download_gameObject,true)
        end
        self.recommend_download_iamge.fillAmount = 1 - tonumber(gameResVersionInfo.downloadedPercent) 
    elseif gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Unzip then
        self.isDownloadingOrUnzip = true
        if CommonHelper.IsActive(self.recommend_download_gameObject)  == true then
            CommonHelper.SetActive(self.recommend_download_gameObject,false)
        end
        if CommonHelper.IsActive(self.recommend_unzip_gameObject)  == false then
            CommonHelper.SetActive(self.recommend_unzip_gameObject,true)
        end
        self.recommend_unzip_text.text = math.ceil(tonumber(gameResVersionInfo.currentUnzipPercent * 100)).."%" 
    elseif gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Complete then
        CommonHelper.SetActive(self.recommend_download_gameObject,false)
        CommonHelper.SetActive(self.recommend_unzip_gameObject,false)
        if self.isDownloadingOrUnzip == true then
            if isSelfBtn == true then
                XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.Game_Asset_Download_Succeed,"["..self.hotGameItemVo.gameName.."]",nil)
            end
        else
            if isSelfBtn == true then
                LobbyHallCoreSystem.GetInstance():GetGameRoomInfo(self.hotGameItemVo)
            end
        end
        self.isDownloadingOrUnzip = false
    elseif gameResVersionInfo.gameVersionStatus == CS.GameVersionStatus.Version_Error then
        if isSelfBtn == true then
            XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.C_Game_Version_File_Error,"["..self.hotGameItemVo.gameName.."]",nil)
        end
    else 
        if isSelfBtn == true then
            XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Download_Game_Asset_Error,"["..self.hotGameItemVo.gameName.."]",nil)
        end
    end
end

function LobbyHallCoreView:FishModuleOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    if LobbyHallCoreSystem.GetInstance().hallFishModulePanel then
        LobbyHallCoreSystem.GetInstance().curSelectGameType = LobbyHallCoreSystem.GetInstance().GameType.Fish
        self:IsShowFunctionPanel(false)
        self:IsShowGameModulePanel()
        LobbyHallCoreSystem.GetInstance().hallFishModulePanel:OpenUIPanel(self.FishModulePanel)
    end
end

function LobbyHallCoreView:ArcadeModuleOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    
    if LobbyHallCoreSystem.GetInstance().hallArcadeModulePanel then
        LobbyHallCoreSystem.GetInstance().curSelectGameType = LobbyHallCoreSystem.GetInstance().GameType.Arcade
        self:IsShowFunctionPanel(false)
        self:IsShowGameModulePanel()
        LobbyHallCoreSystem.GetInstance().hallArcadeModulePanel:OpenUIPanel(self.ArcadeModulePanel)
    end
end

function LobbyHallCoreView:ChessModuleOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    
    if LobbyHallCoreSystem.GetInstance().hallChessModulePanel then
        LobbyHallCoreSystem.GetInstance().curSelectGameType = LobbyHallCoreSystem.GetInstance().GameType.Chess 
        self:IsShowFunctionPanel(false)
        self:IsShowGameModulePanel()
        LobbyHallCoreSystem.GetInstance().hallChessModulePanel:OpenUIPanel(self.ChessModulePanel)
    end
end



function LobbyHallCoreView:PlayAnimation(  )
    if self.tween1 ~= nil then
        self.tween1:Kill()
    end
    self.tween1 = nil

    if self.tween2 ~= nil then
        self.tween2:Kill()
    end
    self.tween2 = nil

    if self.tween3 ~= nil then
        self.tween3:Kill()
    end
    self.tween3 = nil

    if self.alphaSequence ~= nil then
        self.alphaSequence:Kill()
    end
    self.alphaSequence = nil

    if self.particleSequence ~= nil then
        self.particleSequence:Kill()
    end
    self.particleSequence = nil

    self.CenterPanelTrans.localPosition = CSScript.Vector3(-200,0,0)
    self.TopFunctionBtnTrans.localPosition = CSScript.Vector3(585,60,0)
    self.RightFunctionBtnTrans.localPosition = CSScript.Vector3(800,60,0)
    self.RightFunctionBtnCanvaGroup.alpha = 0
    for i = 1,#self.moduleCanvasGroupList do
        self.moduleCanvasGroupList[i].alpha = 0
    end
    
    for i = 1,#self.moduleParticleList do
        CommonHelper.SetActive(self.moduleParticleList[i],false)
    end
    
    self.tween1 = self.CenterPanelTrans:DOLocalMoveX(0,0.42)
    self.tween1:SetEase(self.animationCurve)

    self.tween2 = self.RightFunctionBtnTrans:DOLocalMoveX(585,0.42)
    self.tween2:SetEase(self.animationCurve)

    self.tween3 = self.TopFunctionBtnTrans:DOLocalMoveY(-55,0.42)
    self.tween3:SetEase(self.Ease.OutCubic)

    local time = 0
    for i = 1,#self.moduleCanvasGroupList do
        self:PlayModuleAlphaAnimation(self.moduleCanvasGroupList[i],time)
        time = time + 0.08
    end
    self:PlayModuleAlphaAnimation(self.RightFunctionBtnCanvaGroup,0.15)
    
    self.particleSequence = self.DOTween.Sequence()
    local  particleCallBack = function()
        for i = 1,#self.moduleParticleList do
            CommonHelper.SetActive(self.moduleParticleList[i],true)
        end
    end
    self.particleSequence:InsertCallback(0.3,particleCallBack)
end

function LobbyHallCoreView:PlayModuleAlphaAnimation(canvasGroup,time)
    self.alphaSequence = self.DOTween.Sequence()
    self.alphaSequence:PrependInterval(time)
    local tempColor = CS.UnityEngine.Color(1,1,1,0)
    local callBack1 = function (  )
		return tempColor
	end
    local callBack2 = function (v)
		tempColor = v
	end
    local alPhaTweener = self.DOTween.ToAlpha(callBack1,callBack2,1,(0.3 + time)) 
    alPhaTweener.onUpdate = function (  )
        canvasGroup.alpha = tempColor.a 
    end
    self.alphaSequence:Append(alPhaTweener)
end

function LobbyHallCoreView:SettingOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    LobbySettingSystem.GetInstance():Open()
end

function LobbyHallCoreView:ServiceOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
end

function LobbyHallCoreView:RankOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyRankListSystem.GetInstance():Open()
end

function LobbyHallCoreView:BankOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    LobbyBankSystem.GetInstance():Open()
end

function LobbyHallCoreView:ActivityOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
end

function LobbyHallCoreView:IsDisplayEmailPoint(isDisPlay)
    CommonHelper.SetActive(self.emialPoint_gameObject,isDisPlay)
end

function LobbyHallCoreView:EmailOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    LobbyEmailSystem.GetInstance():Open()
end

function LobbyHallCoreView:RechargelOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
end

function LobbyHallCoreView:UserHeadOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    
    if LobbyHallCoreSystem.GetInstance().personalInformationView ~= nil then
        LobbyHallCoreSystem.GetInstance().personalInformationView:OpenForm()
    end
end

function LobbyHallCoreView:IsShowFunctionPanel(isDisplay)
    CommonHelper.SetActive(self.CenterPanel,isDisplay)
    CommonHelper.SetActive(self.RightPanel,isDisplay)
    CommonHelper.SetActive(self.TopPanel,isDisplay)
    CommonHelper.SetActive(self.GamePanel, (not isDisplay))
    if isDisplay == true then
        GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.NoticeFormChangePosition_EventName,false,1)
    else
        GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.NoticeFormChangePosition_EventName,false,2)
    end
end

function LobbyHallCoreView:IsShowGameModulePanel()
    if LobbyHallCoreSystem.GetInstance().curSelectGameType == LobbyHallCoreSystem.GetInstance().GameType.Fish then
        CommonHelper.SetActive(self.FishModulePanel,true)
        CommonHelper.SetActive(self.ArcadeModulePanel,false)
        CommonHelper.SetActive(self.ChessModulePanel,false)
    elseif LobbyHallCoreSystem.GetInstance().curSelectGameType == LobbyHallCoreSystem.GetInstance().GameType.Arcade then
        CommonHelper.SetActive(self.FishModulePanel,false)
        CommonHelper.SetActive(self.ArcadeModulePanel,true)
        CommonHelper.SetActive(self.ChessModulePanel,false)
    elseif LobbyHallCoreSystem.GetInstance().curSelectGameType == LobbyHallCoreSystem.GetInstance().GameType.Chess then
        CommonHelper.SetActive(self.FishModulePanel,false)
        CommonHelper.SetActive(self.ArcadeModulePanel,false)
        CommonHelper.SetActive(self.ChessModulePanel,true)
    end
end

function LobbyHallCoreView:ShowMoneyPanel()
    self.gameMoney_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.jetton    
    self.bankMoney_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.bank_jetton    
end

function LobbyHallCoreView:ShowUserInfoPanel()
    self.user_name_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.nick_name
    self.head_image.sprite =  self:GetUserHeadImage()
end

function LobbyHallCoreView:GetUserHeadImage()
	return self:GetAllocateHeadImage(LobbyHallCoreSystem.GetInstance().playerInfoVo.face_id)
end


function LobbyHallCoreView:GetAllocateHeadImage(headId)
	if headId<1 then  headId=1 end
	if headId>11 then  headId=11 end
	
	return LobbyManager.GetInstance().gameData.AllAtlasList["PersonalInformationSpriteAtlas"]:GetSprite("grxx_tx_"..headId)
end

function LobbyHallCoreView:IsShowModule(  )
    
end

function LobbyHallCoreView:CloseForm()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
end


function LobbyHallCoreView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.RightPanel = nil
    self.RightFunctionBtnTrans = nil
    self.RightFunctionBtnCanvaGroup = nil
    self.TopPanel = nil
    self.TopFunctionBtnTrans = nil
    self.CenterPanel = nil
    self.CenterPanelTrans = nil
    self.BottomPanel = nil
    self.GamePanel = nil
    self.FishModulePanel = nil
    self.ArcadeModulePanel = nil
    self.ChessModulePanel = nil

    self.moduleCanvasGroupList = nil
    self.RecommendModule_GameObject = nil
    self.FishModule_GameObject = nil
    self.ArcadeModule_GameObject = nil
    self.ChessModule_GameObject = nil
    
    if self.recommendModuleEventScript then
        self.recommendModuleEventScript.onMiniPointerClickCallBack = nil
    end
    self.recommendModuleEventScript = nil 

    if self.fishModuleEventScript then
        self.fishModuleEventScript.onMiniPointerClickCallBack = nil
    end
    self.fishModuleEventScript = nil 

    if self.arcadeModuleEventScript then
        self.arcadeModuleEventScript.onMiniPointerClickCallBack = nil
    end
    self.arcadeModuleEventScript = nil

    if self.chessModuleEventScript then
        self.chessModuleEventScript.onMiniPointerClickCallBack = nil
    end
    self.chessModuleEventScript = nil 

    if self.settingEventScript then
        self.settingEventScript.onMiniPointerClickCallBack = nil
    end
    self.settingEventScript = nil


    if self.serviceEventScript then
        self.serviceEventScript.onMiniPointerClickCallBack = nil
    end
    self.serviceEventScript = nil

    if self.rankEventScript then
        self.rankEventScript.onMiniPointerClickCallBack = nil
    end
    self.rankEventScript = nil

    if self.bankEventScript then
        self.bankEventScript.onMiniPointerClickCallBack = nil
    end
    self.bankEventScript = nil

    if self.activityEventScript then
        self.activityEventScript.onMiniPointerClickCallBack = nil
    end
    self.activityEventScript = nil

   
    if self.emailEventScript then
        self.emailEventScript.onMiniPointerClickCallBack = nil
    end
    self.emailEventScript = nil

    if self.rechargelEventScript then
        self.rechargelEventScript.onMiniPointerClickCallBack = nil
    end
    self.rechargelEventScript  = nil

    if self.userHeadEventScript then
        self.userHeadEventScript.onMiniPointerClickCallBack = nil
    end
    self.userHeadEventScript = nil
    self.user_name_text = nil
    self.head_image = nil
    
    self.itemParent = nil
    self.gameItemMap = nil
    self.emialPoint_gameObject = nil
end

function LobbyHallCoreView:__delete()
    self:CloseForm()
    self:RemoveUIComponent()
end