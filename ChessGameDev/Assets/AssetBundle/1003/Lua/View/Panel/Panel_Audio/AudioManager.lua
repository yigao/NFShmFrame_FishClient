AudioManager=Class()


local Instance=nil
function AudioManager:ctor(gameObj)
	self.gameObject=gameObj
	Instance=self
	self:AddRootGameObject()
	self:InitData()
	self:InitView()

end

function AudioManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Audio
		local BuildAudioPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				AudioManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildAudioPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function AudioManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function AudioManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function AudioManager:InitData()	
    self.CurrentAudioCount=15							
	self.AllAudioSource={}										
	self.AllAudioClips={}	
	self.IsOpenMusic=true
	self.IsOpenSoundEffects=true
end


function AudioManager:InitView()
	self:FindView()
end



function AudioManager:FindView()
	self.AudioSource=CS.UnityEngine.AudioSource
	self.AudioClip=CS.UnityEngine.AudioClip
	local tf=self.gameObject.transform
	self.AudioBG=tf:Find("BGAO"):GetComponent(typeof(self.AudioSource))
	for i=1,self.CurrentAudioCount do
		self.AllAudioSource[i]=tf:Find("AO"..i):GetComponent(typeof(self.AudioSource))
	end
end

function AudioManager:ResetSoundEffects(isOpen,volume)
	local m_Volume=0
	if isOpen then
		m_Volume=volume or 1
	end
	self.IsOpenSoundEffects=isOpen
	for i=1,#self.AllAudioSource do
		self.AllAudioSource[i].volume =m_Volume
	end
end

function AudioManager:ResetBGMusic(isOpen,volume)
	local m_Volume=0
	if isOpen then
		m_Volume=volume or 1
	end
	self.IsOpenMusic=isOpen
	self.AudioBG.volume=m_Volume
end


function AudioManager:PlayAssignAudio(audioSource,volume,tempClip,isLoop)
	audioSource.volume=volume
	audioSource.clip=tempClip
	audioSource.loop=isLoop
	audioSource:Play()
end


function AudioManager:GetAudioClip()
	for i=1,#self.AllAudioSource do
		if self.AllAudioSource[i].isPlaying==false  then
			return self.AllAudioSource[i]
		end
	end
	Debug.LogError("当前没有音频可以使用")
	return nil
end


function AudioManager:GetAudioInfo(index)
	return GameManager.GetInstance().gameData.gameConfigList.SoundConfigList[index]
end



function AudioManager:PlayBGAudio(audioIndex,volume)
	if self.IsOpenMusic then
		volume=volume or 1
	else
		volume=0
	end
	local audioInfo=self:GetAudioInfo(audioIndex)
	if audioInfo==nil then  return end
	
	if self.AllAudioClips[audioInfo.soundName]==nil then 
		local LoadAudioCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local InstantiateAudio=CommonHelper.UnityObjectInstantiate(gameObj.content)
				self.AllAudioClips[audioInfo.soundName]=InstantiateAudio
				self:PlayAssignAudio(self.AudioBG,volume,InstantiateAudio,true)
			else
				print("声音资源加载失败==>"..audioInfo.soundPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(audioInfo.soundPath,typeof(self.AudioClip),LoadAudioCallBack)
	else
		self:PlayAssignAudio(self.AudioBG,volume,self.AllAudioClips[audioInfo.soundName],true)
	end
	
end



function AudioManager:PlayNormalAudio(audioIndex,volume,isLoop)
	isLoop=isLoop or false
	if self.IsOpenSoundEffects then
		volume=volume or 1
	else
		volume=0
	end
	local audioInfo=self:GetAudioInfo(audioIndex)
	if audioInfo==nil then  return end
	local selectAudio = nil
	if self.AllAudioClips[audioInfo.soundName]==nil then 
		local LoadAudioCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local InstantiateAudio=CommonHelper.UnityObjectInstantiate(gameObj.content)
				self.AllAudioClips[audioInfo.soundName]=InstantiateAudio
				selectAudio=self:GetAudioClip()
				if selectAudio then
					self:PlayAssignAudio(selectAudio,volume,InstantiateAudio,isLoop)
				end
			else
				print("声音资源加载失败==>"..audioInfo.soundPath)
			end	
				
		end
		GameManager.GetInstance():AsyncLoadResource(audioInfo.soundPath,typeof(self.AudioClip),LoadAudioCallBack)
	else
		selectAudio=self:GetAudioClip()
		if selectAudio then
			self:PlayAssignAudio(selectAudio,volume,self.AllAudioClips[audioInfo.soundName],isLoop)
		end
	end
		
end



function AudioManager:StopBgMusic()
	self.AudioBG:Stop()
end


function AudioManager:StopNormalAudio(audioIndex)
	local audioInfo=self:GetAudioInfo(audioIndex)
	if audioInfo==nil then  return end
	for i=1,#self.AllAudioSource do
		if self.AllAudioSource[i].isPlaying and self.AllAudioSource[i].clip==self.AllAudioClips[audioInfo.soundName] then
			self.AllAudioSource[i]:Stop()
			self.AllAudioSource[i].clip=nil
			break
		end
	end
end

function AudioManager:StopAllNormalAudio()
	for i=1,#self.AllAudioSource do
		if self.AllAudioSource[i].isPlaying then
			self.AllAudioSource[i]:Stop()   
		end
		self.AllAudioSource[i].clip=nil
	end
end


function AudioManager:StopAllAudio()
	self:StopBgMusic()
	self:StopAllNormalAudio()
end


function AudioManager:__delete()
	self.CurrentAudioCount=nil							
	self.AllAudioSource=nil									
	self.AllAudioClips=nil	
	self.IsOpenMusic=nil
	self.IsOpenSoundEffects=nil
end