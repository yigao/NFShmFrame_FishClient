PlayerListRankView=Class()

function PlayerListRankView:ctor(gameObj)
	self:Init(gameObj)
end

function PlayerListRankView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function PlayerListRankView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.UIFormScript = GameManager.GetInstance().UIFormScript
	self.UIListScript = GameManager.GetInstance().UIListScript
	self.playerRankItemList = {}
end

function PlayerListRankView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function PlayerListRankView:FindView(tf)
	self.uiFormScript = tf:GetComponent(typeof(self.UIFormScript))

	self.uiListScript = tf:Find("Panel/PlayerItemList"):GetComponent(typeof(self.UIListScript))
	self.uiListScript.InstantiateElementCallback = function (go) self:CreatePlayerRankItem(go) end
	
	self.CloseBtn = tf:Find("Panel/close_Btn"):GetComponent(typeof(self.Button))
end

function PlayerListRankView:InitViewData()
	self.uiListScript:Initialize(self.uiFormScript)
end

function PlayerListRankView:AddEventListenner()
	self.CloseBtn.onClick:AddListener(function () self:OnClickClose() end)
end

function PlayerListRankView:ShowPlayerListItemView()
	if self.uiListScript ~= nil then
		self.uiListScript:ResetContentPosition()
	end
	self.uiListScript:SetElementAmount(#PlayerManager.GetInstance().playerVoList)
end

function PlayerListRankView:CreatePlayerRankItem(go)
	local rankItem = PlayerListRankManager.GetInstance().PlayerRankItem.New(go)
    table.insert(self.playerRankItemList,rankItem)
end

function PlayerListRankView:OnClickClose()
	AudioManager.GetInstance():PlayNormalAudio(27)
	PlayerListRankManager.GetInstance():IsShowPlayerListRankPanel(false)
end
