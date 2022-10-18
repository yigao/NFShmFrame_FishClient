GameData=Class()


function GameData:ctor()
	self:Init()

end


function GameData:Init ()
	self:InitData()
end


function GameData:InitData()
	self:InitGameData()
end

function GameData:InitGameData()
	self.AllAtlasList={}		--所有图集列表
	self.GameItemResList ={}    --
	self.lobbyExcelConfigList= {}
end


function GameData:__delete()
	self.GameItemResList=nil
	self.lobbyExcelConfigList=nil
	self.AllAtlasList=nil
end