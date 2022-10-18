LightningEffectItem=Class()

function LightningEffectItem:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function LightningEffectItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function LightningEffectItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.totalTime=1
	self.beginPos = CSScript.Vector3.zero
	self.targetPos = CSScript.Vector3.zero
	self.distance = CSScript.Vector3.zero
end


function LightningEffectItem:InitView(gameObj)
	self:FindView()
	
end

function LightningEffectItem:FindView()
	local tf=self.gameObject.transform
	local SEM=LightningEffectManager.GetInstance()
	self.Vector2 =  SEM.Vector2
	self.Quaternion = SEM.Quaternion
	self.Animator = tf:GetComponent(typeof(SEM.Animator))
	self.LightningRectTrans = tf:Find("lightningImage"):GetComponent(typeof(SEM.RectTransform))
	self.width = self.LightningRectTrans.rect.width
end


function LightningEffectItem:InitViewData()
	
end



function LightningEffectItem:PlayAnim()
	self.gameObject.transform.position = self.beginPos
	self.gameObject.transform.rotation = self.Quaternion.FromToRotation(CSScript.Vector3.up,(self.targetPos-self.beginPos))
	self.LightningRectTrans.sizeDelta=	self.Vector2(self.width,self.distance)
	self.Animator:Play(self.LightningVo.EffectName,0,0)
	AudioManager.GetInstance():PlayNormalAudio(40,1)
end


function LightningEffectItem:ResetEffectVo(vo)
	self.LightningVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
end


function LightningEffectItem:ResetState(beginPos,targetPos,distance,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.beginPos = beginPos
	self.targetPos = targetPos
	self.distance = distance
	self.gameObject.transform.localPosition= CSScript.Vector3(10000,10000,0)

	if self.LightningVo.EffectDelayTime == nil then
		self.delayTime= 0
	else
		self.delayTime=self.LightningVo.EffectDelayTime 
	end

	if self.LightningVo.EffectLifeTime == nil then
		self.totalTime= 0
	else
		self.totalTime=self.LightningVo.EffectLifeTime 
	end

	self.callBack=callBack

	self.currentTime=0
	self.IsDelayPlay=true
end


function LightningEffectItem:Update()
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


function LightningEffectItem:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end


function LightningEffectItem:__delete()
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

