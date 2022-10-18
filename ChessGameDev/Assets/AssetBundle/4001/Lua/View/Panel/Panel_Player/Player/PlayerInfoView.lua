PlayerInfoView=Class()

function PlayerInfoView:ctor(gameObj)
	self:Init(gameObj)

end

function PlayerInfoView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function PlayerInfoView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Image=GameManager.GetInstance().Image
	self.Animator = GameManager.GetInstance().Animator
	self.StartEffectObjList = {}
	self.ScoreResultObjList={}
	self.ScoreResultTextList={}
end


function PlayerInfoView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end

function PlayerInfoView:InitViewData()
	self:SetShowPanel(false)
end

function PlayerInfoView:SetShowPanel(isDisplay)
	self:HideAllScoreResultPanel(isDisplay)
	self:IsShowAllStartEffect(isDisPlay)
	self:IsShowPlayerHeadEffect(isDisPlay)
end


function PlayerInfoView:FindView(tf)
	self:FindPlayerView(tf)
	self:FindResultView(tf)
	self:FindXingXingView(tf)
	
end


function PlayerInfoView:FindPlayerView(tf)
	self.playerName=tf:Find("Panel/name"):GetComponent(typeof(self.Text))
	self.playerMoney=tf:Find("Panel/money"):GetComponent(typeof(self.Text))
	self.playerHeadImage=tf:Find("Panel/head_icon"):GetComponent(typeof(self.Image))
	self.BetInitPos = tf:Find("Panel/betInitPos")
	self.animator = tf:Find("Panel"):GetComponent(typeof(self.Animator))
	self.PlayerHeadEffect =  tf:Find("Panel/PlayerHeadEffect").gameObject
end


function PlayerInfoView:FindResultView(tf)
	local tempObj=tf:Find("Panel/WinTips/Win").gameObject
	table.insert(self.ScoreResultObjList,tempObj)
	tempObj=tf:Find("Panel/WinTips/Win/Text"):GetComponent(typeof(self.Text))
	table.insert(self.ScoreResultTextList,tempObj)
	tempObj=tf:Find("Panel/WinTips/Lose").gameObject
	table.insert(self.ScoreResultObjList,tempObj)
	tempObj=tf:Find("Panel/WinTips/Lose/Text"):GetComponent(typeof(self.Text))
	table.insert(self.ScoreResultTextList,tempObj)
end

function PlayerInfoView:FindXingXingView(tf)
	local tempObj = tf:Find("Panel/Effect_star_long")
	if tempObj then
		table.insert(self.StartEffectObjList,tempObj.gameObject)
	end

	local tempObj = tf:Find("Panel/Effect_star_he")
	if tempObj then
		table.insert(self.StartEffectObjList,tempObj.gameObject)
	end

	local tempObj = tf:Find("Panel/Effect_star_hu")
	if tempObj then
		table.insert(self.StartEffectObjList,tempObj.gameObject)
	end
end

function PlayerInfoView:SetResultScoreValue(value)
	self:HideAllScoreResultPanel(false)
	local tempV=CommonHelper.FormatBaseProportionalScore(math.abs(value))
	for i=1,#self.ScoreResultTextList do
		if tonumber(value)>0 then 
			value="+"..tempV 
			self.ScoreResultTextList[1].text = value
			self:IsShowScoreResultPanel(1,true)
			self:IsShowPlayerHeadEffect(true)
		elseif tonumber(value)<0 then 
			value="-"..tempV 
			self.ScoreResultTextList[2].text = value
			self:IsShowScoreResultPanel(2,true)
		end
	end
end

function PlayerInfoView:HideAllScoreResultPanel(isDisplay)
	self:IsShowScoreResultPanel(1,isDisplay)
	self:IsShowScoreResultPanel(2,isDisplay)
end


function PlayerInfoView:IsShowAllStartEffect(isDisplay)
	if #self.StartEffectObjList >= 1 then
		for i = 1,#self.StartEffectObjList do
			self:IsShowStartEffectObject(i,isDisPlay)
		end
	end
end

function PlayerInfoView:IsShowStartEffectObject(index,isDisplay)
	CommonHelper.SetActive(self.StartEffectObjList[index],isDisplay)
end

function PlayerInfoView:IsShowScoreResultPanel(index,isShow)
	CommonHelper.SetActive(self.ScoreResultObjList[index],isShow)
end

function PlayerInfoView:IsShowPlayerHeadEffect(isDisPlay)
	CommonHelper.SetActive(self.PlayerHeadEffect,isDisPlay)
end


function PlayerInfoView:SetPlayerName(name)
	self.playerName.text=name
end

function PlayerInfoView:SetPlayerMoney(money)
	self.playerMoney.text=money
end

function PlayerInfoView:SetPlayerHead(headImage)
	self.playerHeadImage.sprite=headImage
end

function PlayerInfoView:GetBetInitPos()
	return self.BetInitPos.position
end

function PlayerInfoView:PlayMoveAnimation(animationName)
	if self.animator then
		self.animator:Play(animationName,0,0)
	end
end