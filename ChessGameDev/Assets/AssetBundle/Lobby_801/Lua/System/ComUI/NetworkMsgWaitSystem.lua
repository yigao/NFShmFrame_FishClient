NetworkMsgWaitSystem = Class()

local Instance=nil
local NetworkMsgWaitForm_Path ="Lobby/Prefabs/ComUI/NetworkMsgWaitForm.prefab" 
function NetworkMsgWaitSystem:ctor()
	Instance=self
end


function NetworkMsgWaitSystem.GetInstance()
	if Instance==nil then
		Instance=NetworkMsgWaitSystem.New()
	end
	return Instance
end

function NetworkMsgWaitSystem:Open(time,callBack)	
	self.showTime = time
	self.callBack = callBack
	self.timeElapse = 0
	self:OpenForm()
end

function NetworkMsgWaitSystem:Close()
	self:CloseForm()
end

function NetworkMsgWaitSystem:OpenForm()
	self.uiFormScript = CSScript.UIManager:OpenForm(NetworkMsgWaitForm_Path,true)
	self.formTransform = self.uiFormScript.transform
	self.gameObject = self.uiFormScript.gameObject
	self.updateName = CommonHelper.AddUpdate(self)
end

function NetworkMsgWaitSystem:CloseForm()
	CSScript.UIManager:CloseForm(self.uiFormScript)
	CommonHelper.RemoveUpdate(self.updateName)
	self.uiFormScript = nil
	self.formTransform = nil 
	self.gameObject = nil 
	self.showTime = nil
	self.callBack = nil
	self.timeElapse = nil
end


function NetworkMsgWaitSystem:Update()
	self.timeElapse = self.timeElapse + CS.UnityEngine.Time.deltaTime
	if self.showTime > 0  and self.timeElapse>= self.showTime then
		if self.callBack ~= nil then
			pcall(self.callBack)
		end
		self:Close()
	end
end

function NetworkMsgWaitSystem:__delete()
	self:Close()
end
