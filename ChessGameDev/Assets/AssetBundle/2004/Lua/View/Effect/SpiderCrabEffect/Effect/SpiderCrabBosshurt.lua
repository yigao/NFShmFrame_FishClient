SpiderCrabBossHurt=Class()

function SpiderCrabBossHurt:ctor(obj)
	self.gameObject = obj
	self.transform = obj.transform
	self:Init(obj)
end

function SpiderCrabBossHurt:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end

function SpiderCrabBossHurt:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AnimParms= {"firstbosshurt_start_chs","firstbosshurt_count_chs","firstbosshurt_off_chs"}
	
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

function SpiderCrabBossHurt:InitView(gameObj)
	self:FindView()
end

function SpiderCrabBossHurt:FindView()
	self.SEM=SpiderCrabEffectManager.GetInstance()
	self.Anim = self.transform:Find("Content"):GetComponent(typeof(self.SEM.Animator)) 
	self.scoreText = self.transform:Find("Content/number"):GetComponent(typeof(self.SEM.Text))
	self.firstKill_Image_gameObject = self.transform:Find("Content/firstkill"):GetComponent(typeof(self.SEM.Image)).gameObject
	self.sencondKill_Image_gameObject = self.transform:Find("Content/secondkill"):GetComponent(typeof(self.SEM.Image)).gameObject
end

function SpiderCrabBossHurt:InitViewData()

end

function SpiderCrabBossHurt:SetShowScoreText(score)
	self.scoreText.text= score
end

function SpiderCrabBossHurt:PlayAnim(index)
	local animationName = self.AnimParms[index]
	self.Anim:Play(animationName,0,0)
	--AudioManager.GetInstance():PlayNormalAudio(self.EffectVo.BigAwardTipsEffectConfig.specialDeclareShowAudio)
end

function SpiderCrabBossHurt:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isChangeScore = false
end


function SpiderCrabBossHurt:ResetState(targetPos,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.targetPos = targetPos
	
	if self.EffectVo.IsMe then
		self.transform.localPosition = CSScript.Vector3(0,0,0)
	else
		self.transform.position = self.targetPos
	end
	self.transform.localScale = CSScript.Vector3.one
	self.currentTime=0
	self.delayTime= 0

	self.callBack=callBack

	self.IsDelayPlay = true
	self.isChangeScore = false
	self.changeScoreCurrentTime = 0

	if self.EffectVo.hurtNum == 1 then
		CommonHelper.SetActive(self.firstKill_Image_gameObject,true)
		CommonHelper.SetActive(self.sencondKill_Image_gameObject,false)
	elseif self.EffectVo.hurtNum == 2 then
		CommonHelper.SetActive(self.firstKill_Image_gameObject,false)
		CommonHelper.SetActive(self.sencondKill_Image_gameObject,true)
	end
	self:SetShowScoreText(0)
	self.updateItemNum = CommonHelper.AddUpdate(self)
end

function SpiderCrabBossHurt:BeginSpiderCrabBosshurtStep()
	if self.EffectVo.IsMe then
		
		self:MySelfOneStepCrabBossHurt()
	else
		self:OtherOneStepCrabBossHurt()
	end
end

function SpiderCrabBossHurt:MySelfOneStepCrabBossHurt()
	local sequence =self.SEM.DOTween.Sequence()
	local duration = 1
	
	local oneStepOver = function()
		self:MySelfTwoStepCrabBossHurt()
	end
	
	sequence:InsertCallback(duration,oneStepOver)
	self:PlayAnim(1)
end

function SpiderCrabBossHurt:MySelfTwoStepCrabBossHurt()
	local sequence =self.SEM.DOTween.Sequence()
	local moveDuration = 0.25
	local twoStepDuration = 0.75
	local tween1=self.transform:DOMove(self.targetPos,moveDuration)
	local tween2=self.transform:DOScale(CSScript.Vector3(0.75,0.75,0.75),moveDuration)
	local beginSetChangeScoreCallBack = function()
		if self.EffectVo.IsMe then
			AudioManager.GetInstance():StopNormalAudio(63)
			AudioManager.GetInstance():PlayNormalAudio(63,0.4,true)
		end
		self:SetChangeScore()
	end
	sequence:Insert(0,tween1)
	sequence:Insert(0,tween2)
	sequence:InsertCallback(twoStepDuration,beginSetChangeScoreCallBack)
	self:PlayAnim(2)
end

function SpiderCrabBossHurt:OtherOneStepCrabBossHurt(  )
	
	local sequence =self.SEM.DOTween.Sequence()
	local duration = 1
	
	local animationCallBack = function (  )
		self:PlayAnim(2)
	end

	local beginSetChangeScoreCallBack = function()
		self:SetChangeScore()
	end
	
	sequence:InsertCallback(duration,animationCallBack)
	sequence:InsertCallback((duration + 0.5),beginSetChangeScoreCallBack)
	self:PlayAnim(1)
end

function SpiderCrabBossHurt:SetChangeScore()
	self.changeScoreCurrentTime = 0
	self.changScoreInitScore = 0
	self.IsChangeScore = true
	self.changScoreInitScore = 0
	self.changeScoreTempScore = self.EffectVo.hurtScore
	
	self:SetShowScoreText(0)
end

function SpiderCrabBossHurt:ChangeScore()
	if self.IsChangeScore then
		self.changeScoreCurrentTime = self.changeScoreCurrentTime + CSScript.Time.deltaTime
		if self.changeScoreCurrentTime <= (self.changeScoreTotalTime-0.2) then
			local result=self.changScoreInitScore + math.ceil(self.changeScoreTempScore*(self.changeScoreCurrentTime/self.changeScoreTotalTime))
			self:SetShowScoreText(result)
		else
			self.changeScoreCurrentTime = 0
			self.changScoreInitScore = self.changeScoreTempScore
			self:SetShowScoreText(self.changeScoreTempScore)
			self:ChangeScoreEnd()
		end
	end
end

function SpiderCrabBossHurt:ChangeScoreEnd()
	local sequence =self.SEM.DOTween.Sequence()
	self.IsChangeScore = false
	self.isPlayingAnim = false
	CommonHelper.RemoveUpdate(self.updateItemNum)
	local playEndAnimCallBack = function (  )
		self:PlayAnim(3)	
	end

	local destroyCallBack = function()
		self:EndCallBack()
		self.isCanDestory=true
	end
	sequence:InsertCallback(0.8,playEndAnimCallBack)
	sequence:InsertCallback(1.3,destroyCallBack)
	if self.EffectVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(63)
	end
end

function SpiderCrabBossHurt:Update()
	if self.IsDelayPlay then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.delayTime then
			self.IsDelayPlay=false
			self.currentTime=0
			self:BeginSpiderCrabBosshurtStep()
			self.isPlayingAnim=true
		end
	end
	if self.isPlayingAnim then
		self:ChangeScore()
	end
end

function SpiderCrabBossHurt:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end

function SpiderCrabBossHurt:__delete()
	CommonHelper.RemoveUpdate(self.updateItemNum)
	if self.EffectVo.IsMe then
		AudioManager.GetInstance():StopNormalAudio(63)
	end
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

