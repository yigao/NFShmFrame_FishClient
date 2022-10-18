BetChipView=Class()

function BetChipView:ctor(gameObj)
	self:Init(gameObj)
	
end

function BetChipView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function BetChipView:InitData()
	self.BetTotalCount = 0
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Text = GameManager.GetInstance().Text
	self.Vector3 = GameManager.GetInstance().Vector3
	self.MySelfBetChipMoneyList = {0,0,0}
	self.AllBetChipMoneyList = {0,0,0}
	self.BetChipItemList = {}
	self.AreaTransList = {}
	self.AreaBetChipList = {}
	self.PlaceBetMoneyList = {}
	self.AllBetChipInsList = {}
end

function BetChipView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function BetChipView:FindView(tf)
	for i = 1,5 do
		local betChipItem=tf:Find("ItemPanel/Chip"..i).gameObject
		table.insert(self.BetChipItemList,betChipItem)
	end
	local dragonAreaTrans = tf:Find("Aread/Dragon")
	table.insert(self.AreaTransList,dragonAreaTrans)
	local peaceAreaTrans = tf:Find("Aread/Peace")
	table.insert(self.AreaTransList,peaceAreaTrans)
	local tigerAreaTrans = tf:Find("Aread/Tiger")
	table.insert(self.AreaTransList,tigerAreaTrans)

	local dragonMoney_text = tf:Find("BetChipMoney/DragonMoney/number"):GetComponent(typeof(self.Text))
	table.insert(self.PlaceBetMoneyList,dragonMoney_text)
	local peaceMoney_text = tf:Find("BetChipMoney/PeaceMoney/number"):GetComponent(typeof(self.Text))
	table.insert(self.PlaceBetMoneyList,peaceMoney_text)
	local tigerMoney_text = tf:Find("BetChipMoney/TigerMoney/number"):GetComponent(typeof(self.Text))
	table.insert(self.PlaceBetMoneyList,tigerMoney_text)
end

function BetChipView:InitViewData()
	self:ResetAreaBetMoneyVale()
end

function BetChipView:AddEventListenner()
	
end

function BetChipView:ResetAreaBetMoneyVale()
	for i = 1,#self.MySelfBetChipMoneyList do
		self.MySelfBetChipMoneyList[i] = 0
		self.AllBetChipMoneyList[i] = 0
	end
	self:SetAreaBetChipMoneyValue()
end


function BetChipView:EnterGameStart()
	self:ResetAreaBetMoneyVale()
end

function BetChipView:PrizeBetChip(ownBetChipMoney,allBetChipMoney)
	local count = 200
	for i = 1,count do
		local betChipVo = self:GetBetChipVo(math.random(1,#self.gameData.GameChipMoneyList),math.random(1,GameData.AreaType.AREA_Tiger))
		local targetAreaPos = self:GetTargetAreaPos(betChipVo.AreaIndex)
		local betChipItem = self:GetBetChipItem(betChipVo)
		self.BetTotalCount = self.BetTotalCount + 1
		betChipItem.BetChipTrans.position = targetAreaPos
		betChipItem.BetChipTrans:SetSiblingIndex(self.BetTotalCount)
	end

	if ownBetChipMoney then
		self.MySelfBetChipMoneyList = ownBetChipMoney
	end

	if allBetChipMoney then
		self.AllBetChipMoneyList = allBetChipMoney
	end
	self:SetAreaBetChipMoneyValue()
end


function BetChipView:EnterBetChip(ownBetChipMoney,allBetChipMoney)
	self.BetTotalCount = 0
	if self.gameData.CurStationLifeTime >= 0.1 then
		local count = tonumber(7 * self.gameData.CurStationLifeTime)
		for i = 1,count do
			local betChipVo = self:GetBetChipVo(math.random(1,#self.gameData.GameChipMoneyList),math.random(1,GameData.AreaType.AREA_Tiger))
			local targetAreaPos = self:GetTargetAreaPos(betChipVo.AreaIndex)
			local betChipItem = self:GetBetChipItem(betChipVo)
			self.BetTotalCount = self.BetTotalCount + 1
			betChipItem.BetChipTrans.position = targetAreaPos
			betChipItem.BetChipTrans:SetSiblingIndex(self.BetTotalCount)
		end

		if ownBetChipMoney then
			self.MySelfBetChipMoneyList = ownBetChipMoney
		end

		if allBetChipMoney then
			self.AllBetChipMoneyList = allBetChipMoney
		end
		self:SetAreaBetChipMoneyValue()
	end
end

function BetChipView:BeginCreateBetChipItem(isMe,OneBet,beginPos,areaIndex,chipIndex,addBetChipMoney,ownBetChipMoney,allBetChipMoney)
	if isMe then
		self.MySelfBetChipMoneyList = ownBetChipMoney
		self.AllBetChipMoneyList = allBetChipMoney
		self:SetAreaBetChipMoneyValue()
		local targetAreaPos = self:GetTargetAreaPos(areaIndex)
		local betChipVo = self:GetBetChipVo(chipIndex,areaIndex)
		local betChipItem = self:GetBetChipItem(betChipVo)
		if betChipItem then
			self.BetTotalCount = self.BetTotalCount + 1
			betChipItem:ShowBetChipItem(self.BetTotalCount,0,self.gameData.GameChipMoneyList[chipIndex],beginPos,targetAreaPos)
		end
	else
		self.AllBetChipMoneyList = allBetChipMoney
		self:SetAreaBetChipMoneyValue()
		local betCount = 5
		if OneBet == true then
			betCount = 1
		end
		local delayTimeInterval = 0
		for i = 1,betCount do
			local tmpAreaIndex = 0
			if OneBet == true then
				tmpAreaIndex = areaIndex
			else
				tmpAreaIndex = math.random(1,GameData.AreaType.AREA_Tiger)
			end
 				
			local targetAreaPos = self:GetTargetAreaPos(tmpAreaIndex)
			local tmpChipIndex = math.random(1,#self.gameData.GameChipMoneyList)
			local betChipVo = self:GetBetChipVo(tmpChipIndex,tmpAreaIndex)
			local betChipItem = self:GetBetChipItem(betChipVo)
			if betChipItem then
				self.BetTotalCount = self.BetTotalCount + 1
				delayTimeInterval = delayTimeInterval + 0.1
				betChipItem:ShowBetChipItem(self.BetTotalCount,delayTimeInterval,self.gameData.GameChipMoneyList[tmpChipIndex],beginPos,targetAreaPos)
			end
		end
	end
end

function BetChipView:SetAreaBetChipMoneyValue()
	for i = 1,#self.PlaceBetMoneyList do
		local tmpOwnBetMoney = CommonHelper.FormatBaseProportionalScore(math.abs(self.MySelfBetChipMoneyList[i]))
		local tmpAllBetMoney = CommonHelper.FormatBaseProportionalScore(math.abs(self.AllBetChipMoneyList[i]))
		self.PlaceBetMoneyList[i].text = tmpOwnBetMoney .."/"..tmpAllBetMoney
	end
end

function BetChipView:GetTargetAreaPos(areaIndex)
	return BGManager.GetInstance():GetBetAreaRandomPos(areaIndex)
end

function BetChipView:GetBetChipVo(chipIndex,areaIndex)
	local vo={}
	vo.ChipIndex = chipIndex
	vo.AreaIndex = areaIndex
	vo.BetChipName = self.BetChipItemList[chipIndex].gameObject.name
	return vo
end

function BetChipView:GetBetChipItem(betChipVo)
	if self.AllBetChipInsList[betChipVo.ChipIndex] and next(self.AllBetChipInsList[betChipVo.ChipIndex]) then
		local betChipIns=table.remove(self.AllBetChipInsList[betChipVo.ChipIndex],1)
		if betChipIns then
			
			betChipIns:ResetBetChipVo(betChipVo)
			if(self.AreaBetChipList[betChipVo.AreaIndex])==nil then
				self.AreaBetChipList[betChipVo.AreaIndex]={}
			end
			table.insert(self.AreaBetChipList[betChipVo.AreaIndex],betChipIns)
			return betChipIns
		else
			Debug.LogError("创建BetChipItem失败")
		end
	else
		local tempBT=GameObjectPoolManager.GetInstance():GetGameObject(betChipVo.BetChipName,GameObjectPoolManager.PoolType.BetChipPool)
		local betChipIns=BetChipManager.GetInstance().BetChipItem.New(tempBT)
		if betChipIns then
			betChipIns:ResetBetChipVo(betChipVo)
			if self.AreaBetChipList[betChipVo.AreaIndex] == nil then
				self.AreaBetChipList[betChipVo.AreaIndex] = {}
			end
			table.insert(self.AreaBetChipList[betChipVo.AreaIndex],betChipIns)
			return betChipIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(tempBT,GameObjectPoolManager.PoolType.BetChipPool)
			Debug.LogError("创建BetChipItem失败")
		end
	end
	return nil
end

function BetChipView:RecycleBetChipItem(betChipItem)
	if self.AreaBetChipList[prizeType] and next(self.AreaBetChipList[prizeType]) then
		betChipItem:Destroy()
		self.AreaBetChipList[prizeType][betChipItem.betChipVo.UID] = nil
		table.insert(self.AllBetChipInsList[betChipItem.betChipVo.ChipIndex],betChipItem)
	end
end



function BetChipView:ClearAllBetChipItem()
	for i = 1,#self.AreaBetChipList do 
		for k,v in pairs(self.AreaBetChipList[i]) do
			v:Destroy()
			if self.AllBetChipInsList[v.betChipVo.ChipIndex] == nil then
				self.AllBetChipInsList[v.betChipVo.ChipIndex] = {}
			end
			table.insert(self.AllBetChipInsList[v.betChipVo.ChipIndex],v)
		end
	end
	self.AreaBetChipList = {}
end


function BetChipView:MoveBetChipToWin(prizeType)
	local delayMoveToPlayerCallback = function()
		AudioManager.GetInstance():PlayNormalAudio(26)
		TimerManager.GetInstance():RecycleTimerIns(self.DelayMoveToPlayer)
		self:MoveBetChipToPlayer(prizeType)
	end
	local totalBetCount = 0
	local flagCount = 0
	local moveNextCallBack = function(curBetChipItem)
		flagCount = flagCount + 1
		if flagCount == totalBetCount then
			self.DelayMoveToPlayer=TimerManager.GetInstance():CreateTimerInstance(0.2,delayMoveToPlayerCallback)
		end
	end
	if(self.AreaBetChipList[prizeType])==nil then
		self.AreaBetChipList[prizeType]={}
	end
	
	for i,v in pairs(self.AreaBetChipList) do
		if i ~= prizeType then
			totalBetCount = totalBetCount + #self.AreaBetChipList[i]
			if #self.AreaBetChipList[i] >= 1 then
				local timeInterval = 0
				for j = 1,#self.AreaBetChipList[i] do
					timeInterval = timeInterval + 0.01
					self.AreaBetChipList[i][j]:MoveToWinArea(timeInterval,BaseFctManager.GetInstance():GetBankerBetInitPos(),self:GetTargetAreaPos(prizeType),moveNextCallBack)
					table.insert(self.AreaBetChipList[prizeType],self.AreaBetChipList[i][j])
				end
				self.AreaBetChipList[i] = {}
			end
		end
	end
	AudioManager.GetInstance():PlayNormalAudio(26)
end


function BetChipView:MoveBetChipToPlayer(prizeType)
	local tmpCount = 0
	local totalCount = #self.AreaBetChipList[prizeType]
	local recycleCallBack = function(curBetChipItem)
		tmpCount = tmpCount + 1
		curBetChipItem.BetChipTrans.localPosition = self.Vector3(10000,10000,0)
		if tmpCount == totalCount then
			self:ClearAllBetChipItem()
			BaseFctManager.GetInstance().BaseFctView:HideAllWinArea()
			BaseFctManager.GetInstance().BankerSimpleView:UpdateBankerScoreValue()
			PlayerManager.GetInstance():SetResultScoreValue()
		end
	end

	CurrentAllWinPlayerVector = {}
	local winPlayerInsList=PlayerManager.GetInstance():GetWinPlayerInsList()
	for i=1,#winPlayerInsList do 
		table.insert(CurrentAllWinPlayerVector,winPlayerInsList[i]:GetBetInitPosition())
	end
	table.insert(CurrentAllWinPlayerVector,BaseFctManager.GetInstance():GetOtherPlayerBetInitPosition())
	local winCount = #CurrentAllWinPlayerVector
	local avarge = #self.AreaBetChipList[prizeType]/winCount
	local countIndex = 1
	local timeInterval = 0
	for i = 1,#self.AreaBetChipList[prizeType] do
		if i > avarge * countIndex then
			countIndex = countIndex +1
			if countIndex > winCount then
				countIndex = winCount
			end
		end
		timeInterval = timeInterval + 0.001
		self.AreaBetChipList[prizeType][i]:MoveToPlayer(timeInterval,CurrentAllWinPlayerVector[countIndex],recycleCallBack)
	end
	AudioManager.GetInstance():PlayNormalAudio(26)
end

function BetChipView:__delete()
	Instance=nil
	self:ClearAllBetChipItem()
end


