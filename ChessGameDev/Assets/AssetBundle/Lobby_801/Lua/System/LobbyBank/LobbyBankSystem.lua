LobbyBankSystem = Class()

local Instance=nil
function LobbyBankSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function LobbyBankSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyBankSystem.New()
	end
	return Instance
end

function LobbyBankSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbyBank/LobbyBankVo",
		"H/Lua/System/LobbyBank/LobbyEnterBankView",
		"H/Lua/System/LobbyBank/LobbyBankMainView",
		"H/Lua/System/LobbyBank/LobbyBankDepositPanel",
		"H/Lua/System/LobbyBank/LobbyBankWithdrawalPanel",
		"H/Lua/System/LobbyBank/LobbyBankTransferPanel",
		"H/Lua/System/LobbyBank/LobbyBankGiftRecordPanel",
		"H/Lua/System/LobbyBank/LobbyBankChangePasswordPanel",
		"H/Lua/System/LobbyBank/LobbyTransferConfirmBankView",
		"H/Lua/System/LobbyBank/LobbyTransferSucceedBankView",
		"H/Lua/System/LobbyBank/LobbyBankVerifyPhoneView",
		"H/Lua/System/LobbyBank/LobbyBankResetPasswordView",
		"H/Lua/System/LobbyBank/RecordItem/RecordItem",		
	}
end


function LobbyBankSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function LobbyBankSystem:LoadPB()
	LuaProtoBufManager.LoadProtocFiles("H/Lua/System/LobbyBank/Proto/proto_bank")
end

function LobbyBankSystem:Init()
	self.isFirstEnterBank = false
	self:LoadPB()
	self:AddNetworkEventListenner()
	self.bankVo = LobbyBankVo.New()
	self.enterBankView = LobbyEnterBankView.New()
	self.bankMainView = LobbyBankMainView.New()
	self.bankDepositPanel = LobbyBankDepositPanel.New()
	self.bankWithdrawalPanel = LobbyBankWithdrawalPanel.New()
	self.bankTransferPanel = LobbyBankTransferPanel.New()
	self.bankGiftRecordPanel = LobbyBankGiftRecordPanel.New()
	self.bankChangePasswordPanel = LobbyBankChangePasswordPanel.New()
	self.transferConfirmBankView = LobbyTransferConfirmBankView.New()
	self.transferSucceedBankView = LobbyTransferSucceedBankView.New()
	self.bankVerifyPhoneView = LobbyBankVerifyPhoneView.New()
	self.bankResetPasswordView = LobbyBankResetPasswordView.New()
end

function LobbyBankSystem:AddNetworkEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_GET_DATA_RSP"),self.ResponesBankDataMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_SAVE_MONEY_RSP"),self.ResponesDepositMoneyMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_GET_MONEY_RSP"),self.ResponesWithdrawalMoneyMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_SET_PASSWORD_RSP"),self.ResponesChangeBankPsdMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_QUERY_USER_SIMPLE_DATA_RSP"),self.ResponesQueryUserMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_GIVE_BANK_JETTON_RSP"),self.ResponesBankTransferMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_GET_RECORD_RSP"),self.ResponesBankGiftRecordMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_MSG_PHONE_CHANG_BAND_PASSWORD_RSP"),self.ResponseBankResetPasswordMsg,self)
end

function LobbyBankSystem:RemoveNetworkEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_GET_DATA_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_SAVE_MONEY_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_GET_MONEY_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_SET_PASSWORD_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_QUERY_USER_SIMPLE_DATA_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_GIVE_BANK_JETTON_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_SC_BANK_GET_RECORD_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_MSG_PHONE_CHANG_BAND_PASSWORD_RSP"))
end

--向服务器请求进入银行
function LobbyBankSystem:RequestEnterBankMsg(psd)
	local sendMsg={}
	sendMsg.bank_password = psd
	local bytes = LuaProtoBufManager.Encode("proto_bank.Proto_CSBankGetDataReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_BANK_GET_DATA_REQ"),bytes)
end

--玩家银行数据返回
function LobbyBankSystem:ResponesBankDataMsg(msg)
	local data=LuaProtoBufManager.Decode("proto_bank.Proto_SCBankGetDataRsp",msg)
	if data.result == 0 then
		self.isFirstEnterBank = true
		self.bankVo:SetBankData(data.jetton,data.bank_jetton)
		self.enterBankView:CloseForm()
		self:OpenMainForm()
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end

--玩家向银行存款请求
function LobbyBankSystem:RequestDepositMoneyMsg(money)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg.save_jetton = money
	local bytes = LuaProtoBufManager.Encode("proto_bank.Proto_CSBankSaveMoneyReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_BANK_SAVE_MONEY_REQ"),bytes)
end

--银行存款数据返回
function LobbyBankSystem:ResponesDepositMoneyMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data = LuaProtoBufManager.Decode("proto_bank.Proto_SCBankSaveMoneyRsp",msg)
	if data.result == 0 then
		self.bankVo:SetBankData(data.jetton,data.bank_jetton)
		if self.bankDepositPanel ~= nil then
			self.bankDepositPanel:RefreshUIPanel()
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)		
	end
end



--玩家向银行取款请求
function LobbyBankSystem:RequestWithdrawalMoneyMsg(money)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg.get_jetton = money
	local bytes = LuaProtoBufManager.Encode("proto_bank.Proto_CSBankGetMoneyReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_BANK_GET_MONEY_REQ"),bytes)
end

--银行取款数据返回
function LobbyBankSystem:ResponesWithdrawalMoneyMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data = LuaProtoBufManager.Decode("proto_bank.Proto_SCBankGetMoneyRsp",msg)
	if data.result == 0 then
		self.bankVo:SetBankData(data.jetton,data.bank_jetton)
		if self.bankWithdrawalPanel ~= nil then
			self.bankWithdrawalPanel:ShowUIComponent()
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end

--请求修改银行密码
function LobbyBankSystem:RequestChangeBankPsdMsg(oldPsd,newPsd)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg.old_password = oldPsd
	sendMsg.new_password = newPsd
	local bytes = LuaProtoBufManager.Encode("proto_bank.Proto_CSBankSetPasswordReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_BANK_SET_PASSWORD_REQ"),bytes)
end

--银行修改密码返回结果
function LobbyBankSystem:ResponesChangeBankPsdMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data = LuaProtoBufManager.Decode("proto_bank.Proto_SCBankSetPasswordRsp",msg)
	if data.result == 0 then
		if self.bankChangePasswordPanel ~= nil then
			self.bankChangePasswordPanel:RefreshUIPanel()
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end


--查询玩家是否存在
function LobbyBankSystem:RequestQueryUserMsg(userIDList)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg.query_user_id = userIDList
	pt(sendMsg.query_user_id)
	local bytes = LuaProtoBufManager.Encode("proto_bank.Proto_CSQueryUserReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_QUERY_USER_SIMPLE_DATA_REQ"),bytes)
end

--查询玩家数据返回
function LobbyBankSystem:ResponesQueryUserMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data = LuaProtoBufManager.Decode("proto_bank.Proto_SCQueryUserRsp",msg)
	if data.result == 0 then
		if #data.query_user_list>= 1 then
			if self.bankTransferPanel ~= nil then
				self.bankTransferPanel:SetReciverData(data.query_user_list[1].userid,data.query_user_list[1].nickname)
				self.bankTransferPanel:OpenTransferConfirmForm()
			end
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)	
	end
end

--请求转账给玩家
function LobbyBankSystem:RequestBankTransferMsg(transferMoney,receiverID)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg.give_user_id = receiverID
	sendMsg.give_jetton = transferMoney
	local bytes = LuaProtoBufManager.Encode("proto_bank.Proto_CSBankGiveMoneyReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_BANK_GIVE_BANK_JETTON_REQ"),bytes)	
end

--转账返回结果
function LobbyBankSystem:ResponesBankTransferMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data = LuaProtoBufManager.Decode("proto_bank.Proto_CSBankGiveMoneyRsp",msg)
	if data.result == 0 then
		self.bankVo:SetBankData(data.jetton,data.bank_jetton)
		if self.transferSucceedBankView ~= nil then
			self.transferSucceedBankView:OpenForm(data.record)
		end

		if self.bankTransferPanel ~= nil then
			self.bankTransferPanel:RefreshUIPanel()
		end
	else
		if self.bankTransferPanel ~= nil then
			self.bankTransferPanel:RefreshUIPanel()
		end
	end	
end

--请求查询赠送记录
function LobbyBankSystem:RequestBankGiftRecordMsg(beginIndex,endIndex)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg["begin"] = beginIndex
	sendMsg["end"] = endIndex
	local bytes = LuaProtoBufManager.Encode("proto_bank.Proto_CSBankGetRecordReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_BANK_GET_RECORD_REQ"),bytes)	
end

--赠送记录结果返回
function LobbyBankSystem:ResponesBankGiftRecordMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data = LuaProtoBufManager.Decode("proto_bank.Proto_SCBankGetRecordRsp",msg)
	if data.result == 0 then
		if self.bankGiftRecordPanel ~= nil then
			self.bankGiftRecordPanel:ShowUIComponent(data.record)
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)	
	end	
end

--重置银行密码
function LobbyBankSystem:RequestBankResetPasswordMsg(phoneNumber,pwd)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
	local sendMsg={}
	sendMsg.phone_num = phoneNumber
	sendMsg.new_password = pwd
	local bytes = LuaProtoBufManager.Encode("proto_bank.Proto_CS_PhoneChangeBandPasswordReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_bank.Proto_Bank_CMD","NF_CS_MSG_PHONE_CHANG_BAND_PASSWORD_REQ"),bytes)	
end

function LobbyBankSystem:ResponseBankResetPasswordMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_bank.Proto_SC_PhoneChangeBandPasswordRsp",msg)
	if data.result == 0 then
		self.bankResetPasswordView:CloseForm()
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end	
end


function LobbyBankSystem:NumberToString(number)
	if number == 0 then
		return "零"
	end
    local numerical_tbl = {}
    local numerical_names = {[0] = "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"}
    local numerical_units = {"", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿", "拾", "佰", "仟", "万", "拾", "佰", "仟"}
 
    --01，数字转成表结构存储
    local numerical_length = string.len(number)
    for i = 1, numerical_length do
		numerical_tbl[i] = tonumber(string.sub(number, i, i))
    end
 
    --02，对应数字转中文处理
    local result_numberical = ""
    local to_append_zero, need_filling = false, true
    for index, number in ipairs(numerical_tbl) do
	--从高位到底位的顺序数字转成对应的从低位到高位的顺序数字单位.
	local real_unit_index = numerical_length - index + 1
	if number == 0 then
	   if need_filling then
	      if real_unit_index == 5 then--万位
		 result_numberical = result_numberical .. "万"
		 need_filling = false
	      end
	      if real_unit_index == 9 then--亿位
		 result_numberical = result_numberical .. "亿"
		 need_filling = false
	      end
	      if real_unit_index == 13 then--兆位
		 result_numberical = result_numberical .. "兆"
		 need_filling = false
	      end
	   end
	   to_append_zero = true
        else
	   if to_append_zero then
	      result_numberical = result_numberical .. "零"
	      to_append_zero = false
           end
	   result_numberical = result_numberical  .. numerical_names[number] .. numerical_units[real_unit_index]
	   if real_unit_index == 5 or real_unit_index == 9 or real_unit_index == 13 then
		need_filling = false
	   else
		need_filling = true
	   end
	end
    end
    return result_numberical
end

 
function LobbyBankSystem:Open()
	self:ReInitData()
	if self.isFirstEnterBank == false then
		self:OpenEnterBankForm()
	else
		self:OpenMainForm()
	end
end

function LobbyBankSystem:ReInitData(  )
	
end

function LobbyBankSystem:OpenEnterBankForm(  )
	if self.enterBankView then
		self.enterBankView:OpenForm()
	end
end

function LobbyBankSystem:OpenMainForm()
	if self.bankMainView then 
		self.bankMainView:OpenForm()
	end
end

function LobbyBankSystem:Close()
	self:CloseForm()
end

function LobbyBankSystem:CloseForm()
	if self.bankMainView then 
		self.bankMainView:CloseForm()
	end
end

function LobbyBankSystem:__delete()
	self:Close()
	self:RemoveNetworkEventListenner()
	self.bankMainView:Destroy()
	self.bankMainView = nil
	self.Instance = nil
end
