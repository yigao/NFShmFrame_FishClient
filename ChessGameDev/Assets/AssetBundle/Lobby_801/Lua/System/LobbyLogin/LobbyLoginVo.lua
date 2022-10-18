LobbyLoginVo = Class()

function LobbyLoginVo:ctor()
	self.userAccountKey = "User_Account"
	self.userPasswordKey = "User_Password"

	self.login_type = nil
	self.account = nil
	self.password = nil
	self.token = nil
	self.login_time = nil
	self.user_id = nil
	self.nickName = nil
end

function LobbyLoginVo:SetLoginType(loginType)
	self.login_type = loginType
end

function LobbyLoginVo:SetAccountLoginData(data)
	self.token = data.token 
	self.login_time = data.login_time
	self.user_id = data.user_id
	self:DeserializationNetworkIpInfo(data.server_ip_list) 
end

function LobbyLoginVo:SetAccount(account)
	self.account = account
end

function LobbyLoginVo:SetPassword(pwd)
	self.password = pwd
end

function LobbyLoginVo:SetAccountAndPassword(account,password)
	self.account = account
	self.password = password
end

function LobbyLoginVo:SetNickname(nickName)
	self.nickName = nickName	
end

function LobbyLoginVo:DeserializationNetworkIpInfo(serverIpInfoList)
	CSScript.GlobalConfigManager:ClearUserLoginGameIPEndPoint()
	local ipInfoList = serverIpInfoList
	for i = 1,#ipInfoList do
		CSScript.GlobalConfigManager:SetUserLoginGameIPEndPoint(ipInfoList[i].ip,ipInfoList[i].port)
	end
end

function LobbyLoginVo:GetSaveAccount(  )
	return CS.UnityEngine.PlayerPrefs.GetString(self.userAccountKey,"")
end

function LobbyLoginVo:GetSavePassword(  )
	return CS.UnityEngine.PlayerPrefs.GetString(self.userPasswordKey,"")
end

function LobbyLoginVo:SaveAccountAndPasswod()
	CS.UnityEngine.PlayerPrefs.SetString(self.userAccountKey,self.account)
	CS.UnityEngine.PlayerPrefs.SetString(self.userPasswordKey,self.password)
end

function LobbyLoginVo:__delete( )
   
end


