BisonSkillItem=Class()

function BisonSkillItem:ctor()
	self:Init()
	
end


function BisonSkillItem:Init ()
	self:InitData()
	self:InitView()
	self:InitViewData()
end


function BisonSkillItem:InitData()
	self.BisonSkillStats ={
		Born = 1,
		Idle = 2,
		Shoot = 3,
		End = 4,
		Destroy = 5,
	}
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.Skill_Bison_Res = "Skill_Bison"
	self.BisonCutIn_Res = "Bison_CutIn"
	self.Bison_SpecialDeclare_Res = "SpecialDeclare_Bison"
	self.OtherBison_SpecialDeclare_Res = "SpecialDeclare_BisonsOther"
	self.BisonLogo_AnimParams={"Bison_Start","Bison_Showing","Bison_into","Bison_loop","Bison_end","Bison_OtherEnding"}
	self.LuaBehaviour = nil
	self.isPlayingAnim=false
	self.beginPos = CSScript.Vector3.zero
	self.targetPos = CSScript.Vector3.zero
	self.isCanDestory=false
	self.currentTime=0
	self.ShootTotalTime= 8.5
	self.IdleTotalTime =3
	self.EndTotalTime = 4
	self.DestroyTotalTime = 0.8
	self.direction = 1
	self.BisonsCutInTime = 2.2

	self.changeScoreCurrentTime = 0
	self.changeScoreTotalTime = 1.5
	self.changeScoreTempScore  = 0
	self.changScoreInitScore = 0
	self.IsChangeScore = false 

	self.changeMulCurrentTime = 0
	self.changeMulTotalTime = 0.5
	self.changeMultipleTempMul  = 0
	self.changMultipleInitMul = 0
	self.IsChangeMul = false
	
	self.bisonMultipleTable = nil
end


function BisonSkillItem:InitView()
	self:FindView()
	
end

function BisonSkillItem:FindView()
	self.SEM=BisonSkillManager.GetInstance()

	self.SkillGunParent = nil
	self.SkillPanelParent = nil

	self.Skill_Bison = nil
	self.SpecialDeclare_Bison = nil
	self.BisonCutIn = nil
	self.Bison_MulText = nil
	self.Bison_ScoreText = nil
	self.MyBison_SpecialDeclare_Animator = nil
	self.Bison_Board_Mul_Animator = nil

	self.OtherSpecialDeclare_Bison = nil
	self.OtherBison_MulText = nil
	self.OtherBison_ScoreText = nil
	self.OtherBison_SpecialDeclare_Animator =  nil
	self.bisonSequence = nil
end


function BisonSkillItem:InitViewData()
	
end

function BisonSkillItem:ResetSkillVo(vo)
	self.SkillVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
end


function BisonSkillItem:ResetSkillState(skillStatus,skillTime,skillScore,skillMul,callBack)
	 self.isCanDestory=false
	self.SkillGunParent = self.SkillVo.PlayerIns.Panel.SkillGun
	self.SkillPanelParent = self.SkillVo.PlayerIns.Panel.SKillPanel

	self.beginPos =CSScript.Vector3.zero
	
	self.targetPos = self.SkillGunParent.position

	self.changeScoreCurrentTime = 0
	self.changeScoreTempScore  = 0
	self.changScoreInitScore = skillScore
	self.IsChangeScore = false 

	self.changeMulCurrentTime = 0
	self.changeMultipleTempMul  = 0
	self.changMultipleInitMul = skillMul
	self.IsChangeMul = false

	self.bisonMultipleTable = {}

	self.callBack=callBack
	self:GetCurrentBisonStep(skillStatus,skillTime)
	self:ShowBisonSkill()
	self.isPlayingAnim=true
end

function BisonSkillItem:GetCurrentBisonStep(skillStatus,skillTime)
	if skillStatus == 1 then
		if skillTime <= 0.1 then
			self.curSkillStats = self.BisonSkillStats.Born
		else
			self.curSkillStats = self.BisonSkillStats.Idle
		end
	elseif skillStatus == 2 then
		self.curSkillStats = self.BisonSkillStats.Shoot
	end
	self.currentTime = skillTime * 0.001
end

function BisonSkillItem:ShowBisonSkill(  )
	if self.curSkillStats == self.BisonSkillStats.Born then
		self:GetBisonCutInRes()
	elseif self.curSkillStats == self.BisonSkillStats.Idle then
		self:ShowBisonsSpecialDeclare()
		self:PlayBisonSpecialDeclareAnimation(2)
		self:SetBisonMul(self.changMultipleInitMul)
	elseif self.curSkillStats == self.BisonSkillStats.Shoot then
		self:ShowBisonsSpecialDeclare()
		self:PlayBisonSpecialDeclareAnimation(2)
		self:SetBisonMul(self.changMultipleInitMul)
		self:BeginBisonShoot(self.currentTime)
	end
end

function BisonSkillItem:GetBisonCutInRes(  )
	self.BisonCutIn  = GameObjectPoolManager.GetInstance():GetGameObject(self.BisonCutIn_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans=self.BisonCutIn.transform
	trans.localPosition = CSScript.Vector3.zero
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one

	if 	self.bisonSequence ~= nil then
		self.bisonSequence:Kill()
		self.bisonSequence = nil
	end
	self.bisonSequence = self.SEM.DOTween.Sequence()
	local showBisonLogoCallBack=function()
		self:ShowBisonsSpecialDeclare()
		self:PlayBisonSpecialDeclareAnimation(1)
	end
	local BisonCutInOverCallBack = function (  )
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.BisonCutIn,GameObjectPoolManager.PoolType.EffectPool)
		self.BisonCutIn = nil
	end
	self.bisonSequence:InsertCallback((self.BisonsCutInTime-0.3),showBisonLogoCallBack)
	self.bisonSequence:InsertCallback(self.BisonsCutInTime,BisonCutInOverCallBack)
end

function BisonSkillItem:ShowBisonsSpecialDeclare(  )
	self.SpecialDeclare_Bison = GameObjectPoolManager.GetInstance():GetGameObject(self.Bison_SpecialDeclare_Res,GameObjectPoolManager.PoolType.SpecialDeclarePool)
	local trans = self.SpecialDeclare_Bison.transform
	trans.localPosition = CSScript.Vector3.zero
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.transform.localScale = CSScript.Vector3.one

	self.Bison_MulText = trans:Find("Root/Logo/TextRoot/Text"):GetComponent(typeof(self.SEM.Text))
	self.Bison_ScoreText = trans:Find("Root/RewardROOT/Reward"):GetComponent(typeof(self.SEM.Text))
	self.MyBison_SpecialDeclare_Animator =  trans:Find("Root"):GetComponent(typeof(self.SEM.Animator))
	self.Bison_Board_Mul_Animator = trans:Find("Root/Logo/TextRoot"):GetComponent(typeof(self.SEM.Animator))
	self:SetBisonMul(self.changMultipleInitMul)
	
end

function BisonSkillItem:PlayBisonSpecialDeclareAnimation(index)
	local animationName = self.BisonLogo_AnimParams[index]
	if animationName then
		self.MyBison_SpecialDeclare_Animator:Play(animationName,0,0)
	end
end

function BisonSkillItem:PlayOtherBisonSpecialDeclareAnimation(animationName)
	self.OtherBison_SpecialDeclare_Animator:Play(animationName,0,0)
end

function BisonSkillItem:GetBisonSkillRes()
	self.Skill_Bison  = GameObjectPoolManager.GetInstance():GetGameObject(self.Skill_Bison_Res,GameObjectPoolManager.PoolType.EffectPool)
	
	local trans=self.Skill_Bison.transform
	local animator = trans:Find("Animator"):GetComponent(typeof(self.SEM.Animator))
	animator:Play("BisonSkill01_Move",0,(self.currentTime/self.ShootTotalTime))
	trans.localPosition = CSScript.Vector3.zero
	if self.SkillVo.Direction == 1 then
		trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	elseif self.SkillVo.Direction == 2 then
		trans.localRotation = CSScript.Quaternion.Euler(0,180,0)
	end
	trans.localScale = CSScript.Vector3.one
end

function BisonSkillItem:BeginBisonShoot(timeElapse)
	self.currentTime = timeElapse
	self:GetBisonSkillRes()
	self.curSkillStats = self.BisonSkillStats.Shoot
	AudioManager.GetInstance():PlayNormalAudio(60,1,true)
end


function BisonSkillItem:SetBisonMul(multiple)
	self.Bison_MulText.text = "x"..tostring(multiple)
end

function BisonSkillItem:SetBisonScore(score)
	self.Bison_ScoreText.text = tostring(score)
end

function BisonSkillItem:RefreshBisonInfo(score,mul)
	self.IsChangeMul = true
	self.changeMultipleTempMul = mul

	if self.bisonMultipleTable == nil then
		self.bisonMultipleTable = {}
	end
	table.insert(self.bisonMultipleTable,mul)
	self.Bison_Board_Mul_Animator:Play("Bison_Board_Mul",0,0)
	GameUIManager.GetInstance():SetShake(false)
end

function BisonSkillItem:ChangeBisonMul()
	if self.IsChangeMul == false  then return end
	if self.bisonMultipleTable and next(self.bisonMultipleTable) then
		self.changeMulCurrentTime = self.changeMulCurrentTime + CSScript.Time.deltaTime
		if self.changeMulCurrentTime <= self.changeMulTotalTime then
			local multipleResult=self.changMultipleInitMul + math.ceil(self.changeMultipleTempMul*(self.changeMulCurrentTime/self.changeMulTotalTime))
			self:SetBisonMul(multipleResult)
		else
			table.remove(self.bisonMultipleTable,1)
			self.changeMulCurrentTime = 0
			self.changMultipleInitMul = self.changMultipleInitMul + self.changeMultipleTempMul
			self:SetBisonMul(self.changMultipleInitMul)
			self.Bison_Board_Mul_Animator:Play("Bison_Board_Mul",0,0)
			if self.bisonMultipleTable and next(self.bisonMultipleTable) then
				self.changeMultipleTempMul = self.bisonMultipleTable[1]
			end
		end
	else
		self.IsChangeMul = false	
	end
end


function BisonSkillItem:ChangeBisonScore()
	if self.SkillVo.IsMe then return end

	if self.IsChangeScore == false  then return end
	
	self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
	if self.changeScoreCurrentTime <= self.changeScoreTotalTime then
		local scoreResult=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.changeScoreCurrentTime/self.changeScoreTotalTime))
		self:SetBisonScore(scoreResult)
	else
		self.changeScoreCurrentTime = 0
		self.changScoreInitScore = self.changeScoreTempScore
		self:SetBisonScore(self.changScoreInitScore)
		self.IsChangeScore = false
	end
end


function BisonSkillItem:EndBisonSkill(score,mul)
	self.curSkillStats = self.BisonSkillStats.End
	self.currentTime = 0
	
	if self.Skill_Bison then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Skill_Bison,GameObjectPoolManager.PoolType.EffectPool)
		self.Skill_Bison = nil
	end

	AudioManager.GetInstance():StopNormalAudio(60)
	if self.SkillVo.IsMe then
		self.IsChangeScore = true
		self.changeScoreTempScore = score
		self.changScoreInitScore = 0
		self.changeScoreCurrentTime  = 0
		self:SetBisonMul(mul)
		self:SetBisonScore(score)
		self:PlayBisonSpecialDeclareAnimation(3)	
		AudioManager.GetInstance():PlayNormalAudio(59)
	else
	 	self:PlayBisonSpecialDeclareAnimation(6)
		self.OtherSpecialDeclare_Bison = GameObjectPoolManager.GetInstance():GetGameObject(self.OtherBison_SpecialDeclare_Res,GameObjectPoolManager.PoolType.SpecialDeclarePool)
		local trans = self.OtherSpecialDeclare_Bison.transform
		trans.position = self.SkillVo.PlayerIns.SwrilPanel.position
		trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
		trans.transform.localScale = CSScript.Vector3.one

		self.OtherBison_MulText = trans:Find("Root/Logo/TextRoot/Text"):GetComponent(typeof(self.SEM.Text))
		self.OtherBison_ScoreText = trans:Find("Root/RewardROOT/Reward"):GetComponent(typeof(self.SEM.Text))
		self.OtherBison_SpecialDeclare_Animator =  trans:Find("Root"):GetComponent(typeof(self.SEM.Animator))
		self.OtherBison_MulText.text = tostring(mul)
		self.OtherBison_ScoreText.text = tostring(score)
		self:PlayOtherBisonSpecialDeclareAnimation("Bison_OtherInto",0,0)
	end
end

function BisonSkillItem:DestroyBison(  )
	self.isPlayingAnim=false
	self.isCanDestory=true
	if self.callBack then
		self.callBack()
	end
end

function BisonSkillItem:Update()
	if self.isPlayingAnim then
		if self.curSkillStats ==self.BisonSkillStats.Born or self.curSkillStats == self.BisonSkillStats.Idle then
			self.currentTime = self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.IdleTotalTime then
				self.currentTime=0
			end
		elseif self.curSkillStats == self.BisonSkillStats.Shoot then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			self:ChangeBisonMul()
			if self.currentTime>=self.ShootTotalTime then
				self.currentTime=0
				AudioManager.GetInstance():StopNormalAudio(60)
			end
		elseif self.curSkillStats == self.BisonSkillStats.End then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			self:ChangeBisonScore()
			if self.currentTime>=self.EndTotalTime then
				self.curSkillStats = self.BisonSkillStats.Destroy
				self.currentTime=0
				if self.SkillVo.IsMe then
					self:PlayBisonSpecialDeclareAnimation(5)
				else
					self:PlayOtherBisonSpecialDeclareAnimation("Bison_end",0,0)
				end
			end
		elseif self.curSkillStats == self.BisonSkillStats.Destroy then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.DestroyTotalTime then
				self.currentTime=0
				self:DestroyBison()
			end
		end
	end
end

function BisonSkillItem:__delete()
	AudioManager.GetInstance():StopNormalAudio(60)

	if 	self.bisonSequence ~= nil then
		self.bisonSequence:Kill()
		self.bisonSequence = nil
	end

	if self.SpecialDeclare_Bison then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.SpecialDeclare_Bison,GameObjectPoolManager.PoolType.EffectPool)
		self.SpecialDeclare_Bison = nil
	end

	if self.Skill_Bison then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Skill_Bison,GameObjectPoolManager.PoolType.EffectPool)
		self.Skill_Bison = nil
	end
	
	if self.BisonCutIn then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.BisonCutIn,GameObjectPoolManager.PoolType.EffectPool)
		self.BisonCutIn = nil
	end

	if self.OtherSpecialDeclare_Bison then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.OtherSpecialDeclare_Bison,GameObjectPoolManager.PoolType.EffectPool)
		self.OtherSpecialDeclare_Bison = nil
	end
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.callBack=nil
end

