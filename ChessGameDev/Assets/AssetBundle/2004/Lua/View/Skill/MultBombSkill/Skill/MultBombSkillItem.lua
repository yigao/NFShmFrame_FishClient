MultBombSkillItem=Class()

function MultBombSkillItem:ctor()
	self:Init()
end


function MultBombSkillItem:Init ()
	self:InitData()
	self:InitView()
	self:InitViewData()
end


function MultBombSkillItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.MultBombSkillStats ={
		Move = 1,
		Idle = 2,
	}

	self.Skill_MultBomb_Res = "Skill_MultiBomb"
	self.FishTag="Fish"
	self.AnimParams={"MultBombDrab_Catch","MultBombDrab_Catching"}
	self.isPlayingAnim=false
	self.curSkillStats = self.MultBombSkillStats.Move
	self.beginPos = CSScript.Vector3.zero
	self.isCanDestory=false
	self.currentTime=0
	self.MoveTotalTime= 1
	self.IdleTotalTime = 2
	self.score  = 0
	self.multiple = 0
	self.moveSequence = nil
end


function MultBombSkillItem:InitView()
	self:FindView()
end

function MultBombSkillItem:FindView()
	self.SEM=MultBombSkillManager.GetInstance()

	self.SkillGunParent = nil
	self.SkillPanelParent = nil

	self.Skill_MultBomb = nil
	self.Skill_MultBomb_Anim = nil
	self.Skill_MultBomb_Text = nil
end

function MultBombSkillItem:InitViewData()
	
end

function MultBombSkillItem:ResetSkillVo(vo)
	self.SkillVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
end

function MultBombSkillItem:ResetSkillState(beginPos,skillStatus,skillTime,callBack)
	 self.isCanDestory=false
	
	self.SkillGunParent = self.SkillVo.PlayerIns.Panel.SkillGun
	self.SkillPanelParent = self.SkillVo.PlayerIns.Panel.SKillPanel
	self.beginPos = beginPos

	self.score  = 0
	self.multiple = 0

	self.targetPos = self.SkillGunParent.position
	self.callBack=callBack

	self:GetCurrentMultBombStep(skillStatus,skillTime)

	self:ShowMultBombSkill(skillTime)

	self.isPlayingAnim=true
end

function MultBombSkillItem:GetCurrentMultBombStep(skillStatus,skillTime)
	if skillTime <= 0.1 then
		self.curSkillStats = self.MultBombSkillStats.Move
	else
		self.curSkillStats = self.MultBombSkillStats.Idle
	end
	self.currentTime = skillTime * 0.001
end

function MultBombSkillItem:ShowMultBombSkill(timeElapsed)
	if self.curSkillStats == self.MultBombSkillStats.Move then
		self:GetMultBombResItem(self.beginPos)
		self:MultBombMove()
	elseif self.curSkillStats == self.MultBombSkillStats.Idle then
		self:GetMultBombResItem(self.SkillVo.NextPos)
	end
	self:SetMultBomNumber(self.SkillVo.BombCount)
end

function MultBombSkillItem:GetMultBombResItem(pos)
	self.Skill_MultBomb  = GameObjectPoolManager.GetInstance():GetGameObject(self.Skill_MultBomb_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans=self.Skill_MultBomb.transform
	trans.position = pos

	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one
	self.Skill_MultBomb_Text = trans:Find("Content/Icon/Text"):GetComponent(typeof(self.SEM.Text))
	self.Skill_MultBomb_Anim = trans:GetComponent(typeof(self.SEM.Animator))
	AudioManager.GetInstance():PlayNormalAudio(47,1,true)
end

function MultBombSkillItem:SetMultBomNumber(number)
	self.Skill_MultBomb_Text.text = tostring(number)
end

function MultBombSkillItem:MultBombMove(  )
	local trans = self.Skill_MultBomb.transform

	if self.moveSequence then
		self.moveSequence:Kill()
		self.moveSequence = nil
	end

	self.moveSequence = self.SEM.DOTween.Sequence()
	
	local tweener1 = trans:DOMove(self.SkillVo.NextPos, 1)
	tweener1:SetEase(self.SEM.Ease.Linear)

	self.moveSequence:Insert(0,tweener1)

	local moveOVerCallBack = function (  )
		self:MultBombIdle()
	end
	self.moveSequence:AppendCallback(moveOVerCallBack)
	self:PlayMultBombAnim(1)	
end

function MultBombSkillItem:MultBombIdle()
	self.curSkillStats = self.MultBombSkillStats.Idle
	self:PlayMultBombAnim(2)
	AudioManager.GetInstance():StopNormalAudio(47)
	AudioManager.GetInstance():PlayNormalAudio(47,1,true)
end

function MultBombSkillItem:MultBombExplose()
	
	self:SetMultBomNumber(self.SkillVo.BombCount)
	self:ShowMultBombExploseEffect()
	GameUIManager.GetInstance():SetShake(false)
	AudioManager.GetInstance():StopNormalAudio(47)
	AudioManager.GetInstance():PlayNormalAudio(48)
	self.curSkillStats = self.MultBombSkillStats.Move
	if self.SkillVo.NextPos then
		self:MultBombMove()
	else
		self.Skill_MultBomb.transform.localPosition = CSScript.Vector3(10000,10000,0)
	end
end

function MultBombSkillItem:DelayMultBombDestroy(score,mul)
	self.score  = score
	self.multiple = mul
	self.specialDeclarewScoreTimer = TimerManager.GetInstance():CreateTimerInstance(1.5,self.MultBombDestroy,self) 
end

function MultBombSkillItem:MultBombDestroy()
	self.isCanDestory=true
	TimerManager.GetInstance():RecycleTimerIns(self.specialDeclarewScoreTimer)
	self.specialDeclarewScoreTimer = nil
	self.SEM:ShowSpecialDeclareScore(self.SkillVo.UID,self.score,self.multiple)
end

function MultBombSkillItem:ShowMultBombExploseEffect()
	local beginPos = self.Skill_MultBomb.transform.position
	local name ="Effect_Bomb"
	local type = 1
	local delayTime =0 
	local lifeTime =1.5
	local effectAudio = nil 
	FishEffectManager.GetInstance():ShowFishEffect(beginPos,type,name,0,lifeTime,effectAudio)
end

function MultBombSkillItem:PlayMultBombAnim(index)
	local animationName = self.AnimParams[index]
	if animationName then
		self.Skill_MultBomb_Anim:Play(animationName,0,0)
	end
end

function MultBombSkillItem:Update()
	
end

function MultBombSkillItem:__delete()
	if self.moveSequence then
		self.moveSequence:Kill()
		self.moveSequence = nil
	end
	AudioManager.GetInstance():StopNormalAudio(47)
	if self.Skill_MultBomb then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Skill_MultBomb,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.Skill_MultBomb = nil

	self.isCanDestory=false
	self.isPlayingAnim=false
	self.callBack=nil
end

