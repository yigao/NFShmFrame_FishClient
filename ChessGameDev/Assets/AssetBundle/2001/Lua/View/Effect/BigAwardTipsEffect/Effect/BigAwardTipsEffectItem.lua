BigAwardTipsEffectItem=Class()

function BigAwardTipsEffectItem:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function BigAwardTipsEffectItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function BigAwardTipsEffectItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AnimName="BigAwardTips"
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.totalTime=1
	self.beginPos = CSScript.Vector3.zero
	
end


function BigAwardTipsEffectItem:InitView(gameObj)
	self:FindView()
	
end

function BigAwardTipsEffectItem:FindView()
	local tf=self.gameObject.transform
	local SEM=BigAwardTipsEffectManager.GetInstance()

	self.Anim = tf:GetComponent(typeof(SEM.Animator)) 
	
	self.MyShowScoreText=tf:Find("AwardScore/MyText"):GetComponent(typeof(SEM.Text))
	self.OtherShowScoreText=tf:Find("AwardScore/OtherAwardText"):GetComponent(typeof(SEM.Text))
	self.MyScoreTextObj = self.MyShowScoreText.gameObject
	self.OtherShowScoreObj = self.OtherShowScoreText.gameObject
end


function BigAwardTipsEffectItem:InitViewData()
	
end


function BigAwardTipsEffectItem:SetShowScoreText(score)
	if 	self.EffectVo.IsMe then
		self.MyShowScoreText.text= score
	else
		self.OtherShowScoreText.text= score
	end
end



function BigAwardTipsEffectItem:PlayAnim()
	self.gameObject.transform.position = self.beginPos
	self.Anim:Play(self.AnimName,0,0)
	AudioManager.GetInstance():PlayNormalAudio(self.EffectVo.BigAwardTipsEffectConfig.bigAwardTipsShowAudio)
end


function BigAwardTipsEffectItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	CommonHelper.SetActive(self.MyScoreTextObj,false)
	CommonHelper.SetActive(self.OtherShowScoreObj,false)
end



function BigAwardTipsEffectItem:ResetState(beginPos,delayTime,showTime,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.beginPos = beginPos
	self.gameObject.transform.localPosition= CSScript.Vector3(10000,10000,0)
	if delayTime == nil then
		self.delayTime= 0
	else
		self.delayTime=delayTime
	end
	self.callBack=callBack
	self.totalTime = showTime

	self.currentTime=0
	self.IsDelayPlay=true

	if self.EffectVo.IsMe then
		CommonHelper.SetActive(self.MyScoreTextObj,true)
	else
		CommonHelper.SetActive(self.OtherShowScoreObj,true)
	end
	
end


function BigAwardTipsEffectItem:Update()
	if self.IsDelayPlay then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.delayTime then
			self.IsDelayPlay=false
			self.currentTime=0
			self:PlayAnim()
			self.isPlayingAnim=true
		end
	end

	
	if self.isPlayingAnim then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.totalTime then
			self.currentTime=0
			
			self.isPlayingAnim=false
			self:EndCallBack()
			self.isCanDestory=true
		end
	end
	
end


function BigAwardTipsEffectItem:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end



function BigAwardTipsEffectItem:__delete()
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

