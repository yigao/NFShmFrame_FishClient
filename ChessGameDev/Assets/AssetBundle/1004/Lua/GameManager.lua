GameManager=Class(GameBaseController)

local Instance=nil
function GameManager:ctor(gameId)
	Instance=self
	self.gameId=gameId
	self:InitAddScripts()
end 

function GameManager.GetInstance()
	return Instance
end

function GameManager:InitAddScripts()
	self:AddScriptsPath("Config/GameConfig")
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
	self:InitUnityScripts()
	self.isGamePlaying=false
	self.isGameing=false
end


function GameManager:InitUnityScripts()
	self.Image=CS.UnityEngine.UI.Image
	self.Camera=CS.UnityEngine.Camera
	self.Canvas=CS.UnityEngine.Canvas
	self.Text=CS.UnityEngine.UI.Text
	self.Button=CS.UnityEngine.UI.Button
	self.Animation=CS.UnityEngine.Animation
	self.Animator=CS.UnityEngine.Animator
	self.SkeletonGraphic=CS.Spine.Unity.SkeletonGraphic
	
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
	AudioManager.GetInstance():PlayNormalAudio(1)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.LoadGameAssetsComplete_EventName,false,self.gameData.gameConfigList.RoomConfig_1004List)
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
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.Network_Reconnect_Succeed_EventName)
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
		LobbyPaoMaDengSystem.GetInstance():ResetPaoMaDengState(false)
		LobbyPaoMaDengSystem.GetInstance():CloseForm()
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
	self:InitGameConfigData(data)
	local isScucess=BaseFctManager.GetInstance():InitBetInfo(data)
	if isScucess then return end
	BaseFctManager.GetInstance():SetPlayerMoney(data.userMoney)
	self.gameData.PlayerMoney=data.userMoney
	BaseFctManager.GetInstance():SetPlayerName(data.userName)
	self:InitGameState(data.gameType)
	CommonHelper.SetScreenOrientation(true)
	if self.roomEnterGameCallBack then
		self.roomEnterGameCallBack()
	end
end



function GameManager:InitGameConfigData(data)
	if data.PrezeItems then
		pt(data.PrezeItems)
		self.gameData.GameBetToChangeOtherDataList=data.PrezeItems
	end
	
	if self.isGameing==false then
		if data.RollerMousePrizeTypes and #IconManager.GetInstance().PrizeTypeInsList<=0 then
			IconManager.GetInstance():InitSelectionIocnControlData(1,data.RollerMousePrizeTypes,true)
			IconManager.GetInstance():InitSelectionPrizeTypeInsList()
		end
		IconManager.GetInstance():StartSelectionIconRun(1,0.05)
		
		if data.RollerGoldenMousePrizeTypes then
			IconManager.GetInstance():InitSelectionIocnControlData(2,data.RollerGoldenMousePrizeTypes,false)
		end
	end
	
	if data.cols then
		GameUIManager.GetInstance():ParseGameIconResult(data.cols)
		for i=1,5 do
			local iconRandomValue=math.random(0,10)
			table.insert(self.gameData.GameIconResult[i],1,iconRandomValue)
		end
		pt(self.gameData.GameIconResult)
		if IconManager.GetInstance().AllIconItemInsList and #IconManager.GetInstance().AllIconItemInsList==0 then
			IconManager.GetInstance():InitAllIconItem(self.gameData.GameIconResult)
		end
	else
		Debug.LogError("初始化游戏结果异常")
	end
	pt(data.freezedPos)
	if data.freezedPos then
		GameUIManager.GetInstance(): ParseSLBMaskIcon(data.freezedPos)
	end
	
	if self.isGameing==false then self.isGameing=true end
		
	
end





function GameManager:InitGameState(gameType)
	Debug.LogError("当前游戏状态为：==>"..gameType)
	if gameType>0 then
		StateManager.GetInstance():SetNextMainStation(gameType)
		if gameType==StateManager.MainState.FreeGame then
			GameLogicManager.GetInstance():IsFreeGameProcess()
		elseif gameType==StateManager.MainState.SLB then
			GameLogicManager.GetInstance():SetSLBNormalIconChangeMask()
			GameLogicManager.GetInstance():IsSLBProcess()
		--elseif gameType==StateManager.MainState.Jackpot then
			
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
	self.isGameing=false
	self:RemoveEventListenner()
	ModuleManager.GetInstance():RemoveCurrentGameSpriteAtlas()
	GameUIManager.GetInstance():Destroy()
	
	self:UnloadManifestAssetBundle(self.gameId,true)
	
	self:UnloadScripts()
	CommonHelper.SetScreenOrientation(false)
	LobbyPaoMaDengSystem.GetInstance():ResetPaoMaDengState(true)
end