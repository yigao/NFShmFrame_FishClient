TimerTipsView=Class()


function TimerTipsView:ctor(obj)
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end

function TimerTipsView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function TimerTipsView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.TimerTipsTextList={}
	self.isUpdateTimer=false
	self.currentText=nil
	self.currentTime=0
	self.addTime=0
	self.curentIndex=1
end



function TimerTipsView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function TimerTipsView:InitViewData()
	self:ResetTimerTipsPanl()
end


function TimerTipsView:FindView(tf)
	local tempObj=tf:Find("Panel/TimerTips/GameStartTimeTips/Text"):GetComponent(typeof(self.Text))		
	table.insert(self.TimerTipsTextList,tempObj)
	tempObj=tf:Find("Panel/TimerTips/QiangZhuangTimeTips/Text"):GetComponent(typeof(self.Text))
	table.insert(self.TimerTipsTextList,tempObj)
	tempObj=tf:Find("Panel/TimerTips/OtherQiangZhuangTimeTips/Text"):GetComponent(typeof(self.Text))
	table.insert(self.TimerTipsTextList,tempObj)
	tempObj=tf:Find("Panel/TimerTips/BetTimeTips/Text"):GetComponent(typeof(self.Text))
	table.insert(self.TimerTipsTextList,tempObj)
	tempObj=tf:Find("Panel/TimerTips/OtherBetTimeTips/Text"):GetComponent(typeof(self.Text))
	table.insert(self.TimerTipsTextList,tempObj)
	tempObj=tf:Find("Panel/TimerTips/TPTimeTips/Text"):GetComponent(typeof(self.Text))
	table.insert(self.TimerTipsTextList,tempObj)
	tempObj=tf:Find("Panel/TimerTips/OtherTPTimeTips/Text"):GetComponent(typeof(self.Text))
	table.insert(self.TimerTipsTextList,tempObj)
end


function TimerTipsView:IsShowSingleTimerTipsPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.TimerTipsTextList,isShow,false,false,true)
end


function TimerTipsView:GetCurrentCountDownTimer(index)
	return self.TimerTipsTextList[index]
end


function TimerTipsView:SetCountDownTimeValue(rTimes)
	if self.currentText then
		self.currentText.text=rTimes
	end
end


function TimerTipsView:ResetTimerTipsPanl()
	self.isUpdateTimer=false
	self.currentText=nil
	self:IsShowSingleTimerTipsPanel(0,true)
end


function TimerTipsView:GetCurrentRemainTime()
	return self.currentTime
end


function TimerTipsView:SetCountDownTimer(index,rTimes)
	self:ResetTimerTipsPanl()
	self.curentIndex=index
	self.currentText=self:GetCurrentCountDownTimer(index)
	self.currentTime=math.ceil(rTimes/1000)
	self.addTime=0
	self:SetCountDownTimeValue(self.currentTime)
	self:IsShowSingleTimerTipsPanel(index,true)
	self.isUpdateTimer=true
end



function TimerTipsView:Update()
	if self.isUpdateTimer then
		self.addTime=self.addTime+CSScript.Time.deltaTime
		if self.addTime>=1 then
			AudioManager.GetInstance():PlayNormalAudio(24,0.2)
			self.currentTime=self.currentTime-1
			self.addTime=0
			if self.currentTime>0 then
				self:SetCountDownTimeValue(self.currentTime)
			else
				self.isUpdateTimer=false
				self:SetCountDownTimeValue(0)
				self:IsShowSingleTimerTipsPanel(0,true)
			end
		end
	end
end