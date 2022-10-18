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
	self.ResolutionWidth=1560
	self.ResolutionWidthHalf=1560/2
	self.ResolutionHeight=960
	self.ResolutionHeightHalf=960/2
	self.PlayerChairId= 0	--玩家自己的座位id
	self.PlayerTotalCount=4
	self.UserID=154183			--用户ID
	self.GunLevelConfig={}		--炮等级配置列表
	self.AllAtlasList={}		--所有图集列表
end


function GameData:InitFishData()
	self.fishRawDataList={}			--服务端下发的鱼
	self.gameConfigList={}			--游戏配置列表
end


function GameData:__delete()
	self.fishRawDataList=nil
	self.gameConfigList=nil
	self.GunLevelConfig=nil
	self.AllAtlasList=nil
end