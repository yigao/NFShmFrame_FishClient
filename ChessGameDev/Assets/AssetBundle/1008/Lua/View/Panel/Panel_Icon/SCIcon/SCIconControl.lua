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
	self.GameConfig=GameManager.GetInstance().GameConfig
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


function SCIconControl:ChangeRandomImage()
	local tempIcon=self.IconInsList[1]
	if tempIcon then
		if self.IsUseFuzzy then
			tempIcon:ChangeIconRandomImage(CommonHelper.GetRandomTwo(0,self.GameConfig.IconItemTotalCount-1),true)
		else
			tempIcon:ChangeIconRandomImage(CommonHelper.GetRandomTwo(0,self.GameConfig.IconItemTotalCount-2))
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


function SCIconControl:SetRunSpeed(speed)
	self.RunSpeed=speed
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
		self:RestAllMountPosition()
		--动画回调
		self:AddDoTween()
		--结束回调
		GameLogicManager.GetInstance():SingleColumnIconStopRunCallBack(self.ColumnIndex)
		
	end
	
	
	
end


function SCIconControl:SpecifyGameResult(stopIconIndex)
	self.IconInsList[1]:RecycleIconToGameObjectPool(GameObjectPoolManager.PoolType.IconPool)
	local iconResult=self.IconResultList[#self.MountList-stopIconIndex]
	if iconResult==11 and GameLogicManager.GetInstance().IsFreeGameState then
		iconResult=12
	end
	local tempIconItem=IconManager.GetInstance():GetMainIconItemByIconNum(iconResult)
	if tempIconItem then
		self.IconInsList[1]:BuildIconItem(tempIconItem)
		self.IconInsList[1]:SetIocnParent(self.MountList[1])
	else
		Debug.LogError("SCIconControl当前列获取图标项失败==>"..stopIconIndex)
	end
end



function SCIconControl:AddDoTween()
	local tempCure=GameUIManager.GetInstance().AnimationCureConfig[0]
	local tempTween=self.gameObject.transform:DOLocalMoveY(self.gameObject.transform.localPosition.y-20, 0.2)
	tempTween:SetEase(tempCure)
	if self.ColumnIndex==self.GameConfig.Coordinate_COL then
		tempTween.onComplete=function ()
			self:IsAllIconStopRunCallBack()
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
