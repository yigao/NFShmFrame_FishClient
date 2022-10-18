PartFish=Class(FishBase)

function PartFish:ctor()
	self:Init()

end

function PartFish:Init ()
	self:InitData()
end


function PartFish:InitData()
	self.FishPartType = {
		NormalLeg = 0,
		LeftLeg = 1,
		RightLeg = 2,
		NoneLeg = 3,
	}
	self.curPartType = self.FishPartType.NormalLeg
	self.partCollders = {}
end


function PartFish:BuildFish(vo,obj)
	self:InitBaseFish(vo,obj)
	self:FindView()
	self:BuildPartFish()
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function PartFish:ResetFishState(vo)
	self:ResetBaseFishStateData(vo)
	self:BuildPartFish()
	self:InitViewData()
end


function PartFish:FindView()
	local mTransfrom=self.gameObject.transform
	self.animator=self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
	self.SpineAnim=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
	self.SpineMeshRenderer=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
	self.lockPointList = {}
	self.effectPointList ={}
	for i = 1,3 do
		local lockPoint = mTransfrom:Find("LockPoint/LockPoint"..i)
		local effectPoint = mTransfrom:Find("EffectPoint/EffectPoint"..i)
		table.insert(self.lockPointList,lockPoint)
		table.insert(self.effectPointList,effectPoint)
	end
end


function PartFish:RemoveLockPart(lockTrans)
	for i = 1,3 do
		if self.lockPointList[i] == lockTrans and self.partCollders[i].enabled == false then
			return true
		end
	end
	return false
end


function PartFish:BuildPartFish(  )
	for i =0,self.colliders.Length-1 do
		if self.colliders[i].gameObject.name == "BoxCollider_01" then
			self.partCollders[1] = self.colliders[i]
		elseif self.colliders[i].gameObject.name == "BoxCollider_02" then
			self.partCollders[2] = self.colliders[i]
		elseif self.colliders[i].gameObject.name == "BoxCollider_03" then
			self.partCollders[3] = self.colliders[i]
		end
 	end
	 
	if self.FishVo.FishKindGroup then
		if #self.FishVo.FishKindGroup>0 then
			if self.FishVo.FishKindGroup[self.FishPartType.LeftLeg] == 1  then
				self.curPartType = self.FishPartType.LeftLeg
				self.partCollders[self.FishPartType.LeftLeg].enabled = true
				self.PartCount = 1
			else
				self.partCollders[self.FishPartType.LeftLeg].enabled = false
			end

			if self.FishVo.FishKindGroup[self.FishPartType.RightLeg] == 1 then
				self.PartCount = 1
				self.curPartType = self.FishPartType.RightLeg
				self.partCollders[self.FishPartType.RightLeg].enabled = true
			else
				self.partCollders[self.FishPartType.RightLeg].enabled = false
			end

			if self.FishVo.FishKindGroup[self.FishPartType.LeftLeg] == 1 and  self.FishVo.FishKindGroup[self.FishPartType.RightLeg] == 1 then
				self.curPartType = self.FishPartType.NormalLeg
				self.PartCount = 2
			end

			if self.FishVo.FishKindGroup[self.FishPartType.LeftLeg] == 0 and  self.FishVo.FishKindGroup[self.FishPartType.RightLeg] == 0 then
				self.curPartType = self.FishPartType.NoneLeg
				self.partCollders[self.FishPartType.LeftLeg].enabled = false
				self.partCollders[self.FishPartType.RightLeg].enabled = false
				self.PartCount = 0
			end
		end
	end

	self.partCollders[1].gameObject.tag="Left_Leg"
	self.partCollders[2].gameObject.tag="Right_Leg"
end


function PartFish:InitViewData()
	self:IsEnableAnimator(true)
	self:PlayBornAnim()
	self:PlayMovePartAnim(true)
end

function PartFish:GetEffectPoint(partID)
	return self.lockPointList[partID].position	
end

function PartFish:GetLockPartPoint( )
	if self.curPartType == self.FishPartType.NormalLeg then
		return self.lockPointList[2]
	elseif self.curPartType == self.FishPartType.LeftLeg then
		return self.lockPointList[1]
	elseif self.curPartType == self.FishPartType.RightLeg then
		return self.lockPointList[2]
	elseif self.curPartType == self.FishPartType.NoneLeg then
		return self.lockPointList[3]
	end
end

function PartFish:GetColliderObj(  )
	if self.curPartType == self.FishPartType.NormalLeg then
		return self.partCollders[2]
	elseif self.curPartType == self.FishPartType.LeftLeg then
		return self.partCollders[1]
	elseif self.curPartType == self.FishPartType.RightLeg then
		return self.partCollders[2]
	elseif self.curPartType == self.FishPartType.NoneLeg then
		return self.partCollders[3]
	end
end

function PartFish:RemoveFishPart(partID)
	if self.PartCount == 2 then
		if partID == 1 then
			self.SpineAnim.skeleton.FlipX = true
			self:PlayHitPartAnim("HURT_L",false)
			self.partCollders[self.FishPartType.LeftLeg].enabled = false
			self.curPartType = self.FishPartType.RightLeg
		elseif partID == 2 then
			self.SpineAnim.skeleton.FlipX = false
			self:PlayHitPartAnim("HURT_L",false)
			self.partCollders[self.FishPartType.RightLeg].enabled = false
			self.curPartType = self.FishPartType.LeftLeg
		end
		self.PartCount = self.PartCount - 1
		self.delayRemovePart = TimerManager.GetInstance():CreateTimerInstance(0.6,self.DelayRemovePart,self)
	elseif self.PartCount == 1 then
		if partID == 1 then
			self.SpineAnim.skeleton.FlipX = false
			self.partCollders[self.FishPartType.LeftLeg].enabled = false
			self:PlayHitPartAnim("HURT_R",false)
		elseif partID == 2 then
			self.SpineAnim.skeleton.FlipX = true
			self.partCollders[self.FishPartType.RightLeg].enabled = false
			self:PlayHitPartAnim("HURT_R",false)
		end
		self.curPartType = self.FishPartType.NoneLeg
		self.PartCount = self.PartCount - 1
		if self.delayRemovePart == nil then
			TimerManager.GetInstance():RecycleTimerIns(self.delayRemovePart)
		end
		self.delayRemovePart = TimerManager.GetInstance():CreateTimerInstance(0.6,self.DelayRemovePart,self)
	end
end

function PartFish:DelayRemovePart(  )
	TimerManager.GetInstance():RecycleTimerIns(self.delayRemovePart)	
	self:PlayMovePartAnim()
end

function PartFish:PlayHitPartAnim(animationName)
	self.SpineAnim.timeScale = 1
	self.SpineAnim.state:SetAnimation(0,animationName,false)
end

function PartFish:PlayMovePartAnim()
	self.SpineAnim.timeScale = 1
	if self.curPartType == self.FishPartType.NormalLeg then
		self.SpineAnim.state:SetAnimation(0,"SWIM",true)
	elseif self.curPartType == self.FishPartType.LeftLeg then
		self.SpineAnim.skeleton.FlipX = false
		self.SpineAnim.state:SetAnimation(0,"CRAZY",true)
	elseif self.curPartType == self.FishPartType.RightLeg then
		self.SpineAnim.skeleton.FlipX = true
		self.SpineAnim.state:SetAnimation(0,"CRAZY",true)
	elseif self.curPartType == self.FishPartType.NoneLeg then
		self.SpineAnim.state:SetAnimation(0,"WEAK",true)
	end
end

function PartFish:PauseSpineAnimation(  )
	self.SpineAnim.timeScale = 0
end

function PartFish:PlayBornAnim(  )
	local animName = self.FishVo.FishConfig.fishMoveAnimationName
	if animName ~="nil" then
		self.animator:Play(animName,0,0)
	end
end

function PartFish:PlayDieAnim()
	local animName = self.FishVo.FishConfig.fishDieAnimationName
	if animName ~="nil" then
		self.animator:Play(animName,0,0)
	end
end

function PartFish:SetMainFishOrder(orderIndex)
	if self.SpineMeshRenderer then
		self.SpineMeshRenderer.sortingOrder=orderIndex
	end
end


function PartFish:IsEnableAnimator(isEnabled)
	if self.animator then
		self.animator.enabled=isEnabled
	end
	if self.SpineAnim then
		self.SpineAnim.enabled=isEnabled
	end
end


function PartFish:SetHitFlyDirection(direction)
	self.hitFlyDirection = direction	
end


function PartFish:SetBeHitColor()
	if(self.isHit==false) then
		self:SetMainFishColor(self.beHitColor)
		self.isHit=true
	end
end

function PartFish:ResetNormalColor( ... )
	self:SetMainFishColor(self.NormalColor)
	self.isHit=false
	self.currentHitTime=0
end

function PartFish:SetMainFishColor(color)
	self.SpineAnim.skeleton.R = color.r
	self.SpineAnim.skeleton.G = color.g
	self.SpineAnim.skeleton.B = color.b
	self.SpineAnim.skeleton.A = color.a
end


function PartFish:FishNormalDie(playerIns,hitFishMsg)
	self.playerIns = playerIns
	self.chairdID = self.playerIns.ChairdID
	self.hitFishMsg = hitFishMsg
	self:FishBaseDie()
	self:ResetNormalColor()
	self:PauseSpineAnimation()
	self:PlayDieAnim()
	self:SetMainFishOrder(self.FishVo.FishConfig.fishDieLayer)
	if self.destoryDieFish then
		TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
		self.destoryDieFish = nil
	end
	self.destoryDieFish = TimerManager.GetInstance():CreateTimerInstance(self.FishVo.FishConfig.fishDieTime,self.DestoryDieFish,self) 
	if self.FishVo.DieEffectConfig.fishDieBehavior == 1 then
		self:ShowCoinEffect(self.gameObject.transform)
		self:ShowWinScoreEffect(self.gameObject.transform.position)
		if self.normalOneStepTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
			self.normalOneStepTimer = nil
		end
		self.normalOneStepTimer = TimerManager.GetInstance():CreateTimerInstance(self.FishVo.DieEffectConfig.fishDieOneShowTime,self.NormalOneStepTimer,self) 
	end
end

function PartFish:NormalOneStepTimer(  )
	self:FishDieRotation()
	if self.normalOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
		self.normalOneStepTimer = nil
	end
end

function PartFish:FishDieRotation()
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
	local angle = self.FishVo.FishConfig.dieRotationAngle
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

function PartFish:DestoryDieFish()
	self:SetDestory(true)
	TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
	self.destoryDieFish = nil
end

function PartFish:UpdateHit()
	if self.isHit then
		self.currentHitTime=self.currentHitTime+CSScript.Time.deltaTime
		if self.currentHitTime>=self.hitTotalTime then
			self:ResetNormalColor()	
		end
	end
end

function PartFish:Update()
	self:UpdateHit()
end

function PartFish:__delete()
	self:ResetNormalColor()
	self:IsEnableAnimator(false)

	if self.normalOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
		self.normalOneStepTimer = nil
	end

	if self.destoryDieFish then
		TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
		self.destoryDieFish = nil
	end

	if self.dieRotationSequence then
		self.dieRotationSequence:Kill()
		self.dieRotationSequence = nil
	end
end