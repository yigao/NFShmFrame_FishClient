SerialDrillSkillItem=Class()

function SerialDrillSkillItem:ctor()
	self:Init()
	
end


function SerialDrillSkillItem:Init ()
	self:InitData()
	self:InitView()
	self:InitViewData()
end


function SerialDrillSkillItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	
	self.Skill_SerialDrill_Res = "Skill_SerialDrill"
	self.Gun_SerialDrill_Res = "Gun_SerialDrill"
	self.Bullet_SerialDrill_Res = "Bullet_SerialDrill"
	self.AnimParams={"GunSerialDrill_Idle","GunSerialDrill_Shoot","GunSerialDrill_Bomb"}
	self.beginPos = CSScript.Vector3.zero
	self.targetPos = CSScript.Vector3.zero
	self.isCanDestory=false
	self.isPlayingAnim = false
	self.currentTime=0
	self.totalTime= 30
	self.AllUseSerialDrillBulletList={}
	self.CurrentUseSerialDrillBulletInsList = {}
	
end


function SerialDrillSkillItem:InitView()
	self:FindView()
	
end

function SerialDrillSkillItem:FindView()
	self.SEM=SerialDrillSkillManager.GetInstance()

	self.SkillGunParent = nil
	self.SkillPanelParent = nil

	self.Gun_SerialDrill = nil
	self.Gun_SerialDrill_Anim = nil
	self.Gun_BulletFirePos = nil
end


function SerialDrillSkillItem:InitViewData()
	
end


function SerialDrillSkillItem:ResetSkillVo(vo)
	self.SkillVo=vo
	self.isCanDestory=false
end

function SerialDrillSkillItem:UpdateSkillVo(bulletId,bulletInfo)
	if self.SkillVo.SerialDrillBulletList == nil then
		self.SkillVo.SerialDrillBulletList = {}
	end
	self.SkillVo.SerialDrillBulletList[bulletId] = bulletInfo
	
end

function SerialDrillSkillItem:ResetSkillState(beginPos,skillStatus,skillTime,callBack)
	 self.isCanDestory=false
	
	self.SkillGunParent = self.SkillVo.PlayerIns.Panel.SkillGun
	self.SkillPanelParent = self.SkillVo.PlayerIns.Panel.SKillPanel

	self.beginPos = beginPos
	
	self.targetPos = CSScript.Vector3(beginPos.x,beginPos.y,0) --self.SkillGunParent.position
	self.currentTime = skillTime

	self.callBack=callBack

	self:ShowSerialGunDrill()
end

function SerialDrillSkillItem:ShowSerialGunDrill(  )
	self.Gun_SerialDrill  = GameObjectPoolManager.GetInstance():GetGameObject(self.Gun_SerialDrill_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans = self.Gun_SerialDrill.transform
	trans:SetParent(self.SkillGunParent)
	trans.position =  self.targetPos
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one
	self.Gun_SerialDrill_Anim = trans:Find("TransLocation/Gun_Drill"):GetComponent(typeof(self.SEM.Animator))
	self.Gun_BulletFirePos = trans:Find("TransLocation/BulletFirePos").transform
	self.SkillVo.PlayerIns:EnterSkillStatus(self.SkillVo.PlayerIns.SkillType.Skill_Electric)
	self:PlayGunSerialDrillAnim(self.AnimParams[1])
	self.isPlayingAnim = true
end

function SerialDrillSkillItem:ShootSerialGunDrill(serialBulletID,angle)
	self.Gun_SerialDrill.transform.localRotation = CSScript.Quaternion.Euler(0,0,angle)
	self:PlayGunSerialDrillAnim(self.AnimParams[2])
	self:ShowSerialDrillBullet(serialBulletID)
end


function SerialDrillSkillItem:ShowSerialDrillBullet(serialBulletID)
	local vo=self:GetSerialDrillBulletVo(serialBulletID)
	local tempSerialDrillBulletIns=self:GetSerialDrillBullet(vo)
	if tempSerialDrillBulletIns then
		tempSerialDrillBulletIns:ResetState(self)
	else
		Debug.LogError("获取SerialDrillBullet失败==>")
	end
end

function SerialDrillSkillItem:GetSerialDrillBulletVo(serialBulletID)
	local vo={}
	if self.SkillVo.SerialDrillBulletList[serialBulletID] then
		vo = self.SkillVo.SerialDrillBulletList[serialBulletID]
	end
	return vo
end

function SerialDrillSkillItem:GetSerialDrillBullet(serialDrillBulletVo)
	if self.AllUseSerialDrillBulletList and #self.AllUseSerialDrillBulletList>0 then
		local tempSerialDrillBulletIns=table.remove(self.AllUseSerialDrillBulletList,1)
		if tempSerialDrillBulletIns then
			tempSerialDrillBulletIns:ResetSerialDrillBulletVo(serialDrillBulletVo)
			self.CurrentUseSerialDrillBulletInsList[serialDrillBulletVo.serialDrillBulletID]=tempSerialDrillBulletIns
			return tempSerialDrillBulletIns
		else
			Debug.LogError("创建连环钻头蟹子弹失败==>"..serialDrillBulletVo.serialDrillBulletID)
		end
	else
		local go = GameObjectPoolManager.GetInstance():GetGameObject(self.Bullet_SerialDrill_Res,GameObjectPoolManager.PoolType.BulletPool)
		local tempSerialDrillBulletIns=self.SEM.SerialDrillBullet.New(go)
		if tempSerialDrillBulletIns then
			tempSerialDrillBulletIns:ResetSerialDrillBulletVo(serialDrillBulletVo)
			self.CurrentUseSerialDrillBulletInsList[serialDrillBulletVo.serialDrillBulletID]=tempSerialDrillBulletIns
			return tempSerialDrillBulletIns
		end
	end
end

function SerialDrillSkillItem:SendHitFishInfo(fishUID,bulletUID)
	local hitFishTable = {}
	local chairID = self.SkillVo.PlayerIns.ChairdID 
	local serialDrillUID = self.SkillVo.UID
	local drillBulletUID =  bulletUID
	table.insert(hitFishTable,fishUID)
	self.SEM:RequestSerialDrillHitFishMsg(chairID,serialDrillUID,drillBulletUID,hitFishTable)
end

function SerialDrillSkillItem:BombSerialDrillSkill()
	print("3333333444444444444555555")
	self:PlayGunSerialDrillAnim(self.AnimParams[1])
end

function SerialDrillSkillItem:PlayGunSerialDrillAnim(animationName)
	self.Gun_SerialDrill_Anim:Play(animationName,0,0)
end

function SerialDrillSkillItem:ClearAllSerialDrillBullet()
	if self.CurrentUseSerialDrillBulletInsList then
		for k,v in pairs(self.CurrentUseSerialDrillBulletInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveSerialDrillBullet()
	end
end

function SerialDrillSkillItem:RecycleSerialDrillBullet(serialDrillBulletVo)
	local tempSerialDrillSkillIns =self.CurrentUseSkillInsList[serialDrillBulletVo.serialDrillBulletID]
	if tempSerialDrillSkillIns then
		table.insert(self.AllUseSerialDrillBulletList,tempSerialDrillBulletIns)
		self.CurrentUseSerialDrillBulletInsList[serialDrillBulletVo.serialDrillBulletID]=nil
	else
		Debug.LogError("回收连环钻头蟹子弹失败==>"..serialDrillBulletVo.serialDrillBulletID)
	end	
end

function SerialDrillSkillItem:UpdateRemoveSerialDrillBullet()
	if self.CurrentUseSerialDrillBulletInsList and next(self.CurrentUseSerialDrillBulletInsList) then
		for k,v in pairs(self.CurrentUseSerialDrillBulletInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleSerialDrillBullet(v.serialDrillBulletVo)
			end
		end
	end
end

function SerialDrillSkillItem:Update()
	if self.isPlayingAnim then
		self:UpdateRemoveSerialDrillBullet()	
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.totalTime then
			self.currentTime=0
			self.isCanDestroy= true
			self.isPlayingAnim = false
		end
	end
end

function SerialDrillSkillItem:__delete()
	self.isCanDestory=false
	self.isPlayingAnim = false
	self.callBack=nil
	GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Gun_SerialDrill,GameObjectPoolManager.PoolType.EffectPool)
	self:ClearAllSerialDrillBullet()
end

