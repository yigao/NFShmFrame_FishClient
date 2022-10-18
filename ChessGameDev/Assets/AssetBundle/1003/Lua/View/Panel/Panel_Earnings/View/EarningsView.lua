EarningsView=Class()

function EarningsView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function EarningsView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function EarningsView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.ScoreRawPos=nil
	self.IsUpdateWinScore=false
	self.IsUpdateSpecialWinScore=false
	self.currentTime=0
	self.totalShowTime=0
	self.currentWinScore=0
	self.stayShowTime=0
end



function EarningsView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function EarningsView:FindView(tf)
	self.SetPanel=tf:Find("Set").gameObject
	self.BoxBtn=tf:Find("Set/BG/ImageBox"):GetComponent(typeof(self.Button))
	self.BtnPanel=tf:Find("Set/Btn").gameObject
	self.GetScoreBtn=tf:Find("Set/Btn/Get"):GetComponent(typeof(self.Button))
	self.GuessBtn=tf:Find("Set/Btn/Guess"):GetComponent(typeof(self.Button))
	self.ScoreText=tf:Find("Win/Score/ScoreText"):GetComponent(typeof(self.Text))
	self.ScoreRawPos=self.ScoreText.gameObject.transform.localPosition
	self.ScoreMovePos=tf:Find("Win/Score/TargerPos")
end



function EarningsView:AddEventListenner()
	self.BoxBtn.onClick:AddListener(function () self:OnclickGetScoreBtn() end)
	self.GetScoreBtn.onClick:AddListener(function () self:OnclickGetScoreBtn() end)
	self.GuessBtn.onClick:AddListener(function () self:OnclickEnterGuessBtn() end)
end



function EarningsView:OnclickGetScoreBtn()
	self.IsUpdateWinScore=false
	self:ScoreFly()
end


function EarningsView:OnclickEnterGuessBtn()
	self.IsUpdateWinScore=false
	EarningsManager.GetInstance():EnterGuess()
end


function EarningsView:IsShowSetPanel(isShow)
	CommonHelper.SetActive(self.SetPanel,isShow)
end


function EarningsView:IsShowBtnPanel(isShow)
	CommonHelper.SetActive(self.BtnPanel,isShow)
end


function EarningsView:IsEnableAllControlBtn(isEnable)
	CommonHelper.IsEnableUGUIButton(self.BoxBtn,isEnable)
	CommonHelper.IsEnableUGUIButton(self.GetScoreBtn,isEnable)
	CommonHelper.IsEnableUGUIButton(self.GuessBtn,isEnable)
end


function EarningsView:SetWinScore(score)
	self.ScoreText.text=CommonHelper.FormatBaseProportionalScore(score)
end



function EarningsView:ResetView()
	self:ResetScore()
	self:IsShowSetPanel(true)
	self:IsShowBtnPanel(true)
	EarningsManager.GetInstance():IsShowEarningsPanel(true)
	self:IsEnableAllControlBtn(true)
end


function EarningsView:ResetScore()
	self.ScoreText.gameObject.transform.localPosition=self.ScoreRawPos
	self.ScoreText.gameObject.transform.localScale=CSScript.Vector3(1, 1, 1)
end



function EarningsView:ScoreFly()
	self:IsShowSetPanel(false)
	local sequence = self.DOTween.Sequence()
	local tween1=self.ScoreText.gameObject.transform:DOLocalMove(self.ScoreMovePos.localPosition,0.5)
	tween1:SetEase(self.Ease.InQuint)
	local tween2=self.ScoreText.gameObject.transform:DOScale(CSScript.Vector3(0, 0, 0),0.5)
	tween2:SetEase(self.Ease.InQuint)
	sequence:Append(tween1)
	sequence:Join(tween2)
	local EndAnimCallBackFunc=function ()
		EarningsManager.GetInstance():IsShowEarningsPanel(false)
		self:EndCallBack()
		BaseFctManager.GetInstance():SetPlayerMoney(self.gameData.PlayerMoney)
	end
	sequence:AppendCallback(EndAnimCallBackFunc)
	
end


function EarningsView:EndCallBack()
	if self.callBackFunc then
		self.callBackFunc()
		self.callBackFunc=nil
	end
end


function EarningsView:UpdateWinScore()
	if self.IsUpdateWinScore then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		local tempWinScore=math.ceil(self.currentWinScore*(self.currentTime/self.totalShowTime))
		self:SetWinScore(tempWinScore)
		if self.currentTime>=self.totalShowTime and self.currentTime<self.stayShowTime  then
			self:SetWinScore(self.currentWinScore)
		elseif self.currentTime>=self.stayShowTime then
			self.currentTime=0
			self.IsUpdateWinScore=false
			self:SetWinScore(self.currentWinScore)
			if self.gameData.IsAutoState then
				self:OnclickGetScoreBtn()
			end
		end
	end
end



function EarningsView:UpdateSpecialWinScore()
	
	if self.IsUpdateSpecialWinScore then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		local tempWinScore=math.ceil(self.currentWinScore*(self.currentTime/self.totalShowTime))
		self:SetWinScore(tempWinScore)
		if self.currentTime>=self.totalShowTime then
			self:SetWinScore(self.currentWinScore)
			self.currentTime=0
			self.IsUpdateSpecialWinScore=false
			self.callBackFunc=function ()
				StateManager.GetInstance():GameStateOverCallBack()
			end
			self:OnclickGetScoreBtn()
		end
	end
end



function EarningsView:Update()
	self:UpdateWinScore()
	self:UpdateSpecialWinScore()
end



