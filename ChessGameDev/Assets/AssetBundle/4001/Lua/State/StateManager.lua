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
	STATE_GameStart 	=1,  --游戏开始
	STATE_BetChip       =2,  --下注 
	STATE_OpenPrize     =3,  --开奖
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
	--GameLogicManager.GetInstance():EndStateCallBack()
end


function StateManager:__delete()
	print("oooooooooooooooooo")
	StateManager.MainState=nil
	self.IsStateWaiting=nil
end