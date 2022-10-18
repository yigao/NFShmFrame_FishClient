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
end


GameData.AreaType={
	AREA_Dragon 	=1,  --龙
	AREA_Peace      =2,  --和 
	AREA_Tiger      =3,  --虎
}



function GameData:InitGameCoreData()
	self.MainStation=1					--主游戏状态
	self.CurStationLifeTime = 0 		--当前状态已过时间
	self.CurStationTotalTime = 0		--当前状态总时间
	self.GameChipMoneyList = {}			--游戏下注的筹码列表
	self.PrizeTotalCount = 0   			--已开总局数
	self.PrizeDragonCount = 0  			--开龙总局数
	self.PrizeTigerCount = 0 			--开虎总局数
	self.PrizePeaceCount = 0 			--开和总局数
	self.PrizeHistoryRecord = {}		--近50局开奖记录
	self.OwnBetMoney = {}				--各区域自己已下注金额 三个区域
	self.AllBetMoney = {}				--各区域总下注金额 三个区域	
	self.CurBankerVo = nil				--当前的庄家
	self.WaitBankerVoList = {}			--等待上庄的玩家列表
	self.BeBankMinMoney = 0 			--上庄最低金额
	self.BankMaxNtCount = 0				--最大上庄次数

	self.CurrentBetIndex = 0			--玩家当前选中的筹码
end


function GameData:__delete()
	self.gameConfigList=nil
	self.AllAtlasList=nil
end







