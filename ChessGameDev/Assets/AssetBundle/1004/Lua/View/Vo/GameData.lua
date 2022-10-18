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
	self:InitSpecialGameData()
	self:MiniGameData()
	
end

function GameData:InitGameData()
	self.gameConfigList={}			--游戏配置列表
	self.AllAtlasList={}
end


function GameData:InitGameCoreData()
	self.MainStation=0				--主游戏状态
	self.NextMainStation=0			--下一个主游戏状态
	self.SubStation=1				--子游戏状态
	self.IsAutoState=false			--是否自动
	self.IsQuickState=false			--是否快速模式
	self.GameIconResult={}			--游戏图标结果
	self.PrizeLineResultList={}		--中奖线结果
	self.PlayerMoney=0				--玩家身上的总分
	self.PlayerWinScore=0			--玩家赢分
	self.CurrentBetMultiple=0		--当前下注倍数
	self.AutoCount=0				--自动次数
	self.IsIconRuning=false			--是否正在滚动
	self.IsRecieveSeverData=false	--是否收到服务端返回数据
end


function GameData:InitSpecialGameData()
	self.GameBetToChangeOtherDataList={}
	self.WildStateList={}
	self.SLBMiniGameIconMaskStateList={}
end


function GameData:MiniGameData()
	self.FreeGameTotalCount=0		--小游戏总次数
	self.RemainFreeGameCount=0		--剩余免费次数
	self.FreeGameTotalWinScore=0	--免费游戏中赢分
	self.NextGameTotalScore=0
end






