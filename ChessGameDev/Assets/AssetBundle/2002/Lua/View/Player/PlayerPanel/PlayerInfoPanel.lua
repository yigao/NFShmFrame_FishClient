PlayerInfoPanel=Class()

function PlayerInfoPanel:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function PlayerInfoPanel:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function PlayerInfoPanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.PlayerSeatList={}
	self.WaitPlayerBGList = {}
	self.playerCount=self.gameData.PlayerTotalCount
end



function PlayerInfoPanel:InitView(gameObj)
	self:FindView(gameObj)
end



function PlayerInfoPanel:FindView(gameObj)
	local tf=gameObj.transform
	self:FindPlayerSeatView(tf)
end

function PlayerInfoPanel:FindPlayerSeatView(tf)
	for i=1,self.playerCount do
		local p=tf:Find("P"..i).gameObject
		table.insert(self.PlayerSeatList,p)
	end

	for i =1,self.playerCount do 
		local p=tf:Find("P"..i.."/WaitPlayerBG").gameObject
		CommonHelper.SetActive(p,true)
		table.insert(self.WaitPlayerBGList,p)
	end
end

function PlayerInfoPanel:IsShowWaitPlayerBG(index,isDisplay)
	CommonHelper.SetActive(self.WaitPlayerBGList[index],isDisPlay)
end

function PlayerInfoPanel:ResetAllSeatWaitPlayerBG()
	for i = 1,#self.WaitPlayerBGList do
		CommonHelper.SetActive(self.WaitPlayerBGList[i],true)
	end
end

