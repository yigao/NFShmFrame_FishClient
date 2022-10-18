LobbyNoticeSystem = Class()

local Instance=nil
function LobbyNoticeSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function LobbyNoticeSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyNoticeSystem.New()
	end
	return Instance
end

function LobbyNoticeSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/ComUI/LobbyNotice/LobbyNoticeView",
		"H/Lua/System/ComUI/LobbyNotice/NoticeItem",
	}
end


function LobbyNoticeSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end


function LobbyNoticeSystem:Init()
	self.noticeDataList = {
		[1] = "恭喜老司机带带我在大脑天空2中人品爆发，获得太厉害啦！",
		[2]	= "百亿排行,快手充值：8899,,微信爆分，728转运 金榜广豆 幸运支架 上装通杀 彩云聚集 大额无忧 五连宝箱",
		[3] = "东山再起户型 捕鱼原子弹 小姐姐配料美女微信 想赢加 百亿宝箱"
	}
	self:AddEventListenner()
	self.indexPostion = 1 --1：大厅一级界面，2：大厅二级界面
	self.noticeView = LobbyNoticeView.New()
end

function LobbyNoticeSystem:AddEventListenner(  )
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.NoticeFormChangePosition_EventName,self.LobbyNoticePosition,self)
end

function LobbyNoticeSystem:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.NoticeFormChangePosition_EventName)
end

function LobbyNoticeSystem:LobbyNoticePosition(indexPostion)
	self.indexPostion = indexPostion
	if self.noticeView ~= nil then
		self.noticeView:SetNoticePosition()
	end
end

function LobbyNoticeSystem:Open()
	self:ReInitData()
	self:OpenForm()
end

function LobbyNoticeSystem:ReInitData(  )
	self.indexPostion = 1
end

function LobbyNoticeSystem:OpenForm()
	if self.noticeView then 
		self.noticeView:OpenForm()
	end
end

function LobbyNoticeSystem:Close()
	self:CloseForm()
end

function LobbyNoticeSystem:CloseForm()
	if self.noticeView then 
		self.noticeView:CloseForm()
	end
end

function LobbyNoticeSystem:__delete()
	self:RemoveEventListenner()
	self:Close()
	self.noticeView:Destroy()
	self.noticeView = nil
	self.Instance = nil
end
