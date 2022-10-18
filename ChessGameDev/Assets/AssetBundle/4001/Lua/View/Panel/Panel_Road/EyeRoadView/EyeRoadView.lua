EyeRoadView=Class()

function EyeRoadView:ctor(gameObj)
	self:Init(gameObj)
end

function EyeRoadView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function EyeRoadView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.UIFormScript = GameManager.GetInstance().UIFormScript
	self.UIListScript = GameManager.GetInstance().UIListScript
	self.Row = RoadManager.GetInstance().Row
	self.EyeRoadItemList = {}
	-- self.isPlayAnimation = false
end

function EyeRoadView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function EyeRoadView:FindView(tf)
	self.uiFormScript = tf:GetComponent(typeof(self.UIFormScript))
	self.uiListScript = tf:Find("EyeRoad/EyeItemList"):GetComponent(typeof(self.UIListScript))
	self.uiListScript.InstantiateElementCallback = function (go) self:CreateEyeRoadItem(go) end
end

function EyeRoadView:InitViewData()
	self.uiListScript:Initialize(self.uiFormScript)
end


function EyeRoadView:AddEventListenner()
	
end

function EyeRoadView:InitEyeRoadView()
	if self.uiListScript ~= nil then
		self.uiListScript:ResetContentPosition()
	end
	-- self.isPlayAnimation = false
	self.EyeRoadItemList ={}
	local column = self:GetEyeRoadItemCount()
	self.uiListScript:SetElementAmount(column) 
	self.uiListScript:MoveElementInScrollArea(column-1,true)
end


function EyeRoadView:GetEyeRoadItemCount()
	local column = 0
	for i = 1,#RoadManager.GetInstance().eyeRoadDataList do
		if RoadManager.GetInstance().eyeRoadDataList[i].XPoint >= column then
			column = RoadManager.GetInstance().eyeRoadDataList[i].XPoint
		end
	end
	local tmp = math.ceil(column/2)
	if tmp<9 then
		tmp = 9
	end
	return tmp
end


function EyeRoadView:CreateEyeRoadItem(go)
	local eyeRoadItem = RoadManager.GetInstance().EyeRoadItem.New(go)
    table.insert(self.EyeRoadItemList,eyeRoadItem)
end
