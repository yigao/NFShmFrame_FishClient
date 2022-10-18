
LuaNetwork = {}
LuaNetwork.IsConnectNetwork = false

LuaNetwork.NetworkDefine={
	Hall=1,
	Game=2,
}

CSScript.NetworkManager.ReceiveNetworkMsg = function (msgData)
    LuaNetwork.ReceiveNetworkMsgLua(msgData)
end 

function LuaNetwork.CloseNetwork()
	CSScript.NetworkManager:CloseNetwork()
end

function LuaNetwork.ReconnectNetwork(iPEndPoint,callback)
	local launchNetworkCallBack = function(networkStatus)
		XLuaUIManager.GetInstance():CloseNetWaitForm()
		if networkStatus == CS.TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTED then
			LuaNetwork.IsConnectNetwork = true
		end		
		callback(networkStatus)
	end
	LuaNetwork.IsConnectNetwork = false
	XLuaUIManager.GetInstance():OpenNetWaitForm(-1,0.5,nil)
	CSScript.NetworkManager:LuaLaunchNetwork(iPEndPoint,launchNetworkCallBack)
end

function LuaNetwork.BeginLaunchNetwork(iPEndPoint,callback)
	local launchNetworkCallBack = function(networkStatus)
		XLuaUIManager.GetInstance():CloseNetWaitForm()
		if networkStatus == CS.TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTED then
			LuaNetwork.IsConnectNetwork = true
			callback()
		else
			XLuaUIManager.GetInstance():OpenMessageBox(HallLuaDefine.Client_Failure_Code.C_Unable_Network,true,false,false,nil,nil,nil)
		end
	end
	LuaNetwork.IsConnectNetwork = false
	XLuaUIManager.GetInstance():OpenNetWaitForm(-1,0.5,nil)
	CSScript.NetworkManager:LuaLaunchNetwork(iPEndPoint,launchNetworkCallBack)
end


function LuaNetwork.SendNetworkMsgLua(mainMsgID,subMsgID,msgDatas)
    CSScript.NetworkManager:SendNetworkMsgLua(mainMsgID,subMsgID,msgDatas)
end

function LuaNetwork.ReceiveNetworkMsgLua(msgData)
	--Debug.LogError("接收返回消息"..msgData.MainMsgID.."==>"..msgData.SubMsgID)
    local msgId = msgData.SubMsgID
	local IsContains=LuaNetwork.ContainsKey(msgId)
	if IsContains then
		LuaNetwork.DisPatchNetMessage(msgId,msgData.MsgBody)
	else
		Debug.LogError("服务端消息事件SubMsgID未注册==>"..msgId)
	end
end


function LuaNetwork.ContainsKey(msgHandleId)
	return GlobalEventManager.GetInstance():ContainsKey(msgHandleId)
end


function LuaNetwork.RegisterNetMessage(msgHandleId,handle,obj)
	GlobalEventManager.GetInstance():AddLuaEvent(msgHandleId,handle,obj)
end

function LuaNetwork.RemoveNetMessage(msgHandleId)
    GlobalEventManager.GetInstance():RemoveEvent(msgHandleId)
end

function LuaNetwork.DisPatchNetMessage(msgHandleId,msgHandle)
	GlobalEventManager.GetInstance():DispatchEvent(msgHandleId,false,msgHandle)
end

