LobbyHallChessModulePanel = Class()

function LobbyHallChessModulePanel:ctor()
    self:Init()
end

function LobbyHallChessModulePanel:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyHallChessModulePanel:InitData(  )
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
end

function LobbyHallChessModulePanel:InitView(  )
    self.panelTransform = nil
    self.panelGameObject = nil
    self.gameListTrans = nil
    self.scrollRect01 = nil
    self.gameItemParent01 = nil
    self.scrollRect02 = nil
    self.gameItemParent02 = nil
    self.returnEventScript = nil
    self.gameItemList = nil 

    self.gameItemList = nil 
    self.titleTrans = nil
end

function LobbyHallChessModulePanel:OpenUIPanel(go)
   
    self:GetUIComponent(go)

    self:ShowUIComponent()
end

function LobbyHallChessModulePanel:GetUIComponent(go)
    if self.panelGameObject~=nil and self.panelGameObject~=go then
        self:RemoveUIComponent()
    end
    
    if self.panelGameObject == nil then
        self.panelGameObject = go
    end

    if self.panelTransform == nil then
        self.panelTransform = self.panelGameObject.transform
    end

    if self.titleTrans == nil then
        self.titleTrans = self.panelTransform:Find("Title")
    end

    if self.gameListTrans == nil then
        self.gameListTrans = self.panelTransform:Find("GameList")
    end

    if self.returnEventScript == nil then
        local go = self.panelTransform:Find("Return_Btn").gameObject
        self.returnEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.returnEventScript == nil then 
            self.returnEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        self.returnEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ReturnOnPointerClick(pointerEventData) end
    end
   
    if self.scrollRect01 == nil then
        self.scrollRect01 = self.panelTransform:Find("GameList/ScrollView01"):GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
    end

    if self.gameItemParent01 == nil then
        self.gameItemParent01 = self.panelTransform:Find("GameList/ScrollView01/Viewport/Content")
    end

    if self.scrollRect02 == nil then
        self.scrollRect02 = self.panelTransform:Find("GameList/ScrollView02"):GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
    end

    if self.gameItemParent02 == nil then
        self.gameItemParent02 = self.panelTransform:Find("GameList/ScrollView02/Viewport/Content")
    end
    
    if self.gameItemList == nil then
        self.gameItemList = {}
        local parent = self.gameItemParent01
         local scrollRect = self.scrollRect01
        local tempItemList = {}
    
        for i = 1,#LobbyHallCoreSystem.GetInstance().gameItemDataList do
            local itemVo = LobbyHallCoreSystem.GetInstance().gameItemDataList[i]
            if itemVo.gameType == LobbyHallCoreSystem.GetInstance().curSelectGameType or itemVo.gameType == LobbyHallCoreSystem.GetInstance().GameType.Hundred then
                table.insert(tempItemList,itemVo)
            end
        end

        local boundIndex = math.ceil(#tempItemList/2)
        for i = 1,#tempItemList do
            if i<=boundIndex then
                parent = self.gameItemParent01
            else
                parent = self.gameItemParent02
            end
            local itemVo = tempItemList[i]
            if itemVo.gameType == LobbyHallCoreSystem.GetInstance().curSelectGameType or itemVo.gameType == LobbyHallCoreSystem.GetInstance().GameType.Hundred then
                local itemView = LobbyGameItem.New(parent,self.scrollRect01,self.scrollRect02,itemVo)
                table.insert(self.gameItemList,itemView)
            end
        end
    end
end

function LobbyHallChessModulePanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
end


function LobbyHallChessModulePanel:ShowUIComponent()    
    self.panelGameObject:SetActive(true)
    for i = 1,#self.gameItemList do
        self.gameItemList[i]:DisplayGameItem()
    end
    self:PlayAnimation()
end

function LobbyHallChessModulePanel:PlayAnimation(  )
    if self.tween1 ~= nil then
        self.tween1:Kill()
        self.tween1 = nil
    end

    if self.tween2 ~= nil then
        self.tween2:Kill()
        self.tween2 = nil
    end

    self.gameListTrans.localPosition = CSScript.Vector3(280,0,0)
    self.titleTrans.localPosition = CSScript.Vector3(465.7,425,0)
    
    self.tween1 = self.gameListTrans:DOLocalMoveX(0,0.42)
    self.tween1:SetEase(self.animationCurve)
    
    self.tween2 = self.titleTrans:DOLocalMoveY(310,0.42)
    self.tween2:SetEase(self.Ease.OutCubic)
    
    local time = 0
    for i = 1,#self.gameItemList do
        self.gameItemList[i]:PlayAnimation(time)
        time = time + 0.04
    end
end


function LobbyHallChessModulePanel:ReturnOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self.panelGameObject:SetActive(false)
    LobbyHallCoreSystem.GetInstance().hallCoreView:OpenForm()
end

function LobbyHallChessModulePanel:RemoveUIComponent()
    self.panelTransform = nil
    self.panelGameObject = nil
    
    self.titleTrans = nil

    self.gameListTrans = nil

    self.scrollRect01 = nil
    self.gameItemParent01 = nil
    self.scrollRect02 = nil
    self.gameItemParent02 = nil
    if self.returnEventScript ~= nil then
        self.returnEventScript.onPointerClickCallBack = nil
    end
    self.returnEventScript = nil
    self.gameItemMap = nil 
end

function LobbyHallChessModulePanel:__delete()
    self:RemoveUIComponent()
end