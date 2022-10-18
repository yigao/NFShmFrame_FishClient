LuaHeartBeat = Class()

local Max_Message_Num_Per_Frame = 3
local HeartBeat_Response_Timeout = 4
local HeartBeat_Send_Interval = 5
local Reconnected_Max_Time_Interval = 60

local Instance=nil
function LuaHeartBeat:ctor()
	Instance=self
	self:Init()
end


function LuaHeartBeat.GetInstance()
	if Instance==nil then
		Instance=LuaHeartBeat.New()
	end
	return Instance
end


function LuaHeartBeat:Init()
	self:AddNetworkEventListenner()
	self:InitHeartBeatParams()
end

function LuaHeartBeat:InitHeartBeatParams()
	CSScript.NetworkManager.Max_Message_Num_Per_Frame = Max_Message_Num_Per_Frame
	CSScript.NetworkManager.HeartBeat_Response_Timeout = HeartBeat_Response_Timeout
	CSScript.NetworkManager.HeartBeat_Send_Interval = HeartBeat_Send_Interval
	CSScript.NetworkManager.Reconnected_Max_Time_Interval = Reconnected_Max_Time_Interval
end

function LuaHeartBeat:AddNetworkEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_Msg_HeartBeat_RSP"),self.ResponesOnHeartBeatRsp,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_Msg_ReConnect_RSP"),self.ResponseReconnectToNetwork,self)
	GlobalEventManager.GetInstance():AddCSEvent(CS.EventID.Game_Network_Offline,self.NetworkOffline,self)
	GlobalEventManager.GetInstance():AddCSEvent(CS.EventID.Game_Network_Heart_Beat,self.RequestOnHeartBeat,self)
end

function LuaHeartBeat:RemoveNetworkEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_Msg_HeartBeat_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_Msg_ReConnect_RSP"))
	GlobalEventManager.GetInstance():RemoveEvent(CS.EventID.Game_Network_Offline) 
	GlobalEventManager.GetInstance():RemoveEvent(CS.EventID.Game_Network_Heart_Beat) 
end

function LuaHeartBeat:RequestOnHeartBeat(  )
	local sendMsg={}
	sendMsg.userid = LobbyHallCoreSystem.GetInstance().playerInfoVo.user_id
	local bytes = LuaProtoBufManager.Encode("proto_login.Proto_CSHeartBeatReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_CS_Msg_HeartBeat_REQ"),bytes)
end

function LuaHeartBeat:ResponesOnHeartBeatRsp(msg)
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SCHeartBeatRsp",msg)
	CSScript.NetworkManager.isWaittingHeartRes = false
	CSScript.NetworkManager.heartBeatTimeElapsed = 0
end


function LuaHeartBeat:NetworkOffline(  )
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	LuaNetwork.IsConnectNetwork = false
	CSScript.NetworkManager.isWaittingHeartRes = false
	CSScript.NetworkManager.heartBeatTimeElapsed = 0
	Debug.LogError("NetworkOffline.......")
	if LuaStateControl.GetInstance():GetCurrentStateType() == LuaStateControl.StateType.Login then
		XLuaUIManager.GetInstance():OpenMessageBox(HallLuaDefine.Client_Failure_Code.C_Network_Offline,true,false,false,nil,nil,nil)
	else
		local confirmCallBack = function(  )
			self:ReconnectToNetwork()
		end
	
		local closeCallBack = function (  )
			self:ReturnToLogin()
		end
		XLuaUIManager.GetInstance():OpenMessageBox(HallLuaDefine.Client_Failure_Code.C_Network_Offline,true,false,false,confirmCallBack,nil,closeCallBack)
	end
end

function LuaHeartBeat:ReconnectToNetwork(  )
	CSScript.NetworkManager.reconnectedTimeElapsed = 0
	CSScript.NetworkManager.isReconectedNetwork = true
	Debug.LogError("ReconnectToNetwork.......")
	local reconnectResultCallBack = function (networkStatus)
		if networkStatus == CS.TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTED then
			local sendMsg={}
			sendMsg.userid = LobbyHallCoreSystem.GetInstance().playerInfoVo.user_id
			local bytes = LuaProtoBufManager.Encode("proto_login.Proto_CSReconnectReq", sendMsg)
			LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_CS_Msg_ReConnect_REQ"),bytes)
		else
			self:NetworkOffline()
		end
	end

	LuaNetwork.ReconnectNetwork(CSScript.GlobalConfigManager:GetUserLoginGameIPEndPoint(),reconnectResultCallBack)
	XLuaUIManager.GetInstance():OpenNetWaitForm(-1,0.5,nil)
end

function LuaHeartBeat:ResponseReconnectToNetwork(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SCReconnectRsp",msg)	
	if data.result == 0 then
		GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.Network_Reconnect_Succeed_EventName)
	else
		self:ReturnToLogin()
	end
end

function LuaHeartBeat:ReturnToLogin(  )
	CSScript.NetworkManager.reconnectedTimeElapsed = 0
	CSScript.NetworkManager.isNetworkOffline = false
	CSScript.NetworkManager.isReconectedNetwork = false
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.Reutun_To_Login_EventName)
end

function LuaHeartBeat:__delete()
	self.Instance = nil
end
