GameLogicManager=Class()

local Instance=nil
function GameLogicManager:ctor()
	Instance=self
	self:Init()
end

function GameLogicManager.GetInstance()
	return Instance
end



function GameLogicManager:Init()
	self:InitData()
	
end




function GameLogicManager:InitData()
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.gameData=GameManager.GetInstance().gameData
	self.DOTween = GameManager.GetInstance().DOTween
	self.Ease =GameManager.GetInstance().Ease
	
	
end






function GameLogicManager:__delete()

end


