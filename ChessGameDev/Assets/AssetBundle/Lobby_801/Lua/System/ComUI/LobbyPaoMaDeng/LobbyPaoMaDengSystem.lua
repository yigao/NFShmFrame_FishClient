LobbyPaoMaDengSystem = Class()

local Instance=nil
function LobbyPaoMaDengSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function LobbyPaoMaDengSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyPaoMaDengSystem.New()
	end
	return Instance
end

function LobbyPaoMaDengSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/ComUI/LobbyPaoMaDeng/LobbyPaoMaDengView",
	}
end


function LobbyPaoMaDengSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end


function LobbyPaoMaDengSystem:Init()
	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.TweenExtensions = CS.DG.Tweening.TweenExtensions

	self.paoMaDengDataList = {}
	self:AddEventListenner()
	self.indexPostion = 1 --1：大厅一级界面，2：加载界面或正在游戏里面
	self.paoMaDengView = LobbyPaoMaDengView.New()
	self.isNeedPMD=true
end

function LobbyPaoMaDengSystem:AddEventListenner(  )
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.PaoMaDengChangePosition_EventName,self.LobbyPaoMaDengPosition,self)
end

function LobbyPaoMaDengSystem:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.PaoMaDengChangePosition_EventName)
end


function LobbyPaoMaDengSystem:Open()
	self:ReInitData()
	self:OpenForm()
end

function LobbyPaoMaDengSystem:ReInitData(  )
	self.indexPostion = 1
end

function LobbyPaoMaDengSystem:OpenForm()
	if self.paoMaDengView and self.isNeedPMD==true then 
		self.paoMaDengView:OpenForm()
	end
end

function LobbyPaoMaDengSystem:SetPaoMaDengData(data)
	self.paoMaDengDataList = {}
	self.paoMaDengDataList = data
	self:OpenForm()
end

function LobbyPaoMaDengSystem:LobbyPaoMaDengPosition(indexPostion)
	self.indexPostion = indexPostion
	if self.paoMaDengView ~= nil then
		self.paoMaDengView:SetPaoMaDengPosition()
	end
end

function LobbyPaoMaDengSystem:Close()
	self:CloseForm()
end


function LobbyPaoMaDengSystem:CloseForm()
	if self.paoMaDengView then 
		self.paoMaDengView:CloseForm()
	end
end


function LobbyPaoMaDengSystem:ResetPaoMaDengState(isNeed)
	self.isNeedPMD=isNeed
end

function LobbyPaoMaDengSystem:__delete()
	self:Close()
	self:RemoveEventListenner()
	self.paoMaDengView:Destroy()
	self.paoMaDengView = nil
	self.Instance = nil
end
