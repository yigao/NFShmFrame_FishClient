SerialDrillBullet=Class()

function SerialDrillBullet:ctor(obj)
	self.gameObject = obj
	self:Init(obj)

end

function SerialDrillBullet:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function SerialDrillBullet:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.FishTag="Fish"
	self.AnimParams={"SerialDrill_Bullet_Move"}
	
	self.currentTime=0
	self.totalTime=19
	self.isPlayingAnim=false
	self.serialDrillSkillItem = nil
	self.fishWidth = 120
	self.fishHeight = 340
	self.isCanSeen=false
    self.isCanMove=false
	self.isCanDestroy=false
end


function SerialDrillBullet:InitView(gameObj)
	self:FindView()

end

function SerialDrillBullet:FindView()
	local tf=self.gameObject.transform
	self.SEM=SerialDrillSkillManager.GetInstance()

	self.Bullet_SerialDrill_Anim = tf:Find("Animator_Object"):GetComponent(typeof(self.SEM.Animator))
	self.LuaBehaviour=self.gameObject:GetComponent(typeof(CS.FishLuaBehaviour))
	if not self.LuaBehaviour then
		self.LuaBehaviour=self.gameObject:AddComponent(typeof(CS.FishLuaBehaviour))
		self.LuaBehaviour.m_luaTable=self
	end
	self.LuaBehaviour.onTriggerCallBack=function(other) self:OnTriggerEnter(other) end
end


function SerialDrillBullet:InitViewData()

end

function SerialDrillBullet:PlayAnim(animationName)
	self.Bullet_SerialDrill_Anim:Play(animationName,0,0)
end

function SerialDrillBullet:ResetSerialDrillBulletVo(vo)
	self.serialDrillBulletVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
end

function SerialDrillBullet:ResetState(serialDrillSkillItem)
	self.serialDrillSkillItem = serialDrillSkillItem
	local curPointIndex = self.serialDrillBulletVo.traceStartPoint
	self.LuaBehaviour:FishBeginMove(self.serialDrillBulletVo.traceID,0,0,self.fishWidth,self.fishHeight,curPointIndex)
	self.LuaBehaviour.isMoving = true
	self:PlayAnim(self.AnimParams[1])
	self.isPlayingAnim=true
	self.currentTime = curPointIndex * 0.1
end

function SerialDrillBullet:Update()
	if self.isPlayingAnim then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.totalTime then
			self.currentTime=0
			self.isCanDestroy= true
			self.isPlayingAnim = false
			self.LuaBehaviour.isMoving = false
		end
	end
end

function SerialDrillBullet:OnTriggerEnter(other)
	if other.gameObject:CompareTag(self.FishTag) then
		local HitFish=other.transform.parent.parent:GetComponent(typeof(CS.FishLuaBehaviour)).m_luaTable
		if HitFish then
			if HitFish:GetIsDie() then
				return
			end
			self.serialDrillSkillItem:SendHitFishInfo(HitFish.FishVo.UID,self.serialDrillBulletVo.serialDrillBulletID)
		end
	end
end

function SerialDrillBullet:__delete()
	print("iiiiiiiiiiiiuuuuuuuuuuuuuu")
	self.isCanDestory=false
	self.isPlayingAnim = false
	self.LuaBehaviour.isMoving = false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

