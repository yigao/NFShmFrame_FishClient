PlayerBetView=Class()

function PlayerBetView:ctor(gameObj)
	self:Init(gameObj)

end

function PlayerBetView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function PlayerBetView:InitData()
	self.gameData=GameManager.GetInstance().gameData 
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.BetChipList={}			--筹码表
	self.currentBetIndex=1
	self.totalBetIndex=1
end



function PlayerBetView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function PlayerBetView:FindView(tf)
	self:FindPlayerBetView(tf)
end


function PlayerBetView:FindPlayerBetView(tf)
	self.AddBetBtn=tf:Find("Down/Bet/AdditionBet"):GetComponent(typeof(self.Button))
	self.ReduceBetBtn=tf:Find("Down/Bet/ReduceBet"):GetComponent(typeof(self.Button))
	self.MaxBetBtn=tf:Find("Down/MaxBet/MaxBetBtn"):GetComponent(typeof(self.Button))
	self.BetScoreText=tf:Find("Down/Bet/BetScore/Score"):GetComponent(typeof(self.Text))
	self.SingleBetScoreText=tf:Find("Down/Bet/BetScore/LineScore"):GetComponent(typeof(self.Text))
	self.QuickSpeedBtn=tf:Find("Down/QuickSpeedBet/QuickSpeed"):GetComponent(typeof(self.Button))
	self.QuickSpeedTips=tf:Find("Down/QuickSpeedBet/QuickTips").gameObject
end


function PlayerBetView:InitViewData()
	self:SetBetScore(0)
	self:IsShowQuickSpeedTips(false)
end


function PlayerBetView:AddEventListenner()
	self.AddBetBtn.onClick:AddListener(function () self:OnclickAddBet() end)
	self.ReduceBetBtn.onClick:AddListener(function () self:OnclickReduceBet() end)
	self.MaxBetBtn.onClick:AddListener(function () self:OnclickMaxBet() end)
	self.QuickSpeedBtn.onClick:AddListener(function () self:OnclickQuickSpeedBet() end)
end


function PlayerBetView:OnclickAddBet()
	AudioManager.GetInstance():PlayNormalAudio(19)
	self.currentBetIndex=self.currentBetIndex+1
	if self.currentBetIndex>self.totalBetIndex then
		self.currentBetIndex=self.totalBetIndex
		self:IsEnableButton(self.MaxBetBtn,true)
	end
	if self.currentBetIndex==self.totalBetIndex then
		self:IsEnableButton(self.MaxBetBtn,false)
	end
		
	self:SetBetChipValue(self.currentBetIndex)
end


function PlayerBetView:OnclickReduceBet()
	AudioManager.GetInstance():PlayNormalAudio(18)
	self.currentBetIndex=self.currentBetIndex-1
	if self.currentBetIndex<=0 then
		self.currentBetIndex=1--self.totalBetIndex
		--self:IsEnableButton(self.MaxBetBtn,false)
	else
		self:IsEnableButton(self.MaxBetBtn,true)
	end
	self:SetBetChipValue(self.currentBetIndex)
end


function PlayerBetView:OnclickMaxBet()
	AudioManager.GetInstance():PlayNormalAudio(10)
	self.currentBetIndex=self.totalBetIndex
	self:SetBetChipValue(self.currentBetIndex)
	self:IsEnableButton(self.MaxBetBtn,false)
end



function PlayerBetView:OnclickQuickSpeedBet()
	self.gameData.IsQuickState=not self.gameData.IsQuickState
	if self.gameData.IsQuickState then
		self:IsShowQuickSpeedTips(true)
	else
		self:IsShowQuickSpeedTips(false)
	end
end



function PlayerBetView:IsEnableButton(button,isEnable)
	button.interactable=isEnable
end



function PlayerBetView:IsEnableBetButton(isEnable)
	self:IsEnableButton(self.AddBetBtn,isEnable)
	self:IsEnableButton(self.ReduceBetBtn,isEnable)
	if isEnable and self.currentBetIndex==self.totalBetIndex then
		return
	end
	self:IsEnableButton(self.MaxBetBtn,isEnable)
end


function PlayerBetView:InitBetInfo(betInfo)
	self.BetChipList={}
	if betInfo then
		if betInfo.chipScores and #betInfo.chipScores>0 then
			for i=1,#betInfo.chipScores do
				if betInfo.chipScores[i]~=0 then
					table.insert(self.BetChipList,betInfo.chipScores[i])
				end
			end
		else
			Debug.LogError("下注异常==>")
			GameManager.GetInstance():ShowUITips("下注异常==>",2)
			return true
		end
		self.currentBetIndex=1--betInfo.curChipIndex
		self:SetBetChipValue(self.currentBetIndex)
		self.totalBetIndex=#self.BetChipList
	else
		Debug.LogError("下注异常==>")
		GameManager.GetInstance():ShowUITips("下注异常==>",2)
		return true
	end
end


function PlayerBetView:SetBetChipValue(chipIndex)
	if chipIndex<=#self.BetChipList then
		local chipScore=self.BetChipList[chipIndex]
		chipScore=CommonHelper.FormatBaseProportionalScore(chipScore)
		self:SetBetScore(chipScore)
		self:SetSingleBetScore(chipScore)
		BaseFctManager.GetInstance():SetHandselDataByChangeBet(chipIndex)
	else
		Debug.LogError("chipIndex大于总长度")
	end
	
end


function PlayerBetView:GetCurrentBetChipValue()
	return self.BetChipList[self.currentBetIndex]
end


function PlayerBetView:GetCurrentBetChipIndex()
	return self.currentBetIndex
end


function PlayerBetView:SetBetScore(score)
	self.BetScoreText.text=CommonHelper.FormatBaseProportionalScore(score)
end

function PlayerBetView:SetSingleBetScore(score)
	print(score)
	self.SingleBetScoreText.text="50 x "..math.ceil(CommonHelper.FormatBaseProportionalScore(score)/50)
end


function PlayerBetView:IsShowQuickSpeedTips(isShow)
	CommonHelper.SetActive(self.QuickSpeedTips,isShow)
end