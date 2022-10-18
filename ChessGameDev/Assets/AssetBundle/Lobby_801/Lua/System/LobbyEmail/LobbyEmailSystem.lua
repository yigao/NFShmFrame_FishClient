LobbyEmailSystem = Class()

local Instance=nil
function LobbyEmailSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function LobbyEmailSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyEmailSystem.New()
	end
	return Instance
end

function LobbyEmailSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbyEmail/LobbyEmailMainView",
		"H/Lua/System/LobbyEmail/LobbyEmailContentView",
		"H/Lua/System/LobbyEmail/EmailItem/EmailItem",
		"H/Lua/System/LobbyEmail/LobbyEmailVo",
	}
end

function LobbyEmailSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function LobbyEmailSystem:LoadPB()
	LuaProtoBufManager.LoadProtocFiles("H/Lua/System/LobbyEmail/Proto/proto_email")
end

function LobbyEmailSystem:Init()
	self:LoadPB()
	self.isSelectAll = false
	self.MaxEmailCount = 10
	self.unreadEmailNumber = 0
	self:AddNetworkEventListenner()
	self.emailMainView = LobbyEmailMainView.New()
	self.emailContentView = LobbyEmailContentView.New()

end

function LobbyEmailSystem:AddNetworkEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_SC_SNS_MAIL_AUTO_PUSH_RSP"),self.ResponsAutoPushEmailMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_SC_SNS_MAIL_LIST_RSP"),self.ResponesEmailListMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_SC_SNS_MAIL_READ_RSP"),self.ResponesReadEmailMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_SC_SNS_MAIL_DEL_RSP"),self.ResponesDeleteEmailMsg,self)
end

function LobbyEmailSystem:RemoveNetworkEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_SC_SNS_MAIL_AUTO_PUSH_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_SC_SNS_MAIL_LIST_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_SC_SNS_MAIL_READ_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_SC_SNS_MAIL_DEL_RSP"))
end

function LobbyEmailSystem:ResponsAutoPushEmailMsg(msg)
	local data=LuaProtoBufManager.Decode("proto_email.Proto_CSMailAutoPushRsp",msg)
	self.unreadEmailNumber = data.no_read_count
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.GameNewEmailTips_EventName,false,self.unreadEmailNumber)
end

--向服务器请求邮件
function LobbyEmailSystem:RequestEmailListMsg(	)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg["begin"] = 1
	sendMsg["end"] = self.MaxEmailCount
	local bytes = LuaProtoBufManager.Encode("proto_email.Proto_CSMailListReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_CS_SNS_MAIL_LIST_REQ"),bytes)
end

--邮件数据返回
function LobbyEmailSystem:ResponesEmailListMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_email.Proto_CSMailListRsp",msg)
	if  data.result == 0 then
		if data.role_mail_list ~= nil then
			for i=1,#data.role_mail_list do
				if self:IsExistEmail(data.role_mail_list[i].id) == nil then
					local emailVo = LobbyEmailVo.New(data.role_mail_list[i])
					table.insert( self.emailVoList,emailVo)
				end
			end
			self.unreadEmailNumber = data.no_read_count
		end
		self.emailMainView:ShowUIComponent()
		GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.GameNewEmailTips_EventName,false,self.unreadEmailNumber)
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end

-- id=0 表示一键读取所有的邮件
function LobbyEmailSystem:RequestReadEmailMsg(id)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg.mail_id = id
	local bytes = LuaProtoBufManager.Encode("proto_email.Proto_CSMailReadReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_CS_SNS_MAIL_READ_REQ"),bytes)
end

function LobbyEmailSystem:ResponesReadEmailMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data = LuaProtoBufManager.Decode("proto_email.Proto_CSMailReadRsp",msg)
	if data.result == 0 then
		if data.mail_id_list then
			for i = 1,#data.mail_id_list do
				local emailVo = self:IsExistEmail(data.mail_id_list[i])
				if emailVo ~= nil then
					emailVo:UpdateEmailStatus(1)
				end
			end
			self.unreadEmailNumber = self.unreadEmailNumber - #data.mail_id_list
			if self.isSelectAll == true then
				self:UpdateEmailSelectAll()
			end
			self.emailMainView:RefreshUIComponent()
			GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.GameNewEmailTips_EventName,false,self.unreadEmailNumber)
		else
			XLuaUIManager.GetInstance():OpenTipsForm(10305)
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end

--向服务器请求删除邮件
function LobbyEmailSystem:RequestDeleteEmailMsg(email_list)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg.mail_id = email_list
	local bytes = LuaProtoBufManager.Encode("proto_email.Proto_CSMailDelReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_email.Proto_Email_CMD","NF_CS_SNS_MAIL_DEL_REQ"),bytes)
end

function LobbyEmailSystem:ResponesDeleteEmailMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data = LuaProtoBufManager.Decode("proto_email.Proto_CSMailDelRsp",msg)
	if data.result == 0 then
		if data.mail_id_list then
			for i = 1,#data.mail_id_list do
				self:RemoveEmailVo(data.mail_id_list[i])
			end
			self.emailContentView:CloseForm()
			self.emailMainView:ShowUIComponent()
		else
			
			XLuaUIManager.GetInstance():OpenTipsForm(10306)
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)	
	end
end

function LobbyEmailSystem:UpdateEmailSelectAll()
	for i = 1,#self.emailVoList do
		self.emailVoList[i]:UpdateEmailGouXuan(self.isSelectAll)
	end
end

function LobbyEmailSystem:RemoveEmailVo(id)
	for i = 1,#self.emailVoList do
		if self.emailVoList[i].id == id then
			table.remove(self.emailVoList,i)
			return i
		end
	end
	return nil
end

function LobbyEmailSystem:IsExistEmail(id)
	for i = 1,#self.emailVoList do
		if self.emailVoList[i].id == id then
			return self.emailVoList[i]
		end
	end
	return nil
end

function LobbyEmailSystem:Open()
	self:ReInitData()
	self:OpenForm()
	self:RequestEmailListMsg()
end

function LobbyEmailSystem:ReInitData(  )
	self.isSelectAll = false
	self.emailVoList = {}
end

function LobbyEmailSystem:OpenForm()
	if self.emailMainView then 
		self.emailMainView:OpenForm()
	end
end

function LobbyEmailSystem:Close()
	self:CloseForm()
end

function LobbyEmailSystem:CloseForm()
	if self.emailMainView then 
		self.emailMainView:CloseForm()
	end
end

function LobbyEmailSystem:__delete()
	self:Close()
	self:RemoveNetworkEventListenner()
	self.emailMainView:Destroy()
	self.emailMainView = nil
	self.emailVo:Destroy()
	self.emailVo = nil
	self.emailContentView:Destroy()
	self.emailContentView = nil 
	Instance = nil
end
