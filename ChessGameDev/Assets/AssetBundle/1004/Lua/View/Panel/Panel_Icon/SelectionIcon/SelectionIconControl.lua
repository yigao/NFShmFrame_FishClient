SelectionIconControl=Class()

function SelectionIconControl:ctor(gameObj)
	self.gameObject=gameObj
	self:Init()
	CommonHelper.AddUpdate(self)
end

function SelectionIconControl:Init ()
	self:InitData()
	self:FindView()
	self:InitViewData()
end


function SelectionIconControl:InitData()
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.MountList={}			--图标挂载点列表
	self.MountPosList={}		--初始挂载点位置列表
	self.IconInsList={}			--挂载图标实例列表
	self.IconResult=1	
	self.IconDistance = 0			--图标间隔距离
	self.ColumnIndex=1				--列索引
	self.MoveDirection=CSScript.Vector3.zero		--移动方向
	self.RunSpeed=0.05					--转动速度
	self.CurrentStopIconIndex=1		--停止图标位置Index
	self.IsIconRun=false			
	self.IsIconStop=false
	self.IsStopMark=false
	self.IsDecelerate=false
	
end


function SelectionIconControl:FindView()
	local tf=self.gameObject.transform
	self:FindNodeView(tf)
end

function SelectionIconControl:FindNodeView(tf)
	local childCount=tf.childCount 
	if childCount>0 then
		for i=1,childCount do
			local childItem=tf:Find("Scroll"..i).gameObject
			table.insert(self.MountList,childItem)
			table.insert(self.MountPosList,childItem.transform.localPosition)
		end
	end
end


function SelectionIconControl:InitViewData()
	self:SetIconMoveDir()
	self:SetIconIntervalDistance()
end


function SelectionIconControl:IsShowSelectionPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end


function SelectionIconControl:SetColumnIndex(index)
	self.ColumnIndex=index
end

function SelectionIconControl:GetColumnIndex()
	return self.ColumnIndex
end


function SelectionIconControl:SetIconInsList(iconInsList)
	self.IconInsList=iconInsList
end


function SelectionIconControl:GetIconInsList()
	return self.IconInsList
end

function SelectionIconControl:GetSingleIconIns(index)
	if index>#self.IconInsList then 
		Debug.LogError("图标实例索引超过上限")
		return nil
	end
	return self.IconInsList[index]
end


function SelectionIconControl:AddMountPoint(iconInsList)
	if iconInsList then
		for i=1,#iconInsList do
			iconInsList[i]:SetIocnParent(self.MountList[i])
		end
	end
end



function SelectionIconControl:SetIconMoveDir()
	self.MoveDirection=(self.MountPosList[2]-self.MountPosList[1]).normalized 
end


function SelectionIconControl:SetIconIntervalDistance()
	self.IconDistance=self.MountPosList[2].x-self.MountPosList[1].x
end



function SelectionIconControl:ResetAllIconInsRunState()
	for i=1,#self.IconInsList do
		self.IconInsList[i]:SetIconRunState()
	end
end


function SelectionIconControl:RestAllMountPosition()
	for i=1,#self.MountList do
		self.MountList[i].transform.localPosition=self.MountPosList[i]
	end
end



function SelectionIconControl:SortArrayIndex(array)
	local count=#array
	local lastResult=array[count]
	for i=count,2,-1 do
		array[i]=array[i-1]
	end
	array[1]=lastResult
	return array
end



function SelectionIconControl:SwapIconProcess()
	self:SwapIconItem()
	self:SwapIconListIns()
end

function SelectionIconControl:SwapIconItem()
	self:SortArrayIndex(self.MountList)
	CommonHelper.SetActive(self.MountList[1],false)
	self.MountList[1].transform.localPosition=self.MountPosList[1]
	CommonHelper.SetActive(self.MountList[1],true)
end


function SelectionIconControl:SwapIconListIns()
	self:SortArrayIndex(self.IconInsList)
end






function SelectionIconControl:NormalStartRun(speed)
	self.RunSpeed=speed
	self.CurrentStopIconIndex=1
	self.IsIconStop=false
	self.IsStopMark=false
	self.IsDecelerate=false
	self.IsIconRun=true	
	
end


function SelectionIconControl:NormalStopRun(iconResult)
	self.IconResult=iconResult
	self.IsIconStop=true
	self.IsDecelerate=true
	--self.RunSpeed=0.5
end







function SelectionIconControl:StopIconRunMark()
	if self.IconInsList[1]:GetSelectionType()==self.IconResult  then
		self.IsStopMark=true
		self.IsIconStop=false
		self.StopIconIns=self.IconInsList[1]
		self.StopRunSpeedIndex=math.random(1,4)
	end
end



function SelectionIconControl:StopIconRunProcess()

	if self.CurrentStopIconIndex==self.StopRunSpeedIndex then
		self.RunSpeed=0.25
	end
	
	if self.CurrentStopIconIndex<3 then
		self.CurrentStopIconIndex=self.CurrentStopIconIndex+1
		
	else
		self.IsStopMark=false
		self.IsIconStop=false
		self.IsIconRun=false
		self:RestAllMountPosition()
		AudioManager.GetInstance():StopAllNormalAudio()
		AudioManager.GetInstance():PlayNormalAudio(38)
		self.StopIconIns:PlaySelectAnim()
		local DelayCallBackMidZhuanLunFunc=function ()
			TimerManager.GetInstance():RecycleTimerIns(self.callBackMidZhuanLunTimer)
			GameLogicManager.GetInstance():MidZhuanLunCallBack()
		end
		self.callBackMidZhuanLunTimer=TimerManager.GetInstance():CreateTimerInstance(1,DelayCallBackMidZhuanLunFunc)
	end
end





function SelectionIconControl:UpdateIconRun()
	if self.IsIconRun then
		if self.MountList and #self.MountList>1 then
			for i=1,#self.MountList do
				self.MountList[i].transform:Translate(CSScript.Time.deltaTime*self.RunSpeed*self.MoveDirection)
			end
			self:IsSetRunSpeed()
			if self.MountList[1].transform.localPosition.x>=self.IconDistance then
				self:SwapIconProcess()
				if self.IsIconStop then
					self:StopIconRunMark()
				elseif self.IsStopMark then
					self:StopIconRunProcess()
				end
			end
		else
			Debug.LogError("MountList图标参数异常")
			self.IsIconRun=false
		end
	end
end


function SelectionIconControl:IsSetRunSpeed()
	if self.IsDecelerate then
		self.RunSpeed=self.RunSpeed-CSScript.Time.deltaTime--*3
		if self.RunSpeed<=0.5 then
			self.RunSpeed=0.5
			self.IsDecelerate=false
		end
	end
end



function SelectionIconControl:Update()
	self:UpdateIconRun()
end


function SelectionIconControl:__delete()

end
