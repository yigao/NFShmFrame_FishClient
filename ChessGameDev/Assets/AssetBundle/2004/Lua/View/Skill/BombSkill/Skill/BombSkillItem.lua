BombSkillItem=Class()

function BombSkillItem:ctor()
	self:Init()
	
end

function BombSkillItem:Init ()
	self:InitData()
	self:InitView()
	self:InitViewData()
end

function BombSkillItem:InitData()

	self.BombSkillStats ={
		Born = 1,
		Prepare = 2,
		Bomb = 3,
	}

	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.Skill_Bomb_Res = "Skill_Bomb"
	self.AnimParams={"Skill_Bomb_Prepare","Skill_Bomb_Explosion"}
	self.isPlayingAnim=false
	self.isCanDestory=false
	self.curSkillStats = self.BombSkillStats.Born
	self.beginPos = CSScript.Vector3.zero
	self.targetPos = CSScript.Vector3.zero
	self.currentTime=0
	self.ExplosionTotalTime= 1.5
	self.BornTotalTime = 1.5
	self.PrepareTotlaTime = 2
	self.score  = 0
	self.multiple = 0
	self.skillStatus = 0
end

function BombSkillItem:InitView()
	self:FindView()
end

function BombSkillItem:FindView()
	self.SEM=BombSkillManager.GetInstance()

	self.SkillGunParent = nil
	self.SkillPanelParent = nil

	self.Skill_Bomb = nil
	self.Skill_Bomb_Anim = nil
end

function BombSkillItem:InitViewData()
	
end

function BombSkillItem:ResetSkillVo(vo)
	self.SkillVo=vo
	self.isPlayingAnim=false
	self.isCanDestory=false
	self.score  = 0
	self.multiple = 0
end

function BombSkillItem:ResetSkillState(beginPos,skillStatus,skillTime,callBack)
	 self.isCanDestory=false
	
	self.SkillGunParent = self.SkillVo.PlayerIns.Panel.SkillGun
	self.SkillPanelParent = self.SkillVo.PlayerIns.Panel.SKillPanel

	self.beginPos = beginPos
	
	self.targetPos = self.SkillGunParent.position
	self.callBack=callBack
	
	self:GetCurrentBombStep(skillStatus,skillTime)
	self:ShowBombSkill(skillTime)
	self.isPlayingAnim= true
end

function BombSkillItem:GetCurrentBombStep(skillStatus,skillTime)
	self.skillStatus = skillStatus
	if skillTime < self.BornTotalTime then
		self.curSkillStats = self.BombSkillStats.Born
	else
		self.curSkillStats = self.BombSkillStats.Prepare
	end
	self.currentTime = skillTime * 0.001
end

function BombSkillItem:ShowBombSkill(timeElapsed)
	if self.curSkillStats == self.BombSkillStats.Born then
		self:GetBombResItem()
	elseif self.curSkillStats == self.BombSkillStats.Prepare then
		self:GetBombResItem()
		self:BombCrabPrepare(self.currentTime)
	end
end

function BombSkillItem:BombCrabPrepare(timeElapse)
	self.Skill_Bomb.transform.position = self.beginPos
	self.curSkillStats = self.BombSkillStats.Prepare
	self:PlayBombSkillAnim(1)
	AudioManager.GetInstance():StopNormalAudio(47)
	AudioManager.GetInstance():PlayNormalAudio(47,1,true)
end

function BombSkillItem:GetBombResItem(pos)
	self.Skill_Bomb  = GameObjectPoolManager.GetInstance():GetGameObject(self.Skill_Bomb_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans=self.Skill_Bomb.transform
	trans:SetParent(self.SkillPanelParent)
	trans.localPosition = CSScript.Vector3(10000,10000,0) 
	trans.localScale = CSScript.Vector3.one
	self.Skill_Bomb_Anim = trans:Find("Content"):GetComponent(typeof(self.SEM.Animator))
end


function BombSkillItem:BombCrabExplosion(score,mul)
	self.score  = score
	self.multiple = mul
	self.currentTime = 0
	self.curSkillStats = self.BombSkillStats.Bomb
	self:PlayBombSkillAnim(2)
	GameUIManager.GetInstance():SetShake(false)
	AudioManager.GetInstance():StopNormalAudio(47)
	AudioManager.GetInstance():PlayNormalAudio(48)
end


function BombSkillItem:PlayBombSkillAnim(index)
	local animationName = self.AnimParams[index]
	if animationName then
		self.Skill_Bomb_Anim:Play(animationName,0,0)
	end
end


function BombSkillItem:Update()
	if self.isPlayingAnim then
		if self.curSkillStats == self.BombSkillStats.Born then
			self.currentTime = self.currentTime+CSScript.Time.deltaTime
			if self.currentTime >= self.BornTotalTime then
				self.currentTime=0
				self:BombCrabPrepare(0)
			end
		elseif self.curSkillStats == self.BombSkillStats.Prepare then
			self.currentTime = self.currentTime+CSScript.Time.deltaTime
			if self.currentTime >= self.PrepareTotlaTime then
				AudioManager.GetInstance():StopNormalAudio(47)
				self.currentTime=0
			end
		elseif self.curSkillStats == self.BombSkillStats.Bomb then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.ExplosionTotalTime then
				self.currentTime=0
				self.isPlayingAnim=false
				self.isCanDestory=true
				self.SEM:ShowSpecialDeclareScore(self.SkillVo.UID,self.score,self.multiple)
				if self.callBack then
					self.callBack()
				end
			end
		end
	end
end

function BombSkillItem:__delete()
	AudioManager.GetInstance():StopNormalAudio(47)
	GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Skill_Bomb,GameObjectPoolManager.PoolType.EffectPool)
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.callBack=nil
end

