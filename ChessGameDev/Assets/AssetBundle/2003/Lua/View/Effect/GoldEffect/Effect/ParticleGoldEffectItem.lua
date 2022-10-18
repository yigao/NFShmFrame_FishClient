ParticleGoldEffectItem=Class()

function ParticleGoldEffectItem:ctor(obj,vo)
	self.gameObject = obj
	self.transform = self.gameObject.transform
	self.EffectVo=vo
	self:Init(obj)
	
end


function ParticleGoldEffectItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function ParticleGoldEffectItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.currentTime=0
	self.totalTime=0
end


function ParticleGoldEffectItem:InitView(gameObj)
	self:FindView()
	
end

function ParticleGoldEffectItem:FindView()
	self.myEffect=self.transform:Find(self.EffectVo.GoldEffectConfig.coinMyAnimName).gameObject
	self.otherEffect=self.transform:Find(self.EffectVo.GoldEffectConfig.coinOtherAnimName).gameObject
end


function ParticleGoldEffectItem:InitViewData()
	self:IsShowMyEffect(false)
	self:IsShowOtherEffect(false)
end


function ParticleGoldEffectItem:IsShowMyEffect(isShow)
	CommonHelper.SetActive(self.myEffect,isShow)
end


function ParticleGoldEffectItem:IsShowOtherEffect(isShow)
	CommonHelper.SetActive(self.otherEffect,isShow)
end


function ParticleGoldEffectItem:ResetEffectVo(vo)
	self.EffectVo=vo
	self.currentTime=0
	self.isCanDestory=false
	self.isPlayingAnim=false
	self.totalTime=vo.GoldEffectConfig.coinTime
	self:InitViewData()
end


function ParticleGoldEffectItem:ResetState()
	self.isPlayingAnim=true
	self.transform.position=self.EffectVo.beginPos
	if self.EffectVo.IsMe then
		self:IsShowMyEffect(true)
	else
		self:IsShowOtherEffect(true)
	end
	AudioManager.GetInstance():PlayNormalAudio(self.EffectVo.GoldEffectConfig.coinShowAudioID)
end



function ParticleGoldEffectItem:Update()
	if self.isPlayingAnim then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.totalTime then
			self.isPlayingAnim=false
			self.currentTime=0
			self.isCanDestory=true
		end
	end
end


function ParticleGoldEffectItem:__delete()
	self.isPlayingAnim=false
	self.isCanDestory=false
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end