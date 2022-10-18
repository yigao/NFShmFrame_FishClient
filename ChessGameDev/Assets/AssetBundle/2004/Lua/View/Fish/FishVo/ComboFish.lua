
ComboFish=Class(FishBase)

function ComboFish:ctor()
	self:Init()

end

function ComboFish:Init ()
	self:InitData()
end


function ComboFish:InitData()
	self.AnimParams={"Fish_Move","Fish_Catch"}
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
	self:FindBGComboFishRenderView(mTransfrom)
	self:FindComboFishNodeView(mTransfrom)	
	self:FindComboSubFishScale(mTransfrom)
	
end

function ComboFish:CaculateComboFishCount()
	self.ComboFishCount=#self.FishVo.FishKindGroup
end


function ComboFish:InitViewData()
	
	
end

function ComboFish:GetEffectPoint(  )
	return  nil
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
				if self.ChildFishInsList[i].FishVo.FishId <= 11 then
					local scale = self.SubScaleFishList[self.ChildFishInsList[i].FishVo.FishId].localScale
					self.gameObject.transform:Find("Bone/BGGroup").localScale = scale
				end
				self.ChildFishInsList[i]:SetFishParent(self.FishGroupList[i].transform)
			end
		end
	end
end


function ComboFish:PlayChildMoveAnim()
	if self.ChildFishInsList then
		for i=1,#self.ChildFishInsList do
			self.ChildFishInsList[i]:PlayMoveAnim()
		end
	end
end


function ComboFish:PlayChildDieAnim()
	if self.ChildFishInsList then
		for i=1,#self.ChildFishInsList do
			self.ChildFishInsList[i]:PlayDieAnim()
		end
	end
end



function ComboFish:SetMainFishOrder(orderIndex)
	self:SetChildFishSpriteRenderOrder(orderIndex)
	self:SetBGSpriteRenderOrder(orderIndex)
end

function ComboFish:SetHitFlyDirection(direction)
	self.hitFlyDirection = direction	
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
			self.BGGroupRenderList[i].sortingOrder=(orderIndex-2)-(self.BGGroupRenderList.Length-(i+1))
		end
	end
end

function ComboFish:FishNormalDie(playerIns,hitFishMsg)
	self.playerIns = playerIns
	self.chairdID = self.playerIns.ChairdID
	self.hitFishMsg = hitFishMsg
	self:FishBaseDie()
	self:ResetNormalColor()
	self:PlayChildDieAnim()
	self:SetMainFishOrder(self.FishVo.FishConfig.fishDieLayer)
	if self.destoryDieFish then
		TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
		self.destoryDieFish = nil
	end
	self.destoryDieFish = TimerManager.GetInstance():CreateTimerInstance(self.FishVo.FishConfig.fishDieTime,self.DestoryDieFish,self) 
	local delayTime = 0
	if self.FishVo.DieEffectConfig.fishDieOneShowTime then
		delayTime = self.FishVo.DieEffectConfig.fishDieOneShowTime
	end
	if self.FishVo.DieEffectConfig.fishDieBehavior == 1 then
		self:ShowCoinEffect(self.gameObject.transform)
		self:ShowWinScoreEffect(self.gameObject.transform.position)
		if self.normalOneStepTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
			self.normalOneStepTimer = nil
		end
		self.normalOneStepTimer = TimerManager.GetInstance():CreateTimerInstance(delayTime,self.NormalOneStepTimer,self) 
	elseif self.FishVo.DieEffectConfig.fishDieBehavior == 3 then
		self.dieMoveToTargetPos = self.playerIns.Panel:GetPlayerCatchFishPos()
		if self.catchOneStepTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.catchOneStepTimer)
			self.catchOneStepTimer = nil
		end
		self.catchOneStepTimer = TimerManager.GetInstance():CreateTimerInstance(delayTime,self.CatchOneStepTimer,self) 
	elseif self.FishVo.DieEffectConfig.fishDieBehavior == 4 then
		local localPos = self.gameObject.transform.parent:InverseTransformPoint(self.playerIns.SwrilPanel.position)
		self.dieMoveToTargetPos = localPos + CSScript.Vector3(self.Random.Range(65,85),0,0)
		self:ShowCoinEffect(self.gameObject.transform)
		self:ShowWinScoreEffect(self.gameObject.transform.position)
		if self.swirlOneStepTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.swirlOneStepTimer)
			self.swirlOneStepTimer = nil
		end
		self.swirlOneStepTimer = TimerManager.GetInstance():CreateTimerInstance(delayTime,self.SwirlOneStepTimer,self) 
	end
end

function ComboFish:NormalOneStepTimer(  )
	self:FishDieRotation()
	if self.normalOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
		self.normalOneStepTimer = nil
	end
end


function ComboFish:SwirlOneStepTimer(  )
	self:FishAdsorptionToSwirl()
	if self.swirlOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.swirlOneStepTimer)
		self.swirlOneStepTimer = nil
	end
end


function ComboFish:CatchOneStepTimer(  )
	self:FishCatchToGun()
	if self.catchOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.catchOneStepTimer)
		self.catchOneStepTimer = nil
	end
end

function ComboFish:CatchTwoStepTimer(  )
	self:FishDieRotation()
	self:ShowCoinEffect(self.gameObject.transform)
	if self.catchTwoStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.catchTwoStepTimer)
		self.catchTwoStepTimer = nil
	end
end


function ComboFish:FishCatchToGun()
	if self.catchToGunSequence then
		self.catchToGunSequence:Kill()
		self.catchToGunSequence = nil
	end
	self.catchToGunSequence = self.DOTween.Sequence()
	local targetPos = self.dieMoveToTargetPos
	local duration= 0.6
	local tween1 = self.gameObject.transform:DOMove(targetPos,duration)
	tween1:SetEase(self.Ease.OutCubic)
	local tween2 = self.gameObject.transform:DOLocalRotate(CSScript.Vector3(0,0,180),duration,self.RotateMode.FastBeyond360)
	tween2:SetEase(self.Ease.OutCubic)
	self.catchToGunSequence:Insert(0,tween1)
	self.catchToGunSequence:Insert(0,tween2)
	local catchToGunOver = function (  )
		self:ShowWinScoreEffect(self.gameObject.transform.position)
		self.catchTwoStepTimer = TimerManager.GetInstance():CreateTimerInstance(self.FishVo.DieEffectConfig.fishDieTwoShowTime,self.CatchTwoStepTimer,self) 
	end
	self.catchToGunSequence:AppendCallback(catchToGunOver)
end


function ComboFish:FishAdsorptionToSwirl(  )
	if self.swirlSequence then
		self.swirlSequence:Kill()
		self.swirlSequence = nil
	end
	self.swirlSequence = self.DOTween.Sequence()
	local targetPos = self.dieMoveToTargetPos
	local tween1 = self.gameObject.transform:DOLocalMove(targetPos,0.5)
	local adsorptionToSwirlOver = function(  )
		self:FishDieRotation()
	end
	self.swirlSequence:Append(tween1)
	self.swirlSequence:AppendCallback(adsorptionToSwirlOver)
end


function ComboFish:FishDieRotation()
	local time = self.FishVo.DieEffectConfig.fishDieThreeShowTime
	self.playerIns.Panel:RemovePlayerCatchFishPos()
	if time == nil then
		self:DestoryDieFish()
		return
	end

	if self.dieRotationSequence then
		self.dieRotationSequence:Kill()
		self.dieRotationSequence = nil
	end
	self.dieRotationSequence = self.DOTween.Sequence()
	local angle = 0 
	if self.FishVo.FishConfig.dieRotationAngle then
		angle = self.FishVo.FishConfig.dieRotationAngle
	end
	local tween1 = self.gameObject.transform:DOLocalRotate(CSScript.Vector3(0,0,angle),time,self.RotateMode.LocalAxisAdd)
	tween1:SetEase(self.Ease.Linear)
	local tween2 = self.gameObject.transform:DOScale(CSScript.Vector3(0,0,0),time)	
	tween2:SetEase(self.Ease.InCubic)
	self.dieRotationSequence:Insert(0,tween1)
	self.dieRotationSequence:Insert(0,tween2)

	-- local callBack1 = function (  )
	-- 	return  self.MainFishSpriteRender.color
	-- end
	-- local callBack2 = function (v)
	-- 	self.MainFishSpriteRender.color = v
	-- end
	-- local alPhaTweener =self.DOTween.ToAlpha(callBack1,callBack2,0.3,time) 
	-- alPhaTweener:SetEase(self.Ease.InCubic) 

	local dieRotationOver = function (  )
		self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
	end
	self.dieRotationSequence:AppendCallback(dieRotationOver)
end

function ComboFish:DestoryDieFish()
	self:SetDestory(true)
	TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
	self.destoryDieFish = nil
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
	if self.normalOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
		self.normalOneStepTimer = nil
	end

	if self.catchOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.catchOneStepTimer)
		self.catchOneStepTimer = nil
	end

	if self.catchTwoStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.catchTwoStepTimer)
		self.catchTwoStepTimer = nil
	end

	if self.swirlOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.swirlOneStepTimer)
		self.swirlOneStepTimer = nil
	end

	if self.destoryDieFish then
		TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
		self.destoryDieFish = nil
	end

	if self.catchToGunSequence then
		self.catchToGunSequence:Kill()
		self.catchToGunSequence = nil
	end

	if self.swirlSequence then
		self.swirlSequence:Kill()
		self.swirlSequence = nil
	end

	if self.dieRotationSequence then
		self.dieRotationSequence:Kill()
		self.dieRotationSequence = nil
	end
end