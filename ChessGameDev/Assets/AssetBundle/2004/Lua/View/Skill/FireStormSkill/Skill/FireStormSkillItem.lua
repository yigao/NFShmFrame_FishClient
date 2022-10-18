FireStormSkillItem=Class()

function FireStormSkillItem:ctor()
	self:Init()
end


function FireStormSkillItem:Init ()
	self:InitData()
	self:InitView()
	self:InitViewData()
end


function FireStormSkillItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.FireStormSkillStats ={
		Born = 1,
		Idle = 2,
		Shoot = 3,
		End = 4,
		Destroy = 5,
	}
	self.Skill_FireStorm_Res = "Skill_FireStorm"
	self.FireStorm_SpecialDeclare_Res = "SpecialDeclare_FireStorm"
	self.FireStormYouWin_Res = "FireStormYouWin"

	self.isPlayingAnim=false
	self.curSkillStats = self.FireStormSkillStats.Born
	self.beginPos = CSScript.Vector3.zero
	self.targetPos = CSScript.Vector3.zero
	self.isCanDestory=false
	self.currentTime=0
	self.ShootTotalTime= 30
	self.IdleTotalTime = 7.4
	self.EndTotalTime = 2.5
	self.DestroyTotalTime = 0.5

	self.changeScoreCurrentTime = 0
	self.changeScoreTempScore = 0
	self.changeScoreTotalTime = 0.5
	self.changScoreInitScore = 0
	self.IsChangeScore = false 
	
	
	self.changeMultipleTempMul  = 0
	self.changMultipleInitMul = 0

	self.isEndWarning = false

	self.fireStormScoreTable = nil
	self.fireStormMultipleTable = nil

	self.delayHideSpecialDeclare = nil

	self.audioSequence1 = nil
	self.audioSequence2 = nil
	self.moveToGunSequence = nil
end

function FireStormSkillItem:InitView()
	self:FindView()
end

function FireStormSkillItem:FindView()
	self.SEM=FireStormSkillManager.GetInstance()
	self.SkillGunParent = nil
	self.SkillPanelParent = nil

	self.Skill_FireStorm = nil
	self.FireStormObject = nil
	self.FireStormInfo = nil
	self.Sec_F = nil
	self.Sec_B = nil
	self.Mul_F = nil
	self.Score_T = nil

	self.FireStorm_SpecialDeclare = nil
	self.FireStormYouWin = nil
	self.FireStormYouWinAnimator = nil
	self.FS_Board_Score_Animator = nil
	self.FS_Board_Multiplier_Animator = nil
end

function FireStormSkillItem:InitViewData()
	
end

function FireStormSkillItem:ResetSkillVo(vo)
	self.SkillVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
end


function FireStormSkillItem:ResetSkillState(skillStatus,skillTime,skillScore,skillMul,callBack)
	self.isCanDestory=false
	
	self.SkillGunParent = self.SkillVo.PlayerIns.Panel.SkillGun
	self.SkillPanelParent = self.SkillVo.PlayerIns.Panel.SKillPanel
	if self.SkillVo.IsMe then
		self.SkillVo.PlayerIns:ResetBulletRate()
		self.SkillVo.PlayerIns:UploadShootBulletRateLevel(1)
	end
	self.SkillVo.PlayerIns:SetCanShootBullet(false)
	self.beginPos =GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.EffectPool).transform.position
	
	self.targetPos = self.SkillPanelParent.position
	self.callBack=callBack

	self.changeScoreCurrentTime = 0
	self.changeScoreTempScore = 0
	self.changScoreInitScore = skillScore

	self.changeMultipleTempMul  = 0
	self.changMultipleInitMul = skillMul

	self.fireStormScoreTable = {}
	self.fireStormMultipleTable = {}

	self.IsChangeScore = false 

	self.isEndWarning = true

	self:ChangePlayerSpeedBtn(false)

	self:GetCurrentFireStormStep(skillStatus,skillTime)

	self:ShowFireStormSkill()

	self.isPlayingAnim=true
end

function FireStormSkillItem:ChangePlayerSpeedBtn(isDisPlay)
	if self.SkillVo.IsMe then
		GameSetManager.GetInstance().PlayerSetPanel:SetSpeedBtnDisable(isDisPlay)
		GameSetManager.GetInstance().PlayerSetPanel:ResetSpeedState(false)
	end
end


function FireStormSkillItem:GetCurrentFireStormStep(skillStatus,skillTime)
	if skillStatus == 1 then
		if skillTime <= 0.05 then
			self.curSkillStats = self.FireStormSkillStats.Born
		else
			self.curSkillStats = self.FireStormSkillStats.Idle
		end
	elseif skillStatus == 2 then
		self.curSkillStats = self.FireStormSkillStats.Shoot
	end
	self.currentTime = skillTime * 0.001
end

function FireStormSkillItem:ShowFireStormSkill()

	if self.curSkillStats == self.FireStormSkillStats.Born then
		self:GetFireStormResItem(self.beginPos)
		self:PlayFirestormAudioBorn()
		self:MoveFireStormItemToGun()
	elseif self.curSkillStats == self.FireStormSkillStats.Idle then
		self:GetFireStormResItem(self.targetPos)
		self:ShowGunFireStorm()
		CommonHelper.SetActive(self.FireStormInfo,true)
		CommonHelper.SetActive(self.FireStormObject,false) 
		self:SetFireStormInfo(self.changScoreInitScore,self.changMultipleInitMul)
		self:BeginShootCountdown(0)
	elseif self.curSkillStats == self.FireStormSkillStats.Shoot then
		self:GetFireStormResItem(self.targetPos)
		self:ShowGunFireStorm()
		CommonHelper.SetActive(self.FireStormInfo,true)
		CommonHelper.SetActive(self.FireStormObject,false)
		self:SetFireStormInfo(self.changScoreInitScore,self.changMultipleInitMul)
		self:BeginShootCountdown(self.currentTime)
		self:BeginFireStormShoot(self.currentTime)
	end
end

function FireStormSkillItem:PlayFirestormAudioBorn(  )
	if self.SkillVo.IsMe then
		if self.audioSequence1 then
			self.audioSequence1:Kill()
			self.audioSequence1 = nil
		end
		self.audioSequence1 = self.SEM.DOTween.Sequence()

		local playLieAudioCallBack = function (  )
			AudioManager.GetInstance():PlayNormalAudio(51)
		end

		local playYanAudioCallBack = function (  )
			AudioManager.GetInstance():PlayNormalAudio(51)
		end

		local playFengAudioCallBack = function (  )
			AudioManager.GetInstance():PlayNormalAudio(51)
		end

		local playBaoAudioCallBack = function (  )
			AudioManager.GetInstance():PlayNormalAudio(51)
		end

		local playFontEndAudioCallBack = function (  )
			AudioManager.GetInstance():PlayNormalAudio(52)
		end

		self.audioSequence1:InsertCallback(0.6,playLieAudioCallBack)
		self.audioSequence1:InsertCallback(1.2,playYanAudioCallBack)
		self.audioSequence1:InsertCallback(1.8,playFengAudioCallBack)
		self.audioSequence1:InsertCallback(2.4,playBaoAudioCallBack)
		self.audioSequence1:InsertCallback(2.8,playFontEndAudioCallBack)
	end
end

function FireStormSkillItem:GetFireStormResItem(pos)
	self.Skill_FireStorm  = GameObjectPoolManager.GetInstance():GetGameObject(self.Skill_FireStorm_Res,GameObjectPoolManager.PoolType.EffectPool)
	local trans=self.Skill_FireStorm.transform
	trans:SetParent(self.SkillPanelParent)
	trans.position = pos
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one
	self.FireStormObject = trans:Find("FireStormObject").gameObject
	self.FireStormInfo =  trans:Find("FireStormInfo").gameObject
	self.Mul_F = trans:Find("FireStormInfo/Multiple/Text2/Text_F"):GetComponent(typeof(self.SEM.Text))
	self.FS_Board_Multiplier_Animator = trans:Find("FireStormInfo/Multiple/Text2"):GetComponent(typeof(self.SEM.Animator))
	self.Sec_F = trans:Find("FireStormInfo/Sec/Text2/Text_F"):GetComponent(typeof(self.SEM.Text))
	self.Sec_B = trans:Find("FireStormInfo/Sec/Text2/Text _B"):GetComponent(typeof(self.SEM.Text))
	self.Score_T = trans:Find("FireStormInfo/Score/Text"):GetComponent(typeof(self.SEM.Text))
	self.FS_Board_Score_Animator = trans:Find("FireStormInfo/Score"):GetComponent(typeof(self.SEM.Animator))
	CommonHelper.SetActive(self.FireStormInfo,false)
	CommonHelper.SetActive(self.FireStormObject,true)
end


function FireStormSkillItem:MoveFireStormItemToGun(  )
	local trans  = self.Skill_FireStorm.transform

	if self.moveToGunSequence then
		self.moveToGunSequence:Kill()
		self.moveToGunSequence = nil
	end

	self.moveToGunSequence = self.SEM.DOTween.Sequence()

	local tweener1 = trans:DOMove(self.targetPos, 0.5)
	tweener1:SetEase(self.SEM.Ease.Linear)

	local showGunFireStormCallBack=function()
		CommonHelper.SetActive(self.FireStormObject,false) 
		self:ShowFireStormSpecialDeclare()
		self:ShowGunFireStorm()
	end

	self.moveToGunSequence:Insert(4,tweener1)
	self.moveToGunSequence:InsertCallback(4.5,showGunFireStormCallBack)
end


function FireStormSkillItem:ShowGunFireStorm(  )
	self.SkillVo.PlayerIns:SetMuzzleEulerAngles(0/self.SkillVo.PlayerIns.PrecisionValue)
	self.SkillVo.PlayerIns:EnterFreeScoreState()
	self:PlayGunFireStormAnim("FireStormGun_Idle")
end

function FireStormSkillItem:BeginFireStormShoot(timeElapse)
	self.currentTime = timeElapse
	self.curSkillStats = self.FireStormSkillStats.Shoot
	self.SkillVo.PlayerIns:SetCanShootBullet(true)
end

function FireStormSkillItem:PlayGunFireStormAnim(animationName)
	local curUseRealGunLevel = self.SkillVo.PlayerIns.currentUseRealGunLevel
	self.SkillVo.PlayerIns.Panel:PlayGunShotAnim01(curUseRealGunLevel,animationName)
end


function FireStormSkillItem:ShowFireStormSpecialDeclare(  )
	if self.SkillVo.IsMe then
		self.FireStorm_SpecialDeclare = GameObjectPoolManager.GetInstance():GetGameObject(self.FireStorm_SpecialDeclare_Res,GameObjectPoolManager.PoolType.SpecialDeclarePool)
		local trans = self.FireStorm_SpecialDeclare.transform
		trans.localPosition = CSScript.Vector3.zero
		trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
		trans.transform.localScale = CSScript.Vector3.one
		self:PlayReadGoAudio()
	end
	self.delayHideSpecialDeclare=TimerManager.GetInstance():CreateTimerInstance(3,self.HideFireStormSpecialDeclare,self)
end

function FireStormSkillItem:PlayReadGoAudio(  )
	if self.SkillVo.IsMe then
		self.audioSequence2 = self.SEM.DOTween.Sequence()

		local playReadyCallBack = function (  )
			AudioManager.GetInstance():PlayNormalAudio(54)
		end

		local playGoAudioCallBack = function (  )
			AudioManager.GetInstance():PlayNormalAudio(53)
		end

		self.audioSequence2:InsertCallback(1,playReadyCallBack)
		self.audioSequence2:InsertCallback(1.8,playGoAudioCallBack)
	end
end

function FireStormSkillItem:HideFireStormSpecialDeclare(  )
	if self.SkillVo.IsMe then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.FireStorm_SpecialDeclare,GameObjectPoolManager.PoolType.SpecialDeclarePool)
		TimerManager.GetInstance():RecycleTimerIns(self.delayHideSpecialDeclare)
	end
	CommonHelper.SetActive(self.FireStormInfo,true)
	CommonHelper.SetActive(self.FireStormObject,false)
	self:SetFireStormInfo(self.changScoreInitScore,self.changMultipleInitMul)
	self:BeginShootCountdown(0)
	self.FireStorm_SpecialDeclare = nil
	self.delayHideSpecialDeclare = nil
end


function FireStormSkillItem:EndFireStorm(score)
	
	CommonHelper.SetActive(self.Skill_FireStorm,false)
	self.FireStormYouWin = GameObjectPoolManager.GetInstance():GetGameObject(self.FireStormYouWin_Res,GameObjectPoolManager.PoolType.SpecialDeclarePool)
	local trans =  self.FireStormYouWin.transform
	trans.position = self.SkillVo.PlayerIns.SpecialDeclarePanel.position  --CSScript.Vector3.zero
	trans.localRotation = CSScript.Quaternion.Euler(0,0,0)
	trans.localScale = CSScript.Vector3.one
	self.SkillVo.PlayerIns:LeaveFreeScoreState()
	if not self.SkillVo.IsMe then
		self.SkillVo.PlayerIns:IsShowBetPanel(false)
	end
	self:ChangePlayerSpeedBtn(true)
	self.FireStormYouWinAnimator = self.FireStormYouWin:GetComponent(typeof(self.SEM.Animator))
	self.FireStormYouWinAnimator:Play("FireStormYouWin_start",0,0)
	local scoreText = trans:Find("ScoreTextROOT/ScoreText"):GetComponent(typeof(self.SEM.Text))
	scoreText.text = tostring(score)
	self.curSkillStats = self.FireStormSkillStats.End
	self.currentTime=0
	if self.SkillVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(56)
		AudioManager.GetInstance():PlayNormalAudio(37)
		AudioManager.GetInstance():PlayNormalAudio(57)
	end
end

function FireStormSkillItem:DestroyFireStorm(  )
	self.isCanDestory=true
	if self.callBack then
		self.callBack()
	end
end

function FireStormSkillItem:BeginShootCountdown(timeElapse)
	local time =self.ShootTotalTime - timeElapse
	if time <=0 then
		time = 0
	end
	local t1,t2 = math.modf(time )
	if t1 < 10 then
		if self.isEndWarning == true then
			self.isEndWarning = false
			if self.SkillVo.IsMe then
				AudioManager.GetInstance():PlayNormalAudio(56,1,true)
			end
		end
		self.Sec_F.text = "0"..tostring(t1)
	else
		self.Sec_F.text = tostring(t1)
	end
	
	t2 = math.floor(t2 * 100)
	if t2 < 10 then
		self.Sec_B.text = ".0"..tostring(t2)
	else
		self.Sec_B.text = "."..tostring(t2)
	end
end


function FireStormSkillItem:SetFireStormInfo(score,multiple)
	self.Score_T.text = tostring(score)
	self.Mul_F.text = "x"..tostring(multiple)
end

function FireStormSkillItem:RefreshFireStormInfo(score,mul)
	self.IsChangeScore = true
	self.changeScoreTempScore = score
	self.changeMultipleTempMul = mul

	if self.fireStormScoreTable == nil then
		self.fireStormScoreTable = {}
	end
	if self.fireStormMultipleTable == nil then
		self.fireStormMultipleTable = {}
	end
	table.insert(self.fireStormScoreTable,score)
	table.insert(self.fireStormMultipleTable,mul)
	self.FS_Board_Score_Animator:Play("FireStorm_Board_Score",0,0)
	self.FS_Board_Multiplier_Animator:Play("FireStorm_Board_Score",0,0)
end

function FireStormSkillItem:UpdateFireStormInfo()
	if self.IsChangeScore == false  then return end

	if self.fireStormScoreTable and next(self.fireStormScoreTable) then
		self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
		if self.changeScoreCurrentTime <= self.changeScoreTotalTime then
			local scoreResult=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.changeScoreCurrentTime/self.changeScoreTotalTime))
			local multipleResult=self.changMultipleInitMul + math.ceil(self.changeMultipleTempMul*(self.changeScoreCurrentTime/self.changeScoreTotalTime))
			self:SetFireStormInfo(scoreResult,multipleResult)
		else
			table.remove(self.fireStormScoreTable,1)
			table.remove(self.fireStormMultipleTable,1)
			self.changeScoreCurrentTime = 0
			self.changScoreInitScore = self.changScoreInitScore + self.changeScoreTempScore
			self.changMultipleInitMul = self.changMultipleInitMul + self.changeMultipleTempMul
			self:SetFireStormInfo(self.changScoreInitScore,self.changMultipleInitMul)
			self.FS_Board_Score_Animator:Play("FireStorm_Board_Score",0,0)
			self.FS_Board_Multiplier_Animator:Play("FireStorm_Board_Score",0,0)
			if self.fireStormScoreTable and next(self.fireStormScoreTable) then
				self.changeScoreTempScore = self.fireStormScoreTable[1] 
				self.changeMultipleTempMul =self.fireStormMultipleTable[1]
			end
		end
	else
		self.IsChangeScore = false	
	end
end

function FireStormSkillItem:Update()
	if self.isPlayingAnim then
		if self.curSkillStats ==self.FireStormSkillStats.Born or self.curSkillStats == self.FireStormSkillStats.Idle then
			self.currentTime = self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.IdleTotalTime then
				self.currentTime=0
			end
		elseif self.curSkillStats == self.FireStormSkillStats.Shoot then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			self:BeginShootCountdown(self.currentTime)
			self:UpdateFireStormInfo()
			if self.currentTime>=self.ShootTotalTime then
				self.currentTime=0
			end
		elseif self.curSkillStats == self.FireStormSkillStats.End then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.EndTotalTime then
				self.currentTime=0
				self.curSkillStats = self.FireStormSkillStats.Destroy
				self.FireStormYouWinAnimator:Play("FireStormYouWin_end",0,0)
			end
		elseif self.curSkillStats == self.FireStormSkillStats.Destroy then
			self.currentTime=self.currentTime+CSScript.Time.deltaTime
			if self.currentTime>=self.DestroyTotalTime then
				self.currentTime=0
				self.isPlayingAnim=false
				self:DestroyFireStorm()
			end
		end
	end
end

function FireStormSkillItem:__delete()
	if self.audioSequence1 then
		self.audioSequence1:Kill()
		self.audioSequence1 = nil
	end

	if self.audioSequence2 then
		self.audioSequence2:Kill()
		self.audioSequence2 = nil
	end

	if self.moveToGunSequence then
		self.moveToGunSequence:Kill()
		self.moveToGunSequence = nil
	end

	if self.FireStormYouWin then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.FireStormYouWin,GameObjectPoolManager.PoolType.SpecialDeclarePool)
	end
	self.FireStormYouWin = nil

	if self.Skill_FireStorm then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.Skill_FireStorm,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.Skill_FireStorm = nil

	if self.FireStorm_SpecialDeclare then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.FireStorm_SpecialDeclare,GameObjectPoolManager.PoolType.SpecialDeclarePool)
	end
	self.FireStorm_SpecialDeclare = nil

	self.isCanDestory=false
	self.isPlayingAnim=false
	self.callBack=nil
	self.FireStormYouWin = nil
	self.destroyFireStorm = nil
end

