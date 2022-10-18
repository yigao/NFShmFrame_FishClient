BonusIconManager=Class()

function BonusIconManager:ctor()
	self:Init()
end

function BonusIconManager:Init ()
	self:InitData()
	
	
end


function BonusIconManager:InitData()
	self.IsFirstRun=false
	self.StartRunPos=1
	self.EndRunPos=1
	self.BonusRunCount=1
	self.BonusTotalCount=1
	self.CurrentBonusRunIntervalTime=0
	self.BonusRunIntervalTime={0.6,0.5,0.4,0.3,0.2}
end



function BonusIconManager:GetStartRunPos()
	return self.EndRunPos
end


function BonusIconManager:GetRandomBonusRunCount()
	return math.random(2,3)
end


function BonusIconManager:SetMainIconRun(startPos,endPos)
	self.StartRunPos=startPos
	self.EndRunPos=endPos
	self.BonusTotalCount=self:GetRandomBonusRunCount()
	self.BonusRunCount=self.BonusTotalCount
	self.StartRunIntervalTimeIndex=1
	self.StopRunIntervalTimeIndex=#self.BonusRunIntervalTime
	self.BonusTotalIntervalCount=#self.BonusRunIntervalTime
	local StartMainIconRunFunc=function ()
		local MainIconItemInsList=BonusManager.GetInstance().MainIconItemInsList
		if MainIconItemInsList and #MainIconItemInsList>0 then
			self.IsFirstRun=true
			self:SetFristCircle(MainIconItemInsList)
			self.IsFirstRun=false
			local isLoopRun=true
			while isLoopRun do
				if self.BonusRunCount==2 then
					BonusManager.GetInstance():StopRunMidIcon()
				end
				for i=1,#MainIconItemInsList do
					if self.BonusRunCount>1 then
						self:SetStartRun(MainIconItemInsList[i],i)
					else
						if i~=self.EndRunPos then
							self:SetStartRun(MainIconItemInsList[i],i)
						else
							isLoopRun=false
							MainIconItemInsList[i]:IsShowChangeIconImagePanel(true)
							MainIconItemInsList[i]:PlaySelectIconAnim()
							BonusManager.GetInstance():SetMainIconEndRunCallBack()
							
							local IsContinuePlayBonusFunc=function ()
								self:ResetContinuePlayBonusTimer()
								BonusManager.GetInstance():IsContinuePlayBonus()
							end
							self.ContinuePlayBonusTimer=TimerManager.GetInstance():CreateTimerInstance(3,IsContinuePlayBonusFunc)
							return
						end
					end	
					
				end
				
				self.BonusRunCount=self.BonusRunCount-1
				yield_return(0)
			end
		else
			Debug.LogError("Bonus主图标实例异常")
		end
	end
	startCorotine(StartMainIconRunFunc)
end


function BonusIconManager:ResetContinuePlayBonusTimer()
	if self.ContinuePlayBonusTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.ContinuePlayBonusTimer)
		self.ContinuePlayBonusTimer=nil
	end
end



function BonusIconManager:SetFristCircle(MainIconItemInsList)
	for i=self.StartRunPos,#MainIconItemInsList do
		self:SetStartRun(MainIconItemInsList[i],i)
	end
end


function BonusIconManager:SetStartRun(mainIconItemIns,iconIndex)
	self.CurrentBonusRunIntervalTime=0.1
	if self.BonusRunCount>1 then
		if self.StartRunIntervalTimeIndex<=self.BonusTotalIntervalCount then
			self.CurrentBonusRunIntervalTime=self.BonusRunIntervalTime[self.StartRunIntervalTimeIndex]
			self.StartRunIntervalTimeIndex=self.StartRunIntervalTimeIndex+1
		end
		
		if self.BonusRunCount==2 and self.IsFirstRun==false then
			if self.EndRunPos<=self.BonusTotalIntervalCount then
				if iconIndex>(24-self.BonusTotalIntervalCount+self.EndRunPos) then
					if self.StopRunIntervalTimeIndex>0 then
						self.CurrentBonusRunIntervalTime=self.BonusRunIntervalTime[self.StopRunIntervalTimeIndex]
					end
					self.StopRunIntervalTimeIndex=self.StopRunIntervalTimeIndex-1
				end
			end
		end
		
	else
		if self.EndRunPos>self.BonusTotalIntervalCount then
			if self.EndRunPos-self.BonusTotalIntervalCount<iconIndex then
				if self.StopRunIntervalTimeIndex>0 then
					self.CurrentBonusRunIntervalTime=self.BonusRunIntervalTime[self.StopRunIntervalTimeIndex]
					self.StopRunIntervalTimeIndex=self.StopRunIntervalTimeIndex-1
				end
			end
		else
			if self.StopRunIntervalTimeIndex>0 then
				self.CurrentBonusRunIntervalTime=self.BonusRunIntervalTime[self.StopRunIntervalTimeIndex]
				self.StopRunIntervalTimeIndex=self.StopRunIntervalTimeIndex-1
			end
		end
		
		
	end
	AudioManager.GetInstance():PlayNormalAudio(21)
	mainIconItemIns:PlayAnim(1)
	mainIconItemIns:IsShowSelectIconImagePanel(true)
	yield_return(WaitForSeconds(self.CurrentBonusRunIntervalTime))
	mainIconItemIns:IsShowSelectIconImagePanel(false)
end












function BonusIconManager:__delete()
	
end