RankItem = Class()

function RankItem:ctor(go)
    self:Init(go)
end

function RankItem:Init(go)
    self:InitData()
    self:InitView(go)
end

function RankItem:InitData(  )
    self.currentRankVo = nil
end

function RankItem:InitView(go)
    self.itemGameObject = go
    self.itemTransform = go.transform
    self:GetUIComponent()
end

function RankItem:GetUIComponent()
    self.bg_image =  self.itemTransform:Find("bg"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.rank_icon_image = self.itemTransform:Find("rank_icon"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.rank_text = self.itemTransform:Find("rank_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.head_icon_image = self.itemTransform:Find("head_icon"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.name_text =  self.itemTransform:Find("name"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.user_id_text =  self.itemTransform:Find("user_id"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.money_number_text =  self.itemTransform:Find("money/moneyNumber"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    
    self.uiListElementScript = self.itemTransform:GetComponent(typeof(CS.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableRankItem(index) end

    -- self.itemEventScipt = self.itemGameObject:GetComponent(typeof(CS.UIEventScript))
    -- if self.itemEventScipt == nil then 
    --     self.itemEventScipt = self.itemGameObject:AddComponent(typeof(CS.UIEventScript))
    -- end
    -- self.itemEventScipt.onPointerClickCallBack = function(pointerEventData) self:ItemOnPointerClick(pointerEventData) end
end

function RankItem:OnEnableRankItem(index)
    self.currentRankVo = LobbyRankListSystem.GetInstance().rankInfoList[index + 1]
   -- pt(self.currentRankVo)
    self:ShowUIComponent()

end

function RankItem:ShowUIComponent()
    self.name_text.text =  self.currentRankVo.user_name
    self.user_id_text.text =  self.currentRankVo.user_id
    self.money_number_text.text =  self.currentRankVo.score
    
    if self.currentRankVo.rank == 1 then
        self.bg_image.enabled = true
        self.bg_image.sprite = LobbyManager.GetInstance().gameData.AllAtlasList["RanklistSpriteAtlas"]:GetSprite("phb_imge_03")
        self.rank_icon_image.enabled = true
        self.rank_icon_image.sprite = LobbyManager.GetInstance().gameData.AllAtlasList["RanklistSpriteAtlas"]:GetSprite("phb_icon_01")
        self.rank_text.enabled = false
        self.head_icon_image.sprite =  LobbyManager.GetInstance().gameData.AllAtlasList["PersonalInformationSpriteAtlas"]:GetSprite("grxx_tx_"..self.currentRankVo.face_id)
    elseif self.currentRankVo.rank == 2 then
        self.bg_image.enabled = true
        self.bg_image.sprite= LobbyManager.GetInstance().gameData.AllAtlasList["RanklistSpriteAtlas"]:GetSprite("phb_imge_04")
        self.rank_icon_image.enabled = true
        self.rank_icon_image.sprite = LobbyManager.GetInstance().gameData.AllAtlasList["RanklistSpriteAtlas"]:GetSprite("phb_icon_02")
        self.rank_text.enabled = false
        self.head_icon_image.sprite =  LobbyManager.GetInstance().gameData.AllAtlasList["PersonalInformationSpriteAtlas"]:GetSprite("grxx_tx_"..self.currentRankVo.face_id)
    elseif self.currentRankVo.rank == 3 then
        self.bg_image.enabled = true
        self.bg_image.sprite= LobbyManager.GetInstance().gameData.AllAtlasList["RanklistSpriteAtlas"]:GetSprite("phb_imge_05")
        self.rank_icon_image.enabled = true
        self.rank_icon_image.sprite = LobbyManager.GetInstance().gameData.AllAtlasList["RanklistSpriteAtlas"]:GetSprite("phb_icon_03")
        self.rank_text.enabled = false
        self.head_icon_image.sprite =  LobbyManager.GetInstance().gameData.AllAtlasList["PersonalInformationSpriteAtlas"]:GetSprite("grxx_tx_"..self.currentRankVo.face_id)
    else
        self.bg_image.enabled = false
        self.rank_icon_image.enabled = false
        self.rank_text.enabled = true
        self.rank_text.text = self.currentRankVo.rank
        self.head_icon_image.sprite =  LobbyManager.GetInstance().gameData.AllAtlasList["PersonalInformationSpriteAtlas"]:GetSprite("grxx_tx_"..self.currentRankVo.face_id)
    end
end

function RankItem:ItemOnPointerClick(eventData)

    
end

function RankItem:RemoveUIComponent()
    self.itemGameObject = nil
    self.itemTransform = nil
  
    -- if self.itemEventScipt ~= nil then
    --     self.itemEventScipt.onPointerClickCallBack = nil
    -- end
    -- self.itemEventScipt = nil 
end

function RankItem:__delete()
	self:RemoveUIComponent()
end
