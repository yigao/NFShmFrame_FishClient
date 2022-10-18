LobbyLoginSystem = Class()

local Instance=nil
function LobbyLoginSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end

function LobbyLoginSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyLoginSystem.New()
	end
	return Instance
end

function LobbyLoginSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbyLogin/LobbyAccountLogin/LobbyAccountLoginView",
		"H/Lua/System/LobbyLogin/LobbyRegister/LobbyRegisterInformationView",
		"H/Lua/System/LobbyLogin/LobbyRegister/LobbyRegisterVerificationMobilePhoneView",
		"H/Lua/System/LobbyLogin/LobbyResetPassword/LobbyResetPasswordVerificationMobilePhoneView",
		"H/Lua/System/LobbyLogin/LobbyResetPassword/LobbyResetPasswordView",
		"H/Lua/System/LobbyLogin/LobbyLoginVerifyPhone/LobbyLoginVerifyPhoneView",
		"H/Lua/System/LobbyLogin/LobbyLoginView",
		"H/Lua/System/LobbyLogin/LobbyLoginVo",
	}
end


function LobbyLoginSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function LobbyLoginSystem:LoadPB()
	LuaProtoBufManager.LoadProtocFiles("H/Lua/System/LobbyLogin/Proto/proto_login")
end

function LobbyLoginSystem:Init()
	self:LoadPB()
	self:AddNetworkEventListenner()
	LuaHeartBeat.GetInstance()
	self:InitData()
	self:InitView()
end

function LobbyLoginSystem:InitData(  )
	self.LoginType ={
		Visiton = 0,
		MobilePhone = 1,
		WeiXin = 2,
	}
	
	self.loginView = LobbyLoginView.New()
	self.loginVo = LobbyLoginVo.New()
	self.accountLoginView = LobbyAccountLoginView.New()
	self.registerInformationView =LobbyRegisterInformationView.New()
	self.registerVerificationMobilePhoneView = LobbyRegisterVerificationMobilePhoneView.New()
	self.resetPasswordVerificationMobilePhoneView =LobbyResetPasswordVerificationMobilePhoneView.New()
	self.resetPasswordView = LobbyResetPasswordView.New()
	self.lobbyLoginVerifyPhoneView = LobbyLoginVerifyPhoneView.New()
end

function LobbyLoginSystem:InitView(  )
	
end

function LobbyLoginSystem:AddNetworkEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_CHECK_CONTRACT_INFO_RSP"),self.ResponsCheckContractMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_AccountLoginRsp"),self.ResponsAccountLoginMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_UserLoginRsp"),self.ResponsUserLoginMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_RegisterAccountRsp"),self.ResponsRegisterAccountMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_LoginServer_PhoneAutoCodeRsp"),self.ResponsePhoneAutoCodeMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_LoginServer_CheckPhoneCodeRsp"),self.ResponseCheckPhoneCodeMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_CHANGE_PASSWORD_RESP"),self.ResponseChangePasswordMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_LoginServer_NotifyPhoneCheck"),self.ResponseLoginServerNotifyPhoneCheck,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_Msg_KitPlayer_Notify"),self.ResponseKetPlayerNotify,self)
end

function LobbyLoginSystem:RemoveNetworkEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_CHECK_CONTRACT_INFO_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_AccountLoginRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_UserLoginRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_RegisterAccountRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_LoginServer_PhoneAutoCodeRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_LoginServer_CheckPhoneCodeRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_CHANGE_PASSWORD_RESP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_MSG_LoginServer_NotifyPhoneCheck"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_SC_Msg_KitPlayer_Notify"))
end

function LobbyLoginSystem:Open()
	self:OpenForm()
end

function LobbyLoginSystem:OpenForm()
	if self.loginView then 
		self.loginView:OpenForm()
	end
end

function LobbyLoginSystem:Close()
	self:CloseForm()
end

function LobbyLoginSystem:CloseForm()
	if self.loginView then 
		self.loginView:CloseForm()
	end

	if self.accountLoginView then
		self.accountLoginView:CloseForm()
	end

	if self.registerInformationView then
		self.registerInformationView:CloseForm()
	end

	if self.registerVerificationMobilePhoneView then
		self.registerVerificationMobilePhoneView:CloseForm()
	end

	if self.resetPasswordVerificationMobilePhoneView then
		self.resetPasswordVerificationMobilePhoneView:CloseForm()
	end

	if self.resetPasswordView then
		self.resetPasswordView:CloseForm()
	end

	if self.lobbyLoginVerifyPhoneView then
		self.lobbyLoginVerifyPhoneView:CloseForm()
	end
end


function LobbyLoginSystem:ResponsCheckContractMsg(msg)
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SCCheckContractInfoRsp",msg)
	if tonumber(data.result)~=0 then
		CSScript.LuaManager:QuitGame()
	end
end

function LobbyLoginSystem:RequestAccountLoginMsg()
	local accountLoginCallBack = function (  )
		local sendMsg={}
		sendMsg.login_type = self.loginVo.login_type
		sendMsg.account = self.loginVo.account
		sendMsg.password = self.loginVo.password
		sendMsg.device_id = CS.GlobalConfigManager.instance:GetDeviceUniqueIdentifier()
		sendMsg.contract_info = CSScript.LuaManager:GetMD5(CSScript.GlobalConfigManager.Contract_Number)
		local bytes = LuaProtoBufManager.Encode("proto_login.Proto_CSAccountLoginReq", sendMsg)
		Debug.LogError("Accoount Login.........")
		LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_CS_MSG_AccountLoginReq"),bytes)
		XLuaUIManager.GetInstance():OpenNetWaitForm(-1,0.5,nil)
	end
	if LuaNetwork.IsConnectNetwork == true then
		accountLoginCallBack()
	else
		LuaNetwork.BeginLaunchNetwork(CSScript.GlobalConfigManager:GetAccountLoginIPEndPoint(),accountLoginCallBack)
	end
end

function LobbyLoginSystem:ResponsAccountLoginMsg(msg)
	Debug.LogError("Accoount Login..success.......")
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SCAccountLoginRsp",msg)
	if data.result == 0 then
		Debug.LogError("Accoount Login..success.......")
		self.loginVo:SetAccountLoginData(data)
		if self.loginVo.login_type == self.LoginType.MobilePhone then
			self.loginVo:SaveAccountAndPasswod()
		end
		self:RequestUserLoginMsg()
	else
		Debug.LogError("Accoount Login..failed.......")
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end

function LobbyLoginSystem:RequestUserLoginMsg(  )
	XLuaUIManager.GetInstance():OpenNetWaitForm(-1,0.5,nil)
	Debug.LogError("CloseNetwork.......")
	LuaNetwork.IsConnectNetwork = false
	LuaNetwork.CloseNetwork()

	local userLoginGameCallBack = function (  )
		local sendMsg={}
		sendMsg.account = self.loginVo.account
		sendMsg.user_id = self.loginVo.user_id
		sendMsg.login_time = self.loginVo.login_time
		sendMsg.token = self.loginVo.token
		sendMsg.ext_data = nil
		Debug.LogError("UserLoginReq.......")
		local bytes = LuaProtoBufManager.Encode("proto_login.Proto_CSUserLoginReq", sendMsg)	
		LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_CS_MSG_UserLoginReq"),bytes)
	end
	LuaNetwork.BeginLaunchNetwork(CSScript.GlobalConfigManager:GetUserLoginGameIPEndPoint(),userLoginGameCallBack)
end

function LobbyLoginSystem:ResponsUserLoginMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SCUserLoginRsp",msg)
	if data.result == 0 then
		XLuaUIManager.GetInstance():CloseAllForm()
		self:Close()
		if self.loginVo.login_type == self.LoginType.MobilePhone then
			self.loginVo:SaveAccountAndPasswod()
		end
		LuaStateControl.GetInstance():GotoState(LuaStateControl.StateType.Lobby,data)			
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end


function LobbyLoginSystem:RequestRegisterAccountMsg(  )
	XLuaUIManager.GetInstance():OpenNetWaitForm(-1,0.5,nil)
	local registerAccountCallBack = function(  )
		local sendMsg={}
		sendMsg.account = self.loginVo.account
		sendMsg.password = self.loginVo.password
		sendMsg.nick_name = self.loginVo.nickName
		sendMsg.Proto_UserLoginExternalData = nil
		sendMsg.is_phone  = true
		sendMsg.device_id = CS.GlobalConfigManager.instance:GetDeviceUniqueIdentifier()
		sendMsg.contract_info = CSScript.LuaManager:GetMD5(CSScript.GlobalConfigManager.Contract_Number)
		local bytes = LuaProtoBufManager.Encode("proto_login.Proto_CSRegisterAccountReq", sendMsg)
		LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_CS_MSG_RegisterAccountReq"),bytes)	
	end
	
	if LuaNetwork.IsConnectNetwork == true then
		registerAccountCallBack()
	else
		LuaNetwork.BeginLaunchNetwork(CSScript.GlobalConfigManager:GetAccountLoginIPEndPoint(),registerAccountCallBack)
	end
end

function LobbyLoginSystem:ResponsRegisterAccountMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SCRegisterAccountRsp",msg)
	if data.result == 0 then
		self.loginVo:SetAccountLoginData(data)
		self:RequestUserLoginMsg()
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end

function LobbyLoginSystem:RequestCheckPhoneCodeMsg(phoneNumber,verificationCode)
	XLuaUIManager.GetInstance():OpenNetWaitForm(-1,0.5,nil)
	local checkPhoneCodeCallBack = function (  )
		local sendMsg={}
		sendMsg.phone_num = phoneNumber
		sendMsg.auth_code = verificationCode
		local bytes = LuaProtoBufManager.Encode("proto_login.Proto_CS_LoginServer_CheckPhoneCodeReq", sendMsg)
		LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_CS_MSG_LoginServer_CheckPhoneCodeReq"),bytes)	
	end

	if LuaNetwork.IsConnectNetwork == true then
		checkPhoneCodeCallBack()
	else
		LuaNetwork.BeginLaunchNetwork(CSScript.GlobalConfigManager:GetAccountLoginIPEndPoint(),checkPhoneCodeCallBack)
	end
end

function LobbyLoginSystem:ResponseCheckPhoneCodeMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SC_LoginServer_CheckPhoneCodeRsp",msg)
	if data.result == 0 then
		if data.code_type == HallLuaDefine.PhoneCodeType.Phone_Regiter_Code then
			self.registerVerificationMobilePhoneView:CloseForm()
			self.registerInformationView:OpenForm()	
		elseif data.code_type ==  HallLuaDefine.PhoneCodeType.Change_Login_Password_Code then
			self.resetPasswordVerificationMobilePhoneView:CloseForm()
			self.resetPasswordView:OpenForm()
		elseif data.code_type == HallLuaDefine.PhoneCodeType.Change_Device_Code then
			self.lobbyLoginVerifyPhoneView:CloseForm()
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end	
end

function LobbyLoginSystem:RequestPhoneAutoCodeMsg(phoneNumber,verificationCodeType)
	local phoneAutoCodeCallBack= function (  )
		local sendMsg={}
		sendMsg.phone_num = phoneNumber
		sendMsg.code_type = verificationCodeType
		local bytes = LuaProtoBufManager.Encode("proto_login.Proto_CS_LoginServer_PhoneAutoCodeReq", sendMsg)
		LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_CS_MSG_LoginServer_PhoneAutoCodeReq"),bytes)
	end

	if LuaNetwork.IsConnectNetwork == true then
		phoneAutoCodeCallBack()
	else
		LuaNetwork.BeginLaunchNetwork(CSScript.GlobalConfigManager:GetAccountLoginIPEndPoint(),phoneAutoCodeCallBack)
	end
end

function LobbyLoginSystem:ResponsePhoneAutoCodeMsg(msg)
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SC_LoginServer_PhoneAutoCodeRsp",msg)
	if data.result == 0 then
		if data.code_type == HallLuaDefine.PhoneCodeType.Phone_Regiter_Code then
			self.registerVerificationMobilePhoneView:IsReceiveVerificationCode(true)
		elseif data.code_type == HallLuaDefine.PhoneCodeType.Change_Login_Password_Code then
			self.resetPasswordVerificationMobilePhoneView:IsReceiveVerificationCode(true)
		elseif data.code_type == HallLuaDefine.PhoneCodeType.Change_Device_Code then
			self.lobbyLoginVerifyPhoneView:IsReceiveVerificationCode(true)
		end
		XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Succeed_Code.Send_Verification_Code_Succeed)
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end	
end

function LobbyLoginSystem:RequestChangePasswordMsg(pwd)
	XLuaUIManager.GetInstance():OpenNetWaitForm(-1,0.5,nil)
	local changePasswordCallBack = function (  )
		local sendMsg={}
		sendMsg.account = self.loginVo.account
		sendMsg.new_password = pwd
		sendMsg.device_id =  CS.GlobalConfigManager.instance:GetDeviceUniqueIdentifier()
		local bytes = LuaProtoBufManager.Encode("proto_login.Proto_CS_ChangePasswordReq", sendMsg)
		LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_login.Proto_LOGIN_CS_CMD","NF_CS_MSG_CHANGE_PASSWORD_REQ"),bytes)	
	end

	if LuaNetwork.IsConnectNetwork == true then
		changePasswordCallBack()
	else
		LuaNetwork.BeginLaunchNetwork(CSScript.GlobalConfigManager:GetAccountLoginIPEndPoint(),changePasswordCallBack)
	end
end

function LobbyLoginSystem:ResponseChangePasswordMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SC_ChangePasswordRsp",msg)
	if data.result == 0 then
		self.resetPasswordView:PasswordChangeSucceed()
		self.resetPasswordView:CloseForm()
		self.loginVo:SaveAccountAndPasswod()
		self.accountLoginView:ShowUIComponent()
		self:RequestAccountLoginMsg()
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end	
end


function LobbyLoginSystem:ResponseLoginServerNotifyPhoneCheck(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SC_LoginServer_NotifyPhoneCheck",msg)
	self.lobbyLoginVerifyPhoneView:OpenForm(tostring(data.phone_num))
end


function LobbyLoginSystem:ResponseKetPlayerNotify(msg)
	local data=LuaProtoBufManager.Decode("proto_login.Proto_SCKetPlayerNotify",msg)
	if data.result then
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
		GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.Reutun_To_Login_EventName)
	end
end

function LobbyLoginSystem:__delete()
	self:Close()
	self:RemoveNetworkEventListenner()
	
	self.loginView:Destroy()
	self.loginView = nil
	
	self.loginVo:Destroy()
	self.loginVo = nil

	self.accountLoginView:Destroy()
	self.accountLoginView = nil
	
	self.registerInformationView:Destroy()
	self.registerInformationView = nil
	
	self.registerVerificationMobilePhoneView:Destroy()
	self.registerVerificationMobilePhoneView = nil
	
	self.resetPasswordVerificationMobilePhoneView:Destroy()
	self.resetPasswordVerificationMobilePhoneView = nil

	self.resetPasswordView:Destroy()
	self.resetPasswordView = nil

	self.Instance = nil
end
