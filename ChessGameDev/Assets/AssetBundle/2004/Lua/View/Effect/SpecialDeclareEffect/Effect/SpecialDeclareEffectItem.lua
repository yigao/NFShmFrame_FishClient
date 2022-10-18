SpecialDeclareEffectItem=Class()

function SpecialDeclareEffectItem:ctor(obj)
	self.gameObject = obj
	self.transform = obj.transform
	self:Init(obj)
	
end


function SpecialDeclareEffectItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function SpecialDeclareEffectItem:InitData()
	self.ScoreStep = {
		OneStep = 1,
		TwoStep = 2,
		ThreeStep = 3,
		End = 4,
	}

	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	
	self.myAnimParms= {[1] ={"My_OneStep_01","My_TwoStep_01","My_ThreeStep_01","My_FourStep_01","My_FiveStep_01"},
					   [2] ={"My_OneStep_02","My_TwoStep_02","My_ThreeStep_02","My_FourStep_02","My_FiveStep_02"}}
	self.otherAnimParms= {[1] ={"Other_OneStep_01","My_ThreeStep_01","My_ThreeStep_01","My_FourStep_01","My_FiveStep_01"},
						  [2] ={"Other_OneStep_02","My_ThreeStep_02","My_ThreeStep_02","My_FourStep_02","My_FiveStep_02"},}

	self.targetChangeScoreStep = self.ScoreStep.OneStep
	self.curScoreStep = self.ScoreStep.TwoStep
	self.changeScoreCurrentTime = 0
	self.changeScoreTotalTime = 1
	self.changScoreInitScore = 0
	self.changeScoreTempScore = 0

	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.isChangeScore = false
	
	self.targetPos = CSScript.Vector3.zero
	self.beginPos = CSScript.Vector3.zero

	self.mySequence01 = nil
	self.mySequence02 = nil
	self.otherSequence01 = nil
	self.comSequence01= nil
	self.changeScoreSequence = nil
end


function SpecialDeclareEffectItem:InitView(gameObj)
	self:FindView()
	
end

function SpecialDeclareEffectItem:FindView()
	self.SEM=SpecialDeclareEffectManager.GetInstance()
	self.Anim = self.transform:Find("Object"):GetComponent(typeof(self.SEM.Animator)) 
	self.scoreText = self.transform:Find("Object/Foreground/num"):GetComponent(typeof(self.SEM.Text)) 
end

function SpecialDeclareEffectItem:InitViewData()
	

end

function SpecialDeclareEffectItem:SetShowScoreText(score)
	self.scoreText.text= score
end


function SpecialDeclareEffectItem:PlayAnim(type,index)
	local animationName = nil
	if self.EffectVo.IsMe then
		animationName = self.myAnimParms[type][index]
	else
		animationName = self.otherAnimParms[type][index]
	end
	self.Anim:Play(animationName,0,0)
end


function SpecialDeclareEffectItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isChangeScore = false
end


function SpecialDeclareEffectItem:ResetState(targetPos,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.targetPos = targetPos
	
	if self.EffectVo.IsMe then
		self.transform.localPosition = CSScript.Vector3(1200,0,0)
	else
		self.transform.position = self.targetPos --CSScript.Vector3(0,self.targetPos.y,self.targetPos.z)
	end
	self.gameObject.transform.localScale = CSScript.Vector3.one
	self.currentTime=0
	self.delayTime= 0

	self.callBack=callBack


	self.IsDelayPlay=true

	self.isChangeScore = false
	self.changeScoreCurrentTime = 0

	self.targetChangeScoreStep = self.ScoreStep.OneStep
	self.curScoreStep = self.ScoreStep.TwoStep

end

function SpecialDeclareEffectItem:BeginSpecialDeclareStep()
	if self.EffectVo.IsMe then
		self:MySelfOneStepSpecialDeclare()
	else
		self:OtherOneStepSpecialDeclare()
	end
end

function SpecialDeclareEffectItem:MySelfOneStepSpecialDeclare()
	if self.mySequence01 then
		self.mySequence01:Kill()
		self.mySequence01 = nil
	end
	self.mySequence01 =self.SEM.DOTween.Sequence()
	local moveDuration = 0.4
	local oneStepDuration =1.45

	local tweener1 =self.transform:DOLocalMove(CSScript.Vector3(0,0,0),moveDuration)

	local oneStepOver = function()
		self:MySelfTwoStepSpecialDeclare()
	end
	self.mySequence01:Insert(0,tweener1)
	self.mySequence01:InsertCallback(oneStepDuration,oneStepOver)
	self:PlayAnim(self.EffectVo.AnimType,1)
end

function SpecialDeclareEffectItem:MySelfTwoStepSpecialDeclare()
	if self.mySequence02 then
		self.mySequence02:Kill()
		self.mySequence02 = nil
	end
	self.mySequence02 =self.SEM.DOTween.Sequence()
	local moveDuration = 0.25
	local twoStepDuration = 0.32
	local tween1=self.transform:DOMove(self.targetPos,moveDuration)

	local twoStepOver = function()
		self:PlayAnim(self.EffectVo.AnimType,3)
	end
	self.mySequence02:Insert(0,tween1)
	self.mySequence02:InsertCallback(twoStepDuration,twoStepOver)
	self:PlayAnim(self.EffectVo.AnimType,2)
end


function SpecialDeclareEffectItem:OtherOneStepSpecialDeclare(  )
	if self.otherSequence01 then
		self.otherSequence01:Kill()
		self.otherSequence01 = nil
	end
	self.otherSequence01 =self.SEM.DOTween.Sequence()
	local moveDuration = 0.4
	local oneStepDuration =1.45

	local tweener1 =self.transform:DOMove(self.targetPos,moveDuration)

	local oneStepOver = function()
		self:PlayAnim(self.EffectVo.AnimType,3)
	end
	self.otherSequence01:Insert(0,tweener1)
	self.otherSequence01:InsertCallback(oneStepDuration,oneStepOver)
	self:PlayAnim(self.EffectVo.AnimType,1)
end

function SpecialDeclareEffectItem:ComFourStepSpecialDeclare()
	if self.comSequence01 then
		self.comSequence01:Kill()
		self.comSequence01 = nil
	end
	local fourStepDuration =0.35
	self.comSequence01 =self.SEM.DOTween.Sequence()
	local comFourStepOver = function()
		if self.EffectVo.IsMe then
			AudioManager.GetInstance():PlayNormalAudio(28)
		end
		self:ComFiveStepSpecialDeclare()
	end
	self.comSequence01:InsertCallback(fourStepDuration,comFourStepOver)
	self:PlayAnim(self.EffectVo.AnimType,4)
end

function SpecialDeclareEffectItem:ComFiveStepSpecialDeclare()
	self.IsChangeScore = true	
	self.changeScoreCurrentTime = 0
	self:PlayAnim(self.EffectVo.AnimType,5)
end


function SpecialDeclareEffectItem:BeginShowScore()
	self:SetChangeScore()
	self:ComFourStepSpecialDeclare()
end

function SpecialDeclareEffectItem:SetChangeScore()
	self.changeScoreCurrentTime = 0
	self.changScoreInitScore = 0
	self.IsChangeScore = false
	self.curScoreStep = self.ScoreStep.OneStep
	self.changScoreInitScore = 0
	self.changeScoreTempScore = 0
	if self.EffectVo.Multiple >= 100 then
		self.targetChangeScoreStep = self.ScoreStep.ThreeStep
		self.changeScoreTempScore = math.ceil(self.EffectVo.Score * self.SEM.Random.Range(0.3,0.5))
	else
		self.targetChangeScoreStep = self.ScoreStep.TwoStep
		self.changeScoreTempScore = math.ceil(self.EffectVo.Score * self.SEM.Random.Range(0.4,0.6))
	end
	self:SetShowScoreText(0)

end


function SpecialDeclareEffectItem:ChangeScore()
	if self.IsChangeScore then
		if self.curScoreStep == self.ScoreStep.OneStep then
			self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
			if self.changeScoreCurrentTime <= (self.changeScoreTotalTime-0.2) then
				local result=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.changeScoreCurrentTime/self.changeScoreTotalTime))
				self:SetShowScoreText(result)
			else
				self.IsChangeScore = false
				self.changeScoreCurrentTime = 0
				self.curScoreStep = self.ScoreStep.TwoStep
				self.changScoreInitScore = self.changeScoreTempScore
				self:SetShowScoreText(self.changeScoreTempScore)
				if self.EffectVo.IsMe then
					AudioManager.GetInstance():StopNormalAudio(28)
					AudioManager.GetInstance():PlayNormalAudio(31)
				end
				self:ChangeScoreEnd()
			end
		elseif self.curScoreStep == self.ScoreStep.TwoStep then
			self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
			if self.changeScoreCurrentTime <= (self.changeScoreTotalTime-0.4) then
				local result=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.changeScoreCurrentTime/self.changeScoreTotalTime))
				self:SetShowScoreText(result)
			else
				self.IsChangeScore = false
				self.changeScoreCurrentTime = 0
				if self.curScoreStep >= self.targetChangeScoreStep then
					self.curScoreStep = self.ScoreStep.End
					self.changScoreInitScore = self.EffectVo.Score
				else
					self.curScoreStep = self.ScoreStep.ThreeStep
					self.changScoreInitScore = self.changScoreInitScore + self.changeScoreTempScore
				end
				self:SetShowScoreText(self.changScoreInitScore)
				if self.EffectVo.IsMe then
					AudioManager.GetInstance():StopNormalAudio(29)
					AudioManager.GetInstance():PlayNormalAudio(32)
				end
				self:ChangeScoreEnd()
			end
		elseif self.curScoreStep == self.ScoreStep.ThreeStep then
			self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
			if self.changeScoreCurrentTime <= (self.changeScoreTotalTime-0.6) then
				local result=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.changeScoreCurrentTime/self.changeScoreTotalTime))
				self:SetShowScoreText(result)
			else
				self.IsChangeScore = false
				self.changeScoreCurrentTime = 0
				self.curScoreStep = self.ScoreStep.End
				self.changScoreInitScore = self.EffectVo.Score
				self:SetShowScoreText(self.EffectVo.Score)
				if self.EffectVo.IsMe then
					AudioManager.GetInstance():StopNormalAudio(30)
					AudioManager.GetInstance():PlayNormalAudio(33)
				end
				self:ChangeScoreEnd()
			end
		end
	end
end

function SpecialDeclareEffectItem:ChangeScoreEnd()
	if self.changeScoreSequence then
		self.changeScoreSequence:Kill()
		self.changeScoreSequence = nil
	end
	self.changeScoreSequence =self.SEM.DOTween.Sequence()
	self.scoreText.transform.localScale = CSScript.Vector3(1.5,1.5,1)
	local tween1 = self.scoreText.transform:DOScale(CSScript.Vector3(0.8,0.8,1),0.3)

	local changeScoreWaitCallBack = function()
		if self.curScoreStep == self.ScoreStep.TwoStep then
			if self.EffectVo.IsMe then
				AudioManager.GetInstance():PlayNormalAudio(29)
			end
		elseif self.curScoreStep == self.ScoreStep.ThreeStep then
			if self.EffectVo.IsMe then
				AudioManager.GetInstance():PlayNormalAudio(30)
			end
		end
		self.IsChangeScore = true
	end

	local destroyCallBack = function()
		self.isPlayingAnim=false
		self:EndCallBack()
		self.isCanDestory=true
	end
	
	if self.curScoreStep == self.ScoreStep.TwoStep then
		if self.targetChangeScoreStep == self.ScoreStep.TwoStep then
			self.changeScoreTempScore = self.EffectVo.Score - self.changScoreInitScore
		elseif self.targetChangeScoreStep == self.ScoreStep.ThreeStep then
			self.changeScoreTempScore =  math.ceil((self.EffectVo.Score - self.changScoreInitScore) * self.SEM.Random.Range(0.4,0.6))
		end
		self.changeScoreSequence:Insert(0,tween1)
		self.changeScoreSequence:InsertCallback(0.7,changeScoreWaitCallBack)
	elseif self.curScoreStep == self.ScoreStep.ThreeStep then
		self.changeScoreTempScore = self.EffectVo.Score - self.changScoreInitScore
		self.changeScoreSequence:Insert(0,tween1)
		self.changeScoreSequence:InsertCallback(0.7,changeScoreWaitCallBack)
	elseif self.curScoreStep == self.ScoreStep.End then
		local tween2 = self.gameObject.transform:DOScale(CSScript.Vector3.zero,0.3)
		self.changeScoreSequence:Insert(0,tween1)
		self.changeScoreSequence:Insert(1.7,tween2)
		self.changeScoreSequence:InsertCallback(2,destroyCallBack)
	end
end


function SpecialDeclareEffectItem:Update()
	if self.IsDelayPlay then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.delayTime then
			self.IsDelayPlay=false
			self.currentTime=0
			self:BeginSpecialDeclareStep()
			self.isPlayingAnim=true
		end
	end

	if self.isPlayingAnim  then
		self:ChangeScore()
	end
end

function SpecialDeclareEffectItem:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end

function SpecialDeclareEffectItem:__delete()
	if self.mySequence01 then
		self.mySequence01:Kill()
		self.mySequence01 = nil
	end

	if self.mySequence02 then
		self.mySequence02:Kill()
		self.mySequence02 = nil
	end

	if self.otherSequence01 then
		self.otherSequence01:Kill()
		self.otherSequence01 = nil
	end

	if self.comSequence01 then
		self.comSequence01:Kill()
		self.comSequence01 = nil
	end

	if self.changeScoreSequence then
		self.changeScoreSequence:Kill()
		self.changeScoreSequence = nil
	end

	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

