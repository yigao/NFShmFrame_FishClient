TimerManager=Class()

local Instance=nil
function TimerManager:ctor()
	Instance=self
	self:Init()
end


function TimerManager:Init()
	self:InitData()
	self:CreateTimerIns()
end


function TimerManager:InitData()
	self.CSTimerMangaer=CS.TimerManager.instance
	self.CacheMapList={}
	self.InitCount=5
end

function TimerManager:CreateTimerIns()
	for i=1,self.InitCount do
		local tempIns=PrototypeTimer.New()
		table.insert(self.CacheMapList,tempIns)
	end
end


function TimerManager:GetTimerIns()
	local targetIns=self:GetEnableTimerIns()
	if targetIns then
		targetIns:SetUseState(true)
		return targetIns
	end
	return nil
	
end

function TimerManager:GetEnableTimerIns()
	for i=1,#self.CacheMapList do
		if self.CacheMapList[i]:GetUseState()==false then
			return self.CacheMapList[i]
		end
	end
	return nil
	
end



--创建和回收搭配使用
function TimerManager:CreateTimerInstance(delayTime,func,object)
	local tempTimerIns=self:GetTimerIns()
	if tempTimerIns==nil then
		tempTimerIns=PrototypeTimer.New()
		tempTimerIns:SetUseState(true)
		table.insert(self.CacheMapList,tempTimerIns)
	end
	
	tempTimerIns:SetTimerStateData(delayTime,func,object)
	return tempTimerIns
end



function TimerManager:RecycleTimerIns(targetStateList)
	if targetStateList==nil then  return end	
	targetStateList:SetUseState(false)
	targetStateList:ResetTimeStateData()
end



function TimerManager:RecycleAllTimerIns()
	for i=1,#self.CacheMapList do
		self:RecycleTimerIns(self.CacheMapList[i])
	end
end



function TimerManager:GetRemainTime(targetStateList)
	if targetStateList==nil then  return 0 end
	return targetStateList:GetRemainTime()
end


function TimerManager:ModifyDelayTime(delayTime)
	if targetStateList==nil then  return end
	targetStateList:ModifyDelayTime(delayTime)
end


function TimerManager:PauseTimer(targetStateList)
	if targetStateList==nil then  return end
	targetStateList:PauseTimer()
end

function TimerManager:ResumeTimer(targetStateList)
	if targetStateList==nil then  return end
	targetStateList:ResumeTimer()
end


function TimerManager:ResetTimer(targetStateList)
	if targetStateList==nil then  return end
	targetStateList:ResetTimer()
end










function TimerManager.GetInstance()
	if Instance==nil then
		Instance=TimerManager.New()
	end
	return Instance
end