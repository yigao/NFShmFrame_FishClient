GameManager=Class(GameBaseController)

local Instance=nil
function GameManager:ctor(gameId)
	Instance=self
	Debug.LogError(gameId)
	self.gameId=gameId
	self:InitAddScripts()
end 

function GameManager.GetInstance()
	return Instance
end

function GameManager:InitAddScripts()
	self:AddScriptsPath("Common/GameConfig")
	self:AddScriptsPath("View/Vo/GameData")
	self:AddScriptsPath("Control/GameLogicManager")
	self:AddScriptsPath("State/StateManager")
	self:AddScriptsPath("Module/ModuleManager")
end




function GameManager:Init()
	self:BaseInit()
	self:InitData()
	self:InitInstance()
	self:AddEventListenner()
end

function GameManager:InitData()
	CommonHelper.SetGameFrameRate(60)
	self:InitUnityScripts()
	self.isGamePlaying=false
end


function GameManager:InitUnityScripts()
	self.Image=CS.UnityEngine.UI.Image
	self.Camera=CS.UnityEngine.Camera
	self.Canvas=CS.UnityEngine.Canvas
	self.Text=CS.UnityEngine.UI.Text
	self.Button=CS.UnityEngine.UI.Button
	self.Animation=CS.UnityEngine.Animation
	self.Animator=CS.UnityEngine.Animator
	self.Color=CS.UnityEngine.Color
	
end


function GameManager:InitInstance()
	self:LoadManifestFile(self.gameId)
	self.gameData=GameData.New()
	self.GameConfig=GameConfig.New()
	self.GameLogicManager=GameLogicManager.New()
	self.StateManager=StateManager.New()
	self.ModuleManager=ModuleManager.New()
end




function GameManager:GameAssetLoadCompleteCallBack()
	BaseFctManager.GetInstance():InitSoundState()
	GameUIManager.GetInstance():IsShowGamePanel(true)
	AudioManager.GetInstance():PlayBGAudio(1,0.3)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.LoadGameAssetsComplete_EventName,false,self.gameData.gameConfigList.RoomConfig_1003List)
end
 


--------------------------------------------------------Handle事件回调----------------------------------------------------------

function GameManager:AddEventListenner()
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.Network_Reconnect_Succeed_EventName,self.ResetGameState,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.EnterGame_EventName,self.RoomEnterGameCallBack,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.UnloadGameAssets_EventName,self.ClearGameResources,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterGameRsp"),self.EnterGame,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_GameStatusRsp"),self.SyncGameState,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.OpenGameIntroduction_EventName,self.OpenHelpPanel,self)
end


function GameManager:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.EnterGame_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.UnloadGameAssets_EventName)
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_GameStatusRsp"))
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.OpenGameIntroduction_EventName)
end


function GameManager:ResetGameState()
	if LuaStateControl.GetInstance():GetCurrentStateType() == LuaStateControl.StateType.Game then
		CommonHelper.ClearNetMsgQueue()
		GameUIManager.GetInstance():RequestSyncGameStateMsg()
		self.isGamePlaying=true
	end
end


function GameManager:RoomEnterGameCallBack(roomID,deskID,chairID,isAutoAllotRoom,roomEnterGameCallBack)
	local sendMsg={}
	sendMsg.game_id=self.gameId
	sendMsg.room_id=roomID
	sendMsg.desk_id=deskID
	sendMsg.chair_id=chairID
	self.isAutoAllotRoom = isAutoAllotRoom
	self.roomEnterGameCallBack=roomEnterGameCallBack
	pt(sendMsg)
	local bytes = LuaProtoBufManager.Encode("Link_Msg.EnterGameReq",sendMsg)
	self:SendLobbyNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_CS_MSG_EnterGameReq"),bytes)
end

function GameManager:EnterGame(msg)
	Debug.LogError("事件回调==>1020")
	local data=LuaProtoBufManager.Decode("Link_Msg.EnterGameRsp",msg)
	pt(data)
	
	self:SetBaseDeskInfoState(data)
	
end


function GameManager:SetBaseDeskInfoState(data)
	if data.result==0 then
		GameUIManager.GetInstance():RequestSyncGameStateMsg()
	else
		Debug.LogError("进入游戏错误ErrorID==>"..data.result)
		--self:ShowUITips("进入游戏错误ErrorID==>"..data.result,3)
		if self.isAutoAllotRoom then
			local ExitGameCallBack = function()
				GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.EnterGameFailure_EventName)
			end
			XLuaUIManager.GetInstance():OpenMessageBox(HallLuaDefine.Client_Failure_Code.C_EnterGame_Failure_Error,true,false,false,ExitGameCallBack,nil,nil)
		else
			self:EnterGameErrorTips(data.result)
		end
	end
	
end


function GameManager:EnterGameErrorTips(errorId)
	if errorId and errorId>0 then
		local str = HallLuaDefine.Tips_Info_Str[errorId]
		if str then
			self:ShowUITips(str,2)
		end
	end
end




function GameManager:SyncGameState(msg)
	Debug.LogError("事件回调==>10002")
	local data=LuaProtoBufManager.Decode("Link_Msg.GameStatusRsp",msg)
	pt(data)
	local isScucess=BaseFctManager.GetInstance():InitBetInfo(data)
	if isScucess then return end
	BaseFctManager.GetInstance():SetPlayerMoney(data.userMoney)
	self.gameData.PlayerMoney=data.userMoney
	BaseFctManager.GetInstance():SetPlayerName(data.userName)
	self:InitGameState(data.gameType)
	if self.roomEnterGameCallBack then
		self.roomEnterGameCallBack()
	end
end



function GameManager:InitGameState(gameType)
	Debug.LogError("当前游戏状态为：==>"..gameType)
	if gameType>0 then
		StateManager.GetInstance():SetNextMainStation(gameType+1)
		if gameType==StateManager.MainState.FreeGame-1 then
			GameLogicManager.GetInstance():IsFreeGameProcess()
		end
	else
		self.isGamePlaying=false
		StateManager.GetInstance():SetNextMainStation(StateManager.MainState.Normal)
	end
	
end


function GameManager:OpenHelpPanel()
	BaseFctManager.GetInstance():OpenHelpPanel()
end



function GameManager:ClearGameResources()
	BaseFctManager.GetInstance():BaseResetState()
	self:Destroy()
end



function GameManager:__delete()
	self:RemoveEventListenner()
	ModuleManager.GetInstance():RemoveCurrentGameSpriteAtlas()
	GameUIManager.GetInstance():Destroy()
	
	self:UnloadManifestAssetBundle(self.gameId,true)
	
	self:UnloadScripts()
	
end