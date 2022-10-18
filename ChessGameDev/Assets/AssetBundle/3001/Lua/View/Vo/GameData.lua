GameData=Class()


function GameData:ctor()
	self:Init()

end


function GameData:Init ()
	self:InitData()
end


function GameData:InitData()
	self:InitGameData()
	self:InitGameCoreData()
end

function GameData:InitGameData()
	self.gameConfigList={}			--游戏配置列表
	self.AllAtlasList={}
	self.PlayerChairId= 0	--玩家自己的座位id
	self.PlayerTotalCount=5
	self.ZJChairId=0		--庄家座位号
end


function GameData:InitGameCoreData()
	self.MainStation=1				--主游戏状态
	self.BaseBetScore=0				--基础下注值
	self.QZMulptileList={}			--抢庄下注列表
	self.BetMulptileList={}			--下注列表
end


function GameData:__delete()
	self.gameConfigList=nil
	self.AllAtlasList=nil
end







