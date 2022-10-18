ScoreEffecItem=Class()

function ScoreEffecItem:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end

function ScoreEffecItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end

function ScoreEffecItem:InitData()
	self.ScoreStep = {
		Normal = 1,
		OneStep = 2,
		TwoStep = 3,
		End = 4,
	}

	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.MyAnimParams={"MyScore01","MyScore02","MyScore03"}
	self.OtherAnimParams={"OtherScore02","OtherScore02","OtherScore03"}
	self.beginPos = CSScript.Vector3.zero
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.totalTime=1
	self.currentScoreLabel = nil
	self.IsChangeScore = true	
	self.targetChangeScoreStep = self.ScoreStep.Normal
	self.curScoreStep = self.ScoreStep.Normal
	self.changeScoreCurrentTime = 0
	self.changeScoreTotalTime = 1
	self.changScoreInitScore = 0
	self.changeScoreTempScore = 0
	self.changeScoreDelayTimer = nil
end


function ScoreEffecItem:InitView(gameObj)
	self:FindView()
end

function ScoreEffecItem:FindView()
	local tf=self.gameObject.transform
	local SEM=ScoreEffectManager.GetInstance()

	self.Anim = self.gameObject:GetComponent(typeof(SEM.Animator))

	self.text1 = tf:Find("Content/Text1"):GetComponent(typeof(SEM.Text))
	self.text2 = tf:Find("Content/Text2"):GetComponent(typeof(SEM.Text))
end


function ScoreEffecItem:InitViewData()
	
end

function ScoreEffecItem:SetShowScoreText(score)
	self.currentScoreLabel.text=score
end

function ScoreEffecItem:PlayAnim(index)
	
	if self.EffectVo.IsMe then
		local animationName = self.MyAnimParams[index]
		self.Anim:Play(animationName,0,0)
	else
		local animationName = self.OtherAnimParams[index]
		self.Anim:Play(animationName,0,0)
	end
end

function ScoreEffecItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
end

function ScoreEffecItem:ResetState(beginPos,delayTime,showTime,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
	self.beginPos = beginPos
	if delayTime == nil then
		self.delayTime = 0
	else
		self.delayTime=delayTime
	end
	self.callBack=callBack
	self.totalTime=showTime

	self.currentTime=0
	self.IsDelayPlay=true
	self:SetScoreLabelText()
	self:SetChangeScore()
end

function ScoreEffecItem:SetChangeScore()
	self.changeScoreCurrentTime = 0
	self.changScoreInitScore = 0
	self.targetChangeScoreStep = self.EffectVo.ScoreEffectConfig.scoreEffect 
	if self.EffectVo.ScoreEffectConfig.scoreEffect == 1 then
		self.IsChangeScore = false
		self.changeScoreTempScore = 0
		self.curScoreStep = self.ScoreStep.Normal
		self:SetShowScoreText(self.EffectVo.Score)
	elseif self.EffectVo.ScoreEffectConfig.scoreEffect == 2 then
		self.IsChangeScore = true
		self.changeScoreTempScore = self.EffectVo.Score
		self.curScoreStep = self.ScoreStep.OneStep
		if self.EffectVo.IsMe then
			AudioManager.GetInstance():PlayNormalAudio(28)
		end
	elseif self.EffectVo.ScoreEffectConfig.scoreEffect == 3 then
		self.IsChangeScore = true
		self.changeScoreTempScore = math.ceil(self.EffectVo.Score * CS.UnityEngine.Random.Range(0.4,0.75))
		self.curScoreStep = self.ScoreStep.OneStep
		if self.EffectVo.IsMe then
			AudioManager.GetInstance():PlayNormalAudio(28)
		end
	end
end

function ScoreEffecItem:SetScoreLabelText()
	if self.EffectVo.IsMe then
		self.currentScoreLabel = self.text1
	else
		self.currentScoreLabel = self.text2
	end
end

function ScoreEffecItem:ChangeScore()
	if self.IsChangeScore then
		if self.curScoreStep == self.ScoreStep.OneStep then
			self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
			if self.changeScoreCurrentTime <= self.changeScoreTotalTime then
				local result=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.currentTime/self.totalTime))
				self:SetShowScoreText(result)
			else
				self.IsChangeScore = false
				self.changeScoreCurrentTime = 0
				self.curScoreStep = self.ScoreStep.TwoStep
				self.changScoreInitScore = self.changeScoreTempScore
				self:SetShowScoreText(self.changeScoreTempScore)
				if self.EffectVo.IsMe then
					AudioManager.GetInstance():PlayNormalAudio(31)
				end
				self:ChangeScoreEnd()
			end
		elseif self.curScoreStep == self.ScoreStep.TwoStep then
			self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
			if self.changeScoreCurrentTime <= self.changeScoreTotalTime then
				local result=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.currentTime/self.totalTime))
				self:SetShowScoreText(result)
			else
				self.IsChangeScore = false
				self.changeScoreCurrentTime = 0
				self.curScoreStep = self.ScoreStep.End
				self.changScoreInitScore = self.EffectVo.Score
				self:SetShowScoreText(self.EffectVo.Score)
				if self.EffectVo.IsMe then
					AudioManager.GetInstance():StopNormalAudio(29)
					AudioManager.GetInstance():PlayNormalAudio(32)
				end
				self:ChangeScoreEnd()
			end
		end
	end
end


function ScoreEffecItem:ChangeScoreEnd()
	self:PlayAnim(3)
	if self.curScoreStep > self.targetChangeScoreStep or self.curScoreStep == self.ScoreStep.End then
		return 
	end
	if not self.changeScoreDelayTimer then
		self.changeScoreDelayTimer = TimerManager.GetInstance():CreateTimerInstance(0.5,self.DelayChangeScore,self) 
	end
end


function ScoreEffecItem:DelayChangeScore()
	self.IsChangeScore = true
	if self.EffectVo.IsMe then
		AudioManager.GetInstance():PlayNormalAudio(29)
	end
	self.changeScoreTempScore = self.EffectVo.Score - self.changeScoreTempScore
	TimerManager.GetInstance():RecycleTimerIns(self.changeScoreDelayTimer)
	self.changeScoreDelayTimer = nil
end

function ScoreEffecItem:Update()
	if self.IsDelayPlay then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.delayTime then
			self.IsDelayPlay=false
			self.currentTime=0
			self.gameObject.transform.position=self.beginPos
			if self.targetChangeScoreStep == self.ScoreStep.Normal then
				self:PlayAnim(1)
			elseif self.targetChangeScoreStep == self.ScoreStep.OneStep or self.targetChangeScoreStep == self.ScoreStep.TwoStep then
				self:PlayAnim(2)
			end
			self.isPlayingAnim=true
		end
	end

	if self.isPlayingAnim then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		self:ChangeScore()
		if self.currentTime>=self.totalTime then
			self.currentTime=0
			self.isPlayingAnim=false
			self:EndCallBack()
			self.isCanDestory=true
		end
	end
end

function ScoreEffecItem:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end

function ScoreEffecItem:__delete()
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

