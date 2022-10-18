DrillBullet=Class()

function DrillBullet:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end

function DrillBullet:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function DrillBullet:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.DrillBulletStats = {
		DrillBullet_Normal = 1,
		DrillBullet_Rotation = 2,
		DrillBullet_Bomb = 3,
	}
	self.FishTag="Fish"
	self.AnimParams={"Drill_BulletNormal","Drill_BulletRotation","Drill_BulletlBomb"}
	
	self.currentDrillBulletStats = self.DrillBulletStats.DrillBullet_Normal
	self.isPlayingAnim=false
	self.currentTime=0
	self.NormalTotalTime=10
	self.RotationTotalTime = 2
	self.BombTotalTime = 1.6
	self.beginPos = CSScript.Vector3.zero
	self.drillSkillItem = nil
	self.fishWidth = 120
	self.fishHeight = 340
	self.isCanSeen=false
    self.isCanMove=false
	self.isCanDestroy=false
	self.isPlayHitAudio = false
end


function DrillBullet:InitView(gameObj)
	self:FindView()
	
end

function DrillBullet:FindView()
	local tf=self.gameObject.transform
	self.SEM=DrillSkillManager.GetInstance()

	self.Bullet_Drill_Anim = tf:Find("Animator_Object"):GetComponent(typeof(self.SEM.Animator))
	self.boxCollider = tf:GetComponent(typeof(CS.UnityEngine.BoxCollider))
	self.LuaBehaviour=self.gameObject:GetComponent(typeof(CS.FishLuaBehaviour))
	if not self.LuaBehaviour then
		self.LuaBehaviour=self.gameObject:AddComponent(typeof(CS.FishLuaBehaviour))
		self.LuaBehaviour.m_luaTable=self
	end
	self.LuaBehaviour.onTriggerCallBack=function(other) self:OnTriggerEnter(other) end
end


function DrillBullet:InitViewData()
	
end



function DrillBullet:PlayAnim(animationName)
	self.Bullet_Drill_Anim:Play(animationName,0,0)
end


function DrillBullet:ResetDrillBulletVo(vo)
	self.drillBulletVo=vo
	self.isCanDestory=false
	self.isPlayingAnim =  false
	self.isPlayHitAudio = false
end



function DrillBullet:ResetState(drillSkillItem)
	self.drillSkillItem = drillSkillItem
	local curPointIndex = self.drillBulletVo.TraceStartPoint
	self.LuaBehaviour:FishBeginMove(self.drillBulletVo.TraceID,0,0,self.fishWidth,self.fishHeight,curPointIndex,0)
	self.LuaBehaviour.curFishStatus = CS.FishLuaBehaviour.FishStatus.Move
	self:PlayAnim(self.AnimParams[1],0,0)
	self:GetDrillStats(curPointIndex * 0.1)
	self.isPlayingAnim = true
	self.isPlayHitAudio = true
	self.boxCollider.enabled = true
end

function DrillBullet:GetDrillStats(timeElapsed)
	if timeElapsed <= self.NormalTotalTime then
		self:PlayAnim(self.AnimParams[1])
		self.currentTime = timeElapsed
		self.currentDrillBulletStats = self.DrillBulletStats.DrillBullet_Normal
	elseif timeElapsed>=self.NormalTotalTime and timeElapsed<=(self.NormalTotalTime + self.RotationTotalTime) then
		self:PlayAnim(self.AnimParams[2])
		self.currentTime = timeElapsed - self.NormalTotalTime
		self.currentDrillBulletStats = self.DrillBulletStats.DrillBullet_Rotation
	end
end

function DrillBullet:BombDrill()
	self.boxCollider.enabled = false
	self.currentDrillBulletStats = self.DrillBulletStats.DrillBullet_Bomb
	self.currentTime = 0
	self.LuaBehaviour.curFishStatus = CS.FishLuaBehaviour.FishStatus.Stop
	self:PlayAnim(self.AnimParams[3])
	GameUIManager.GetInstance():SetShake(false)
	AudioManager.GetInstance():PlayNormalAudio(45)
end

function DrillBullet:Update()
	if self.isPlayingAnim then
		if self.currentDrillBulletStats == self.DrillBulletStats.DrillBullet_Normal then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.NormalTotalTime then
				self.currentTime=0
				self:PlayAnim(self.AnimParams[2])
				self.currentDrillBulletStats = self.DrillBulletStats.DrillBullet_Rotation
			end
		elseif self.currentDrillBulletStats == self.DrillBulletStats.DrillBullet_Rotation then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.RotationTotalTime then
				self.currentTime=0
			end
		elseif self.currentDrillBulletStats == self.DrillBulletStats.DrillBullet_Bomb then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.BombTotalTime then
				self.currentTime=0
				self.isPlayingAnim = false
				self.isCanDestroy = true
			end
		end
	end
end

function DrillBullet:OnTriggerEnter(other)
	if other.gameObject:CompareTag(self.FishTag) then
		local HitFish=other.transform.parent.parent:GetComponent(typeof(CS.FishLuaBehaviour)).m_luaTable
		if HitFish then
			if HitFish:GetIsDie() then
				return
			end
			self:PlayHitAudio()
			self.drillSkillItem:SendHitFishInfo(HitFish.FishVo.UID)
		end
	end
end

function DrillBullet:PlayHitAudio(  )
	if self.isPlayHitAudio == true then
		self.isPlayHitAudio = false
		AudioManager.GetInstance():PlayNormalAudio(44)
		local sequence = self.SEM.DOTween.Sequence()
		local resetHitAudioFlag = function (  )
			self.isPlayHitAudio = true
		end
		sequence:InsertCallback(0.7,resetHitAudioFlag)
	end
end

function DrillBullet:__delete()
	self.isCanDestory=false
	self.isPlayingAnim = false
	self.LuaBehaviour.curFishStatus = CS.FishLuaBehaviour.FishStatus.Stop
	self.currentDrillBulletStats = self.DrillBulletStats.DrillBullet_Normal
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

