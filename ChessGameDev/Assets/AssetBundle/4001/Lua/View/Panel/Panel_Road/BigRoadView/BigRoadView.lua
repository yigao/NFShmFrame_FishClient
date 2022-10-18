BigRoadView=Class()

function BigRoadView:ctor(gameObj)
	self:Init(gameObj)
end

function BigRoadView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function BigRoadView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.UIFormScript = GameManager.GetInstance().UIFormScript
	self.UIListScript = GameManager.GetInstance().UIListScript
	self.Row = RoadManager.GetInstance().Row
	self.BigRoadItemList = {}
end

function BigRoadView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function BigRoadView:FindView(tf)
	self.uiFormScript = tf:GetComponent(typeof(self.UIFormScript))
	self.uiListScript = tf:Find("BigRoad/BigItemList"):GetComponent(typeof(self.UIListScript))
	self.uiListScript.InstantiateElementCallback = function (go) self:CreateBigRoadItem(go) end
end

function BigRoadView:InitViewData()
	self.uiListScript:Initialize(self.uiFormScript)
end


function BigRoadView:AddEventListenner()
	
end

function BigRoadView:InitBigRoadView()
	if self.uiListScript ~= nil then
		self.uiListScript:ResetContentPosition()
	end

	self.BigRoadItemList ={}
	local column = self:GetBigRoadItemCount()
	self.uiListScript:SetElementAmount(column) 
	self.uiListScript:MoveElementInScrollArea(column-1,true)
end


function BigRoadView:GetBigRoadItemCount()
	local column = 0
	for i = 1,#RoadManager.GetInstance().history do
		if RoadManager.GetInstance().history[i].XPoint >= column then
			column = RoadManager.GetInstance().history[i].XPoint
		end
	end
	if column<19 then
		column = 19
	end
	return column
end

function BigRoadView:CreateBigRoadItem(go)
	local bigRoadItem = RoadManager.GetInstance().BigRoadItem.New(go)
    table.insert(self.BigRoadItemList,bigRoadItem)
end
