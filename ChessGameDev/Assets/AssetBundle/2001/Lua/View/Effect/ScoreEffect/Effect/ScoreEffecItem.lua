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
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.MyAnimName="Score01"
	self.OtherAnimName="Score02"
	self.beginPos = CSScript.Vector3.zero
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.totalTime=1
	
end


function ScoreEffecItem:InitView(gameObj)
	self:FindView()
	
end

function ScoreEffecItem:FindView()
	local tf=self.gameObject.transform
	local SEM=ScoreEffectManager.GetInstance()

	self.Anim = self.gameObject:GetComponent(typeof(SEM.Animator))

	self.MySoreObj = tf:Find("Score01").gameObject
	CommonHelper.SetActive(self.MySoreObj,false)

	self.OtherScoreObj = tf:Find("Score02").gameObject
	CommonHelper.SetActive(self.OtherScoreObj,false)

	self.MyShowScoreText=tf:Find("Score01/Text"):GetComponent(typeof(SEM.Text))
	self.OtherShowScoreText=tf:Find("Score02/Text"):GetComponent(typeof(SEM.Text))
end


function ScoreEffecItem:InitViewData()
	
end


function ScoreEffecItem:SetShowScoreText(score)
	if self.EffectVo.IsMe then
		self.MyShowScoreText.text=score
	else
		self.OtherShowScoreText.text=score
	end
end



function ScoreEffecItem:PlayAnim()
	if self.EffectVo.IsMe then
		self.Anim:Play(self.MyAnimName,0,0)
	else
		self.Anim:Play(self.OtherAnimName,0,0)
	end
end


function ScoreEffecItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	CommonHelper.SetActive(self.MySoreObj,false)
	CommonHelper.SetActive(self.OtherScoreObj,false)
end



function ScoreEffecItem:ResetState(beginPos,delayTime,showTime,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	
	self.beginPos = beginPos
	if delayTime == nil then
		self.delayTime = 0
	else
		self.delayTime=delayTime
	end
	self.callBack=callBack
	self.totalTime= showTime
	self.currentTime=0
	self.IsDelayPlay=true
	if self.EffectVo.IsMe then
		CommonHelper.SetActive(self.MySoreObj,true)
	else
		CommonHelper.SetActive(self.OtherScoreObj,true)
	end
end


function ScoreEffecItem:Update()
	if self.IsDelayPlay then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.delayTime then
			self.IsDelayPlay=false
			self.currentTime=0
			self.gameObject.transform.position=self.beginPos
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

