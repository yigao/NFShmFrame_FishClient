ElectricSkillItem=Class()

function ElectricSkillItem:ctor()
	self:Init()
end


function ElectricSkillItem:Init ()
	self:InitData()
	self:InitView()
	self:InitViewData()
end


function ElectricSkillItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.ElcSkillStats ={
		Born = 1,
		Idle = 3,
		Shoot = 4,
	}

	self.Skill_Electric_Res = "Skill_Electric"
	self.Gun_Electric_Res = "Gun_Electric"
	self.Skill_CountdownTimer_Res = "Skill_CountdownTimer"
	self.FishTag="Fish"
	self.AnimParams={"EletricGun_Idle","EletricGun_Fire"}
	self.LuaBehaviour = nil
	self.isPlayingAnim=false
	self.curSkillStats = self.ElcSkillStats.Born
	self.beginPos = CSScript.Vector3.zero
	self.targetPos = CSScript.Vector3.zero
	self.isCanDestory=false
	self.currentTime=0
	self.ShootTotalTime= 3.15
	self.IdleTotalTime = 32
	self.CountdownTime = 30
	self.moveToGunSequence = nil
end


function ElectricSkillItem:InitView()
	self:FindView()
	
end

function ElectricSkillItem:FindView()
	self.SEM=ElectricSkillManager.GetInstance()

	self.SkillGunParent = nil
	self.SkillPanelParent = nil

	self.Skill_Electric = nil
	self.Skill_LogoItem = nil
	self.Skill_ShootBtnObj = nil
	self.shootEventScript = nil

	self.CountdownLabel = nil
	self.CountdownGameObject = nil

	self.Gun_Electric = nil
	self.Gun_Electric_Anim = nil
	self.Gun_BoxCollider_Obj = nil
end

function ElectricSkillItem:InitViewData()
	
end

function ElectricSkillItem:ResetSkillVo(vo)
	self.SkillVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
end

function ElectricSkillItem:ResetSkillState(beginPos,skillStatus,skillTime,callBack)
	 self.isCanDestory=false
	
	self.SkillGunParent = self.SkillVo.PlayerIns.Panel.SkillGun
	self.SkillPanelParent = self.SkillVo.PlayerIns.Panel.SKillPanel

	self.beginPos = beginPos
	
	self.targetPos = self.SkillGunParent.position
	self.callBack=callBack

	self:ChangePlayerView()
	
	self:GetCurrentElectricStep(skillStatus,skillTime)

	self:ShowElectricSkill(skillTime)

	self.isPlayingAnim=true
end

function ElectricSkillItem:ChangePlayerView(  )
	if self.SkillVo.IsMe then
		self.SkillVo.PlayerIns:UploadAutoLockFish(false)
		self.SkillVo.PlayerIns.Panel:IsShowLockFishPanel(false)
		GameSetManager.GetInstance().PlayerSetPanel:ResetLockState(false)
		GameSetManager.GetInstance().PlayerSetPanel:SetLockFishBtnDisable(false)
	end
	self.SkillVo.PlayerIns:SetCanShootBullet(false)
end

function ElectricSkillItem:GetCurrentElectricStep(skillStatus,skillTime)
	if skillStatus == 1 then
		if skillTime <= 0.05 then
			self.curSkillStats = self.ElcSkillStats.Born
		else
			self.curSkillStats = self.ElcSkillStats.Idle
		end
	elseif skillStatus == 2 then
		self.curSkillStats = self.ElcSkillStats.Shoot
	end
	self.currentTime = skillTime * 0.001
end

function ElectricSkillItem:ShowElectricSkill(timeElapsed)
	if self.curSkillStats == self.ElcSkillStats.Born then
		self:GetElectricResItem(self.beginPos)
		self:GetCountdownTimerResItem()
		self:MoveElectricItemToGun()
	elseif self.curSkillStats == self.ElcSkillStats.Idle then
		self:GetElectricResItem(self.targetPos)
		self:GetCountdownTimerResItem()
		self:ShowGunElectric()
	elseif self.curSkillStats == self.ElcSkillStats.Shoot then
		self:GetElectricResItem(self.targetPos)
		self:ShowGunElectric()
		self:ShootGunElectric(self.SkillVo.PlayerIns.ChairdID,0,timeElapsed)
	end
end

function ElectricSkillItem:GetElectricResItem(pos)
	self.Skill_Electric  = GameObjectPoolManager.GetInstance():GetGameObject(self.Skill_Electric_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans=self.Skill_Electric.transform
	trans:SetParent(self.SkillPanelParent)
	trans.position = pos
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one
	self.Skill_LogoItem = trans:Find("FakeGun").gameObject
	self.Skill_ShootBtnObj = trans:Find("Fire").gameObject

	if self.shootEventScript == nil then
        self.shootEventScript = self.Skill_ShootBtnObj:GetComponent(typeof(CS.UIMiniEventScript))
        if self.shootEventScript == nil then 
            self.shootEventScript = self.Skill_ShootBtnObj:AddComponent(typeof(CS.UIMiniEventScript))
        end
	end
	if self.shootEventScript ~= nil and self.shootEventScript.onMiniPointerClickCallBack == nil then
        self.shootEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:OnclickShootFire(pointerEventData) end
    end

	self:IsShowSkillLogoItem(true)
	self:IsShowSkillShootBtnObj(false)
end

function ElectricSkillItem:GetCountdownTimerResItem()
	if self.SkillVo.IsMe then
		self.CountdownGameObject  = GameObjectPoolManager.GetInstance():GetGameObject(self.Skill_CountdownTimer_Res,GameObjectPoolManager.PoolType.EffectPool)
		local trans=self.CountdownGameObject.transform
		trans.localPosition = CSScript.Vector3(0,-170,0)
		trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
		trans.localScale = CSScript.Vector3.one
		self.CountdownLabel = trans:Find("Text"):GetComponent(typeof(self.SEM.Text))
		CommonHelper.SetActive(self.CountdownGameObject,false)
	end
end

function ElectricSkillItem:MoveElectricItemToGun(  )
	local trans = self.Skill_Electric.transform

	if self.moveToGunSequence then
		self.moveToGunSequence:Kill()
		self.moveToGunSequence = nil
	end

	self.moveToGunSequence = self.SEM.DOTween.Sequence()
	
	local tweener1 = trans:DOMove(self.targetPos, 0.7)
	tweener1:SetEase(self.SEM.Ease.Linear)

	local tweener2 = trans:DOScale(CSScript.Vector3(1.5,1.5,1.5), 0.7)
	tweener2:SetEase(self.SEM.Ease.Linear)

	local tweener3 = trans:DOScale(CSScript.Vector3(1,1,1), 0.3)
	tweener3:SetEase(self.SEM.Ease.Linear)

	self.moveToGunSequence:Insert(1,tweener1)
	self.moveToGunSequence:Insert(1,tweener2)
	self.moveToGunSequence:Insert(1.7,tweener3)

	if self.SkillVo.IsMe then
		AudioManager.GetInstance():PlayNormalAudio(41)
	end

	local gunElectricCallBack = function (  )
		self:ShowGunElectric()
	end
	self.moveToGunSequence:AppendCallback(gunElectricCallBack)	
end

function ElectricSkillItem:ShowGunElectric(  )
	if self.SkillVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(43)
		AudioManager.GetInstance():PlayNormalAudio(43,1,true)
	end
	self:IsShowSkillLogoItem(false)
	if self.SkillVo.IsMe then
		self:IsShowSkillShootBtnObj(true)
	end
	self.Gun_Electric= GameObjectPoolManager.GetInstance():GetGameObject(self.Gun_Electric_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans  = self.Gun_Electric.transform
	trans:SetParent(self.SkillGunParent)
	trans.position = self.targetPos
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one
	self.SkillVo.PlayerIns:SetMuzzleEulerAngles(0/self.SkillVo.PlayerIns.PrecisionValue)
	self.Gun_Electric_Anim = trans:Find("GunAnimator"):GetComponent(typeof(self.SEM.Animator))
	local Sphere_Obj = trans:Find("GunAnimator/Sphere_Obj").gameObject
	self.LuaBehaviour=Sphere_Obj:GetComponent(typeof(CS.FishLuaBehaviour))
	if not self.LuaBehaviour then
		self.LuaBehaviour=Sphere_Obj:AddComponent(typeof(CS.FishLuaBehaviour))
		self.LuaBehaviour.m_luaTable=self
	end
	self.LuaBehaviour.onTriggerCallBack=function(other) self:OnTriggerEnter(other) end
	self:IsShowPlayerGunPanel(false)
	self.curSkillStats = self.ElcSkillStats.Idle
	self:PlayGunElcAnim(self.AnimParams[1])
end

function ElectricSkillItem:IsShowPlayerGunPanel(isDisPlay)
	local playerIns = self.SkillVo.PlayerIns
	if isDisPlay == true then
		GameUIManager.GetInstance():IsGamePress(true)
		if self.SkillVo.IsMe then
			
			self.SkillVo.PlayerIns.Panel:IsShowLockFishPanel(true)
			GameSetManager.GetInstance().PlayerSetPanel:SetLockFishBtnDisable(true)
		end
		if self.SkillVo.IsMe then
			playerIns.Panel:IsShowBetPanel(true)
		end
		playerIns:SetCanShootBullet(true)
		playerIns:SetGunLevelValue(playerIns.CurrentGunLevel)
	else
		playerIns.Panel:IsShowBetPanel(false)
		playerIns.Panel:HideGunPanel()
	end
end

function ElectricSkillItem:OnTriggerEnter(other)
	if other.gameObject:CompareTag(self.FishTag) then
		local HitFish=other.transform.parent.parent:GetComponent(typeof(CS.FishLuaBehaviour)).m_luaTable
		if HitFish then
			if HitFish:GetIsDie() then
				return
			end
			self:SendHitFishInfo(HitFish.FishVo.UID)
		end
	end
end

function ElectricSkillItem:SendHitFishInfo(fishUID)
	if self.SkillVo.IsMe or (self.SkillVo.usProcUserChairId ~= -1 and self.SkillVo.usProcUserChairId == self.gameData.PlayerChairId) then
		local usRobotChairId = nil 
		
		if self.SkillVo.usProcUserChairId ~= -1 and self.SkillVo.usProcUserChairId == self.gameData.PlayerChairId then
			usRobotChairId = self.SkillVo.ChairdID
		else
			usRobotChairId = -1
		end
		local hitFishTable = {}
		local chairID = self.gameData.PlayerChairId
		local UID =  self.SkillVo.UID
		table.insert(hitFishTable,fishUID)
		self.SEM:RequestDianCiCannonHitFishMsg(chairID,UID,hitFishTable,usRobotChairId)
	end
end

function ElectricSkillItem:ShootGunElectric(chairId,angle,timeElapsed)
	self.currentTime = timeElapsed
	self:IsShowSkillLogoItem(false)
	self:IsShowSkillShootBtnObj(false)
	if self.CountdownGameObject then
		CommonHelper.SetActive(self.CountdownGameObject,false)
	end
	self.curSkillStats = self.ElcSkillStats.Shoot
	self.SkillVo.PlayerIns:SetMuzzleEulerAngles(angle/self.SkillVo.PlayerIns.PrecisionValue)
	self:PlayGunElcAnim(self.AnimParams[2])
	AudioManager.GetInstance():StopNormalAudio(43)
	AudioManager.GetInstance():PlayNormalAudio(42)
	GameUIManager.GetInstance():SetShake(false)
end

function ElectricSkillItem:PlayGunElcAnim(animationName)
	self.Gun_Electric_Anim:Play(animationName,0,0)
end

function ElectricSkillItem:OnclickShootFire(  )
	local UID = self.SkillVo.UID
	local chairId =  self.SkillVo.PlayerIns.ChairdID
	local angle=math.floor(self.SkillVo.PlayerIns.GunTeamObj.transform.eulerAngles.z*self.SkillVo.PlayerIns.PrecisionValue)
	self.SEM:RequestDianCiCannonShootMsg(chairId,angle,UID)
end


function ElectricSkillItem:ElectricAimOnClick(  )
	if self.curSkillStats == self.ElcSkillStats.Idle and self.SkillVo.IsMe then
		self.SkillVo.PlayerIns:NormalRotationGun()
		local UID = self.SkillVo.UID
		local chairId =  self.SkillVo.PlayerIns.ChairdID
		local aimAngle=math.floor(self.SkillVo.PlayerIns.GunTeamObj.transform.eulerAngles.z*self.SkillVo.PlayerIns.PrecisionValue)
		self.SEM:RequestDianCiCannonAimMsg(chairId,aimAngle,UID)
	end
end 

function ElectricSkillItem:ChangeElectricSkillAim(chairId,angle)
	self.SkillVo.PlayerIns:SetMuzzleEulerAngles(angle/self.SkillVo.PlayerIns.PrecisionValue)
end

function ElectricSkillItem:IsShowSkillLogoItem(isDisplay)
	CommonHelper.SetActive(self.Skill_LogoItem,isDisplay)
end

function ElectricSkillItem:IsShowSkillShootBtnObj(isDisplay)
	CommonHelper.SetActive(self.Skill_ShootBtnObj,isDisplay)
end

function ElectricSkillItem:ShootCountdownLable()
	if self.SkillVo.IsMe == true then
		if  ((self.IdleTotalTime - self.currentTime) <= self.CountdownTime) then 
			if 	CommonHelper.IsActive(self.CountdownGameObject) == false then
				CommonHelper.SetActive(self.CountdownGameObject,true)
			end
			local time = math.ceil(self.IdleTotalTime - self.currentTime)
			self.CountdownLabel.text = "调整发射方向并点击发射按钮，或<color=red>"..tostring(time).."s".."</color>后自动发射！" 
		else
			if 	CommonHelper.IsActive(self.CountdownGameObject) == true then
				CommonHelper.SetActive(self.CountdownGameObject,false)
			end
			AudioManager.GetInstance():StopNormalAudio(43)
		end
	end
end

function ElectricSkillItem:Update()
	if self.isPlayingAnim then
		if self.curSkillStats == self.ElcSkillStats.Idle or self.curSkillStats == self.ElcSkillStats.Born then
			self.currentTime = self.currentTime+CSScript.Time.deltaTime
			self:ShootCountdownLable()
			if self.currentTime>=self.IdleTotalTime then
				self.currentTime=0
			end
		elseif self.curSkillStats == self.ElcSkillStats.Shoot then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.ShootTotalTime then
				self.currentTime=0
				self.isPlayingAnim=false
				self.isCanDestory=true
				self:IsShowPlayerGunPanel(true)
				if self.callBack then
					self.callBack()
				end
			end
		end
	end
end


function ElectricSkillItem:__delete()
	AudioManager.GetInstance():StopNormalAudio(43)

	if self.moveToGunSequence then
		self.moveToGunSequence:Kill()
		self.moveToGunSequence = nil
	end

	if self.CountdownGameObject then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.CountdownGameObject,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.CountdownGameObject = nil
	
	if self.Skill_Electric then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Skill_Electric,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.Skill_Electric = nil

	if self.Gun_Electric then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Gun_Electric,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.Gun_Electric = nil
	
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.callBack=nil
	
end

