DrillSkillItem=Class()

function DrillSkillItem:ctor()
	self:Init()
	
end


function DrillSkillItem:Init ()
	self:InitData()
	self:InitView()
	self:InitViewData()
end


function DrillSkillItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.DrillSkillStats ={
		Born = 1,
		Idle = 2,
		Shoot = 3,
	}

	self.Skill_Drill_Res = "Skill_Drill"
	self.Gun_Drill_Res = "Gun_Drill"
	self.Bullet_Drill_Res = "Bullet_Drill"
	self.Skill_CountdownTimer_Res = "Skill_CountdownTimer"
	self.AnimParams={"DrillGun_Idle",}
	self.BulletUID = 1
	self.curSkillStats = self.DrillSkillStats.Born
	self.beginPos = CSScript.Vector3.zero
	self.targetPos = CSScript.Vector3.zero
	self.isPlayingAnim=false
	self.isCanDestory=false
	self.currentTime=0
	self.ShootTotalTime= 13.6
	self.IdleTotalTime = 32
	self.CountdownTime = 30
	self.score  = 0
	self.multiple = 0
	self.AllUseDrillBulletList={}
	self.CurrentUseDrillBulletInsList = {}
end


function DrillSkillItem:InitView()
	self:FindView()
end

function DrillSkillItem:FindView()
	self.SEM=DrillSkillManager.GetInstance()

	self.SkillGunParent = nil
	self.SkillPanelParent = nil

	self.Skill_Drill = nil
	self.Skill_LogoItem = nil
	self.Skill_ShootBtnObj = nil
	self.shootEventScript = nil

	self.Gun_Drill = nil
	self.Gun_Drill_Anim = nil
	self.Gun_Sphere_Sprite = nil
	self.Gun_BulletFirePos = nil

	self.CountdownLabel = nil
	self.CountdownGameObject = nil
end

function DrillSkillItem:InitViewData()
	
end

function DrillSkillItem:ResetSkillVo(vo)
	self.SkillVo=vo
	self.isCanDestory=false
end


function DrillSkillItem:ResetSkillState(beginPos,skillStatus,skillTime,callBack)
	 self.isCanDestory=false
	
	 self.score  = 0
	 self.multiple = 0
	 
	self.SkillGunParent = self.SkillVo.PlayerIns.Panel.SkillGun
	self.SkillPanelParent = self.SkillVo.PlayerIns.Panel.SKillPanel

	self.beginPos = beginPos
	
	self.targetPos = self.SkillGunParent.position
	self.callBack=callBack

	self:ChangePlayerView()

	self:GetCurrentDrillStep(skillStatus,skillTime)
	self:ShowDrillSkill(skillTime * 0.001)
	self.isPlayingAnim=true
end


function DrillSkillItem:ChangePlayerView(  )
	if self.SkillVo.IsMe then
		self.SkillVo.PlayerIns:UploadAutoLockFish(false)
		self.SkillVo.PlayerIns.Panel:IsShowLockFishPanel(false)
		GameSetManager.GetInstance().PlayerSetPanel:ResetLockState(false)
		GameSetManager.GetInstance().PlayerSetPanel:SetLockFishBtnDisable(false)
	end
	self.SkillVo.PlayerIns:SetCanShootBullet(false)
end


function DrillSkillItem:GetCurrentDrillStep(skillStatus,skillTime)
	if skillStatus == 1 then
		if skillTime <= 0.1 then
			self.curSkillStats = self.DrillSkillStats.Born
		else
			self.curSkillStats = self.DrillSkillStats.Idle
		end
	elseif skillStatus == 2 then
		self.curSkillStats = self.DrillSkillStats.Shoot
	end
	
	self.currentTime = skillTime * 0.001
end

function DrillSkillItem:ShowDrillSkill(timeElapsed)
	if self.curSkillStats == self.DrillSkillStats.Born then
		self:GetDrillResItem(self.beginPos)
		self:GetCountdownTimerResItem()
		self:MoveDrillItemToGun()
	elseif self.curSkillStats == self.DrillSkillStats.Idle then
		self:GetDrillResItem(self.targetPos)
		self:GetCountdownTimerResItem()
		self:ShowGunDrill()
	elseif self.curSkillStats == self.DrillSkillStats.Shoot then
		self:GetDrillResItem(self.targetPos)
		self:ShowGunDrill()
		self:ShootGunDrill(self.SkillVo.PlayerIns.ChairdID,0,timeElapsed)
	end
end

function DrillSkillItem:IsDrillShoot()
	if  self.curSkillStats == self.DrillSkillStats.Shoot then
		return true
	else
		return false
	end
end

function DrillSkillItem:GetDrillResItem(pos)
	self.Skill_Drill =GameObjectPoolManager.GetInstance():GetGameObject(self.Skill_Drill_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans = self.Skill_Drill.transform
	trans:SetParent(self.SkillPanelParent)
	trans.position =pos
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one
	self.Skill_LogoItem = trans:Find("DrillObject").gameObject
	self.Skill_ShootBtnObj = trans:Find("Fire").gameObject
	if self.shootEventScript == nil then
        self.shootEventScript = self.Skill_ShootBtnObj:GetComponent(typeof(CS.UIMiniEventScript))
        if self.shootEventScript == nil then 
            self.shootEventScript = self.Skill_ShootBtnObj:AddComponent(typeof(CS.UIMiniEventScript))
        end
	end
	if self.shootEventScript ~= nil and self.shootEventScript.onMiniPointerClickCallBack == nil then
        self.shootEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:OnClickShootFire(pointerEventData) end
    end
	self:IsShowSkillLogoItem(true)
	self:IsShowSkillShootBtnObj(false)
end


function DrillSkillItem:GetCountdownTimerResItem()
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


function DrillSkillItem:MoveDrillItemToGun(  )

	local trans = self.Skill_Drill.transform

	local sequence = self.SEM.DOTween.Sequence()
	
	local tweener1 = trans:DOMove(self.targetPos, 0.7)
	tweener1:SetEase(self.SEM.Ease.Linear)

	local tweener2 = trans:DOScale(CSScript.Vector3(1.5,1.5,1.5), 0.7)
	tweener2:SetEase(self.SEM.Ease.Linear)

	local tweener3 = trans:DOScale(CSScript.Vector3(1,1,1), 0.3)
	tweener3:SetEase(self.SEM.Ease.Linear)

	sequence:Insert(1,tweener1)
	sequence:Insert(1,tweener2)
	sequence:Insert(1.7,tweener3)

	if self.SkillVo.IsMe then
		AudioManager.GetInstance():PlayNormalAudio(41)
	end

	local gunDrillCallBack = function (  )
		self:ShowGunDrill()
	end
	sequence:AppendCallback(gunDrillCallBack)	
	
end

function DrillSkillItem:ShowGunDrill(  )
	if self.SkillVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(43)
		AudioManager.GetInstance():PlayNormalAudio(43,1,true)
	end
	self:IsShowSkillLogoItem(false)
	if self.SkillVo.IsMe then
		self:IsShowSkillShootBtnObj(true)
	end
	self.Gun_Drill  = GameObjectPoolManager.GetInstance():GetGameObject(self.Gun_Drill_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans = self.Gun_Drill.transform
	trans:SetParent(self.SkillGunParent)
	trans.position =  self.targetPos
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one
	self.SkillVo.PlayerIns:SetMuzzleEulerAngles(0/self.SkillVo.PlayerIns.PrecisionValue)
	self.Gun_Drill_Anim = trans:Find("TransLocation/Gun_Drill"):GetComponent(typeof(self.SEM.Animator))
	self.Gun_Sphere_Sprite = trans:Find("TransLocation/Sphere_Sprite").gameObject
	self.Gun_BulletFirePos = trans:Find("TransLocation/BulletFirePos").transform
	self:IsShowPlayerGunPanel(false)
	self.curSkillStats = self.DrillSkillStats.Idle
	self:IsShowGunSphere(true)
	self:PlayGunDrillAnim(self.AnimParams[1])
end


function DrillSkillItem:IsShowPlayerGunPanel(isDisPlay)
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


function DrillSkillItem:PlayGunDrillAnim(animationName)
	self.Gun_Drill_Anim:Play(animationName,0,0)
end

function DrillSkillItem:DrillAimOnClick(  )
	if self.curSkillStats == self.DrillSkillStats.Idle and self.SkillVo.IsMe then
		self.SkillVo.PlayerIns:NormalRotationGun()
		local UID = self.SkillVo.UID
		local chairId =  self.SkillVo.PlayerIns.ChairdID
		local aimAngle=math.floor(self.SkillVo.PlayerIns.GunTeamObj.transform.eulerAngles.z*self.SkillVo.PlayerIns.PrecisionValue)
		self.SEM:RequestDrillAimMsg(chairId,aimAngle,UID)
	end
end 

function DrillSkillItem:ChangeDrillSkillAim(chairId,angle)
	self.SkillVo.PlayerIns:SetMuzzleEulerAngles(angle/self.SkillVo.PlayerIns.PrecisionValue)
end

function DrillSkillItem:OnClickShootFire(  )
	local UID = self.SkillVo.UID
	local chairId =  self.SkillVo.PlayerIns.ChairdID
	local angle=math.floor(self.SkillVo.PlayerIns.GunTeamObj.transform.eulerAngles.z*self.SkillVo.PlayerIns.PrecisionValue)
	self.SEM:RequestDrillShootMsg(chairId,angle,UID)
end

function DrillSkillItem:ShootGunDrill(chairId,angle,timeElapsed)
	self.currentTime = timeElapsed
	self:IsShowSkillLogoItem(false)
	self:IsShowSkillShootBtnObj(false)
	if self.CountdownGameObject  then
		CommonHelper.SetActive(self.CountdownGameObject,false)
	end
	self.curSkillStats = self.DrillSkillStats.Shoot
	self.SkillVo.PlayerIns:SetMuzzleEulerAngles(angle/self.SkillVo.PlayerIns.PrecisionValue)
	self:IsShowGunSphere(false)
	self:ShowDrillBullet(self.SkillVo.TraceID,self.SkillVo.TraceStartPoint)
	self.Gun_Drill.transform.localPosition = CSScript.Vector3(10000,10000,0)
	if self.SkillVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(43)
		AudioManager.GetInstance():PlayNormalAudio(42)
	end
end

function DrillSkillItem:ShowDrillBullet(traceId,traceStartPoint)
	local vo=self:GetDrillBulletVo(traceId,traceStartPoint)
	local tempDrillBulletIns=self:GetDrillBullet(vo)
	if tempDrillBulletIns then
		tempDrillBulletIns:ResetState(self)
	else
		Debug.LogError("获取DrillBullet失败==>")
	end
end

function DrillSkillItem:GetDrillBulletUID()
	self.BulletUID=self.BulletUID+1
	return self.BulletUID
end

function DrillSkillItem:GetDrillBulletVo(traceID,traceStartPoint)
	local vo={}
	vo.UID=self:GetDrillBulletUID()
	vo.TraceID = traceID
	vo.TraceStartPoint = traceStartPoint
	return vo
end


function DrillSkillItem:GetDrillBullet(drillBulletVo)
	if self.AllUseDrillBulletList and #self.AllUseDrillBulletList>0 then
		local tempDrillBulletIns=table.remove(self.AllUseDrillBulletList,1)
		if tempDrillBulletIns then
			tempDrillBulletIns:ResetDrillBulletVo(drillBulletVo)
			self.CurrentUseDrillBulletInsList[drillBulletVo.UID]=tempDrillBulletIns
			return tempDrillBulletIns
		end
	else
		local go = GameObjectPoolManager.GetInstance():GetGameObject(self.Bullet_Drill_Res,GameObjectPoolManager.PoolType.BulletPool)
		local tempDrillBulletIns=self.SEM.DrillBullet.New(go)
		if tempDrillBulletIns then
			tempDrillBulletIns:ResetDrillBulletVo(drillBulletVo)
			self.CurrentUseDrillBulletInsList[drillBulletVo.UID]=tempDrillBulletIns
			return tempDrillBulletIns
		end
	end
	return nil
end

function DrillSkillItem:SendHitFishInfo(fishUID)
	-- local hitFishTable = {}
	-- local chairID = self.SkillVo.PlayerIns.ChairdID 
	-- local UID =  self.SkillVo.UID
	-- table.insert(hitFishTable,fishUID)
	-- self.SEM:RequestDrillHitFishMsg(chairID,UID,hitFishTable)
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
		self.SEM:RequestDrillHitFishMsg(chairID,UID,hitFishTable,usRobotChairId)
	end
end

function DrillSkillItem:BombDrillSkill(score,mul)
	self.score  = score
	self.multiple = mul
	if self.CurrentUseDrillBulletInsList and next(self.CurrentUseDrillBulletInsList) then
		for k,v in pairs(self.CurrentUseDrillBulletInsList) do
			v:BombDrill()
		end
	end
end

function DrillSkillItem:ClearAllDrillBullet()
	if self.CurrentUseDrillBulletInsList then
		for k,v in pairs(self.CurrentUseDrillBulletInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveDrillBullet()
	end
	self.CurrentUseDrillBulletInsList ={}
end

function DrillSkillItem:RecycleDrillBullet(drillBulletVo)
	local tempDrillSkillIns =self.CurrentUseDrillBulletInsList[drillBulletVo.UID]
	if tempDrillSkillIns then
		table.insert(self.AllUseDrillBulletList,tempDrillSkillIns)
		self.CurrentUseDrillBulletInsList[drillBulletVo.UID]=nil
	else
		Debug.LogError("回收钻头蟹子弹失败==>"..drillBulletVo.UID)
	end	
end

function DrillSkillItem:UpdateRemoveDrillBullet()
	if self.CurrentUseDrillBulletInsList and next(self.CurrentUseDrillBulletInsList) then
		for k,v in pairs(self.CurrentUseDrillBulletInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleDrillBullet(v.drillBulletVo)
			end
		end
	end
end


function DrillSkillItem:ShootCountdownLable()
	if self.SkillVo.IsMe == true then
		if ((self.IdleTotalTime - self.currentTime) <= self.CountdownTime) then
			if 	CommonHelper.IsActive(self.CountdownGameObject) == false then
				CommonHelper.SetActive(self.CountdownGameObject,true)
			end
			local time = math.ceil(self.IdleTotalTime - self.currentTime)
			self.CountdownLabel.text = "调整发射方向并点击发射按钮，或<color=red>"..tostring(time).."</color>S后自动发射！" 
		else
			if 	CommonHelper.IsActive(self.CountdownGameObject) == true then
				CommonHelper.SetActive(self.CountdownGameObject,false)
			end
			AudioManager.GetInstance():StopNormalAudio(43)
		end
	end
end


function DrillSkillItem:Update()
	if self.isPlayingAnim then
		if self.curSkillStats == self.DrillSkillStats.Born or self.curSkillStats == self.DrillSkillStats.Idle then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			self:ShootCountdownLable()
			if self.currentTime>=self.IdleTotalTime then
				self.currentTime=0
			end
		elseif self.curSkillStats == self.DrillSkillStats.Shoot then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.ShootTotalTime then
				self.currentTime=0
				self.isPlayingAnim = false
				self.isCanDestory=true
				self:IsShowPlayerGunPanel(true)
				self.SEM:ShowSpecialDeclareScore(self.SkillVo.UID,self.score,self.multiple)
				if self.callBack then
					self.callBack()
				end
			end
		end
	end
end


function DrillSkillItem:IsShowSkillLogoItem(isDisplay)
	CommonHelper.SetActive(self.Skill_LogoItem,isDisplay)
end

function DrillSkillItem:IsShowSkillShootBtnObj(isDisplay)
	CommonHelper.SetActive(self.Skill_ShootBtnObj,isDisplay)
end

function DrillSkillItem:IsShowGunSphere(isDisplay)
	CommonHelper.SetActive(self.Gun_Sphere_Sprite,isDisplay)
end

function DrillSkillItem:__delete()
	self.isCanDestory=false
	self.isPlayingAnim = false
	self.callBack=nil
	if self.CountdownGameObject then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.CountdownGameObject,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.CountdownGameObject = nil

	if self.Skill_Drill then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Skill_Drill,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.Skill_Drill = nil

	if self.Gun_Drill then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Gun_Drill,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.Gun_Drill = nil
	self:ClearAllDrillBullet()
end
