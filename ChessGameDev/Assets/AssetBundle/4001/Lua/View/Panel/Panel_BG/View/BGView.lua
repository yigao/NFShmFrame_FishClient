BGView=Class()

function BGView:ctor(gameObj)
	self:Init(gameObj)

end

function BGView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function BGView:InitData()
	self.Button=GameManager.GetInstance().Button
	self.Vector3 = GameManager.GetInstance().Vector3
	self.gameData = GameManager.GetInstance().gameData
end

function BGView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
end


function BGView:FindView(tf)
	self.DragonBtn = tf:Find("Area/DragonBtn"):GetComponent(typeof(self.Button))
	self.DragonBtnTrans = self.DragonBtn.transform
	self.dagonAreaLocalPos = tf:Find("Area/DragonBtn/bg").localPosition
	self.PeacepBtn = tf:Find("Area/PeaceBtn"):GetComponent(typeof(self.Button))
	self.PeacepBtnTrans = self.PeacepBtn.transform
	self.PeacepAreaLocalPos = tf:Find("Area/PeaceBtn/bg").localPosition
	self.TigerBtn = tf:Find("Area/TigerBtn"):GetComponent(typeof(self.Button))
	self.TigerBtnTrans = self.TigerBtn.transform
	self.TigerAreaLocalPos = tf:Find("Area/TigerBtn/bg").localPosition
end

function BGView:AddEventListenner()
	self.DragonBtn.onClick:AddListener(function () self:OnClickDragonArea() end)
	self.PeacepBtn.onClick:AddListener(function () self:OnClickPeace() end)
	self.TigerBtn.onClick:AddListener(function () self:OnClickTiger() end)
end


function BGView:OnClickDragonArea()
	if self.gameData.MainStation ~= StateManager.MainState.STATE_BetChip then
		return
	end
	PlayerManager.GetInstance():GetMySelfPlayer():OnClickSendBetChip(GameData.AreaType.AREA_Dragon)
end

function BGView:OnClickPeace()
	if self.gameData.MainStation ~= StateManager.MainState.STATE_BetChip then
		return
	end
	PlayerManager.GetInstance():GetMySelfPlayer():OnClickSendBetChip(GameData.AreaType.AREA_Peace)
end

function BGView:OnClickTiger()
	if self.gameData.MainStation ~= StateManager.MainState.STATE_BetChip then
		return
	end
	PlayerManager.GetInstance():GetMySelfPlayer():OnClickSendBetChip(GameData.AreaType.AREA_Tiger)
end


function BGView:GetRandBetAreaPos(areaIndex)
	local areaPos = self.Vector3.zero
	local x = 0
	local y = 0
	if areaIndex == 1 then
		x = math.random(self.dagonAreaLocalPos.x-120,self.dagonAreaLocalPos.x+120)
		y = math.random(self.dagonAreaLocalPos.x-80,self.dagonAreaLocalPos.x+80)
		areaPos = self.DragonBtnTrans:TransformPoint(self.Vector3(x,y,self.dagonAreaLocalPos.z))
	elseif areaIndex == 2 then
		x = math.random(self.PeacepAreaLocalPos.x-90,self.PeacepAreaLocalPos.x+90)
		y = math.random(self.PeacepAreaLocalPos.x-40,self.PeacepAreaLocalPos.x+40)
		areaPos = self.PeacepBtnTrans:TransformPoint(self.Vector3(x,y,self.PeacepAreaLocalPos.z))
	elseif areaIndex == 3 then
		x = math.random(self.TigerAreaLocalPos.x-120,self.TigerAreaLocalPos.x+120)
		y = math.random(self.TigerAreaLocalPos.x-80,self.TigerAreaLocalPos.x+80)
		areaPos = self.TigerBtnTrans:TransformPoint(self.Vector3(x,y,self.TigerAreaLocalPos.z))
	end
	return areaPos
end

function BGView:__delete()
	
end
