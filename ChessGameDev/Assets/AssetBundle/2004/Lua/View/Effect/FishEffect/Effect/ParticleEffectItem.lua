ParticleEffectItem=Class()

function ParticleEffectItem:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function ParticleEffectItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function ParticleEffectItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.delayTime=0
	self.currentTime=0
	self.totalTime=1
	self.beginPos = CSScript.Vector3.zero
end


function ParticleEffectItem:InitView(gameObj)
	self:FindView()
	
end

function ParticleEffectItem:FindView()
	local tf=self.gameObject.transform
	local SEM=FishEffectManager.GetInstance()
	self.particleSystemList=tf:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem),true);
end


function ParticleEffectItem:InitViewData()
	
end



function ParticleEffectItem:PlayAnim()
	self.gameObject.transform.position = self.beginPos

	for i=0,self.particleSystemList.Length-1 do
		self.particleSystemList[i]:Play()
	end

	if self.EffectVo.EffectAudio then
		AudioManager.GetInstance():PlayNormalAudio(self.EffectVo.EffectAudio)
	end
end


function ParticleEffectItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.IsDelayPlay=false
end

function ParticleEffectItem:ResetState(beginPos,callBack)
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

function ParticleEffectItem:Update()
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


function ParticleEffectItem:EndCallBack()
	if self.callBack then
		self.callBack()
	end
end


function ParticleEffectItem:__delete()
	self.isPlayingAnim=false
	self.IsDelayPlay=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

