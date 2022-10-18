TipsSystem = Class()

local Instance=nil
function TipsSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
end


function TipsSystem.GetInstance()
	if Instance==nil then
		Instance=TipsSystem.New()
	end
	return Instance
end

function TipsSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/ComUI/TipsSystem/TipsView",
	}
end


function TipsSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function TipsSystem:Init()
	self:InitData()
	self:InitView()
end

function TipsSystem:InitData()
	self.AllUseTipsViewList = {}
	self.CurrentTipsViewList={}
	self.UID=1
	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.TweenExtensions = CS.DG.Tweening.TweenExtensions
	self.currentCount = 0
	self.MaxCount = 3
end

function TipsSystem:InitView()
	
end

function TipsSystem:OpenForm(tipsID,prefix,suffix,lifeTime)
	if tipsID == nil or self.currentCount > self.MaxCount then return end

	local str = HallLuaDefine.Tips_Info_Str[tipsID]
	if str == nil then
		str = HallLuaDefine.Tips_Info_Str[-1]
	end
	local color = nil
	if tipsID >=30000 then
		color =  CS.UnityEngine.Color(0.81,0.67,0.09,1)
	else
		color = CS.UnityEngine.Color(0.71,0.13,0.13,1)
	end

	if prefix then
		str = prefix..str
	end

	if suffix then
		str = str..suffix
	end

	local tempUID = self:GetTipsViewUID()
	local tipsView = self:GetTipsView(tempUID)
	if tipsView ~= nil then
		tipsView:OpenForm(tempUID,str,color,lifeTime)
	end
end

function TipsSystem:OpenTipsFormContent(content,lifeTime)
	if content == nil or self.currentCount > self.MaxCount then return end
	local color = CS.UnityEngine.Color(0.71,0.13,0.13,1)
	local tempUID = self:GetTipsViewUID()
	local tipsView = self:GetTipsView(tempUID)
	if tipsView ~= nil then
		tipsView:OpenForm(tempUID,content,color,lifeTime)
	end
end

function TipsSystem:GetTipsViewUID()
	self.currentCount = self.currentCount + 1
	self.UID=self.UID+1
	return self.UID
end

function TipsSystem:GetTipsView(curUID)
	if self.AllUseTipsViewList and #self.AllUseTipsViewList>0 then
		local tempTipsView=table.remove(self.AllUseTipsViewList,1)
		if tempTipsView then
			self.CurrentTipsViewList[curUID]=tempTipsView
			return tempTipsView
		else
			Debug.LogError("创建TipsView失败==>"..curUID)
		end
	else
		local tempTipsView = TipsView.New()
		self.CurrentTipsViewList[curUID]=tempTipsView
		return tempTipsView
	end
	return nil	
end

function TipsSystem:CloseForm(uid)
	local tempTipsView=self.CurrentTipsViewList[uid]
	if tempTipsView then
		if self.AllUseTipsViewList==nil then
			self.AllUseTipsViewList={}
		end
		self.currentCount = self.currentCount - 1
		tempTipsView:CloseForm()
		table.insert(self.AllUseTipsViewList,tempTipsView)
		self.CurrentTipsViewList[uid]=nil
	else
		Debug.LogError("移除的TipsView为nil==>UID"..uid)
	end
end

function TipsSystem:CloseAllForm(  )
	if self.CurrentTipsViewList  then
		for k,v in pairs(self.CurrentTipsViewList) do
			v:CloseForm(v.UID)
		end
	end
	self.currentCount = 0
end

function TipsSystem:__delete()
	self:Close()
	self.netWaitView:Destroy()
	self.netWaitView = nil
end
