SpineFish=Class(FishBase)

function SpineFish:ctor()
	self:Init()

end

function SpineFish:Init ()
	self:InitData()
end


function SpineFish:InitData()
end


function SpineFish:BuildFish(vo,obj)
	self:InitBaseFish(vo,obj)
	self:FindView()
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function SpineFish:ResetFishState(vo)
	self:ResetBaseFishStateData(vo)
	self:IsEnableAnimator(true)
	self:PlayMoveAnim(true)
end



function SpineFish:FindView()
	local mTransfrom=self.gameObject.transform
	self.SpineAnim=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
	self.SpineMeshRenderer=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
end

function SpineFish:GetEffectPoint(  )
	return  nil
end


function SpineFish:InitViewData()
	self:PlayMoveAnim(true)
end

function SpineFish:PlayMoveAnim(isLoop)
	local animName = self.FishVo.FishConfig.fishMoveAnimationName
	if animName ~="nil" then
		self.SpineAnim.loop=isLoop
		self.SpineAnim.state:SetAnimation(0,animName,isLoop)
	end
end

function SpineFish:PlayDieAnim(isLoop)
	local animName = self.FishVo.FishConfig.fishDieAnimationName
	if animName ~="nil" then
		self.SpineAnim.loop=isLoop
		self.SpineAnim.state:SetAnimation(0,animName,isLoop)
	end
end

function SpineFish:IsEnableAnimator(isEnabled)
	if self.SpineAnim then
		self.SpineAnim.enabled=isEnabled
	end
end
function SpineFish:SetMainFishOrder(orderIndex)
	if self.SpineMeshRenderer then
		self.SpineMeshRenderer.sortingOrder=orderIndex
	end
end

function SpineFish:SetHitFlyDirection(direction)
	self.hitFlyDirection = direction	
end


function SpineFish:SetBeHitColor()
	if(self.isHit==false) then
		self:SetMainFishColor(self.beHitColor)
		self.isHit=true
	end
end

function SpineFish:ResetNormalColor( ... )
	self:SetMainFishColor(self.NormalColor)
	self.isHit=false
	self.currentHitTime=0
end

function SpineFish:SetMainFishColor(color)
	self.SpineAnim.skeleton.R = color.r
	self.SpineAnim.skeleton.G = color.g
	self.SpineAnim.skeleton.B = color.b
	self.SpineAnim.skeleton.A = color.a
end




function SpineFish:FishNormalDie(playerIns,hitFishMsg)
	self.playerIns = playerIns
	self.chairdID = self.playerIns.ChairdID
	self.hitFishMsg = hitFishMsg
	self:FishBaseDie()
	self:ResetNormalColor()
	self:PlayDieAnim(true)
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
	elseif self.FishVo.DieEffectConfig.fishDieBehavior == 2 then
		self:FishHitFly()
		self:ShowCoinEffect(self.gameObject.transform.position)
		self:ShowWinScoreEffect(self.gameObject.transform.position)
	elseif self.FishVo.DieEffectConfig.fishDieBehavior == 3 then
		self.dieMoveToTargetPos = self.playerIns.Panel:GetPlayerCatchFishPos()
		if self.catchOneStepTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.catchOneStepTimer)
			self.catchOneStepTimer = nil
		end
		self.catchOneStepTimer = TimerManager.GetInstance():CreateTimerInstance(self.FishVo.DieEffectConfig.fishDieOneShowTime,self.CatchOneStepTimer,self) 
	end
end

function SpineFish:NormalOneStepTimer(  )
	self:FishDieRotation()
	if self.normalOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
		self.normalOneStepTimer = nil
	end
end

function SpineFish:CatchOneStepTimer(  )
	self:FishCatchToGun()
	if self.catchOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.catchOneStepTimer)
		self.catchOneStepTimer = nil
	end
end

function SpineFish:CatchTwoStepTimer(  )
	self:FishDieRotation()
	self:ShowCoinEffect(self.gameObject.transform)
	if self.catchTwoStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.catchTwoStepTimer)
		self.catchTwoStepTimer = nil
	end
end


function SpineFish:FishHitFly(  )
	local targetPos = self.hitFlyDirection * self.FishVo.DieEffectConfig.hitFlyDistance  + self.gameObject.transform.localPosition
	local HitFlyOver = function()
		self:FishDieRotation()
	end
	local tween = self.gameObject.transform:DOLocalMove(targetPos,0.3)
	tween:SetEase(self.Ease.OutCubic)
	tween.onComplete = HitFlyOver
end

function SpineFish:FishCatchToGun()
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

function SpineFish:FishDieRotation()
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

function SpineFish:DestoryDieFish()
	self:SetDestory(true)
	TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
	self.destoryDieFish = nil
end


function SpineFish:UpdateHit()
	if self.isHit then
		self.currentHitTime=self.currentHitTime+CSScript.Time.deltaTime
		if self.currentHitTime>=self.hitTotalTime then
			self:ResetNormalColor()	
		end
	end
end


function SpineFish:Update()
	self:UpdateHit()
end


function SpineFish:__delete()
	self:ResetNormalColor()
	self:IsEnableAnimator(false)
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
	self.gameObject.transform:DOKill()
end