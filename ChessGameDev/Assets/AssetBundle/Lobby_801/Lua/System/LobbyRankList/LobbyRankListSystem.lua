LobbyRankListSystem = Class()

local Instance=nil
function LobbyRankListSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function LobbyRankListSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyRankListSystem.New()
	end
	return Instance
end

function LobbyRankListSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbyRankList/LobbyRankListView",
		"H/Lua/System/LobbyRankList/RankItem/RankItem",
	}
end


function LobbyRankListSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function LobbyRankListSystem:LoadPB()
	LuaProtoBufManager.LoadProtocFiles("H/Lua/System/LobbyRankList/Proto/proto_ranklist")
end

function LobbyRankListSystem:Init()
	self.MaxRankCount = 30
	self:LoadPB()
	self:AddNetworkEventListenner()
	self.rankListView = LobbyRankListView.New()
end

function LobbyRankListSystem:AddNetworkEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_ranklist.Proto_RankList_CMD","NF_CS_GET_COMMON_RANK_RSP"),self.ResponesRankListMsg,self)
end

function LobbyRankListSystem:RemoveNetworkEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_ranklist.Proto_RankList_CMD","NF_CS_GET_COMMON_RANK_RSP"))
end


--向服务器请求排行榜列表
function LobbyRankListSystem:RequestRankListMsg(rank_type)
	local sendMsg={}
	sendMsg.rank_from = 1
	sendMsg.rank_to = self.MaxRankCount
	sendMsg.rank_type = rank_type
	local bytes = LuaProtoBufManager.Encode("proto_ranklist.Proto_CSGetCommonRankReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_ranklist.Proto_RankList_CMD","NF_CS_GET_COMMON_RANK_REQ"),bytes)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
end

--排行榜列表数据返回
function LobbyRankListSystem:ResponesRankListMsg(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data=LuaProtoBufManager.Decode("proto_ranklist.Proto_SCGetCommonRankRsp",msg)
	if  data.result == 0 then
		if self.rankListView ~= nil then
			self.rankInfoList = data.rank_list
			self.rankListView:ShowUIComponent()
		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end


function LobbyRankListSystem:Open()
	self:ReInitData()
	self:OpenForm()
	self:RequestRankListMsg(1)
end

function LobbyRankListSystem:ReInitData(  )
	self.rankInfoList = {}
end

function LobbyRankListSystem:OpenForm()
	if self.rankListView then 
		self.rankListView:OpenForm()
	end
end

function LobbyRankListSystem:Close()
	self:CloseForm()
end

function LobbyRankListSystem:CloseForm()
	if self.rankListView then 
		self.rankListView:CloseForm()
	end
end

function LobbyRankListSystem:__delete()
	self:Close()
	self:RemoveNetworkEventListenner()
	self.rankListView:Destroy()
	self.rankListView = nil
	self.Instance = nil
end
