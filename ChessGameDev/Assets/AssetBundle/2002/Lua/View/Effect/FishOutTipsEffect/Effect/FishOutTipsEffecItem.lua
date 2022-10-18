FishOutTipsEffecItem=Class()

function FishOutTipsEffecItem:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function FishOutTipsEffecItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function FishOutTipsEffecItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.totalTime=1
	self.animName = "Fish_Move"
	
end


function FishOutTipsEffecItem:InitView(gameObj)
	self:FindView()
	
end

function FishOutTipsEffecItem:FindView()
	local tf=self.gameObject.transform
	local SEM=FishOutTipsEffectManager.GetInstance()
	self.SpineAnim=tf:Find("FishOutTips"):GetComponent(typeof(SEM.SkeletonAnimation))
end


function FishOutTipsEffecItem:InitViewData()
	
end



function FishOutTipsEffecItem:PlayAnim()
	self.SpineAnim.loop=false
	self.SpineAnim.state:SetAnimation(0,self.animName,false)
end


function FishOutTipsEffecItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
end



function FishOutTipsEffecItem:ResetState(callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.delayTime= 0
	self.callBack=callBack
	self.totalTime=self.EffectVo.LifeTime
	self.currentTime=0
	self.IsDelayPlay=true
	self.gameObject.transform.localPosition = CSScript.Vector3.zero
	CommonHelper.SetActive(self.gameObject,true)
end



function FishOutTipsEffecItem:Update()
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


function FishOutTipsEffecItem:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end



function FishOutTipsEffecItem:__delete()
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	CommonHelper.SetActive(self.gameObject,false )
end

