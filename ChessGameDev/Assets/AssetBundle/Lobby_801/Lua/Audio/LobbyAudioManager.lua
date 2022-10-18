LobbyAudioManager=Class()


local instance=nil
function LobbyAudioManager:ctor(gameObj)
	self.gameObject=gameObj
	CSScript.UIManager:SetObjPool(self.gameObject)
	instance=self
	self:InitData()
	self:InitView()

end

function LobbyAudioManager.GetInstance()
	return instance
end


function LobbyAudioManager:InitData()	
    self.CurrentAudioCount=15							
	self.AllAudioSource={}										
	self.AllAudioClips={}	
	self.IsOpenMusic=true
	self.IsOpenSoundEffects=true
	self.Music_Key = "Music_Key"
	self.Sound_Key = "Sound_Key"
	self.isMusicOpen = CS.UnityEngine.PlayerPrefs.GetInt(self.Music_Key,1)
	self.isSoundOpen = CS.UnityEngine.PlayerPrefs.GetInt(self.Sound_Key,1)
end


function LobbyAudioManager:InitView()
	self:FindView()
end



function LobbyAudioManager:FindView()
	self.AudioSource=CS.UnityEngine.AudioSource
	self.AudioClip=CS.UnityEngine.AudioClip
	local tf=self.gameObject.transform
	self.AudioBG=tf:Find("BGAO"):GetComponent(typeof(self.AudioSource))
	for i=1,self.CurrentAudioCount do
		self.AllAudioSource[i]=tf:Find("AO"..i):GetComponent(typeof(self.AudioSource))
	end
	
	self:ResetBGMusic(self.isMusicOpen == 1)
	self:ResetSoundEffects(self.isSoundOpen == 1)
end

function LobbyAudioManager:ResetSoundEffects(isOpen,volume)
	local m_Volume=0
	if isOpen then
		m_Volume=volume or 1
	end
	self.IsOpenSoundEffects=isOpen
	for i=1,#self.AllAudioSource do
		self.AllAudioSource[i].volume =m_Volume
	end
	CS.UnityEngine.PlayerPrefs.SetInt(self.Sound_Key,m_Volume)
end

function LobbyAudioManager:ResetBGMusic(isOpen,volume)
	local m_Volume=0
	if isOpen then
		m_Volume=volume or 1
	end
	self.IsOpenMusic=isOpen
	self.AudioBG.volume=m_Volume
	CS.UnityEngine.PlayerPrefs.SetInt(self.Music_Key,m_Volume)
end


function LobbyAudioManager:PlayAssignAudio(audioSource,volume,tempClip,isLoop)
	audioSource.volume=volume
	audioSource.clip=tempClip
	audioSource.loop=isLoop
	audioSource:Play()
end


function LobbyAudioManager:GetAudioClip()
	for i=1,#self.AllAudioSource do
		if self.AllAudioSource[i].isPlaying==false  then
			return self.AllAudioSource[i]
		end
	end
	Debug.LogError("当前没有音频可以使用")
	return nil
end


function LobbyAudioManager:GetAudioInfo(index)
	return LobbyManager.GetInstance().gameData.lobbyExcelConfigList.Lobby_SoundConfigList[index]
end



function LobbyAudioManager:PlayBGAudio(audioIndex,volume)
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
				Debug.LogError("声音资源加载失败==>"..audioInfo.soundPath)
			end
		end
		LobbyManager.GetInstance():AsyncLoadResource(audioInfo.soundPath,typeof(self.AudioClip),LoadAudioCallBack,true,false)
	else
		self:PlayAssignAudio(self.AudioBG,volume,self.AllAudioClips[audioInfo.soundName],true)
	end
	
end



function LobbyAudioManager:PlayNormalAudio(audioIndex,volume,isLoop)
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
		LobbyManager.GetInstance():AsyncLoadResource(audioInfo.soundPath,typeof(self.AudioClip),LoadAudioCallBack,true,false)
	else
		selectAudio=self:GetAudioClip()
		if selectAudio then
			self:PlayAssignAudio(selectAudio,volume,self.AllAudioClips[audioInfo.soundName],isLoop)
		end
	end
		
end



function LobbyAudioManager:StopBgMusic()
	self.AudioBG:Stop()
end


function LobbyAudioManager:StopNormalAudio(audioIndex)
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

function LobbyAudioManager:StopAllNormalAudio()
	for i=1,#self.AllAudioSource do
		if self.AllAudioSource[i].isPlaying then
			self.AllAudioSource[i]:Stop()   
		end
		self.AllAudioSource[i].clip=nil
	end
end

function LobbyAudioManager:RestoreAudioListenter(isOpen)
	CommonHelper.SetActive(self.gameObject,isOpen)
end

function LobbyAudioManager:StopAllAudio()

	self:StopBgMusic()
	self:StopAllNormalAudio()
end



function LobbyAudioManager:SetMusic(isOpenMusic)
	local volume=0
	if isOpenMusic then
		volume=1
	end
	CS.UnityEngine.PlayerPrefs.SetInt(self.Music_Key,volume)
	self.IsOpenMusic=isOpenMusic
	self.isMusicOpen=volume
end


function LobbyAudioManager:GetMusicState()
	return CS.UnityEngine.PlayerPrefs.GetInt(self.Music_Key,1)
end


function LobbyAudioManager:SetSound(isOpenSound)
	local volume=0
	if isOpenSound then
		volume=1
	end
	CS.UnityEngine.PlayerPrefs.SetInt(self.Sound_Key,volume)
	self.IsOpenSoundEffects=isOpenSound
	self.isSoundOpen=volume
end


function LobbyAudioManager:GetSoundState()
	return CS.UnityEngine.PlayerPrefs.GetInt(self.Sound_Key,1)
end



function LobbyAudioManager:__delete()
	self.CurrentAudioCount=nil							
	self.AllAudioSource=nil									
	self.AllAudioClips=nil	
	self.IsOpenMusic=nil
	self.IsOpenSoundEffects=nil
end