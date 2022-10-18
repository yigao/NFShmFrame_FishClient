SmallRoadView=Class()

function SmallRoadView:ctor(gameObj)
	self:Init(gameObj)
end

function SmallRoadView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function SmallRoadView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.UIFormScript = GameManager.GetInstance().UIFormScript
	self.UIListScript = GameManager.GetInstance().UIListScript
	self.Row = RoadManager.GetInstance().Row
	self.smallRoadItemList = {}
end

function SmallRoadView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function SmallRoadView:FindView(tf)
	self.uiFormScript = tf:GetComponent(typeof(self.UIFormScript))
	self.uiListScript = tf:Find("SmallRoad/SamllItemList"):GetComponent(typeof(self.UIListScript))
	self.uiListScript.InstantiateElementCallback = function (go) self:CreateSmallRoadItem(go) end
end

function SmallRoadView:InitViewData()
	self.uiListScript:Initialize(self.uiFormScript)
end


function SmallRoadView:AddEventListenner()
	
end

function SmallRoadView:InitSmallRoadView()
	if self.uiListScript ~= nil then
		self.uiListScript:ResetContentPosition()
	end

	self.smallRoadItemList ={}
	local column = self:GetSmallRoadItemCount()
	self.uiListScript:SetElementAmount(column) 
	self.uiListScript:MoveElementInScrollArea(column-1,true)
end


function SmallRoadView:GetSmallRoadItemCount()
	local column = 0
	for i = 1,#RoadManager.GetInstance().smallRoadDataList do
		if RoadManager.GetInstance().smallRoadDataList[i].XPoint >= column then
			column = RoadManager.GetInstance().smallRoadDataList[i].XPoint
		end
	end
	local tmp = math.ceil(column/2)
	if tmp<10 then
		tmp = 10
	end
	return tmp
end


function SmallRoadView:CreateSmallRoadItem(go)
	local smallRoadItem = RoadManager.GetInstance().SmallRoadItem.New(go)
    table.insert(self.smallRoadItemList,smallRoadItem)
end
