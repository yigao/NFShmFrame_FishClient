GameSetManager=Class()

local Instance=nil
function GameSetManager:ctor()
	Instance=self
	self:Init()
	
end

function GameSetManager.GetInstance()
	if Instance==nil then
		GameSetManager.New()
	end
	return Instance
end


function GameSetManager:Init ()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView()
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end



function GameSetManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	
	
end

function GameSetManager:AddScripts()
	self.ScriptsPathList={
		"View/Set/PlayerSet/PlayerSetPanel",
		"View/Set/GameSet/MainPanel",
		"View/Set/GameSet/FishDescriptionPanel",
		"View/Set/GameSet/SystemSetPanel",
	}
end


function GameSetManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function GameSetManager:InitView()
	
end


function GameSetManager:InitInstance()
	
	
end


function GameSetManager:InitPlayerSetPanel(gameObj)
	self.PlayerSetPanel=PlayerSetPanel.New(gameObj)
	self.MainPanel=MainPanel.New(gameObj)
	self.FishDescriptionPanel=FishDescriptionPanel.New(gameObj)
	self.SystemSetPanel=SystemSetPanel.New(gameObj)
end


function GameSetManager:InitViewData()	
	
	
end


function GameSetManager:AddEventListenner()
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.OpenGameIntroduction_EventName,self.OpenFishRule,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_ExitGameRsp"),self.ResponesQuitGameMsg,self)
end


function GameSetManager:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.OpenGameIntroduction_EventName)
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_ExitGameRsp"))
end

function GameSetManager:ResetGameSetState()
	self.SystemSetPanel:ResetSoundState()
end


function GameSetManager:ResetGameSetPanel()
	self.PlayerSetPanel:InitViewData()
	self.MainPanel:InitViewData()
	self.PlayerSetPanel:SetLockFishBtnDisable(true)
	self.PlayerSetPanel:SetSpeedBtnDisable(true)
	GameUIManager.GetInstance():IsGamePress(true)
end


function GameSetManager:SendQuitGameMsg()
	local sendMsg={}
	sendMsg.reserved=2004	--谁便填
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.ExitGameReq",sendMsg)
	GameManager.GetInstance():SendLobbyNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_ExitGameReq"),bytes)
end



function GameSetManager:ResponesQuitGameMsg(msg)
	Debug.LogError("事件回调==>1024")
	local data=LuaProtoBufManager.Decode("Fish_Msg.ExitGameRsp",msg)
	pt(data)
	self:QuitGameProcess(data)
end

function GameSetManager:QuitGameProcess(data)
	if data.exit_type==0 then
		self:QuitGame()
	else
		Debug.LogError("退出游戏失败==>"..data.exit_type)
	end
end



function GameSetManager:OpenFishRule()
	self.MainPanel:OnclickFishRuleBtn()
end


function GameSetManager:QuitGame()
	local QuitGameFunc=function ()
		self:ResetGameSetPanel()
		PlayerManager.GetInstance():ClearAllPlayerState()
		FishManager.GetInstance():ClearAllUsingFish()
		ScoreEffectManager.GetInstance():ClearAllScoreEffect()
		BulletManager.GetInstance():ClearAllBullet()
		CS.DG.Tweening.DOTween.KillAll()
		yield_return(WaitForSeconds(0.1))
		PlayerManager.GetInstance():ResetAllSeatWaitPlayerBG()
		GoldEffectManager.GetInstance():ClearAllGoldEffect()
		PlusTipsEffectManager.GetInstance():ClearAllPlusTipsEffect()
		SpecialDeclareEffectManager.GetInstance():ClearAllSpecialDeclareEffect()
		SpiderCrabEffectManager.GetInstance():ClearSpiderCrabBossScoreEffect()
		SpiderCrabEffectManager.GetInstance():ClearSpiderCrabBossHurtEffect()
		FishEffectManager.GetInstance():ClearAllFishEffect()
		FishOutTipsEffectManager.GetInstance():ClearAllFishOutTipsEffect()
		LightningEffectManager.GetInstance():ClearAllLightningEffect()
		ElectricSkillManager.GetInstance():ClearAllElectricSkill()
		FireStormSkillManager.GetInstance():ClearAllFireStormSkill()
		DrillSkillManager.GetInstance():ClearAllDrillSkill()
		--SerialDrillSkillManager.GetInstance():ClearAllPlusTipsEffect()
		BisonSkillManager.GetInstance():ClearAllBisonSkill()
		BombSkillManager.GetInstance():ClearAllBombSkill()
		MultBombSkillManager.GetInstance():ClearAllMultBombSkill()
		BulletManager.GetInstance():ClearAllBullet()
		TimerManager.GetInstance():RecycleAllTimerIns()
		AudioManager.GetInstance():StopAllNormalAudio()
		CommonHelper.RemoveOnApplicationFocus()
		GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.QuitGame_EventName)
	end
	startCorotine(QuitGameFunc)
end




function GameSetManager:ResetGameState()
	StopAllCorotines()
	self:ResetGameSetPanel()
	PlayerManager.GetInstance():ClearAllPlayerState()
	FishManager.GetInstance():ClearAllUsingFish()
	ScoreEffectManager.GetInstance():ClearAllScoreEffect()
	BulletManager.GetInstance():ClearAllBullet()
	BulletManager.GetInstance():ClearAllBullet()
	TimerManager.GetInstance():RecycleAllTimerIns()
	AudioManager.GetInstance():StopAllNormalAudio()
	
	PlayerManager.GetInstance():ResetAllSeatWaitPlayerBG()
	GoldEffectManager.GetInstance():ClearAllGoldEffect()
	PlusTipsEffectManager.GetInstance():ClearAllPlusTipsEffect()
	SpecialDeclareEffectManager.GetInstance():ClearAllSpecialDeclareEffect()
	SpiderCrabEffectManager.GetInstance():ClearSpiderCrabBossScoreEffect()
	SpiderCrabEffectManager.GetInstance():ClearSpiderCrabBossHurtEffect()
	FishEffectManager.GetInstance():ClearAllFishEffect()
	FishOutTipsEffectManager.GetInstance():ClearAllFishOutTipsEffect()
	LightningEffectManager.GetInstance():ClearAllLightningEffect()
	ElectricSkillManager.GetInstance():ClearAllElectricSkill()
	FireStormSkillManager.GetInstance():ClearAllFireStormSkill()
	DrillSkillManager.GetInstance():ClearAllDrillSkill()
	BisonSkillManager.GetInstance():ClearAllBisonSkill()
	BombSkillManager.GetInstance():ClearAllBombSkill()
	MultBombSkillManager.GetInstance():ClearAllMultBombSkill()
	
	
	GameManager.GetInstance().IsFocus=false
end


function GameSetManager:__delete()
	self:RemoveEventListenner()
	self.PlayerSetPanel=nil
	self.MainPanel=nil
	self.FishDescriptionPanel=nil
	self.SystemSetPanel=nil
end