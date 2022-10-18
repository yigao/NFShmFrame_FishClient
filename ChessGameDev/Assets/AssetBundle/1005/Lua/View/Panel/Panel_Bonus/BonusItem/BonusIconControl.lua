BonusIconControl=Class()

function BonusIconControl:ctor(gameObj)
	self.gameObject=gameObj
	self:Init()
	CommonHelper.AddUpdate(self)
end

function BonusIconControl:Init ()
	self:InitData()
	self:FindView()
	self:InitViewData()
end


function BonusIconControl:InitData()
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
end


function BonusIconControl:FindView()
	local tf=self.gameObject.transform
	self:FindNodeView(tf)
end

function BonusIconControl:FindNodeView(tf)
	local childCount=tf.childCount 
	if childCount>0 then
		for i=1,childCount do
			local childItem=tf:Find("Scroll"..i).gameObject
			table.insert(self.MountList,childItem)
			table.insert(self.MountPosList,childItem.transform.localPosition)
		end
	end
end


function BonusIconControl:InitViewData()
	self:SetIconMoveDir()
	self:SetIconIntervalDistance()
end


function BonusIconControl:SetColumnIndex(index)
	self.ColumnIndex=index
end

function BonusIconControl:GetColumnIndex()
	return self.ColumnIndex
end


function BonusIconControl:SetIconInsList(iconInsList)
	self.IconInsList=iconInsList
end


function BonusIconControl:GetIconInsList()
	return self.IconInsList
end

function BonusIconControl:GetSingleIconIns(index)
	if index>#self.IconInsList then 
		Debug.LogError("图标实例索引超过上限")
		return nil
	end
	return self.IconInsList[index]
end


function BonusIconControl:AddMountPoint(iconInsList)
	if iconInsList then
		for i=1,#iconInsList do
			iconInsList[i]:SetIocnParent(self.MountList[i])
		end
	end
end



function BonusIconControl:SetIconMoveDir()
	self.MoveDirection=(self.MountPosList[2]-self.MountPosList[1]).normalized 
end


function BonusIconControl:SetIconIntervalDistance()
	self.IconDistance=self.MountPosList[2].y-self.MountPosList[1].y
end



function BonusIconControl:ResetAllIconInsRunState()
	for i=1,#self.IconInsList do
		self.IconInsList[i]:InitBaseView()
	end
end


function BonusIconControl:RestAllMountPosition()
	for i=1,#self.MountList do
		self.MountList[i].transform.localPosition=self.MountPosList[i]
	end
end



function BonusIconControl:SortArrayIndex(array)
	local count=#array
	local lastResult=array[count]
	for i=count,2,-1 do
		array[i]=array[i-1]
	end
	array[1]=lastResult
	return array
end



function BonusIconControl:SwapIconProcess()
	self:SwapIconItem()
	self:SwapIconListIns()
end

function BonusIconControl:SwapIconItem()
	self:SortArrayIndex(self.MountList)
	CommonHelper.SetActive(self.MountList[1],false)
	self.MountList[1].transform.localPosition=self.MountPosList[1]
	CommonHelper.SetActive(self.MountList[1],true)
end


function BonusIconControl:SwapIconListIns()
	self:SortArrayIndex(self.IconInsList)
end


function BonusIconControl:ChangeRandomImage()
	local tempIcon=self.IconInsList[1]
	if tempIcon then
		if self.IsUseFuzzy then
			tempIcon:ChangeBonusIconRandomImage(CommonHelper.GetRandomTwo(1,7),true)
		else
			tempIcon:ChangeBonusIconRandomImage(CommonHelper.GetRandomTwo(1,7))
		end
	else
		Debug.LogError("图标实例不存在")
	end
end


function BonusIconControl:ChangeRandomImageActiveState()
	if self.ChangIconActiveStateCount+1<=self.GameConfig.Coordinate_ROW+2 then
		self.ChangIconActiveStateCount=self.ChangIconActiveStateCount+1
		self.IconInsList[1]:SetIconRunState()
	end
end



function BonusIconControl:NormalStartRun(speed,fuzzy)
	self.RunSpeed=speed
	self.CurrentStopIconIndex=1
	self.ChangIconActiveStateCount=1
	self.IsUseFuzzy=fuzzy or false
	self.IsIconStop=false
	self.IsIconRun=true
end


function BonusIconControl:NormalStopRun(iconResultlist)
	--pt(iconResultlist)
	self.IconResultList=iconResultlist
	self.IsIconStop=true
	--self.RunSpeed=1
end



function BonusIconControl:UpdateIconRun()
	if self.IsIconRun then
		if self.MountList and #self.MountList>1 then
			for i=1,#self.MountList do
				self.MountList[i].transform:Translate(CSScript.Time.deltaTime*self.RunSpeed*self.MoveDirection)
			end
			
			if self.MountList[1].transform.localPosition.y<=self.IconDistance then
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



function BonusIconControl:StopIconRunProcess()
	self:SwapIconProcess()
	if self.CurrentStopIconIndex<=#self.MountList-1 then
		self:SpecifyGameResult(self.CurrentStopIconIndex)
		self.CurrentStopIconIndex=self.CurrentStopIconIndex+1
	else
		self.IsIconStop=false
		self.IsIconRun=false
		self:RestAllMountPosition()
		self:AddDoTween()

	end
	
	
	
end


function BonusIconControl:SpecifyGameResult(stopIconIndex)
	self.IconInsList[1]:RecycleIconToGameObjectPool(GameObjectPoolManager.PoolType.IconPool)
	local iconResult=self.IconResultList[#self.MountList-stopIconIndex]
	local tempIconItem=IconManager.GetInstance():GetBonusIconItemByIconNum(iconResult)
	if tempIconItem then
		self.IconInsList[1]:BuildIconItem(tempIconItem)
		self.IconInsList[1]:SetIocnParent(self.MountList[1])
	else
		Debug.LogError("BonusIconControl获取图标项失败==>"..stopIconIndex)
	end
end



function BonusIconControl:AddDoTween()
	local tempCure=GameUIManager.GetInstance().AnimationCureConfig[0]
	self.gameObject.transform:DOLocalMoveY(self.gameObject.transform.localPosition.y-20, 0.5):SetEase(tempCure)
end



function BonusIconControl:Update()
	self:UpdateIconRun()
end


function BonusIconControl:__delete()

end
