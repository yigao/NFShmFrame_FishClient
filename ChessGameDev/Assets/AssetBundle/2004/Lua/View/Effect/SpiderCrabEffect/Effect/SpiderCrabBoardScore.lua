SpiderCrabBoardScore=Class()

function SpiderCrabBoardScore:ctor(obj)
	self.gameObject = obj
	self.transform = obj.transform
	self:Init(obj)
end

function SpiderCrabBoardScore:Init (gameObj)
	self.ScoreStep = {
		OneStep = 1,
		TwoStep = 2,
		End = 4,
	}
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end

function SpiderCrabBoardScore:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AnimParms1= {"bosskilled_start_chs","bosskilled_NOlove_chs","bosskilled_NOlove_off_chs"}
	self.AnimParms2= {"bosskilled_start_chs","bosskilled_love_chs","bosskilled_love_off_chs"}

	self.targetChangeScoreStep = self.ScoreStep.OneStep
	self.curScoreStep = self.ScoreStep.TwoStep

	self.changeScoreCurrentTime = 0
	self.changeScoreTotalTime = 1.5
	self.changScoreInitScore = 0
	self.changeScoreTempScore = 0

	self.updateItemNum = -1 
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.isChangeScore = false
	
	self.targetPos = CSScript.Vector3.zero
	self.beginPos = CSScript.Vector3.zero
end

function SpiderCrabBoardScore:InitView(gameObj)
	self:FindView()
end

function SpiderCrabBoardScore:FindView()
	self.SEM=SpiderCrabEffectManager.GetInstance()
	self.Anim = self.transform:GetComponent(typeof(self.SEM.Animator)) 
	self.scoreText = self.transform:Find("mainwidow/number"):GetComponent(typeof(self.SEM.Text))
	self.twoMultiple_Sprite_gameObject = self.transform:Find("mainwidow/X2X3/ImageX2").gameObject
	self.threeMultiple_Sprite_gameObject = self.transform:Find("mainwidow/X2X3/ImageX3").gameObject
end

function SpiderCrabBoardScore:InitViewData()

end

function SpiderCrabBoardScore:SetShowScoreText(score)
	self.scoreText.text= score
end

function SpiderCrabBoardScore:PlayAnim(index)
	if self.EffectVo.partMul == 1 then
		local animationName = self.AnimParms1[index]
		self.Anim:Play(animationName,0,0)
	else
		local animationName = self.AnimParms2[index]
		self.Anim:Play(animationName,0,0)
	end
	--AudioManager.GetInstance():PlayNormalAudio(self.EffectVo.BigAwardTipsEffectConfig.specialDeclareShowAudio)
end

function SpiderCrabBoardScore:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isChangeScore = false
end


function SpiderCrabBoardScore:ResetState(targetPos,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.targetPos = targetPos
	
	if self.EffectVo.IsMe then
		self.transform.localPosition = CSScript.Vector3(0,0,0)
		self.gameObject.transform.localScale = CSScript.Vector3.one
	else
		self.transform.position = self.targetPos
		self.gameObject.transform.localScale = CSScript.Vector3(0.75,0.75,0.75)
	end
	
	self.currentTime=0
	self.delayTime= 0

	self.callBack=callBack

	self.IsDelayPlay = true
	self.isChangeScore = false
	self.changeScoreCurrentTime = 0

	if self.EffectVo.partMul == 2 then
		CommonHelper.SetActive(self.twoMultiple_Sprite_gameObject,true)
		CommonHelper.SetActive(self.threeMultiple_Sprite_gameObject,false)
	elseif self.EffectVo.partMul == 3 then
		CommonHelper.SetActive(self.twoMultiple_Sprite_gameObject,false)
		CommonHelper.SetActive(self.threeMultiple_Sprite_gameObject,true)
	end
	
	AudioManager.GetInstance():PlayNormalAudio(64)
	self:SetShowScoreText(0)
	self.updateItemNum = CommonHelper.AddUpdate(self)
end

function SpiderCrabBoardScore:BeginSpiderCrabBossScoreStep()
	self:OneStepCrabBossScore()
end

function SpiderCrabBoardScore:OneStepCrabBossScore()
	local sequence =self.SEM.DOTween.Sequence()
	local duration = 2
	
	local beginSetScoreCallBack = function()
		self:SetChangeScore()
	end
	
	if self.EffectVo.partMul == 1 then
		sequence:InsertCallback(duration,beginSetScoreCallBack)
	else
		local animationCallBack = function (  )
			self:PlayAnim(2)
		end
		sequence:InsertCallback(2,animationCallBack)
		sequence:InsertCallback(4.5,beginSetScoreCallBack)
	end
	self:PlayAnim(1)
end

function SpiderCrabBoardScore:SetChangeScore()
	self.changeScoreCurrentTime = 0
	self.IsChangeScore = true

	if self.EffectVo.partMul == 1 then
		self.changScoreInitScore = 0
		self.changeScoreTempScore = self.EffectVo.totalScore
	else
		self.changScoreInitScore =  self.EffectVo.selfScore
		self.changeScoreTempScore = self.EffectVo.totalScore - self.EffectVo.selfScore
	end
	self:SetShowScoreText(self.changScoreInitScore)
	if self.EffectVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(63)
		AudioManager.GetInstance():PlayNormalAudio(63,0.4,true)
	end
end

function SpiderCrabBoardScore:ChangeScore()
	
	if self.IsChangeScore then
		self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
		if self.changeScoreCurrentTime <= self.changeScoreTotalTime then
			local result=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.changeScoreCurrentTime/self.changeScoreTotalTime))
			self:SetShowScoreText(result)
		else
			self.changeScoreCurrentTime = 0
			self.changScoreInitScore = self.EffectVo.totalScore
			self:SetShowScoreText(self.EffectVo.totalScore)
			self:ChangeScoreEnd()
		end
	end
end

function SpiderCrabBoardScore:ChangeScoreEnd()
	local sequence =self.SEM.DOTween.Sequence()
	self.IsChangeScore = false
	self.isPlayingAnim = false
	CommonHelper.RemoveUpdate(self.updateItemNum)
	local playEndAnimCallBack = function (  )
		self:PlayAnim(3)	
	end
	if self.EffectVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(63)
	end
	local destroyCallBack = function()
		self:EndCallBack()
		self.isCanDestory=true
	end
	sequence:InsertCallback(0.5,playEndAnimCallBack)
	sequence:InsertCallback(1.5,destroyCallBack)
end

function SpiderCrabBoardScore:Update()
	if self.IsDelayPlay then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.delayTime then
			self.IsDelayPlay=false
			self.currentTime=0
			self:BeginSpiderCrabBossScoreStep()
			self.isPlayingAnim=true
		end
	end
	if self.isPlayingAnim then
		self:ChangeScore()
	end
end

function SpiderCrabBoardScore:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end

function SpiderCrabBoardScore:__delete()
	if self.EffectVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(63)
	end
	CommonHelper.RemoveUpdate(self.updateItemNum)
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

