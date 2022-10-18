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
	self.IconResultList=0		--游戏图标结果列表
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
	self.CurrentValue=0
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


function SCIconControl:ChangeRandomImage(index)
	local tempIcon=self.IconInsList[1]
	if tempIcon then
		tempIcon:ChangeIconRandomImage(index)
	else
		Debug.LogError("图标实例不存在")
	end
end




function SCIconControl:NormalStartRun(speed,fuzzy)
	self.RunSpeed=speed
	self.IsIconStop=false
	self.IsIconRun=true
	self.CurrentValue=0
	self:ChangeRandomImage(self.CurrentValue)
end


function SCIconControl:NormalStopRun(iconResultlist,callBackFunc)
	self.IconResultList=iconResultlist
	self.IsIconStop=true
	self.callBackFunc=callBackFunc
end



function SCIconControl:SetCurrentRunIndex()
	self.CurrentValue=self.CurrentValue+1
	if self.CurrentValue>9 then
		self.CurrentValue=0
	end
	self:ChangeRandomImage(self.CurrentValue)
end


function SCIconControl:UpdateIconRun()
	if self.IsIconRun then
		if self.MountList and #self.MountList>1 then
			for i=1,#self.MountList do
				self.MountList[i].transform:Translate(CSScript.Time.deltaTime*self.RunSpeed*self.MoveDirection)
			end
			
			if self.MountList[1].transform.localPosition.y<=self.IconDistance then	
				self:StopIconRunProcess()
			end
		else
			Debug.LogError("MountList图标参数异常")
			self.IsIconRun=false
		end
	end
end



function SCIconControl:StopIconRunProcess()
	self:SwapIconProcess()
	if self.IsIconStop==true then
		if self.IconResultList==self.CurrentValue then
			self.IsIconRun=false
			self.IsIconStop=false
			self:RestAllMountPosition()
			self:AddDoTween()
			return
		end
	end
	
	self:SetCurrentRunIndex()
	
end



function SCIconControl:AddDoTween()
	AudioManager.GetInstance():PlayNormalAudio(71)
	local tempCure=GameUIManager.GetInstance().AnimationCureConfig[0]
	local tempTween=self.gameObject.transform:DOLocalMoveY(self.gameObject.transform.localPosition.y-5, 0.3)
	tempTween:SetEase(tempCure)
	tempTween.onComplete=function ()
		if self.callBackFunc then
			self.callBackFunc(self.ColumnIndex)
		end
	end
	
	
end


function SCIconControl:IsAllIconStopRunCallBack()
	
end



function SCIconControl:Update()
	self:UpdateIconRun()
end


function SCIconControl:__delete()

end
