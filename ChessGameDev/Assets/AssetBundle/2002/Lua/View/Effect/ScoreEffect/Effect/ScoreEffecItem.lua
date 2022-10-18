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
	self.AnimName="Score01"
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

	self.SoreObj = tf:Find("Score01").gameObject
	--CommonHelper.SetActive(self.MySoreObj,false)

	self.ShowScoreText=tf:Find("Score01/Text"):GetComponent(typeof(SEM.Text))
end


function ScoreEffecItem:InitViewData()
	
end


function ScoreEffecItem:SetShowScoreText(score)
	self.ShowScoreText.text=score
end



function ScoreEffecItem:PlayAnim()
	self.Anim:Play(self.AnimName,0,0)
end


function ScoreEffecItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	--CommonHelper.SetActive(self.SoreObj,false)
end



function ScoreEffecItem:ResetState(beginPos,delayTime,showTime,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.beginPos  = beginPos

	if delayTime == nil then
		self.delayTime = 0
	else
		self.delayTime= delayTime
	end
	self.callBack=callBack
	self.totalTime=showTime
	self.currentTime=0
	self.IsDelayPlay=true
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

