HandselItem=Class()

function HandselItem:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function HandselItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function HandselItem:InitData()
	self.Text=GameManager.GetInstance().Text
	self.IsAddScore=false
	self.currentTime=0
	self.totalTime=0
	self.startScore=0
	self.addScore=0
end



function HandselItem:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
end


function HandselItem:FindView(tf)
	self.HandselValueText=tf:Find("TextValue"):GetComponent(typeof(self.Text))
end



function HandselItem:InitViewData()
	self:SetHandselValue(0)
end


function HandselItem:SetHandselValue(score)
	self.HandselValueText.text=CommonHelper.FormatBaseProportionalScore(score)
end


function HandselItem:SetAddScore(data)
	self.startScore=data.jackpotStartValue
	self.addScore=data.jackpotAddValue
	self.totalTime=data.jackpotAddTime/1000+0.5
	self.currentTime=0
	self.IsAddScore=true
end


function HandselItem:Update()
	if self.IsAddScore then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime<self.totalTime then
			local values=self.startScore+math.ceil(self.addScore*(self.currentTime/self.totalTime))
			self:SetHandselValue(values)
		else
			self.IsAddScore=false
			self.currentTime=0
			self:SetHandselValue(self.startScore+self.addScore)
		end
	end
end

