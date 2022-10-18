GameData=Class()


function GameData:ctor()
	self:Init()

end


function GameData:Init ()
	self:InitData()
end


function GameData:InitData()
	self:InitGameData()
	self:InitFishData()
end

function GameData:InitGameData()
	self.AllAtlasList={}		--所有图集列表
	self.GameItemResList ={}    --
end


function GameData:__delete()
	self.fishRawDataList=nil
	self.gameConfigList=nil
	self.GunLevelConfig=nil
	self.AllAtlasList=nil
end