ComboFish=Class(FishBase)

function ComboFish:ctor()
	self:Init()

end

function ComboFish:Init ()
	self:InitData()
end


function ComboFish:InitData()
	self.AnimParams={"Fish_Move","Fish_Die"}
	self.ComboFishCount=1
	self.BGGroupRenderList={}
	self.SubScaleFishList = {}	
	self.FishGroupList={}
	self.ChildFishInsList={}
end


function ComboFish:BuildFish(vo,obj)
	self:InitBaseFish(vo,obj)
	self:CaculateComboFishCount()
	self:FindView()
	self:BuildChildFish()
	self:SetAllChildFishPosition()
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function ComboFish:ResetFishState(vo)
	self:ResetBaseFishStateData(vo)
	self:BuildChildFish()
	self:SetAllChildFishPosition()
end



function ComboFish:FindView()
	local mTransfrom=self.gameObject.transform
	self.centerPoint = mTransfrom:Find("CenterPoint")
	self:FindBGComboFishRenderView(mTransfrom)
	self:FindComboFishNodeView(mTransfrom)	
	self:FindComboSubFishScale(mTransfrom)
	
end

function ComboFish:CaculateComboFishCount()
	self.ComboFishCount=#self.FishVo.FishKindGroup
end


function ComboFish:InitViewData()
	
	
end

function ComboFish:FindBGComboFishRenderView(tf)
	local tempBGGroup=tf:Find("Bone/BGGroup").gameObject
	if tempBGGroup then
		self.BGGroupRenderList=tempBGGroup:GetComponentsInChildren(typeof(CS.UnityEngine.SpriteRenderer))	--获取的unity组件列表Index是从0开始
	end
	
end


function ComboFish:FindComboFishNodeView(tf)
	local tempFishGroup=tf:Find("Bone/FishGroup")
	if tempFishGroup then
		local childCount=tempFishGroup.childCount
		local tempChild=nil
		if childCount>0 then
			for i=1,childCount do
				tempChild=tempFishGroup:Find("Fish"..i).gameObject
				if tempChild then
					table.insert(self.FishGroupList,tempChild)
				end
			end
		end
	end
end

function ComboFish:FindComboSubFishScale(tf)
	local tempFishScale=tf:Find("Scale")
	if tempFishScale then
		local childCount=tempFishScale.childCount
		local tempChild=nil
		if childCount>0 then
			for i=1,childCount do
				tempChild=tempFishScale:Find("Scale"..i)
				if tempChild then
					table.insert(self.SubScaleFishList,tempChild)
				end
			end
		end
	end
end



function ComboFish:BuildChildFish()
	if self.FishVo.FishKindGroup then
		if #self.FishVo.FishKindGroup>0 then
			for i=1,#self.FishVo.FishKindGroup do
				local tempFishID=self.FishVo.FishKindGroup[i]
				local childFish=FishManager.GetInstance():GetChildFish(tempFishID)
				if childFish then
					childFish:IsEnableBoxcollider(false)	--必须要关闭子鱼的碰撞否则子弹移除异常bug
					table.insert(self.ChildFishInsList,childFish)
				end
			end
		end
	end
end


function ComboFish:RemoveChildFish()
	if self.ChildFishInsList then
		if #self.ChildFishInsList>0 then
			for i=1,#self.ChildFishInsList do
				GameObjectPoolManager.GetInstance():SetPoolParent(self.ChildFishInsList[i].gameObject,GameObjectPoolManager.PoolType.FishPool)
				FishManager.GetInstance():AddChildFishToAllUsedFishList(self.ChildFishInsList[i])
			end
		end
		self.ChildFishInsList={}
	end
end

function ComboFish:SetAllChildFishPosition()
	if self.ChildFishInsList then
		if #self.ChildFishInsList>0 then
			for i=1,#self.ChildFishInsList do
				if self.ChildFishInsList[i].FishVo.FishId <= 15 then
					local scale = self.SubScaleFishList[self.ChildFishInsList[i].FishVo.FishId].localScale
					if self.FishVo.FishConfig.fishRuleType == 3 then
						self.gameObject.transform:Find("Bone/BGGroup").localScale = scale
					else
						self.FishGroupList[i].transform.localScale = scale
					end
				end
				self.ChildFishInsList[i]:SetFishParent(self.FishGroupList[i].transform)
			end
		end
	end
end





function ComboFish:PlayChildAnim(index)
	if self.ChildFishInsList then
		for i=1,#self.ChildFishInsList do
			self.ChildFishInsList[i]:PlayAnim(index)
		end
	end
	
end


function ComboFish:SetMainFishOrder(orderIndex)
	self:SetChildFishSpriteRenderOrder(orderIndex)
	self:SetBGSpriteRenderOrder(orderIndex)
end


function ComboFish:SetBeHitColor()
	if(self.isHit==false) then
		self:SetChildFishColor(self.beHitColor)
		self:SetBGSpriteColor(self.beHitColor)
		self.isHit=true
	end
	
end

function ComboFish:ResetNormalColor()
	self:SetChildFishColor(self.NormalColor)
	self:SetBGSpriteColor(self.NormalColor)
	self.isHit=false
	self.currentHitTime=0
end

function ComboFish:SetChildFishColor(color)
	if self.ChildFishInsList then
		for i=1,#self.ChildFishInsList do
			self.ChildFishInsList[i]:SetMainFishColor(color)
		end
	end
end

function ComboFish:SetBGSpriteColor(color)
	if self.BGGroupRenderList then
		for i=0,self.BGGroupRenderList.Length-1 do
			self.BGGroupRenderList[i].color= color
		end
	end
end

function ComboFish:SetChildFishSpriteRenderOrder(orderIndex)
	if self.ChildFishInsList then
		for i=1,#self.ChildFishInsList do
			self.ChildFishInsList[i]:SetMainFishOrder(orderIndex + (i-1))
		end
	end
end


function ComboFish:SetBGSpriteRenderOrder(orderIndex)
	if self.BGGroupRenderList then
		for i=0,self.BGGroupRenderList.Length-1 do
			self.BGGroupRenderList[i].sortingOrder=(orderIndex-1)-(self.BGGroupRenderList.Length-(i+1))
		end
	end
end


function ComboFish:FishNormalDie()
	self:FishBaseDie()
	self:ResetNormalColor()
	self:PlayChildAnim(2)
	self:SetMainFishOrder(self.FishVo.FishConfig.fishDieLayer)
	self.gameObject.transform.localScale = CSScript.Vector3(self.FishVo.FishConfig.dieScaleX,self.FishVo.FishConfig.dieScaleY,self.FishVo.FishConfig.dieScaleZ)
	self.delayDestoryComboFishTimer=TimerManager.GetInstance():CreateTimerInstance(self.FishVo.FishConfig.fishDieTime,self.DelayDestoryDieComboFish,self)
	
end


function ComboFish:DelayDestoryDieComboFish()
	self:SetDestory(true)
	self.gameObject.transform.localScale = CSScript.Vector3(1,1,1)
	TimerManager.GetInstance():RecycleTimerIns(self.delayDestoryComboFishTimer)
end


function ComboFish:UpdateHit()
	if self.isHit then
		self.currentHitTime=self.currentHitTime+CSScript.Time.deltaTime
		if self.currentHitTime>=self.hitTotalTime then
			self:ResetNormalColor()	
		end
	end
end


function ComboFish:Update()
	self:UpdateHit()
end



function ComboFish:__delete()
	self:RemoveChildFish()
	self:ResetNormalColor()
end