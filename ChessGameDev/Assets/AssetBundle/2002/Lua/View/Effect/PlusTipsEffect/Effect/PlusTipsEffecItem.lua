PlusTipsEffecItem=Class()

function PlusTipsEffecItem:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function PlusTipsEffecItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function PlusTipsEffecItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AnimName="PlusTips"
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.totalTime=1
	self.beginPos = CSScript.Vector3.zero
	
end


function PlusTipsEffecItem:InitView(gameObj)
	self:FindView()
	
end

function PlusTipsEffecItem:FindView()
	local tf=self.gameObject.transform
	local SEM=PlusTipsEffectManager.GetInstance()

	self.Anim = tf:GetComponent(typeof(SEM.Animator)) 
	
	self.ShowScoreText=tf:Find("Content/Text"):GetComponent(typeof(SEM.Text))
end


function PlusTipsEffecItem:InitViewData()
	
end


function PlusTipsEffecItem:SetShowScoreText(score)
	self.ShowScoreText.text="+"..score
end



function PlusTipsEffecItem:PlayAnim()
	self.gameObject.transform.position = self.beginPos
	self.Anim:Play(self.AnimName,0,0)
end


function PlusTipsEffecItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
end



function PlusTipsEffecItem:ResetState(beginPos,delayTime,showTime,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.beginPos = beginPos
	self.gameObject.transform.localPosition= CSScript.Vector3(10000,10000,0)
	self.delayTime=delayTime
	self.callBack=callBack
	self.totalTime=showTime
	self.currentTime=0
	self.IsDelayPlay=true
	
end


function PlusTipsEffecItem:Update()
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


function PlusTipsEffecItem:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end



function PlusTipsEffecItem:__delete()
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

