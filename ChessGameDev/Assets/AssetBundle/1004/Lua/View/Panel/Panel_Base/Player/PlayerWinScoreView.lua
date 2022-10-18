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
	self.Text=GameManager.GetInstance().Text
	self.IsShowWinScore=false
	self.IsShowAddScore=false
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
end


function PlayerWinScoreView:InitViewData()
	self:SetWinScore(0)
end


function PlayerWinScoreView:SetWinScore(score)
	if score==0 then
		self.playerWinScore.text=""
	else
		self.playerWinScore.text=CommonHelper.FormatBaseProportionalScore(score)
	end
end

function PlayerWinScoreView:ResetAddScoreState(score)
	self.currentTime=0
	self.IsShowWinScore=false
	self.addScore=score
	self:SetWinScore(score)
end


function PlayerWinScoreView:SetPlayerWinScore(score,showTime,isShowAddScore)
	self.totalShowTime = showTime or 0.5
	self.IsShowAddScore= isShowAddScore
	self.currentWinScore=score
	self.currentTime=0
	if self.IsShowAddScore==false then
		self.addScore=0
		if score==0 then
			self:SetWinScore(0)
			return
		end
		
	end
	
	if score>0 then
		self.IsShowWinScore=true
	end
	
end


function PlayerWinScoreView:UpdateWinScore()
	if self.IsShowWinScore then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		local tempWinScore=math.ceil(self.addScore+self.currentWinScore*(self.currentTime/self.totalShowTime))
		self:SetWinScore(tempWinScore)
		if self.currentTime>=self.totalShowTime then
			self.IsShowWinScore=false
			self.currentTime=0
			self:SetWinScore(self.addScore+self.currentWinScore)
			if self.IsShowAddScore then
				self.addScore=self.addScore+self.currentWinScore
			else
				self.addScore=0
			end
		end
	end
end


function PlayerWinScoreView:Update()
	self:UpdateWinScore()
end