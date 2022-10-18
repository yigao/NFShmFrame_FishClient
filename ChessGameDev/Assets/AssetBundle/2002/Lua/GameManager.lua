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
	self:AddScriptsPath("Common/GameConfig")
	self:AddScriptsPath("EventMsg/FishEventParams")
	self:AddScriptsPath("View/Vo/GameData")
	self:AddScriptsPath("View/GameUIManager")
	self:AddScriptsPath("View/Pool/GameObjectPoolManager")
	self:AddScriptsPath("View/Fish/FishManager")
	self:AddScriptsPath("View/Bullet/BulletManager")
	self:AddScriptsPath("View/Player/PlayerManager")
	self:AddScriptsPath("View/Net/NetManager")
	self:AddScriptsPath("View/ResourcesManager/ResourcesManager")
	self:AddScriptsPath("View/Bomb/BombManager")
	self:AddScriptsPath("View/Effect/GoldEffect/GoldEffectManager")
	self:AddScriptsPath("View/Effect/ScoreEffect/ScoreEffectManager")
	self:AddScriptsPath("View/Effect/PlusTipsEffect/PlusTipsEffectManager")
	self:AddScriptsPath("View/Effect/BigAwardTipsEffect/BigAwardTipsEffectManager")
	self:AddScriptsPath("View/Effect/FishEffect/FishEffectManager")
	self:AddScriptsPath("View/Effect/FishOutTipsEffect/FishOutTipsEffectManager")
	self:AddScriptsPath("View/Effect/LightningEffect/LightningEffectManager")
	self:AddScriptsPath("View/Set/GameSetManager")
	self:AddScriptsPath("View/Audio/AudioManager")
end




function GameManager:Init()
	self:BaseInit()
	self:InitData()
	self:InitInstance()
	
end

function GameManager:InitData()
	--CommonHelper.SetGameFrameRate(45)
	self:InitUnityScripts()
	self.gameData=nil
	self.IsFocus=true		
	self.gamePrefabPath="Prefabs/Game/GamePanel.prefab"
	
end

function GameManager:InitUnityScripts()
	self.Image=CS.UnityEngine.UI.Image
	self.Camera=CS.UnityEngine.Camera
	self.Canvas=CS.UnityEngine.Canvas
	self.Text=CS.UnityEngine.UI.Text
	self.Button=CS.UnityEngine.UI.Button
	self.Animation=CS.UnityEngine.Animation
	self.SkinnedMeshRenderer=CS.UnityEngine.SkinnedMeshRenderer
	self.SphereCollider=CS.UnityEngine.SphereCollider
	self.SpriteAtlas=CS.UnityEngine.U2D.SpriteAtlas
	self.Texture2D = CS.UnityEngine.Texture2D
end

function GameManager:InitInstance()
	self:LoadManifestFile(self.gameId)
	self.gameData=GameData.New()
	self.gameData.GameConfig=GameConfig.New()
	ResourcesManager.GetInstance():CorotineLoadResources()
	
end


function GameManager:InitGameGroup()
	local gameObj=self:LoadGameResuorce(self.gamePrefabPath,false,true)
	if gameObj then
		local gameObject=CommonHelper.Instantiate(gameObj)
		self.gameObject=gameObject
		self:InitView(gameObject)
	else
		--TODO 加载失败跳回大厅
		
	end
end






function GameManager:InitView(gameObj)
	self.gameObject=gameObj
	--self:IsShowGamePanel(false)
	self.gameUIManager=GameUIManager.New(gameObj)
	self:AddEventListenner()
	
end


function GameManager:IsShowGamePanel(isdisplay)
	CommonHelper.SetActive(self.gameObject,isdisplay)
end



function GameManager:LoadResourcesCompleteCallBack()
	self:GameAssetLoadCompleteCallBack()
end


function GameManager:GameAssetLoadCompleteCallBack()
	GameSetManager.GetInstance():ResetGameSetState()
	AudioManager.GetInstance():PlayBGAudio(22)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.LoadGameAssetsComplete_EventName,false,self.gameData.gameConfigList.RoomConfigList)
end


function GameManager:LoadBinaryTraceFile(trackeCallBack)
	local isRotation=false
	if self.gameUIManager.gameData.PlayerChairId>=3 then
		isRotation=true
	end
	--TODO判断玩家位置，计算炮台方向
	CS.FishManager.AccordingDeskLoadBinaryTraceFile(self.gameId,isRotation,trackeCallBack)
end




--------------------------------------------------------Handle事件回调----------------------------------------------------------

function GameManager:AddEventListenner()
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.Network_Reconnect_Succeed_EventName,self.ResetGameState,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.EnterGame_EventName,self.RoomEnterGameCallBack,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.UnloadGameAssets_EventName,self.ClearGameResources,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_EnterGameRsp"),self.EnterGame,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_GameStatusRsp"),self.ResponesStateSyncMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_UserStatusRsp"),self.ResponesUserStateMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_ChangeSceneRsp"),self.ResponesChangeSceneMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_PROMPTINFO_RSP"),self.ResponesSceneFishOutTipsMsg,self)
end


function GameManager:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.Network_Reconnect_Succeed_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.EnterGame_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.UnloadGameAssets_EventName)
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_EnterGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_GameStatusRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_UserStatusRsp"))
	
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_ChangeSceneRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_PROMPTINFO_RSP"))
end



function GameManager:OnApplicationFocus(isFocus)
	if(isFocus) then
		CommonHelper.ClearNetMsgQueue()
		self:ResetGameState()
	else
		PlayerManager.GetInstance():CancelLockFishState(self.gameData.PlayerChairId)
		self.IsFocus=isFocus
		GameSetManager.GetInstance():ResetGameState()
	end
	
end


function GameManager:ResetGameState()
	if LuaStateControl.GetInstance():GetCurrentStateType() == LuaStateControl.StateType.Game then
		GameSetManager.GetInstance():ResetGameState()
		self:SendStateSyncMsg()
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
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.EnterGameReq",sendMsg)
	self:SendLobbyNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_EnterGameReq"),bytes)
	
end



function GameManager:EnterGame(msg)
	--Debug.LogError("事件回调==>1020")
	local data=LuaProtoBufManager.Decode("Fish_Msg.EnterGameRsp",msg)
	--pt(data)
	self:SetBaseDeskInfoState(data)	
	
end


function GameManager:SyncGameState()
	
	local trackeCompleteCallBack=function ()
		self:SendStateSyncMsg()
	end
	self:LoadBinaryTraceFile(trackeCompleteCallBack)
	
end

--同步状态信息
function GameManager:SendStateSyncMsg()
	local sendMsg={}
	sendMsg.gameId=self.gameId	
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.GameStatusReq",sendMsg)
	self:SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_GameStatusReq"),bytes)
end

function GameManager:ResponesStateSyncMsg(msg)
	--Debug.LogError("事件回调==>10002")
	local data=LuaProtoBufManager.Decode("Fish_Msg.GameStatusRsp",msg)
	--pt(data)
	self:SyncDeskInfoState(data)
end

function GameManager:SyncGameScene(sceneId)
	self.gameUIManager:SysncGameSceneBG((sceneId))
	AudioManager.GetInstance():PlayBGAudio(22 + sceneId)
end

function GameManager:SetBaseDeskInfoState(data)
	if data.result==0 then
		self.gameUIManager.gameData.PlayerTotalCount=data.chair_count
		self.gameUIManager.gameData.PlayerChairId=data.my_chair_id
		self:SyncGameState()
		CommonHelper.AddOnApplicationFocus(self.OnApplicationFocus,self)
	else
		Debug.LogError("进入游戏错误ErrorID==>"..data.result)
		--self:ShowUITips("进入游戏错误ErrorID==>"..data.result,2)
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

function GameManager:SyncDeskInfoState(data)
	if data.cannonlist then
		PlayerManager.GetInstance():InitGunLevelConfig(data.cannonlist)
	else
		Debug.LogError("初始化玩家炮值异常")
		self:ShowUITips("初始化玩家炮值异常",3)
		return nil
	end
	
	if data.userlist then
		PlayerManager.GetInstance():InitPlayerStateData(data.userlist)
	else
		Debug.LogError("初始化玩家信息失败")
		self:ShowUITips("初始化玩家信息失败",3)
		return nil
	end
	
	if data.background_index then
		self:SyncGameScene(data.background_index)
	end
	
	if self.roomEnterGameCallBack then
		self.roomEnterGameCallBack()
	end

	if self.IsFocus==false then
		self.IsFocus=true
	end
end


function GameManager:ResponesUserStateMsg(msg)
	--Debug.LogError("事件回调==>10018")
	local data=LuaProtoBufManager.Decode("Fish_Msg.UserStatusRsp",msg)
	--pt(data.userstatuslist)
	self:SyncUserState(data)
end


function GameManager:SyncUserState(data)
	if data.userstatuslist then
		for i=1,#data.userstatuslist do
			PlayerManager.GetInstance():SyncPlayerState(data.userstatuslist[i])
		end
	end
end





function GameManager:ResponesChangeSceneMsg(msg)
	Debug.LogError("事件回调==>10024")
	local data=LuaProtoBufManager.Decode("Fish_Msg.ChangeSceneRsp",msg)
	self.gameUIManager:ChangeGameScene(data)
end



function GameManager:ResponesSceneFishOutTipsMsg(msg)
	
	local data=LuaProtoBufManager.Decode("Fish_Msg.PromptInfoRsp",msg)
	--pt(data.infoType)
	--self.gameUIManager:SceneFishOutTips(data.infoType,data.fishKindId)
end







function GameManager:ClearGameResources()
	GameSetManager.GetInstance():ResetGameState()
	self:Destroy()
	
end



function GameManager:__delete()
	ResourcesManager.GetInstance():RemoveCurrentGameSpriteAtlas()
	self:RemoveEventListenner()
	CommonHelper.RemoveOnApplicationFocus()
	BulletManager.GetInstance():Destroy()
	FishManager.GetInstance():Destroy()
	PlayerManager.GetInstance():Destroy()
	GameSetManager.GetInstance():Destroy()
	GameObjectPoolManager.GetInstance():Destroy()
	AudioManager.GetInstance():Destroy()
	ResourcesManager.GetInstance():Destroy()
	FishOutTipsEffectManager.GetInstance():Destroy()
	GameUIManager.GetInstance():Destroy()
	
	self:UnloadManifestAssetBundle(self.gameId,true)
	
	self:UnloadScripts()
	CommonHelper.Destroy(self.gameObject)
	
end


