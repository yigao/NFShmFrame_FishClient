HandselItem=Class()

function HandselItem:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function HandselItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function HandselItem:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.IsUpdateHandsel=false
	self.currentTime=0
	self.totalTime=0
	self.startScore=0
	self.totalScore=0
	self.addScore=0
	self.handselIndex=0
end



function HandselItem:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function HandselItem:FindView(tf)
	self.text=tf:Find("Text"):GetComponent(typeof(self.Text))
end


function HandselItem:InitViewData()
	self:SetTextValue(0)
end


function HandselItem:SetTextValue(value)
	self.text.text=CommonHelper.FormatBaseProportionalScore(value)
	if self.handselIndex==4 then
		HandselManager.GetInstance().HandselView:SetJJJackpotSocre(value)
	end
end


function HandselItem:SetHandselProcess(data)
	self.handselIndex=data.jackpotType
	self.startScore=data.jackpotStartValue
	self.addScore=data.jackpotAddValue
	self.totalTime=data.jackpotAddTime/1000+0.5
	self.currentTime=0
	self:SetTextValue(self.startScore)
	self.IsUpdateHandsel=true
end


function HandselItem:Update()
	if self.IsUpdateHandsel then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		local tempScore=math.ceil(self.startScore+self.addScore*(self.currentTime/self.totalTime))
		self:SetTextValue(tempScore)
		if self.currentTime>=self.totalTime then
			self.IsUpdateHandsel=false
			self.currentTime=0
			self:SetTextValue(self.totalScore)
		end
	end
end