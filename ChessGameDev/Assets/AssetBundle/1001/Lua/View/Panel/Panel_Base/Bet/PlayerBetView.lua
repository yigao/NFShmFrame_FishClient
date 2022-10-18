PlayerBetView=Class()

function PlayerBetView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function PlayerBetView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function PlayerBetView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.BetChipList={}			--筹码表
	self.currentBetIndex=1
	self.totalBetIndex=1
	self.isRunZhanPan=false
	self.currentTime=0
	self.totalTime=0.5
	self.fillAmountPoint=0.3
	self.endFillAmountPoint=0.75
end



function PlayerBetView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function PlayerBetView:FindView(tf)
	self:FindPlayerBetView(tf)
	self:FindBetAnimView(tf)
end


function PlayerBetView:FindPlayerBetView(tf)
	self.AddBetBtn=tf:Find("Down/Bet/AdditionBet"):GetComponent(typeof(self.Button))
	self.ReduceBetBtn=tf:Find("Down/Bet/ReduceBet"):GetComponent(typeof(self.Button))
	self.MaxBetBtn=tf:Find("Down/MaxBet/MaxBetBtn"):GetComponent(typeof(self.Button))
	self.BetScoreText=tf:Find("Down/Bet/BetScore/Score"):GetComponent(typeof(self.Text))
end


function PlayerBetView:FindBetAnimView(tf)
	self.SilderImage=tf:Find("Down/Bet/BetTips/ZhuanPan/ImageQ"):GetComponent(typeof(self.Image))
	self.ZhiZhengPonitTf=tf:Find("Down/Bet/BetTips/ZhuanPan/ZhiZheng")
	self.ZPTF=tf:Find("Down/Bet/BetTips/ZhuanPan/ImageBG")
end


function PlayerBetView:InitViewData()
	self:SetBetScore(0)
	self:IsEnableButton(self.MaxBetBtn,true)
	self.SilderImage.fillAmount=0.3
	self.ZhiZhengPonitTf.localEulerAngles=CSScript.Vector3(0,0,126)
	self.ZPTF.localEulerAngles=CSScript.Vector3(0,0,0)
end


function PlayerBetView:AddEventListenner()
	self.AddBetBtn.onClick:AddListener(function () self:OnclickAddBet() end)
	self.ReduceBetBtn.onClick:AddListener(function () self:OnclickReduceBet() end)
	self.MaxBetBtn.onClick:AddListener(function () self:OnclickMaxBet() end)
end


function PlayerBetView:OnclickAddBet(isInit)
	AudioManager.GetInstance():PlayNormalAudio(8)
	self.currentBetIndex=self.currentBetIndex+1
	if self.currentBetIndex>self.totalBetIndex then
		self.currentBetIndex=1
		self:IsEnableButton(self.MaxBetBtn,true)
		self:SetZhiZhengTips(0.75,0.3)
		self.fillAmountPoint=0.3
	else
		self.endFillAmountPoint=self.fillAmountPoint+0.45/self.totalBetIndex
		if self.currentBetIndex==self.totalBetIndex then
			self:IsEnableButton(self.MaxBetBtn,false)
			self.endFillAmountPoint=0.75
		end
		self:SetZhiZhengTips(self.fillAmountPoint,self.endFillAmountPoint)
		self.fillAmountPoint=self.endFillAmountPoint
	end
	
	self:SetBetChipValue(self.currentBetIndex)
	
	
end


function PlayerBetView:OnclickReduceBet()
	AudioManager.GetInstance():PlayNormalAudio(9)
	self.currentBetIndex=self.currentBetIndex-1
	if self.currentBetIndex<=0 then
		self.currentBetIndex=self.totalBetIndex
		self:IsEnableButton(self.MaxBetBtn,false)
		self:SetZhiZhengTips(0.3,0.75)
		self.fillAmountPoint=0.75
	else
		self:IsEnableButton(self.MaxBetBtn,true)
		self.endFillAmountPoint=self.fillAmountPoint-(0.45/self.totalBetIndex)
		if self.currentBetIndex==1 then self.endFillAmountPoint=0.3 end
		self:SetZhiZhengTips(self.fillAmountPoint,self.endFillAmountPoint)
		self.fillAmountPoint=self.endFillAmountPoint
	end
	self:SetBetChipValue(self.currentBetIndex)
end


function PlayerBetView:OnclickMaxBet()
	AudioManager.GetInstance():PlayNormalAudio(19)
	self.currentBetIndex=self.totalBetIndex
	self:SetBetChipValue(self.currentBetIndex)
	self:IsEnableButton(self.MaxBetBtn,false)
	self:SetZhiZhengTips(self.fillAmountPoint,0.75)
	self.fillAmountPoint=0.75
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
		Debug.LogError("当前下注Index==>"..self.currentBetIndex)
		self:SetBetChipValue(self.currentBetIndex)
		self.totalBetIndex=#self.BetChipList
	else
		GameManager.GetInstance():ShowUITips("下注异常==>",2)
		return true
	end
end


function PlayerBetView:SetBetChipValue(chipIndex)
	if chipIndex<=#self.BetChipList then
		local chipScore=self.BetChipList[chipIndex]
		self:SetBetScore(chipScore)
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
	self.BetScoreText.text=score
end



function PlayerBetView:SetZhiZhengTips(silderS,silderT)
	self.currentTime=0
	self.isRunZhanPan=true
	self.silderStartP=silderS
	self.silderToP=silderT
end


function PlayerBetView:Update()
	if self.isRunZhanPan then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime<=self.totalTime then
			self.SilderImage.fillAmount=self.silderStartP+(self.silderToP-self.silderStartP)*(self.currentTime/self.totalTime)
			self.ZhiZhengPonitTf.localEulerAngles=CSScript.Vector3(0,0,(180*(1-self.SilderImage.fillAmount)))
			self.ZPTF.localEulerAngles=CSScript.Vector3(0,0,(180*(1-self.SilderImage.fillAmount)-120))
		else
			self.currentTime=0
			self.isRunZhanPan=false
		end
	end
end