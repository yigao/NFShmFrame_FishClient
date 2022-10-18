JackpotView=Class()

function JackpotView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function JackpotView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function JackpotView:InitData()
	self.SkeletonAnimation=GameManager.GetInstance().SkeletonAnimation
	self.Text=GameManager.GetInstance().Text
	self.totalWinScore=0
	self.totalTime=0
	self.showTime=t0
	self.currentTime=0
	self.isPlayJackpot=false
end



function JackpotView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
end

function JackpotView:InitViewData()
	self:SetWinScore(0)
end


function JackpotView:FindView(tf)
	self.jackpotSpine=tf:Find("Panel/SpineJackpot"):GetComponent(typeof(self.SkeletonAnimation))
	self.winScoreText=tf:Find("Panel/Score/Text"):GetComponent(typeof(self.Text))
end


function JackpotView:PlaySpineAnim()
	self.jackpotSpine.AnimationState:SetAnimation(0,"animation",false)
end


function JackpotView:SetWinScore(score)
	self.winScoreText.text=CommonHelper.FormatBaseProportionalScore(score)
end


function JackpotView:SetJackpotProcess(score,totalTime)
	self.totalWinScore=score
	self.totalTime=totalTime
	self.showTime=totalTime-1
	self.currentTime=0
	self:SetWinScore(0)
	self.isPlayJackpot=true
	JackpotManager.GetInstance():IsShowGamePanel(true)
end



function JackpotView:Update()
	if self.isPlayJackpot then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime<self.showTime then
			local curentScore=math.ceil(self.totalWinScore*(self.currentTime/self.showTime))
			self:SetWinScore(curentScore)
		elseif self.currentTime>self.showTime and self.currentTime<self.totalTime then
			self:SetWinScore(self.totalWinScore)
		elseif self.currentTime>=self.totalTime then
			self.isPlayJackpot=false
			self.currentTime=0
			self:JackpotFinishCallBack()
		end
	end
end


function JackpotView:JackpotFinishCallBack()
	JackpotManager.GetInstance():IsShowGamePanel(false)
	
end