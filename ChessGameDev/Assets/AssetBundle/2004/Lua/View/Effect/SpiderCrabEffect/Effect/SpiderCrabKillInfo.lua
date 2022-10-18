SpiderCrabKillInfo=Class()

function SpiderCrabKillInfo:ctor(obj)
	self.gameObject = obj
	self.transform = obj.transform
	self:Init(obj)
	
end


function SpiderCrabKillInfo:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function SpiderCrabKillInfo:InitData()
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
end


function SpiderCrabKillInfo:InitView(gameObj)
	self:FindView()
	
end

function SpiderCrabKillInfo:FindView()
	self.SEM=SpecialDeclareEffectManager.GetInstance()
	self.Anim = self.transform:Find("Object"):GetComponent(typeof(self.SEM.Animator)) 
	self.scoreText = self.transform:Find("Object/Foreground/num"):GetComponent(typeof(self.SEM.Text)) 
end

function SpiderCrabKillInfo:InitViewData()
	

end

function SpiderCrabKillInfo:SetShowScoreText(score)
	self.scoreText.text= score
end


function SpiderCrabKillInfo:PlayAnim(type,index)
	local animationName = nil
	if self.EffectVo.IsMe then
		animationName = self.myAnimParms[type][index]
	else
		animationName = self.otherAnimParms[type][index]
	end
	self.Anim:Play(animationName,0,0)
	--AudioManager.GetInstance():PlayNormalAudio(self.EffectVo.BigAwardTipsEffectConfig.specialDeclareShowAudio)
end


function SpiderCrabKillInfo:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isChangeScore = false
end


function SpiderCrabKillInfo:ResetState(targetPos,callBack)
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

function SpiderCrabKillInfo:BeginSpecialDeclareStep()
	if self.EffectVo.IsMe then
		self:MySelfOneStepSpecialDeclare()
	else
		self:OtherOneStepSpecialDeclare()
	end
end

function SpiderCrabKillInfo:MySelfOneStepSpecialDeclare()
	local sequence =self.SEM.DOTween.Sequence()
	local moveDuration = 0.4
	local oneStepDuration =1.45

	local tweener1 =self.transform:DOLocalMove(CSScript.Vector3(0,0,0),moveDuration)

	local oneStepOver = function()
		self:MySelfTwoStepSpecialDeclare()
	end
	sequence:Insert(0,tweener1)
	sequence:InsertCallback(oneStepDuration,oneStepOver)
	self:PlayAnim(self.EffectVo.AnimType,1)
end

function SpiderCrabKillInfo:MySelfTwoStepSpecialDeclare()
	local sequence =self.SEM.DOTween.Sequence()
	local moveDuration = 0.25
	local twoStepDuration = 0.32
	local tween1=self.transform:DOMove(self.targetPos,moveDuration)

	local twoStepOver = function()
		self:PlayAnim(self.EffectVo.AnimType,3)
	end
	sequence:Insert(0,tween1)
	sequence:InsertCallback(twoStepDuration,twoStepOver)
	self:PlayAnim(self.EffectVo.AnimType,2)
end


function SpiderCrabKillInfo:OtherOneStepSpecialDeclare(  )
	local sequence =self.SEM.DOTween.Sequence()
	local moveDuration = 0.4
	local oneStepDuration =1.45

	local tweener1 =self.transform:DOMove(self.targetPos,moveDuration)

	local oneStepOver = function()
		self:PlayAnim(self.EffectVo.AnimType,3)
	end
	sequence:Insert(0,tweener1)
	sequence:InsertCallback(oneStepDuration,oneStepOver)
	self:PlayAnim(self.EffectVo.AnimType,1)
end

function SpiderCrabKillInfo:ComFourStepSpecialDeclare()
	local fourStepDuration =0.35
	local sequence =self.SEM.DOTween.Sequence()
	local comFourStepOver = function()
		self:ComFiveStepSpecialDeclare()
	end
	sequence:InsertCallback(fourStepDuration,comFourStepOver)
	self:PlayAnim(self.EffectVo.AnimType,4)
end

function SpiderCrabKillInfo:ComFiveStepSpecialDeclare()
	self.IsChangeScore = true	
	self.changeScoreCurrentTime = 0
	self:PlayAnim(self.EffectVo.AnimType,5)
end


function SpiderCrabKillInfo:BeginShowScore()
	self:SetChangeScore()
	self:ComFourStepSpecialDeclare()
end

function SpiderCrabKillInfo:SetChangeScore()
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


function SpiderCrabKillInfo:ChangeScore()

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
				self:ChangeScoreEnd()
			end
		end
	end
end

function SpiderCrabKillInfo:ChangeScoreEnd()
	local sequence =self.SEM.DOTween.Sequence()
	self.scoreText.transform.localScale = CSScript.Vector3(1.5,1.5,1)
	local tween1 = self.scoreText.transform:DOScale(CSScript.Vector3(0.8,0.8,1),0.3)

	local changeScoreWaitCallBack = function()
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
		sequence:Insert(0,tween1)
		sequence:InsertCallback(0.7,changeScoreWaitCallBack)
	elseif self.curScoreStep == self.ScoreStep.ThreeStep then
		self.changeScoreTempScore = self.EffectVo.Score - self.changScoreInitScore
		sequence:Insert(0,tween1)
		sequence:InsertCallback(0.7,changeScoreWaitCallBack)
	elseif self.curScoreStep == self.ScoreStep.End then
		local tween2 = self.gameObject.transform:DOScale(CSScript.Vector3.zero,0.3)
		sequence:Insert(0,tween1)
		sequence:Insert(1.7,tween2)
		sequence:InsertCallback(2,destroyCallBack)
	end
end


function SpiderCrabKillInfo:Update()
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

function SpiderCrabKillInfo:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end

function SpiderCrabKillInfo:__delete()
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

