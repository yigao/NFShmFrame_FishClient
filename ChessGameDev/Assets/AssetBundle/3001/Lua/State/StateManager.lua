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
	WaitOtherPlayerState=1, --等待其它玩家
	GrabTheVillageState=3,  --抢庄
	AllocateGrabTheVillage=4,	--分配庄家
	BetState=5,				--下注
	SendCard=6,				--发牌
	OpenCard=7,				--开牌
	NextWaitGame=8,			--等待下一局开始
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
	StateManager.MainState=nil
	self.IsStateWaiting=nil
end