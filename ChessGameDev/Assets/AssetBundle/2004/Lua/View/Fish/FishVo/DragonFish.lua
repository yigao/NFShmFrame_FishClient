DragonFish=Class(FishBase)

function DragonFish:ctor()
	self:Init()

end

function DragonFish:Init ()
	self:InitData()
end


function DragonFish:InitData()
	self.Score  = 0
	self.Multiple = 0
	self.specialDeclareUID = 0
end

function DragonFish:CheckBoundValid()
	local ResolutionWidthHalf =  CS.FishManager.curResolutionWidth * 0.5

	local ResolutionHeightHalf = CS.FishManager.curResolutionHeight * 0.5

	local pos = GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.FishPool).transform:InverseTransformPoint(self.centerTrans.position)
	
	if (pos.x < -ResolutionWidthHalf) or (pos.x > ResolutionWidthHalf) then return false end

	if (pos.y < -ResolutionHeightHalf) or (pos.y > ResolutionHeightHalf) then return false end

	return true
end


function DragonFish:BuildFish(vo,obj)
	self:InitBaseFish(vo,obj)
	self:FindView()
	self:InitViewData()
	self:PlayBornAnim()
	CommonHelper.AddUpdate(self)
end


function DragonFish:ResetFishState(vo)
	self:ResetBaseFishStateData(vo)
	self:IsEnableAnimator(true)
	self.effectPosList = {}
	self:PlayBornAnim()
	self:PlayMoveAnim(true)
end


function DragonFish:FindView()
	local mTransfrom=self.gameObject.transform
	self.animator=self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
	self.SpineAnim=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
	self.centerTrans = mTransfrom:Find("Collider/BoxCollider_02")
	self.SpineMeshRenderer=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
end

function DragonFish:InitViewData()
	self:PlayMoveAnim(true)
end

function DragonFish:GetEffectPoint(  )
	self.effectPosList = {}
	for i = 1,5 do 
		local tempPos =	self.gameObject.transform:Find("Collider/BoxCollider_0"..i).position
		table.insert(self.effectPosList,tempPos)
	end
	return  self.effectPosList
end

function DragonFish:GetLockPartPoint( )
	return self.centerTrans
end


function DragonFish:PlayMoveAnim(isLoop)
	self.SpineAnim.timeScale = 1
	local animName = self.FishVo.FishConfig.fishMoveAnimationName
	if animName ~="nil" then
		self.SpineAnim.loop=isLoop
		self.SpineAnim.state:SetAnimation(0,animName,isLoop)
	end
end


function DragonFish:PauseSpineAnimation(  )
	self.SpineAnim.timeScale = 0
end

function DragonFish:IsEnableAnimator(isEnabled)
	if self.SpineAnim then
		self.SpineAnim.enabled=isEnabled
	end
	if self.animator then
		self.animator.enabled=isEnabled
	end
end

function DragonFish:PlayBornAnim(  )
	self.animator:Play("Fish_Born",0,0)
end


function DragonFish:PlayDieAnim()
	local animName = self.FishVo.FishConfig.fishDieAnimationName
	if animName ~="nil" then
		self.animator:Play(animName,0,0)
	end
end

function DragonFish:SetMainFishOrder(orderIndex)
	if self.SpineMeshRenderer then
		self.SpineMeshRenderer.sortingOrder=orderIndex
	end
end

function DragonFish:SetHitFlyDirection(direction)
	self.hitFlyDirection = direction	
end


function DragonFish:SetBeHitColor()
	if(self.isHit==false) then
		self:SetMainFishColor(self.beHitColor)
		self.isHit=true
	end
end

function DragonFish:ResetNormalColor( ... )
	self:SetMainFishColor(self.NormalColor)
	self.isHit=false
	self.currentHitTime=0
end

function DragonFish:SetMainFishColor(color)
	self.SpineAnim.skeleton.R = color.r
	self.SpineAnim.skeleton.G = color.g
	self.SpineAnim.skeleton.B = color.b
	self.SpineAnim.skeleton.A = color.a
end

function DragonFish:FishNormalDie(playerIns,hitFishMsg)	
	self.playerIns = playerIns
	self.chairdID = self.playerIns.ChairdID
	self.hitFishMsg = hitFishMsg
	self:FishBaseDie()
	self:ResetNormalColor()
	self:PauseSpineAnimation()
	self:PlayDieAnim()
	self:SetMainFishOrder(self.FishVo.FishConfig.fishDieLayer)
	self:ShowSpecialDeclareEffect(playerIns,hitFishMsg)
	AudioManager.GetInstance():PlayNormalAudio(64)
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

function DragonFish:NormalOneStepTimer(  )
	self:FishDieRotation()
	if self.normalOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
		self.normalOneStepTimer = nil
	end
end

function DragonFish:FishDieRotation()
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

function DragonFish:DestoryDieFish()
	self:SetDestory(true)

	TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
	self.destoryDieFish = nil
end

function DragonFish:ShowSpecialDeclareEffect(playerIns,hitFishMsg)
	local parentFishID=hitFishMsg.bombUID
	self.Score  = hitFishMsg.totalScore
	self.Multiple = hitFishMsg.totalRatio

	if parentFishID and parentFishID==0 then
		local specialDeclareConfig =SpecialDeclareEffectManager.GetInstance():GetSpecialDeclareEffectConfig(self.FishVo.DieEffectConfig.specialDeclareID)
		self.specialDeclareUID =SpecialDeclareEffectManager.GetInstance():SetSpecialDeclareEffectShowMode(playerIns.ChairdID,playerIns.SpecialDeclarePanel.position,specialDeclareConfig)
		if not self.specialDeclarewScoreTimer then
			local time = specialDeclareConfig.delayTime
			self.specialDeclarewScoreTimer = TimerManager.GetInstance():CreateTimerInstance(time,self.ShowSpecialDeclareScore,self) 
		end
	end
end

function DragonFish:ShowSpecialDeclareScore(  )
	SpecialDeclareEffectManager.GetInstance():BeginSpecialDeclareEffectChangeScore(self.specialDeclareUID,self.Score,self.Multiple)
	TimerManager.GetInstance():RecycleTimerIns(self.specialDeclarewScoreTimer)
	self.specialDeclarewScoreTimer = nil
end


function DragonFish:UpdateHit()
	if self.isHit then
		self.currentHitTime=self.currentHitTime+CSScript.Time.deltaTime
		if self.currentHitTime>=self.hitTotalTime then
			self:ResetNormalColor()	
		end
	end
end


function DragonFish:Update()
	self:UpdateHit()
end


function DragonFish:__delete()
	self:IsEnableAnimator(false)
	self:ResetNormalColor()
	if self.normalOneStepTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.normalOneStepTimer)
		self.normalOneStepTimer = nil
	end

	if self.destoryDieFish then
		TimerManager.GetInstance():RecycleTimerIns(self.destoryDieFish)
		self.destoryDieFish = nil
	end

	if self.specialDeclarewScoreTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.specialDeclarewScoreTimer)
		self.specialDeclarewScoreTimer = nil
	end

	if self.dieRotationSequence then
		self.dieRotationSequence:Kill()
		self.dieRotationSequence = nil
	end
end