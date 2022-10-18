PrototypeTimer=Class()


function PrototypeTimer:ctor()
	self.isUsing=false	--是否正在使用
	self:Init()
end


function PrototypeTimer:Init()
	self.currentTimerIndex=0
	self.isStartTimer=false
	self.delayTime=100000
	
end


function PrototypeTimer:SetUseState(use)
	self.isUsing=use
end

function PrototypeTimer:GetUseState()
	return self.isUsing
end


function PrototypeTimer:SetTimerStateData(delayTime,func,object)

	self.delayTime= math.floor(delayTime*1000) 		--单位ms
	self.callBackFunc=function ()
		func(object)
	end
	self.currentTimerIndex=TimerManager.GetInstance().CSTimerMangaer:AddTimer(self.delayTime,1,self.callBackFunc)
end

function PrototypeTimer:ResetTimeStateData()
	self.delayTime=0
	self.callBackFunc=nil
	self.isUsing=false
	self:RemoveTimer()
	self.currentTimerIndex=0
end


function PrototypeTimer:GetRemainTime()
	local remainTime=TimerManager.GetInstance().CSTimerMangaer:GetLeftTime(self.currentTimerIndex)
	if remainTime<=0 then
		remainTime=0
	end
	return remainTime
end

--修改延迟时间
function PrototypeTimer:ModifyDelayTime(delayTime)
	delayTime=delayTime*1000
	TimerManager.GetInstance().CSTimerMangaer:ModifyTimerTotalTime(self.currentTimerIndex,delayTime)
end


function PrototypeTimer:PauseTimer()
	TimerManager.GetInstance().CSTimerMangaer:PauseTimer(self.currentTimerIndex)
end

function PrototypeTimer:ResumeTimer()
	TimerManager.GetInstance().CSTimerMangaer:ResumeTimer(self.currentTimerIndex)
end


function PrototypeTimer:ResetTimer()
	TimerManager.GetInstance().CSTimerMangaer:ResetTimer(self.currentTimerIndex)
end


function PrototypeTimer:RemoveTimer()
	TimerManager.GetInstance().CSTimerMangaer:RemoveTimer(self.currentTimerIndex)
end







