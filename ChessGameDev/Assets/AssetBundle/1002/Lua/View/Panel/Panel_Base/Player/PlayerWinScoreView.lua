PlayerWinScoreView=Class()

function PlayerWinScoreView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function PlayerWinScoreView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function PlayerWinScoreView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.IsShowWinScore=false
	self.IsShowAddScore=false
	self.IsRecieveScore=false
	self.currentTime=0
	self.totalShowTime=0
	self.currentWinScore=0
	self.addScore=0
end



function PlayerWinScoreView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function PlayerWinScoreView:FindView(tf)
	self:FindPlayerWinScoreView(tf)
end


function PlayerWinScoreView:FindPlayerWinScoreView(tf)
	self.playerWinScore=tf:Find("Down/WinScore/WinScore/Score"):GetComponent(typeof(self.Text))
	self.playerWinScoreEffect=tf:Find("Down/WinScore/WinScore/Score/Effect").gameObject
	self.SingleWinScore=tf:Find("Down/SingleWinScore/WinScore/Image/Score"):GetComponent(typeof(self.Text))
	self.SingleWinScorePanel=tf:Find("Down/SingleWinScore/WinScore/Image").gameObject
end


function PlayerWinScoreView:InitViewData()
	self:SetWinScore(0)
	self:IsShowSingleWinPanel(false)
	self:IsShowPlayerWinScoreEffect(false)
end


function PlayerWinScoreView:SetWinScore(score)
	self.playerWinScore.text=score
end


function PlayerWinScoreView:SetSingleWinScore(score)
	self.SingleWinScore.text=score
end

function PlayerWinScoreView:IsShowSingleWinPanel(isShow)
	CommonHelper.SetActive(self.SingleWinScorePanel,isShow)
end

function PlayerWinScoreView:IsShowPlayerWinScoreEffect(isShow)
	CommonHelper.SetActive(self.playerWinScoreEffect,isShow)
end


function PlayerWinScoreView:SetAddScore(score)
	self.addScore=score
end


function PlayerWinScoreView:SetPlayerWinScore(score,showTime,isShowAddScore)
	self.totalShowTime = showTime or 0.5
	self.IsShowAddScore= isShowAddScore
	self.currentWinScore=score
	self.currentTime=0
	if self.IsShowAddScore==false then
		self.addScore=0
	end
	if score==0 then
		return
	end
	self:SetSingleWinScore("+"..score)
	self:IsShowSingleWinPanel(true)
	
	local DelayShowWinScoreFunc=function ()
		self.IsShowWinScore=true
	end
	self.winSocreTimer=TimerManager.GetInstance():CreateTimerInstance(0.8,DelayShowWinScoreFunc)
end



function PlayerWinScoreView:UpdateWinScore()
	if self.IsShowWinScore then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		local tempWinScore=math.ceil(self.addScore+self.currentWinScore*(self.currentTime/self.totalShowTime))
		self:SetWinScore(tempWinScore)
		tempWinScore=math.ceil(self.currentWinScore-self.currentWinScore*(self.currentTime/self.totalShowTime))
		self:SetSingleWinScore(tempWinScore)
		if self.currentTime>=self.totalShowTime then
			self.IsShowWinScore=false
			self.currentTime=0
			self:SetWinScore(self.gameData.AddPlayerWinScore)
			if self.IsShowAddScore then
				self:SetAddScore(self.gameData.AddPlayerWinScore)
			else
				self:SetAddScore(0)
			end
			
			self:SetSingleWinScore(0)
			self:IsShowSingleWinPanel(false)
		end
	end
end




function PlayerWinScoreView:RecieveScoreProcess()
	self.totalShowTime =1
	self.currentTime=0
	self.IsRecieveScore=true
end


function PlayerWinScoreView:UpdateRecieveScore()
	if self.IsRecieveScore then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		local tempWinScore=math.ceil(self.gameData.AddPlayerWinScore-self.gameData.AddPlayerWinScore*(self.currentTime/self.totalShowTime))
		self:SetWinScore(tempWinScore)
		if self.currentTime>=self.totalShowTime then
			self:SetWinScore(0)
			self.IsRecieveScore=false
			self.currentTime=0
			self.gameData.AddPlayerWinScore=0
			self:IsShowPlayerWinScoreEffect(false)
			BaseFctManager.GetInstance():SetPlayerMoney(self.gameData.PlayerMoney)
		end
	end
end


function PlayerWinScoreView:Update()
	self:UpdateWinScore()
	self:UpdateRecieveScore()
end