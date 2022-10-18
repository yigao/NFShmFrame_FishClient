Player=Class()

function Player:ctor(gameObj,index)
	self.gameObject=gameObj
	self.index = index
	self:Init(gameObj)

end

function Player:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function Player:InitData()
	self.gameData = PlayerManager.GetInstance().gameData
	self.ChairdID = 0					--座位id
	self.UserId = 0						--玩家ID
	self.isMe = false
	self.animationNameParam = {"Player_LeftToRight","Player_RightToLeft"}
end


function Player:InitView(gameObj)
	self.playerPanel=PlayerManager.GetInstance().PlayerInfoView.New(gameObj)
end

function Player:InitViewData()
	self:IsShowPlayerPanel(false)
	self:InitAllPanel()
end



function Player:InitAllPanel()
	self.playerPanel:InitViewData()
end


function Player:IsShowPlayerPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end

function Player:PlayerEnterSeat(playerVo)
	self:InitAllPanel()
	self.isMe = (playerVo.chair_id == self.gameData.PlayerChairId)
	self:SetPlayerChairID(playerVo.chair_id)
	self:SetUserID(playerVo.user_id)
	self:SetPlayerName(playerVo.user_name)
	self:SetPlayerMoney(playerVo.user_money)
	self:SetPlayerHead(playerVo.usFaceId)
	self:IsShowPlayerPanel(true)
end


function Player:SetPlayerChairID(chairId)
	self.ChairdID=chairId
end

function Player:GetPlayerChairID()
	return self.ChairdID
end

function Player:SetUserID(userId)
	self.UserId=userId
end

function Player:GetUserID()
	return self.UserId
end

function Player:SetResultScoreValue(value)
	if self.isMe then
		if value > 0 then
			AudioManager.GetInstance():PlayNormalAudio(28)
		elseif value < 0 then
			AudioManager.GetInstance():PlayNormalAudio(29)
		end
	end
	self.playerPanel:SetResultScoreValue(value)
end

function Player:UpdatePlayerValue(palyerVo)
	self:SetPlayerName(palyerVo.user_name)
	self:SetPlayerMoney(palyerVo.user_money)
end

function Player:SetPlayerMoney(score)
	self.playerPanel:SetPlayerMoney(score)
end

function Player:SetPlayerName(name)
	self.playerPanel:SetPlayerName(name)
end


function Player:SetPlayerHead(headId)
	if self.isMe then
		self.playerPanel:SetPlayerHead(LobbyHallCoreSystem.GetInstance():GetCurrentUserHeadImage())
	else
		self.playerPanel:SetPlayerHead(LobbyHallCoreSystem.GetInstance():GetAllocateHeadImage(headId))
	end
end

function Player:OnClickSendBetChip(areaIndex)
	if self.gameData.CurrentBetIndex >=1 then
		PlayerManager.GetInstance():RequestUserBetChipMsg(areaIndex,self.gameData.CurrentBetIndex)
	end
end

function Player:IsShowAllStartEffect(isDisplay)
	self.playerPanel:IsShowAllStartEffect(isDisplay)
end

function Player:PlayXingxingEffect(areaIndex)
	self.playerPanel:IsShowStartEffectObject(areaIndex,true)
end

function Player:GetBetInitPosition()
	return self.playerPanel:GetBetInitPos()
end

function Player:PlayMoveAnimation()
	local animationName = nil
	if self.index == 1 then
		animationName = self.animationNameParam[2]
	elseif self.index == 2 then
		animationName = self.animationNameParam[1]
	elseif self.index >= 3 and self.index<=5 then
		animationName = self.animationNameParam[2]
	elseif self.index >= 6 and self.index<=7 then
		animationName = self.animationNameParam[1]
	end
	self.playerPanel:PlayMoveAnimation(animationName)
end