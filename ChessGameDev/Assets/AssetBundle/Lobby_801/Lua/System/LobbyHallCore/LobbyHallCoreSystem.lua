LobbyHallCoreSystem = Class()

local Instance=nil
function LobbyHallCoreSystem:ctor()
	Instance=self
	self:Init()
end


function LobbyHallCoreSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyHallCoreSystem.New()
	end
	return Instance
end

function LobbyHallCoreSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbyHallCore/LobbyHallCoreView",
		"H/Lua/System/LobbyHallCore/LobbyHallFishModulePanel",
		"H/Lua/System/LobbyHallCore/LobbyHallArcadeModulePanel",
		"H/Lua/System/LobbyHallCore/LobbyHallChessModulePanel",
		"H/Lua/System/LobbyHallCore/LobbyGameItem/LobbyGameItem",
		"H/Lua/System/LobbyHallCore/LobbyPlayerInfoVo",
		"H/Lua/System/LobbyRoom/LobbyRoomSystem",
		"H/Lua/System/LobbyEmail/LobbyEmailSystem",
		"H/Lua/System/LobbyBank/LobbyBankSystem",
		"H/Lua/System/LobbyRankList/LobbyRankListSystem",
		"H/Lua/System/LobbySetting/LobbySettingSystem",
		"H/Lua/System/LobbyPersonalInformation/LobbyPersonalInformationView",
		"H/Lua/System/ComUI/LobbyNotice/LobbyNoticeSystem",
		"H/Lua/System/LobbyPersonalChangeHeadIcon/LobbyPersonalChangeHeadIconSystem",
		"H/Lua/System/ComUI/LobbyPaoMaDeng/LobbyPaoMaDengSystem",
		"H/Lua/System/LobbyBindMobilePhone/LobbyBindMobilePhoneSystem",
	}
end

function LobbyHallCoreSystem:LoadPB()
	LuaProtoBufManager.LoadProtocFiles("H/Lua/System/LobbyHallCore/Proto/proto_lobby")
end


function LobbyHallCoreSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function LobbyHallCoreSystem:Init()
	self.GameType = {
		None=0,
		Arcade = 1, --街机
		Fish = 2,	--捕鱼
		Chess = 3,	--棋牌
		Hundred = 4,--押分
	}
	self.curSelectGameType = self.GameType.None
	self.roomExcelData = nil

	self:LoadPB()
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:AddEventListenner()
	self:GetGameItemConfigData()
	
	LobbyEmailSystem.GetInstance()
	self.hallCoreView = LobbyHallCoreView.New()
	self.hallFishModulePanel = LobbyHallFishModulePanel.New()
	self.hallArcadeModulePanel = LobbyHallArcadeModulePanel.New()
	self.hallChessModulePanel = LobbyHallChessModulePanel.New()
	self.playerInfoVo = LobbyPlayerInfoVo.New()
	self.personalInformationView = LobbyPersonalInformationView.New()
end

function LobbyHallCoreSystem:LoginSwitchToLobby(args)
	self:ParseComData(args)

	self:OpenForm()
end

function LobbyHallCoreSystem:RoomSwitchToLobby()
	self.roomExcelData = nil

	self:OpenForm()
	LobbyAudioManager.GetInstance():RestoreAudioListenter(true)
	LobbyAudioManager.GetInstance():PlayBGAudio(1)

	if self.curSelectGameType == LobbyHallCoreSystem.GetInstance().GameType.Fish then
		self.hallCoreView:FishModuleOnPointerClick()
	elseif self.curSelectGameType == LobbyHallCoreSystem.GetInstance().GameType.Arcade then
		self.hallCoreView:ArcadeModuleOnPointerClick()
	end
end


function LobbyHallCoreSystem:GetGameItemConfigData()
	self.gameItemDataList = {}
	self.gameItemDataTypeMap = {}
	self.gameItemDataList = LobbyManager.GetInstance().gameData.lobbyExcelConfigList.Lobby_GameItemConfigList
end

function LobbyHallCoreSystem:ParseComData(args)
	self.playerInfoVo:SetUserDetailCommonData(args)	
end


function LobbyHallCoreSystem:OpenForm(  )
	self.hallCoreView:OpenForm()

	LobbyNoticeSystem.GetInstance():Open()
	LobbyPaoMaDengSystem.GetInstance():Open()
	
end

function LobbyHallCoreSystem:CloseForm(  )
	self.hallCoreView:CloseForm()
end

function LobbyHallCoreSystem:AddEventListenner(  )
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_ChangeFaceRsp"),self.ResponesHeadImageMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_PlayerPhoneAutoCodeRsp"),self.ResponsePlayerPhoneAutoCodeMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_PlayerCheckPhoneCodeRsp"),self.ResponsePlayerCheckPhoneCodeMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_CS_MSG_BIND_PHONE_RSP"),self.ResponseBindPhoneCodeMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_MoneyChangeNotify"),self.ResponseMoneyChangeMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_PaoMaDengNotify"),self.ResponsePaoMaDengNotifyMsg,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.EnteGameRoom_EventName,self.BeginEnterGameRoom,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.GameNewEmailTips_EventName,self.IsDisplayEmailPoint,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.Reutun_To_Login_EventName,self.LobbySwtichToLogin,self)
end

function LobbyHallCoreSystem:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_ChangeFaceRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_PlayerPhoneAutoCodeRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_PlayerCheckPhoneCodeRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_CS_MSG_BIND_PHONE_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_MoneyChangeNotify"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_SC_MSG_PaoMaDengNotify"))
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.EnteGameRoom_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.GameNewEmailTips_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.Reutun_To_Login_EventName)
end

function LobbyHallCoreSystem:RequestHeadImageMsg(head_id)
	local sendMsg={}
	sendMsg.face_id = head_id
	local bytes = LuaProtoBufManager.Encode("proto_lobby.Proto_CSChangeFaceReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_CS_MSG_ChangeFaceReq"),bytes)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
end

function LobbyHallCoreSystem:ResponesHeadImageMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_lobby.Proto_SCChangeFaceRsp",msg)
	if  data.result == 0 then
		LobbyHallCoreSystem.GetInstance().playerInfoVo:SetGameHeadImage(data.face_id)
		self.personalInformationView:RefreshUIComponent()
		self.hallCoreView:ShowUserInfoPanel()
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end


function LobbyHallCoreSystem:RequestPlayerPhoneAutoCodeMsg(phoneNumber,verificationCodeType)
	local sendMsg={}
	sendMsg.phone_num = phoneNumber
	sendMsg.code_type = verificationCodeType
	local bytes = LuaProtoBufManager.Encode("proto_lobby.Proto_CS_Player_PhoneAutoCodeReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_CS_MSG_PlayerPhoneAutoCodeReq"),bytes)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
end


function LobbyHallCoreSystem:ResponsePlayerPhoneAutoCodeMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_lobby.Proto_SC_Player_PhoneAutoCodeRsp",msg)
	if data.result == 0 then
		if data.code_type == HallLuaDefine.PhoneCodeType.Bind_Phone_Code then --绑定手机获取验证码
			LobbyBindMobilePhoneSystem.GetInstance().bindMobilePhoneView:IsReceiveVerificationCode(true)
		elseif data.code_type == HallLuaDefine.PhoneCodeType.Change_Bank_Password then --修改银行密码获取验证码
			LobbyBankSystem.GetInstance().bankVerifyPhoneView:IsReceiveVerificationCode(true)
		end
		XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.Send_Verification_Code_Succeed)
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end	
end

function LobbyHallCoreSystem:RequestPlayerCheckPhoneCodeMsg(phoneNumber,code)
	local sendMsg={}
	sendMsg.phone_num = phoneNumber
	sendMsg.auth_code = code
	local bytes = LuaProtoBufManager.Encode("proto_lobby.Proto_CS_Player_CheckPhoneCodeReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_CS_MSG_PlayerCheckPhoneCodeReq"),bytes)	
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
end

function LobbyHallCoreSystem:ResponsePlayerCheckPhoneCodeMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_lobby.Proto_SC_Player_CheckPhoneCodeRsp",msg)
	if data.result == 0 then
		if data.code_type == HallLuaDefine.PhoneCodeType.Bind_Phone_Code then --绑定手机检测验证码
			LobbyBindMobilePhoneSystem.GetInstance().bindMobilePhoneView:SendBindPhoneMsg()
		elseif data.code_type == HallLuaDefine.PhoneCodeType.Change_Bank_Password then --修改银行密码检测验证码
			LobbyBankSystem.GetInstance().bankVerifyPhoneView:CloseForm()
			LobbyBankSystem.GetInstance().bankResetPasswordView:OpenForm()
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end	
end

function LobbyHallCoreSystem:RequestBindPhoneMsg(data)
	local sendMsg={}
	sendMsg.phone_num = data.phone_num
	sendMsg.nick_name = data.nick_name
	sendMsg.password = data.password
	sendMsg.device_id = data.device_id
	local bytes = LuaProtoBufManager.Encode("proto_lobby.Proto_CS_Player_BindPhoneReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_lobby.Proto_LOBBY_CS_CMD","NF_CS_MSG_BIND_PHONE_REQ"),bytes)	
end

function LobbyHallCoreSystem:ResponseBindPhoneCodeMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_lobby.Proto_SC_Player_BindPhoneRsp",msg)
	if data.result == 0 then
		self.playerInfoVo:SetNickName(data.nick_name)
		self.playerInfoVo:SetPhoneNumber(data.phone_num)
		LobbyBindMobilePhoneSystem.GetInstance():CloseForm()
		XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.Bind_Phone_Succeed)
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end	
end


function LobbyHallCoreSystem:ResponseMoneyChangeMsg(msg)
	local data=LuaProtoBufManager.Decode("proto_lobby.MoneyChangeNotify",msg)
	self.playerInfoVo:SetLobbyMoney(data.cur_money,data.cur_bank_money)
	self.hallCoreView:ShowMoneyPanel()
end

function LobbyHallCoreSystem:ResponsePaoMaDengNotifyMsg(msg)
	local data=LuaProtoBufManager.Decode("proto_lobby.Proto_SCPaoMaDengNotify",msg)
	LobbyPaoMaDengSystem.GetInstance():SetPaoMaDengData(data.info)
end


function LobbyHallCoreSystem:GetGameRoomInfo(gameItemVo)
	local roomInfoCallBack = function(roomInfo)
		if roomInfo then
			self:BeginLoadGameRes(gameItemVo)
		else
			XLuaUIManager.GetInstance():OpenTipsForm(10202)
		end
	end
	LobbyRoomSystem.GetInstance():SendRoomListReq(gameItemVo,roomInfoCallBack)
end

function LobbyHallCoreSystem:BeginLoadGameRes(gameItemVo)
	self:CloseForm()
	LobbyNoticeSystem.GetInstance():CloseForm()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.PaoMaDengChangePosition_EventName,false,2)
	local resName = nil
	if self.curSelectGameType == LobbyHallCoreSystem.GetInstance().GameType.Fish then
		resName ="Fish"
	elseif self.curSelectGameType == LobbyHallCoreSystem.GetInstance().GameType.Arcade then
		resName = "Arcade"
	elseif self.curSelectGameType == LobbyHallCoreSystem.GetInstance().GameType.Chess then
		resName = "Chess"
	end

	LobbyAudioManager.GetInstance():RestoreAudioListenter(false)
	LobbyAudioManager.GetInstance():StopAllAudio()

	GameLoadingSystem.GetInstance():Open(resName)

    local gamePath="G/"..gameItemVo.id.."/Lua/GameManager"

	--Debug.LogError("模块是否加载：")
	local IsLoaded=package.loaded[gamePath] or false
	--Debug.LogError(IsLoaded)
	if IsLoaded then
		package.loaded[gamePath]=nil
		package.preload[gamePath]=nil
		_G["GameManager"]=nil
	end
	require(gamePath)
	GameManager.New(gameItemVo.id):Init()
end

function LobbyHallCoreSystem:IsDisplayEmailPoint(number)
	if number > 0 then
		self.hallCoreView:IsDisplayEmailPoint(true)
	else
		self.hallCoreView:IsDisplayEmailPoint(false)
	end
end

function LobbyHallCoreSystem:BeginEnterGameRoom(roomExcelData)
	local DelaySwitchToRoom=function ()
		yield_return(0)
		GameLoadingSystem.GetInstance():Close()
		self.roomExcelData = roomExcelData
		self:LobbySwitchToRoom()
	end
	startCorotine(DelaySwitchToRoom)
end

function LobbyHallCoreSystem:LobbySwitchToRoom()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.PaoMaDengChangePosition_EventName,false,1)
	LuaStateControl.GetInstance():GotoState(LuaStateControl.StateType.Room)
end

function LobbyHallCoreSystem:LobbySwtichToLogin()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.UnloadGameAssets_EventName)
	XLuaUIManager.GetInstance():CloseAllForm()
	LuaNetwork.CloseNetwork()
	LuaNetwork.IsConnectNetwork = false
	LuaStateControl.GetInstance():GotoState(LuaStateControl.StateType.Login)
end

function LobbyHallCoreSystem:GetHotGameItemData()
	if self.gameItemDataList then
		for i = 1,#self.gameItemDataList do
			local itemVo = self.gameItemDataList[i]
			if itemVo.isShowHotIcon == 1 then
				return itemVo
			end
		end
	end
	return nil
end

function LobbyHallCoreSystem:GetHotGameItemView(id)
	if self.hallFishModulePanel and self.hallFishModulePanel.gameItemList then
		for i = 1,#self.hallFishModulePanel.gameItemList do
			if (self.hallFishModulePanel.gameItemList[i].ItemVo.id == id) and (self.hallFishModulePanel.gameItemList[i].ItemVo.isShowHotIcon == 1) then
				return self.hallFishModulePanel.gameItemList[i]
			end
		end
	end

	if self.hallArcadeModulePanel and self.hallArcadeModulePanel.gameItemList then
		for i = 1,#self.hallArcadeModulePanel.gameItemList do
			if (self.hallArcadeModulePanel.gameItemList[i].ItemVo.id == id) and (self.hallArcadeModulePanel.gameItemList[i].ItemVo.isShowHotIcon == 1) then
				return self.hallArcadeModulePanel.gameItemList[i]
			end
		end
	end
	return nil
end



function LobbyHallCoreSystem:GetCurrentUserHeadImage()
	return self.hallCoreView:GetUserHeadImage()
end


function LobbyHallCoreSystem:GetAllocateHeadImage(headId)
	return self.hallCoreView:GetAllocateHeadImage(headId)
end


function LobbyHallCoreSystem:Close()
	self.roomExcelData = nil
	self.hallCoreView:CloseForm()
end

function LobbyHallCoreSystem:__delete()
	self:Close()
	self:RemoveEventListenner()
	self.hallCoreView:Destroy()
	self.hallCoreView = nil
end
