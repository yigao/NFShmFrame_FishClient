SpineEffectItem=Class()

function SpineEffectItem:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function SpineEffectItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function SpineEffectItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AnimName="die"
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.totalTime=1
	self.beginPos = CSScript.Vector3.zero
end


function SpineEffectItem:InitView(gameObj)
	self:FindView()
	
end

function SpineEffectItem:FindView()
	local tf=self.gameObject.transform
	local SEM=FishEffectManager.GetInstance()
	self.SkeletonAnimation = tf:Find("SkeletonAnimation"):GetComponent(typeof(SEM.SkeletonAnimation))
end


function SpineEffectItem:InitViewData()
	
end



function SpineEffectItem:PlayAnim()
	if self.EffectVo.EffectPositionFlag == 0 or self.EffectVo.EffectPositionFlag == nil then
		self.gameObject.transform.position = self.beginPos
	else
		self.gameObject.transform.localPosition = CSScript.Vector3.zero
	end
	if self.SkeletonAnimation ~= nil then
		self.SkeletonAnimation.state:SetAnimation(0,self.AnimName,false)
	end
end


function SpineEffectItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
end



function SpineEffectItem:ResetState(beginPos,callBack)
	self.isCanMove=false
	self.isCanDestory=false
	self.beginPos = beginPos
	self.gameObject.transform.localPosition= CSScript.Vector3(10000,10000,0)

	if self.EffectVo.EffectDelayTime == nil then
		self.delayTime= 0
	else
		self.delayTime=self.EffectVo.EffectDelayTime 
	end

	if self.EffectVo.EffectLifeTime == nil then
		self.totalTime= 0
	else
		self.totalTime=self.EffectVo.EffectLifeTime 
	end

	self.callBack=callBack

	self.currentTime=0
	self.IsDelayPlay=true
end


function SpineEffectItem:Update()
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


function SpineEffectItem:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end


function SpineEffectItem:__delete()
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

