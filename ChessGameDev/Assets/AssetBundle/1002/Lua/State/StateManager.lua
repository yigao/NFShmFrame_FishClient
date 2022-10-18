StateManager=Class()

local Instance=nil
function StateManager:ctor()
	Instance=self
	self:Init()
end

function StateManager.GetInstance()
	return Instance
end


StateManager.MainState={
	Normal=0,
	Bonus=1,
	Jackpot=2,
}

StateManager.SubState={
	Normal=1,
	FreeGame=2,
	Bonus=3,
	Win=4,
	FreeGameOver=5,
	Jackpot=6,
}



function StateManager:Init()
	self:InitData()
	
end



function StateManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.IsStateWaiting=false
end



function StateManager:SetGameMainStation(stationNum)
	self.gameData.MainStation=stationNum
end


function StateManager:SetNextMainStation(nextStationNum)
	self.gameData.NextMainStation=nextStationNum
end


function StateManager:SetSubGameStation(stationNum)
	self.gameData.SubStation=stationNum
end


function StateManager:SetStateWait(isWaiting)
	self.IsStateWaiting=isWaiting
end

function StateManager:GetGameStateWaitResult()
	return self.IsStateWaiting
end


function StateManager:EnableGameState()
	self:SetStateWait(true)
end


function StateManager:GameStateOverCallBack()
	self:SetStateWait(false)
	GameLogicManager.GetInstance():EndStateCallBack()
end


function StateManager:__delete()
	StateManager.MainState=nil
	StateManager.SubState=nil
	self.IsStateWaiting=nil
end