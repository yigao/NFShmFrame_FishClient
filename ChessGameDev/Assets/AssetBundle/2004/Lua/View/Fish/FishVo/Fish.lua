Fish=Class(FishBase)

function Fish:ctor()
	self:Init()

end

function Fish:Init ()
	self:InitData()
end


function Fish:InitData()
end


function Fish:BuildFish(vo,obj)
	self:InitBaseFish(vo,obj)
	self:FindView()
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function Fish:ResetFishState(vo)
	self:ResetBaseFishStateData(vo)
	self:IsEnableRenderer(true)
	self:IsEnableAnimator(true)
	self:PlayMoveAnim()
end


function Fish:FindView()
	local mTransfrom=self.gameObject.transform
	self:FindMainFishRenderView(mTransfrom)
	self:FindSpecialFishRenderView(mTransfrom)
	self.animator=self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
end


function Fish:FindMainFishRenderView(tf)
	local tempObj=tf:Find("Bone/Fish")
	if tempObj then
		self.MainFishSpriteRender=tempObj:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
	end
	tempObj = tf:Find("Bone/Shadow")
	if tempObj then
		self.ShadowFishSpriteRender = tempObj:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
	end
end


function Fish:FindSpecialFishRenderView(tf)
	
end


function Fish:InitViewData()
	self:PlayMoveAnim()
end

function Fish:GetEffectPoint(  )
	return  nil
end



function Fish:PlayMoveAnim()
	local animName = self.FishVo.FishConfig.fishMoveAnimationName
	if animName then
		self.animator:Play(animName)
	end
end

function Fish:PlayDieAnim()
	local animName = self.FishVo.FishConfig.fishDieAnimationName
	if animName then
		self.animator:Play(animName)
	end
end


function Fish:SetMainFishOrder(orderIndex)
	if self.MainFishSpriteRender then
		self.MainFishSpriteRender.sortingOrder=orderIndex
	end
	if self.ShadowFishSpriteRender then
		self.ShadowFishSpriteRender.sortingOrder = orderIndex - 1
	end
end

function Fish:SetHitFlyDirection(direction)
	self.hitFlyDirection = direction	
end

function Fish:IsEnableAnimator(isEnabled)
	if self.animator then
		self.animator.enabled=isEnabled
	end
end

function Fish:SetBeHitColor()
	if self.isHit==false  then
		self:SetMainFishColor(self.beHitColor)
		self.isHit=true
	end
	
end

function Fish:IsEnableRenderer(isEnabled)
	if self.MainFishSpriteRender then
		self.MainFishSpriteRender.enabled=isEnabled
	end
end

function Fish:ResetNormalColor( ... )
	self:SetMainFishColor(self.NormalColor)
	self.isHit=false
	self.currentHitTime=0
end

function Fish:SetMainFishColor(color)
	self.MainFishSpriteRender.color = color
end


function Fish:FishNormalDie(playerIns,hitFishMsg)
	self.playerIns = playerIns
	self.chairdID = self.playerIns.ChairdID
	self.hitFishMsg = hitFishMsg
	self:FishBaseDie()
	self:ResetNormalColor()
	self:PlayDieAnim()
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
	elseif self.FishVo.DieEffectConfig.fishDieBehavior == 2 then
		self:FishHitFly()
		self:ShowCoinEffect(self.gameObject.transform)
		self:ShowWinScoreEffect(self.gameObject.transform.position)
	elseif self.FishVo.DieEffectConfig.fishDieBehavior == 3 then
		self.dieMoveToTargetPos = self.playerIns.Panel:GetPlayerCatchFishPos()
		if self.catchOneStepTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.catchOneStepTimer)
			self.catchOneStepTimer = nil
		end
		self.catchOneStepTimer = TimerManager.GetInstance():CreateTimerInstance(delayTime,self.CatchOneStepTimer,self) 
	elseif self.FishVo.DieEffectConfig.fishDieBehavior == 4 then
		local localPos = self.gameObject.transform.parent:InverseTransformPoint(self.playerIns.SwrilPanel.position)
		self.dieMoveToTargetPos = localPos - CSScript.Vector3(self.Random.Range(-50,50),self.Random.Range(-50,50),0)
		self:ShowCoinEffect(self.gameObject.transform)
		self:ShowWinScoreEffect(self.gameObject.transform.position)
		if self.swirlOneStepTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.swirlOneStepTimer)
			self.swirlOneStepTimer = nil
		end
		self.swirlOneStepTimer = TimerManager.GetInstance():CreateTimerInstance(delayTime,self.SwirlOneStepTimer,self) 
	end
end

function Fish:NormalOneStepTimer(  )
	self:FishDieRotation()
	if self.normalOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
		self.normalOneStepTimer = nil
	end
end

function Fish:CatchOneStepTimer(  )
	self:FishCatchToGun()
	if self.catchOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.catchOneStepTimer)
		self.catchOneStepTimer = nil
	end
end

function Fish:CatchTwoStepTimer(  )
	self:FishDieRotation()
	self:ShowCoinEffect(self.gameObject.transform)
	if self.catchTwoStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.catchTwoStepTimer)
		self.catchTwoStepTimer = nil
	end
end

function Fish:SwirlOneStepTimer(  )
	self:FishAdsorptionToSwirl()
	if self.swirlOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.swirlOneStepTimer)
		self.swirlOneStepTimer = nil
	end
end

function Fish:FishHitFly(  )
	local targetPos = self.hitFlyDirection * self.FishVo.DieEffectConfig.hitFlyDistance  + self.gameObject.transform.localPosition
	local HitFlyOver = function()
		self:FishDieRotation()
	end
	local tween = self.gameObject.transform:DOLocalMove(targetPos,0.3)
	tween:SetEase(self.Ease.OutCubic)
	tween.onComplete = HitFlyOver
end

function Fish:FishCatchToGun()
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
	self.catchToGunSequence :Insert(0,tween1)
	self.catchToGunSequence :Insert(0,tween2)
	local catchToGunOver = function (  )
		self:ShowWinScoreEffect(self.gameObject.transform.position)
		if self.catchTwoStepTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.catchTwoStepTimer)
			self.catchTwoStepTimer = nil
		end
		self.catchTwoStepTimer = TimerManager.GetInstance():CreateTimerInstance(self.FishVo.DieEffectConfig.fishDieTwoShowTime,self.CatchTwoStepTimer,self) 
	end
	self.catchToGunSequence :AppendCallback(catchToGunOver)
end

function Fish:FishAdsorptionToSwirl(  )
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

function Fish:FishDieRotation()
	local time = self.FishVo.DieEffectConfig.fishDieThreeShowTime
	self.playerIns.Panel:RemovePlayerCatchFishPos()
	if time == nil then
		self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
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

function Fish:DestoryDieFish()
	self:SetDestory(true)
	TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
	self.destoryDieFish = nil
end

function Fish:UpdateHit()
	if self.isHit then
		self.currentHitTime=self.currentHitTime+CSScript.Time.deltaTime
		if self.currentHitTime>=self.hitTotalTime then
			self:ResetNormalColor()	
		end
	end
end

function Fish:Update()
	self:UpdateHit()
end

function Fish:__delete()
	self:ResetNormalColor()
	self:IsEnableRenderer(false)
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
	self.gameObject.transform:DOKill()
end