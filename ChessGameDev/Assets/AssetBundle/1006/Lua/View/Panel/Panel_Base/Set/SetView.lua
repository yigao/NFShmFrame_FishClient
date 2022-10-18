SetView=Class()

function SetView:ctor(gameObj)
	self:Init(gameObj)
	
end

function SetView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function SetView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.IsOpenGameSet=false
	self.isOpenMusic=false
	self.isOpenEffect=false
end



function SetView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
	self:InitSound()
end


function SetView:FindView(tf)
	self:FindSetView(tf)
end


function SetView:FindSetView(tf)
	self.GameSetBtn=tf:Find("Up/SetPanel/SetBtn"):GetComponent(typeof(self.Button))
	self.GameSetPanel=tf:Find("Up/SubSetPanel").gameObject
	self.CloseGameSetBtn=self.GameSetPanel:GetComponent(typeof(self.Button))
	self.QuitGameBtn=tf:Find("Up/SubSetPanel/SetPanel/QuitBtn"):GetComponent(typeof(self.Button))
	self.MusicBtn=tf:Find("Up/SubSetPanel/SetPanel/MusicBtn"):GetComponent(typeof(self.Button))
	self.MusicImage=tf:Find("Up/SubSetPanel/SetPanel/MusicBtn"):GetComponent(typeof(self.Image))
	self.SoundBtn=tf:Find("Up/SubSetPanel/SetPanel/SoundBtn"):GetComponent(typeof(self.Button))
	self.SoundImage=tf:Find("Up/SubSetPanel/SetPanel/SoundBtn"):GetComponent(typeof(self.Image))
	self.HelpBtn=tf:Find("Up/SubSetPanel/SetPanel/HelpBtn"):GetComponent(typeof(self.Button))
end


function SetView:InitViewData()
	self.IsOpenGameSet=false
	self:IsShowGameSetPanel(false)
end


function SetView:InitSound()
	self.isOpenMusic=not (LobbySettingSystem.GetInstance():GetMusicState() or false)
	self.isOpenEffect=not(LobbySettingSystem.GetInstance():GetSoundEffectState() or false)
end

function SetView:ResetSound()
	self:OnclickMusic(true)
	self:OnclickSound(true)
end


function SetView:AddEventListenner()
	self.GameSetBtn.onClick:AddListener(function () self:OnclickGameSet() end)
	self.QuitGameBtn.onClick:AddListener(function () self:OnclickQuitGame() end)
	self.HelpBtn.onClick:AddListener(function () self:OnclickHelp() end)
	self.MusicBtn.onClick:AddListener(function () self:OnclickMusic() end)
	self.SoundBtn.onClick:AddListener(function () self:OnclickSound() end)
	self.CloseGameSetBtn.onClick:AddListener(function () self:OnclickGameSet() end)
end


function SetView:OnclickGameSet()
	AudioManager.GetInstance():PlayNormalAudio(20)
	self.IsOpenGameSet=not self.IsOpenGameSet
	if self.IsOpenGameSet then
		self:IsShowGameSetPanel(true)
	else
		self:IsShowGameSetPanel(false)
	end
end

function SetView:OnclickHelp()
	AudioManager.GetInstance():PlayNormalAudio(20)
	HelpManager.GetInstance():IsShowHelpPanel(true)
end

function SetView:OnclickMusic(isInit)
	self.isOpenMusic=not self.isOpenMusic
	if self.isOpenMusic then
		CommonHelper.SetImageColor(self.MusicImage,CS.UnityEngine.Color(1,1,1,1))
	else
		CommonHelper.SetImageColor(self.MusicImage,CS.UnityEngine.Color(0.5,0.5,0.5,1))
	end
	AudioManager.GetInstance():ResetBGMusic(self.isOpenMusic)
	LobbySettingSystem.GetInstance():SetMusicState(self.isOpenMusic)
	if isInit then return end
	AudioManager.GetInstance():PlayNormalAudio(20)
end

function SetView:OnclickSound(isInit)
	self.isOpenEffect=not self.isOpenEffect
	if self.isOpenEffect then
		CommonHelper.SetImageColor(self.SoundImage,CS.UnityEngine.Color(1,1,1,1))
	else
		CommonHelper.SetImageColor(self.SoundImage,CS.UnityEngine.Color(0.5,0.5,0.5,1))
	end
	AudioManager.GetInstance():ResetSoundEffects(self.isOpenEffect)
	LobbySettingSystem.GetInstance():SetSoundEffectState(self.isOpenEffect)
	if isInit then return end
	AudioManager.GetInstance():PlayNormalAudio(20)
end


function SetView:OnclickQuitGame()
	AudioManager.GetInstance():PlayNormalAudio(20)
	if GameLogicManager.GetInstance():GetCurrentExitState()==false then
		GameManager.GetInstance():ShowUITips("开奖过程 不能退出",3)
		return
	end
	GameUIManager.GetInstance():RequestQuitGameMsg()
end



function SetView:IsShowGameSetPanel(isShow)
	CommonHelper.SetActive(self.GameSetPanel,isShow)
end


