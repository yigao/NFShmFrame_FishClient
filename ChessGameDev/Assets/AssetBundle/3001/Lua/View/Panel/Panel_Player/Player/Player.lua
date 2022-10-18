Player=Class()

function Player:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)

end

function Player:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function Player:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.isMe=false
	self.isObservedState=false
	
end



function Player:InitView(gameObj)
	self.PlayerPanel=PlayerManager.GetInstance().PlayerInfoView.New(gameObj)
end



function Player:InitViewData()
	self:IsShowPlayerPanel(false)
	self:InitAllPanel()
	
end


function Player:EnterGame(PlayerInfo)
	self:InitAllPanel()
	self:SetMe(PlayerInfo.chairId)
	self:SetObservedState(PlayerInfo.isWatchUser)
	self.PlayerPanel:SetPlayerName(PlayerInfo.userName)
	self:SetPlayerHead(PlayerInfo.headId)
	self:SetPlayerMoney(PlayerInfo.userMoney)
	self:IsShowWaitEnterDeskPanel(self.isObservedState)
	self:IsShowPlayerPanel(true)
end


function Player:LeaveGame()
	self:IsShowPlayerPanel(false)
	self:InitAllPanel()
	
end


function Player:InitAllPanel()
	self.PlayerPanel:InitViewData()
end


function Player:ResetPlayerStateData(data)
	self:SetObservedState(data.isWatchUser)
	self:SetPlayerMoney(data.userMoney)
end


function Player:IsShowPlayerPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end


function Player:IsShowCard(index,isShow)
	self.PlayerPanel:IsShowCardAnimPanel(index,isShow)
end


function Player:IsShowBetTips(index,isShow)
	self.PlayerPanel:IsShowBetTipsPanel(index,isShow)
end


function Player:IsShowScoreResult(index,isShow)
	self.PlayerPanel:IsShowScoreResultPanel(index,isShow)
end


function Player:IsShowWaitEnterDeskPanel(isShow)
	self.PlayerPanel:IsShowWaitEnterDeskPanel(isShow)
end


function Player:SetMe(PlayerChairID)
	self.isMe=(PlayerChairID==self.gameData.PlayerChairId)
end

function Player:SetObservedState(isState)
	self.isObservedState=isState
end


function Player:GetObservedState()
	return self.isObservedState
end


function Player:SetPlayerHead(headId)
	if self.isMe then
		self.PlayerPanel:SetPlayerHead(LobbyHallCoreSystem.GetInstance():GetCurrentUserHeadImage())
	else
		self.PlayerPanel:SetPlayerHead(LobbyHallCoreSystem.GetInstance():GetAllocateHeadImage(headId))
	end
end


function Player:SetPlayerMoney(money)
	self.PlayerPanel:SetPlayerMoney(money)
end



function Player:SetQiangZhuangMultipleTipsValue(index)
	local tempV=self.gameData.QZMulptileList[index]
	if tempV then
		self.PlayerPanel:SetQiangZhuangMultipleValue(tempV)
	else
		Debug.LogError("抢庄Index异常===>>>"..index)
	end
	
end



function Player:SetBetMultipleTipsValue(index)
	local tempV=self.gameData.BetMulptileList[index]
	if tempV then
		self.PlayerPanel:SetBetMultipleValue(tempV)
	else
		Debug.LogError("下注Index异常===>>>"..index)
	end
end



function Player:PlaySelectZhuangJiaEffect()
	self.PlayerPanel:IsShowSelectZJAnimTipsPanel(false)
	self.PlayerPanel:IsShowSelectZJAnimTipsPanel(true)
end


function Player:SetSelectZhuangJia()
	self.PlayerPanel:IsShowZhuangJiaTipsPanel(false)
	self.PlayerPanel:IsShowZhuangJiaTipsPanel(true)
end


function Player:SetKanPaiValue(tempKPVlaue)
	if self.isMe then
		self.PlayerPanel:SetKanPaiImageValue(tempKPVlaue)
	end
end


function Player:SetTanPaiValue(tempKPVlaue)
	self.PlayerPanel:SetTanPaiImageValue(tempKPVlaue)
end


function Player:SetOpenAward(resultIndex)
	local isNN=false
	if resultIndex>0 then
		isNN=true
	end
	self.PlayerPanel:SetNNOpenResultBgImage(isNN)
	self.PlayerPanel:SetNNOpenResultImage(resultIndex)
	self.PlayerPanel:IsShowNNOpenResultPanel(true)
end


function Player:SetPlayerGetScoreTips(score)
	self.PlayerPanel:SetResultScoreValue(score)
end


function Player:GetGoldFlyEffectPos()
	return self.PlayerPanel:GetGoldFlyEffectPos()
end