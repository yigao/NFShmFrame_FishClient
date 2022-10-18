PlayerManager=Class()

local Instance=nil
function PlayerManager:ctor(obj)
	Instance=self
	self:Init(obj)
	
end


function PlayerManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:InitBulletUID()
	self:AddEventListenner()
end



function PlayerManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.ShowFishUIDMark=10000000000	--展示鱼使用的标记位
	self.PlayerSeatList={}
	self.PlayerInsList={}
	self.PlayerCount=6							--TODO 玩家数量
	self.PlayerBulletUIDBaseMultiple=10000		--玩家子弹基础倍率
	self.PlayerBulletUIDList={}
	
end

function PlayerManager:AddScripts()
	self.ScriptsPathList={
		"/View/Player/PlayerPanel/PlayerInfoPanel",
		"/View/Player/PlayerInfo/PlayerInfo",
		"/View/Player/PlayerInfo/Panel/PlayerPanel",
	}
end


function PlayerManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function PlayerManager:InitView(gameObj)
	self.gameObject=gameObj.transform:Find("GamePanel/GamePanel/PlayerSeat").gameObject
end


function PlayerManager:InitInstance()
	self.PlayerInfoPanel=PlayerInfoPanel.New(self.gameObject)
	self.PlayerInfo=PlayerInfo
	self.PlayerPanel=PlayerPanel
end


function PlayerManager:InitViewData()	
	self.PlayerSeatList=self.PlayerInfoPanel.PlayerSeatList
	
end


function PlayerManager:InitPlayerInfo(index,playerPrefab)
	CommonHelper.AddToParentGameObject(playerPrefab,self.PlayerSeatList[index])
	local playerIns=self.PlayerInfo.New(playerPrefab)
	playerIns:InitPlayerData(index)
	self.PlayerInsList[index]=playerIns
end


function PlayerManager:InitPlayerStateData(playerInfoList)
	local count=#playerInfoList
	if count>0 then
		for i=1,count do
			self:PlayerEnter(playerInfoList[i])
		end
	end
end


--清楚所有位置玩家状态
function PlayerManager:ClearAllPlayerState()
	for i=1,#self.PlayerInsList do
		self.PlayerInsList[i]:PlayerLeaveState()
	end
end


function PlayerManager:ClearOtherAllPlayerState()
	for i=1,#self.PlayerInsList do
		if(self.PlayerInsList[i].ChairdID~=self.gameData.PlayerChairId) then
			self.PlayerInsList[i]:PlayerLeaveState()
		else
			self.PlayerInsList[i]:ClearBulletCache()
			self.PlayerInsList[i]:SetAutoSendShootBullet(false)
			self.PlayerInsList[i]:SetOnlineState(false)
		end
	end
end


function PlayerManager:SyncPlayerState(syncData)
	local playerIns=self:GetPlayerInsByChairdId(syncData.chair_id)
	if playerIns then
		playerIns:SetAutoLockFish(syncData.lockfish_onoff)
		if syncData.lockfish_onoff and syncData.lockfish_uid>=0 then
			local tempFish=FishManager.GetInstance():GetUsingFishByFishUID(syncData.lockfish_uid)
			if tempFish then
				playerIns:SetLockFish(tempFish)
			end
			
		end
	else
		Debug.LogError("当前位置获取玩家异常==>"..syncData.chair_id)
	end
end




function PlayerManager:InitBulletUID()
	for i=1,self.PlayerCount do
		local tempMultiple=self.PlayerBulletUIDBaseMultiple*i
		table.insert(self.PlayerBulletUIDList,tempMultiple)
	end
end


function PlayerManager:InitGunLevelConfig(gunInfo)
	self.gameData.GunLevelConfig=gunInfo
end



--serverChairId 是服务端的座位号，玩家真实的位置
function PlayerManager:GetPlayerBulletUID(serverChairId)
	if serverChairId and serverChairId<=#self.PlayerBulletUIDList then
		return self.PlayerBulletUIDList[serverChairId]
	end
end


function PlayerManager:GetPlayerInsBySeatId(index)
	return self.PlayerInsList[index]
end

function PlayerManager:GetPlayerInsByChairdId(chairId)
	local playerIndex=GameManager.GetInstance():GetPlayerSeatByServerChairId(chairId)
	local playerIns=self:GetPlayerInsBySeatId(playerIndex)
	if playerIns then
		return playerIns
	else
		return nil
	end
end

function PlayerManager:SetPlayerChairID(index,chairId)
	self:GetPlayerInsBySeatId(index):SetPlayerChairID(chairId)
end




function PlayerManager:PlayerEnter(playerInfo)
	--pt(playerInfo)

	local playerIns=self:GetPlayerInsByChairdId(playerInfo.chair_id)
	if playerIns then
		self:IsShowWaitPlayerBG(playerInfo.chair_id,false)
		playerIns:PlayerEnterState(playerInfo)
	else
		Debug.LogError("当前位置玩家进入异常==>"..playerInfo.chair_id)
	end
end


function PlayerManager:OtherPlayerLeave(playerChairID)
	local playerIns=self:GetPlayerInsByChairdId(playerChairID)
	if playerIns then
		self:IsShowWaitPlayerBG(playerChairID,true)
		playerIns:PlayerLeaveState()
	else
		Debug.LogError("当前位置玩家离开异常==>"..playerChairID)
	end
end



function PlayerManager:ServerToClientLockTragetFishProcess(msgData)
	local tempPlayerIns=self:GetPlayerInsByChairdId(msgData.chairId)
	local tempFish=FishManager.GetInstance():GetUsingFishByFishUID(msgData.fishId)
	if tempPlayerIns and tempFish then
		tempPlayerIns:SetLockFish(tempFish)
	end
end


function PlayerManager:ServerToClientLockFishSwitchProcess(msgData)
	local tempPlayerIns=self:GetPlayerInsByChairdId(msgData.chairId)
	if tempPlayerIns then
		tempPlayerIns:SetAutoLockFish(msgData.onOff)
		tempPlayerIns:ResetLockTargetFishState(msgData.onOff)
		if msgData.chairId==self.gameData.PlayerChairId then
			GameSetManager.GetInstance().PlayerSetPanel:IsShowLockFishStatePanel(msgData.onOff)
		end
	end
end

function PlayerManager:IsShowWaitPlayerBG(chairId,isDisplay)
	local playerIndex=GameManager.GetInstance():GetPlayerSeatByServerChairId(chairId)
	self.PlayerInfoPanel:IsShowWaitPlayerBG(playerIndex,isDisPlay)
end



function PlayerManager:CancelLockFishState(chairId)
	self:GetPlayerInsByChairdId(chairId):UploadAutoLockFish(false)
end

function PlayerManager:ResetAllSeatWaitPlayerBG()
	self.PlayerInfoPanel:ResetAllSeatWaitPlayerBG()
end


function PlayerManager:GetRealGunLevel(level)
	local gunLevel=self.gameData.gameConfigList.GunConfigList[self.gameData.GunLevelConfig[level].cannon_value_gun_id].normalGunRes
	if gunLevel then
		return gunLevel
	else
		Debug.LogError("获取真实炮等级异常==>>>"..level)
		gunLevel=1	
		return gunLevel
	end
end




--------------------------------------------------------------handle事件回调-----------------------------------------------------

function PlayerManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_ChangeCannonRsp"),self.ResponesChangeGunMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_UserMoneyRsp"),self.ResponesChangePlayerMoneyMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_UserEnterDeskRsp"),self.ResponesPlayerEnterGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_UserLeaveDeskRsp"),self.ResponesPlayerLeaveGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DOUBLEGUNONOFF_RSP"),self.ResponesPlayerDoubleGunMsg,self)
end

function PlayerManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_ChangeCannonRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_UserMoneyRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_UserEnterDeskRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_UserLeaveDeskRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DOUBLEGUNONOFF_RSP"))
end


function PlayerManager:SendChangeGunMsg(gunIndex)
    local sendMsg={}
	sendMsg.cannon_id=gunIndex
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.ChangeCannonReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_ChangeCannonReq"),bytes)
end


function PlayerManager:ResponesChangeGunMsg(msg)
	--Debug.LogError("事件回调==>10020")
	local data=LuaProtoBufManager.Decode("Fish_Msg.ChangeCannonRsp",msg)
	--pt(data)
	self:SetChangeGun(data)
end


function PlayerManager:SetChangeGun(data)
	local playerIns=self:GetPlayerInsByChairdId(data.chair_id)
	if playerIns then
		playerIns:SetGunLevelValue(data.cannon_id)
		playerIns:SetGunParticleEffect()
	end
end


function PlayerManager:ResponesChangePlayerMoneyMsg(msg)
	--Debug.LogError("事件回调==>10022")
	local data=LuaProtoBufManager.Decode("Fish_Msg.UserMoneyRsp",msg)
	--pt(data)
	local playerIns=self:GetPlayerInsByChairdId(data.chair_id)
	if playerIns then
		playerIns:SetPlayerMoneyScore(data.user_money)
	end
end



function PlayerManager:ResponesPlayerEnterGameMsg(msg)
--	Debug.LogError("事件回调==>10028")
	local data=LuaProtoBufManager.Decode("Fish_Msg.UserEnterDeskRsp",msg)
--	pt(data)
	self:PlayerEnter(data.userInfo)
end

function PlayerManager:ResponesPlayerLeaveGameMsg(msg)
--	Debug.LogError("事件回调==>10030")
	local data=LuaProtoBufManager.Decode("Fish_Msg.UserLeaveDeskRsp",msg)
--	pt(data)
	self:OtherPlayerLeave(data.chair_id)
end


function PlayerManager:ResponesPlayerDoubleGunMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.DoubleGunOnOffRsp",msg)
	local playerIns=self:GetPlayerInsByChairdId(data.chairId)
	if playerIns then
		playerIns:DoubleGunOnOffState(data.onOff)
	end
end







function PlayerManager.GetInstance()
	return Instance
end



function PlayerManager:__delete()
	self:RemoveEventListenner()
	self.PlayerSeatList=nil
	self.PlayerInsList=nil
	self.PlayerCount=nil							
	self.PlayerBulletUIDBaseMultiple=nil		
	self.PlayerBulletUIDList=nil
	self.PlayerInfoPanel=nil
	self.PlayerInfo=nil
	self.PlayerPanel=nil	
	self.PlayerSeatList=nil
end