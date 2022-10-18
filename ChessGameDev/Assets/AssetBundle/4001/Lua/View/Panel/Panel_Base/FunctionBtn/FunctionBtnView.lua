FunctionBtnView=Class()

function FunctionBtnView:ctor(gameObj)
	self:Init(gameObj)
end

function FunctionBtnView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
	self:InitSound()
end


function FunctionBtnView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.isOpenMusic=false
	self.isOpenEffect=false
end


function FunctionBtnView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function FunctionBtnView:FindView(tf)
	self:FindButtonView(tf)
end


function FunctionBtnView:FindButtonView(tf)
	self.HelpBtn=tf:Find("FunBtnPanel/help_Btn"):GetComponent(typeof(self.Button))
	self.VoiceBtn=tf:Find("FunBtnPanel/voice_Btn"):GetComponent(typeof(self.Button))
	self.Voice_Open_Image_Obj = tf:Find("FunBtnPanel/voice_Btn/btn_bg01").gameObject
	self.Voice_Close_Image_Obj = tf:Find("FunBtnPanel/voice_Btn/btn_bg02").gameObject
	self.HangUpBtn=tf:Find("FunBtnPanel/hangUp_Btn"):GetComponent(typeof(self.Button))
	self.ReturnBtn=tf:Find("FunBtnPanel/return_Btn"):GetComponent(typeof(self.Button))
	self.ContinuedBetBtn=tf:Find("FunBtnPanel/continuedBet_Btn"):GetComponent(typeof(self.Button))
	self.PlayerListRankBtn=tf:Find("FunBtnPanel/playerListRank_Btn"):GetComponent(typeof(self.Button))
end


function FunctionBtnView:InitViewData()

end

function FunctionBtnView:InitSound()
	self.isOpenMusic=not (LobbySettingSystem.GetInstance():GetMusicState() or false)
	self.isOpenEffect=not(LobbySettingSystem.GetInstance():GetSoundEffectState() or false)
end

function FunctionBtnView:ResetSound()
	self:OnClickVoice(true)
end

function FunctionBtnView:AddEventListenner()
	self.HelpBtn.onClick:AddListener(function () self:OnClickHelp() end)
	self.VoiceBtn.onClick:AddListener(function () self:OnClickVoice() end)

	self.HangUpBtn.onClick:AddListener(function () self:OnClickHangUp() end)
	self.ReturnBtn.onClick:AddListener(function () self:OnClickReturn() end)
	self.ContinuedBetBtn.onClick:AddListener(function () self:OnClickContinuedBet() end)
	self.PlayerListRankBtn.onClick:AddListener(function () self:OnClickPlayerListRank() end)
end

function FunctionBtnView:EnterGameStart()
	self:DisabledBtnContinuedBet(false)
end

function FunctionBtnView:EnterBetChip()
	self:DisabledBtnContinuedBet(true)
end

function FunctionBtnView:EnterOpenPrize()
	self:DisabledBtnContinuedBet(false)
end



function FunctionBtnView:OnClickHelp()
	AudioManager.GetInstance():PlayNormalAudio(27)
	HelpManager.GetInstance():IsShowHelpPanel(true)
end

function FunctionBtnView:OnClickVoice(isInit)
	self.isOpenMusic=not self.isOpenMusic
	self.isOpenEffect=not self.isOpenEffect
	if self.isOpenMusic then
		CommonHelper.SetActive(self.Voice_Open_Image_Obj,true)
		CommonHelper.SetActive(self.Voice_Close_Image_Obj,false)
	else
		CommonHelper.SetActive(self.Voice_Open_Image_Obj,false)
		CommonHelper.SetActive(self.Voice_Close_Image_Obj,true)
	end
	AudioManager.GetInstance():ResetBGMusic(self.isOpenMusic)
	LobbySettingSystem.GetInstance():SetMusicState(self.isOpenMusic)
	AudioManager.GetInstance():ResetSoundEffects(self.isOpenEffect)
	LobbySettingSystem.GetInstance():SetSoundEffectState(self.isOpenEffect)
	AudioManager.GetInstance():PlayNormalAudio(27)
	if isInit then return end
	-- AudioManager.GetInstance():PlayNormalAudio(7)
end

function FunctionBtnView:OnClickHangUp()
	AudioManager.GetInstance():PlayNormalAudio(27)
	BetChipManager.GetInstance():BeginMoveBetChipToWinArea(3)
end

function FunctionBtnView:OnClickReturn()
	AudioManager.GetInstance():PlayNormalAudio(27)
	GameUIManager.GetInstance():RequestQuitGameMsg()
end

function FunctionBtnView:OnClickContinuedBet()
	AudioManager.GetInstance():PlayNormalAudio(27)
	PlayerManager.GetInstance():RequestUserRepeatBetMsg()
end

function FunctionBtnView:DisabledBtnContinuedBet(isInteractable)
	self.ContinuedBetBtn.interactable = isInteractable
end

function FunctionBtnView:OnClickPlayerListRank()
	AudioManager.GetInstance():PlayNormalAudio(27)
	PlayerListRankManager.GetInstance():OpenPlayerListRankPanel()
end

function FunctionBtnView:GetOtherPlayerBetInitPos()
	return self.PlayerListRankBtn.transform.position
end

