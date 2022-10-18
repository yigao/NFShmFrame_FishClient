SystemSetView=Class()


function SystemSetView:ctor(obj)
	self:Init(obj)

end

function SystemSetView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
	self:InitSound()
end


function SystemSetView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.isOpenMusic=false
	self.isOpenEffect=false
	self.GameAtlasName="QZNNBaseSpriteAtlas"
	self.MusicImageNameList={"Game_LHDZ_btn_music","Game_LHDZ_btn_music_N"}
	self.SoundImageNameList={"Game_LHDZ_btn_set","Game_LHDZ_btn_set_N"}
	
end



function SystemSetView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function SystemSetView:FindView(tf)
	self.QuitGameBtn=tf:Find("Panel/SystemPanel/RetrunButton"):GetComponent(typeof(self.Button))
	self.HelpBtn=tf:Find("Panel/SystemPanel/HelpButton"):GetComponent(typeof(self.Button))
	self.MusicBtn=tf:Find("Panel/SystemPanel/MusicButton"):GetComponent(typeof(self.Button))
	self.MusicImage=tf:Find("Panel/SystemPanel/MusicButton"):GetComponent(typeof(self.Image))
	self.SoundBtn=tf:Find("Panel/SystemPanel/SoundButton"):GetComponent(typeof(self.Button))
	self.SoundImage=tf:Find("Panel/SystemPanel/SoundButton"):GetComponent(typeof(self.Image))
end


function SystemSetView:InitSound()
	self.isOpenMusic=not (LobbySettingSystem.GetInstance():GetMusicState() or false)
	self.isOpenEffect=not(LobbySettingSystem.GetInstance():GetSoundEffectState() or false)
end

function SystemSetView:ResetSound()
	self:OnclickMusic(true)
	self:OnclickSound(true)
end

function SystemSetView:AddEventListenner()
	self.QuitGameBtn.onClick:AddListener(function () self:OnclickQuitGame() end)
	self.HelpBtn.onClick:AddListener(function () self:OnclickHelp() end)
	self.MusicBtn.onClick:AddListener(function () self:OnclickMusic() end)
	self.SoundBtn.onClick:AddListener(function () self:OnclickSound() end)
end



function SystemSetView:OnclickHelp()
	AudioManager.GetInstance():PlayNormalAudio(16)
	HelpManager.GetInstance():IsShowHelpPanel(true)
end

function SystemSetView:OnclickMusic(isInit)
	self.isOpenMusic=not self.isOpenMusic
	if self.isOpenMusic then
		self.MusicImage.sprite=self.gameData.AllAtlasList[self.GameAtlasName]:GetSprite(self.MusicImageNameList[1])
	else
		self.MusicImage.sprite=self.gameData.AllAtlasList[self.GameAtlasName]:GetSprite(self.MusicImageNameList[2])
	end
	AudioManager.GetInstance():ResetBGMusic(self.isOpenMusic)
	LobbySettingSystem.GetInstance():SetMusicState(self.isOpenMusic)
	if isInit then return end
	AudioManager.GetInstance():PlayNormalAudio(16)
end

function SystemSetView:OnclickSound(isInit)
	self.isOpenEffect=not self.isOpenEffect
	if self.isOpenEffect then
		self.SoundImage.sprite=self.gameData.AllAtlasList[self.GameAtlasName]:GetSprite(self.SoundImageNameList[1])
	else
		self.SoundImage.sprite=self.gameData.AllAtlasList[self.GameAtlasName]:GetSprite(self.SoundImageNameList[2])
	end
	AudioManager.GetInstance():ResetSoundEffects(self.isOpenEffect)
	LobbySettingSystem.GetInstance():SetSoundEffectState(self.isOpenEffect)
	if isInit then return end
	AudioManager.GetInstance():PlayNormalAudio(16)
end


function SystemSetView:OnclickQuitGame()
	AudioManager.GetInstance():PlayNormalAudio(16)
	--[[if GameLogicManager.GetInstance():GetCurrentExitState()==false then
		GameManager.GetInstance():ShowUITips("游戏中 不能退出",3)
		return
	end--]]
	GameUIManager.GetInstance():RequestQuitGameMsg()
end