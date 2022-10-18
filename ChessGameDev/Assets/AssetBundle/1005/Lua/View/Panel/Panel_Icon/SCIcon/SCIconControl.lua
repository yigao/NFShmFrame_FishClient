SCIconControl=Class()

function SCIconControl:ctor(gameObj)
	self.gameObject=gameObj
	self:Init()
	CommonHelper.AddUpdate(self)
end

function SCIconControl:Init ()
	self:InitData()
	self:FindView()
	self:InitViewData()
end


function SCIconControl:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.DOTween = GameManager.GetInstance().DOTween
	self.Ease =GameManager.GetInstance().Ease
	self.MountList={}			--图标挂载点列表
	self.MountPosList={}		--初始挂载点位置列表
	self.IconInsList={}			--挂载图标实例列表
	self.IconResultList={}		--游戏图标结果列表
	self.IconDistance = 0			--图标间隔距离
	self.ColumnIndex=1				--列索引
	self.MoveDirection=CSScript.Vector3.zero		--移动方向
	self.RunSpeed=3					--转动速度
	self.CurrentStopIconIndex=1		--停止图标位置Index
	self.IsIconRun=false			
	self.IsIconStop=false
	self.IsUseFuzzy=false			--是否启用滚动模糊图标
	self.ChangIconActiveStateCount=1	--切换图标状态计数
	self.MarkCount=0
end


function SCIconControl:FindView()
	local tf=self.gameObject.transform
	self.StartPos=tf.localPosition
	self:FindNodeView(tf)
end

function SCIconControl:FindNodeView(tf)
	local childCount=tf.childCount 
	if childCount>0 then
		for i=1,childCount do
			local childItem=tf:Find("Scroll"..i).gameObject
			table.insert(self.MountList,childItem)
			table.insert(self.MountPosList,childItem.transform.localPosition)
		end
	end
end


function SCIconControl:InitViewData()
	self:SetIconMoveDir()
	self:SetIconIntervalDistance()
end


function SCIconControl:SetColumnIndex(index)
	self.ColumnIndex=index
end

function SCIconControl:GetColumnIndex()
	return self.ColumnIndex
end


function SCIconControl:SetIconInsList(iconInsList)
	self.IconInsList=iconInsList
end


function SCIconControl:GetIconInsList()
	return self.IconInsList
end

function SCIconControl:GetSingleIconIns(index)
	if index>#self.IconInsList then 
		Debug.LogError("图标实例索引超过上限")
		return nil
	end
	return self.IconInsList[index]
end


function SCIconControl:AddMountPoint(iconInsList)
	if iconInsList then
		for i=1,#iconInsList do
			iconInsList[i]:SetIocnParent(self.MountList[i])
		end
	end
end



function SCIconControl:SetIconMoveDir()
	self.MoveDirection=(self.MountPosList[2]-self.MountPosList[1]).normalized 
end


function SCIconControl:SetIconIntervalDistance()
	self.IconDistance=self.MountPosList[2].y-self.MountPosList[1].y
end



function SCIconControl:ResetAllIconInsRunState()
	for i=1,#self.IconInsList do
		self.IconInsList[i]:SetIconRunState()
	end
end


function SCIconControl:RestAllMountPosition()
	for i=1,#self.MountList do
		self.MountList[i].transform.localPosition=self.MountPosList[i]
	end
end



function SCIconControl:SortArrayIndex(array)
	local count=#array
	local lastResult=array[count]
	for i=count,2,-1 do
		array[i]=array[i-1]
	end
	array[1]=lastResult
	return array
end



function SCIconControl:SwapIconProcess()
	self:SwapIconItem()
	self:SwapIconListIns()
end

function SCIconControl:SwapIconItem()
	self:SortArrayIndex(self.MountList)
	CommonHelper.SetActive(self.MountList[1],false)
	self.MountList[1].transform.localPosition=self.MountPosList[1]
	CommonHelper.SetActive(self.MountList[1],true)
end


function SCIconControl:SwapIconListIns()
	self:SortArrayIndex(self.IconInsList)
end

local freeGameResultTable={3,4,5,6,7,8,10}
local betChipList={
	[1]={8},
	[2]={8,18},
	[3]={8,18,38},
	[4]={8,18,38,68},
	[5]={8,18,38,68,88},
}
function SCIconControl:ChangeRandomImage()
	local tempIcon=self.IconInsList[1]
	if tempIcon then
		local randomNum=0
		if self.gameData.MainStation==StateManager.MainState.Normal then
			randomNum=CommonHelper.GetRandomTwo(0,9)
		elseif self.gameData.MainStation==StateManager.MainState.FreeGame then
			randomNum=freeGameResultTable[CommonHelper.GetRandomTwo(1,7)]
		else
			randomNum=CommonHelper.GetRandomTwo(3,11)
		end
		
		local isGolden=IconManager.GetInstance():IsGoldenIcon(randomNum)
		
		
		if self.gameData.MainStation~=StateManager.MainState.BBG then
			
			if isGolden then
				tempIcon:AllocateChangeIconRandomImage(randomNum,"_G")
			else
				tempIcon:ChangeIconRandomImage(randomNum)
			end
			
			if randomNum>=9 and randomNum<=11 then
				local betChip=BaseFctManager.GetInstance():GetCurrentBetChipIndex()
				if betChip>#betChipList then
					betChip=#betChipList
				end
				local currentBetList=betChipList[betChip]
				local iconValue=currentBetList[math.random(1,#currentBetList)]
				if self.gameData.MainStation==StateManager.MainState.FreeGame and randomNum==10 then
					iconValue=self.gameData.fuIconMul or 8
				end
				tempIcon:SetIconText(iconValue)
				tempIcon:IsShowIconText(true)
			else
				if CommonHelper.IsActive(tempIcon.IconText.gameObject) then
					tempIcon:IsShowIconText(false)
				end
			end
		else
			if randomNum<9 then
				tempIcon:AllocateChangeIconRandomImage(randomNum,"_D")
			end
			
			if CommonHelper.IsActive(tempIcon.IconText.gameObject) then
				tempIcon:IsShowIconText(false)
			end

		end
		
	else
		Debug.LogError("图标实例不存在")
	end
end


function SCIconControl:ChangeRandomImageActiveState()
	if self.ChangIconActiveStateCount+1<=self.GameConfig.Coordinate_ROW+2 then
		self.ChangIconActiveStateCount=self.ChangIconActiveStateCount+1
		self.IconInsList[1]:SetIconRunState()
	end
end



function SCIconControl:NormalStartRun(speed,fuzzy)
	self.RunSpeed=speed
	self.CurrentStopIconIndex=1
	self.ChangIconActiveStateCount=1
	self.IsUseFuzzy=fuzzy or false
	self.IsIconStop=false
	self.IsIconRun=true
	if self.ColumnIndex==self.GameConfig.Coordinate_COL then
		self.MarkCount=0
	end
	
end


function SCIconControl:NormalStopRun(iconResultlist)
	--pt(iconResultlist)
	self.IconResultList=iconResultlist
	self.IsIconStop=true
	--self.RunSpeed=1
end



function SCIconControl:UpdateIconRun()
	if self.IsIconRun then
		if self.MountList and #self.MountList>1 then
			for i=1,#self.MountList do
				self.MountList[i].transform:Translate(CSScript.Time.deltaTime*self.RunSpeed*self.MoveDirection)
			end
			
			if self.MountList[1].transform.localPosition.y<=self.IconDistance then
				self.MarkCount=self.MarkCount+1
				if self.MarkCount==2 then
					self.gameObject.transform.parent.localPosition=CSScript.Vector3.zero
				end
				
				if self.IsIconStop then
					self:StopIconRunProcess()
				else
					self:SwapIconProcess()
					self:ChangeRandomImage()
					self:ChangeRandomImageActiveState()
				end
			end
		else
			Debug.LogError("MountList图标参数异常")
			self.IsIconRun=false
		end
	end
end



function SCIconControl:StopIconRunProcess()
	self:SwapIconProcess()
	if self.CurrentStopIconIndex<=#self.MountList-1 then
		self:SpecifyGameResult(self.CurrentStopIconIndex)
		self.CurrentStopIconIndex=self.CurrentStopIconIndex+1
	else
		self.IsIconStop=false
		self.IsIconRun=false
		--self:RestAllMountPosition()
		--动画回调
		self:AddDoTween()
		--结束回调
		GameLogicManager.GetInstance():SingleColumnIconStopRunCallBack(self.ColumnIndex)
		
	end
	
	
	
end


function SCIconControl:SpecifyGameResult(stopIconIndex)
	self.IconInsList[1]:RecycleIconToGameObjectPool(GameObjectPoolManager.PoolType.IconPool)
	local iconResult=self.IconResultList[#self.MountList-stopIconIndex]
	local tempIconItem=IconManager.GetInstance():GetMainIconItemByIconNum(iconResult)
	if tempIconItem then
		self.IconInsList[1]:BuildIconItem(tempIconItem)
		--print("当前主游戏状态为：==>")
		--print(self.gameData.MainStation)
		if self.gameData.MainStation~=StateManager.MainState.BBG then
			if iconResult<9 then
				local isGolden=IconManager.GetInstance():IsGoldenIcon(iconResult)
				if isGolden then
					self.IconInsList[1]:ChangGoldenToMainIcon(iconResult,true)
					self.IconInsList[1]:PlayShowAnim()
				else
					self.IconInsList[1]:AllocateChangMainIcon(iconResult)
					self.IconInsList[1]:PlayWinAnim()
				end
				self.IconInsList[1]:ChangeIconRandomImage(iconResult)
			end
			
		else
			if iconResult<9  then
				self.IconInsList[1]:AllocateChangMainIcon(iconResult,"_D")
				self.IconInsList[1]:AllocateChangeIconRandomImage(iconResult,"_D")
			end
		end
		
		self.IconInsList[1]:SetIocnParent(self.MountList[1])
		self.IconInsList[1]:SetIconNum(iconResult)
		if iconResult>=9 and iconResult<=11 then
			self:SetFirecrackerIconValue(#self.MountList-stopIconIndex)
		end
	else
		Debug.LogError("SCIconControl获取图标项失败==>"..stopIconIndex)
	end
end




function SCIconControl:SetFirecrackerIconValue(iconIndex)
	if self.gameData.MainStation==StateManager.MainState.BBG then
		if self.gameData.BBGCoordinateState and self.gameData.BBGCoordinateState[self.ColumnIndex][iconIndex]==true then
			local iconValue=self.gameData.GameIconResult[5+self.ColumnIndex][iconIndex]
			IconManager.GetInstance():SetIconValue(iconValue,self.IconInsList[1])
		end
	else
		local iconValue=self.gameData.GameIconResult[5+self.ColumnIndex][iconIndex]
		IconManager.GetInstance():SetIconValue(iconValue,self.IconInsList[1])
	end
	
	
	
end



function SCIconControl:AddDoTween1()

	for i=1,#self.MountList do
		local sequence = self.DOTween.Sequence()
		local tempTween=self.gameObject.transform:DOLocalMoveY(self.gameObject.transform.localPosition.y-50, 0.3)
		tempTween:SetEase(self.Ease.OutQuad)
		local tempTween1=self.gameObject.transform:DOLocalMoveY(self.StartPos.y, 0.3)
		tempTween1:SetEase(self.Ease.OutQuad)
		sequence:Append(tempTween)
		sequence:Append(tempTween1)
		if self.ColumnIndex==self.GameConfig.Coordinate_COL then
			local completeCallBackFunc=function ()
				self:IsAllIconStopRunCallBack()
			end
			sequence:AppendCallback(completeCallBackFunc)	
		end
	end
	
end


function SCIconControl:AddDoTween()

	for i=1,#self.MountList do
		local sequence = self.DOTween.Sequence()
		local tempTween=self.MountList[i].transform:DOLocalMoveY(self.MountList[i].transform.localPosition.y-10, 0.1)
		tempTween:SetEase(self.Ease.Linear)
		local tempTween1=self.MountList[i].transform:DOLocalMoveY(self.MountPosList[i].y, 0.1)
		tempTween1:SetEase(self.Ease.Linear)
		sequence:Append(tempTween)
		sequence:Append(tempTween1)
		if self.ColumnIndex==self.GameConfig.Coordinate_COL and i==#self.MountList then
			local completeCallBackFunc=function ()
				self:IsAllIconStopRunCallBack()
			end
			sequence:AppendCallback(completeCallBackFunc)	
		end
	end
	
end


function SCIconControl:IsAllIconStopRunCallBack()
	if self.ColumnIndex==self.GameConfig.Coordinate_COL then
		GameLogicManager.GetInstance():AllIconStopRunProcess()
	end
end



function SCIconControl:Update()
	self:UpdateIconRun()
end


function SCIconControl:__delete()

end
