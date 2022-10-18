SystemSetPanel=Class()

function SystemSetPanel:ctor(gameobj)
	self.gameObject=gameobj
	self:Init()
end


function SystemSetPanel:Init()
	self:InitData()
	self:FindView()
	self:AddBtnEventListenner()
	self:InitViewData()
	self:InitSound()
end


function SystemSetPanel:InitData()
	self.MusicSpriteList={}
	self.SoundEffectsList={}
	self.MusicSpriteNameList={}
	self.SoundEffectsNameList={}
	self.isOpenMusic=false
	self.isOpenEffect=false
end


function SystemSetPanel:FindView()
	local tf=self.gameObject.transform
	local Toggle=CS.UnityEngine.UI.Toggle
	local Button=CS.UnityEngine.UI.Button
	
	self.SystemSetPanel=tf:Find("RulePanel/SystemSetPanel").gameObject
	self.ClosePanelBtn=tf:Find("RulePanel/SystemSetPanel/RawImage/CloseBtn"):GetComponent(typeof(Button))

	local tempSprite=tf:Find("RulePanel/SystemSetPanel/RawImage/Music/ButtonGroup/OpenBtn"):GetComponent(typeof(Button))
	table.insert(self.MusicSpriteList,tempSprite)
	tempSprite=tf:Find("RulePanel/SystemSetPanel/RawImage/Music/ButtonGroup/CloseBtn"):GetComponent(typeof(Button))
	table.insert(self.MusicSpriteList,tempSprite)
	
	tempSprite=tf:Find("RulePanel/SystemSetPanel/RawImage/SoundEffects/ButtonGroup/OpenBtn"):GetComponent(typeof(Button))
	table.insert(self.SoundEffectsList,tempSprite)
	tempSprite=tf:Find("RulePanel/SystemSetPanel/RawImage/SoundEffects/ButtonGroup/CloseBtn"):GetComponent(typeof(Button))
	table.insert(self.SoundEffectsList,tempSprite)
	
end



function SystemSetPanel:InitViewData()
	self:IsShowSystemSetPanel(false)
	self:IsShowMusicPanel(1,true)
	self:IsShowSoundEffectsPanel(1,true)
end


function SystemSetPanel:InitSound()
	self.isOpenMusic=not (LobbySettingSystem.GetInstance():GetMusicState() or false)
	self.isOpenEffect=not(LobbySettingSystem.GetInstance():GetSoundEffectState() or false)
end

function SystemSetPanel:ResetSoundState()
	if self.isOpenMusic then
		self:OnclickOpenMusicPanelBtn(true)
	else
		self:OnclickCloseMusicPanelBtn(true)
	end
	
	if self.isOpenEffect then
		self:OnclickOpenSoundEffectsPanelBtn(true)
	else
		self:OnclickCloseSoundEffectsPanelBtn(true)
	end
end


function SystemSetPanel:AddBtnEventListenner()
	self.ClosePanelBtn.onClick:AddListener(function () self:OnclickClosePanelBtn() end)
	
	self:AddMusicEvent()
	self:AddSoundEffectsEvent()
end


function SystemSetPanel:AddMusicEvent()
	for i=1,#self.MusicSpriteList do
		if i==1 then
			self.MusicSpriteList[i].onClick:AddListener(function () self:OnclickOpenMusicPanelBtn() end)
		else
			self.MusicSpriteList[i].onClick:AddListener(function () self:OnclickCloseMusicPanelBtn() end)
		end
		
	end
end

function SystemSetPanel:AddSoundEffectsEvent()
	for i=1,#self.SoundEffectsList do
		if i==1 then
			self.SoundEffectsList[i].onClick:AddListener(function () self:OnclickOpenSoundEffectsPanelBtn() end)
		else
			self.SoundEffectsList[i].onClick:AddListener(function () self:OnclickCloseSoundEffectsPanelBtn() end)
		end
		
	end
end



function SystemSetPanel:OnclickClosePanelBtn()
	AudioManager.GetInstance():PlayNormalAudio(48)
	self:IsShowSystemSetPanel(false)
end

function SystemSetPanel:OnclickOpenMusicPanelBtn(isInit)
	self:IsShowMusicPanel(2,true)
	AudioManager.GetInstance():ResetBGMusic(false)
	LobbySettingSystem.GetInstance():SetMusicState(false)
	if isInit then return end
	AudioManager.GetInstance():PlayNormalAudio(48)
end

function SystemSetPanel:OnclickCloseMusicPanelBtn(isInit)
	self:IsShowMusicPanel(1,true)
	AudioManager.GetInstance():ResetBGMusic(true)
	LobbySettingSystem.GetInstance():SetMusicState(true)
	if isInit then return end
	AudioManager.GetInstance():PlayNormalAudio(48)
end

function SystemSetPanel:OnclickOpenSoundEffectsPanelBtn(isInit)
	self:IsShowSoundEffectsPanel(2,true)
	AudioManager.GetInstance():ResetSoundEffects(false)
	LobbySettingSystem.GetInstance():SetSoundEffectState(false)
	if isInit then return end
	AudioManager.GetInstance():PlayNormalAudio(48)
end

function SystemSetPanel:OnclickCloseSoundEffectsPanelBtn(isInit)
	self:IsShowSoundEffectsPanel(1,true)
	AudioManager.GetInstance():ResetSoundEffects(true)
	LobbySettingSystem.GetInstance():SetSoundEffectState(true)
	if isInit then return end
	AudioManager.GetInstance():PlayNormalAudio(48)
end

function SystemSetPanel:IsShowSystemSetPanel(isdisplay)
	CommonHelper.SetActive(self.SystemSetPanel,isdisplay)
end

function SystemSetPanel:IsShowMusicPanel(index,isdisplay)
	CommonHelper.IsShowPanel(index,self.MusicSpriteList,isdisplay,false,false)
end

function SystemSetPanel:IsShowSoundEffectsPanel(index,isdisplay)
	CommonHelper.IsShowPanel(index,self.SoundEffectsList,isdisplay,false,false)
end
