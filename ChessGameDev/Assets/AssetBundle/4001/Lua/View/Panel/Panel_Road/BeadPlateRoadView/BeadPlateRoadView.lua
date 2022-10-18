BeadPlateRoadView=Class()

function BeadPlateRoadView:ctor(gameObj)
	self:Init(gameObj)
end

function BeadPlateRoadView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function BeadPlateRoadView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.UIFormScript = GameManager.GetInstance().UIFormScript
	self.UIListScript = GameManager.GetInstance().UIListScript
	self.Row = RoadManager.GetInstance().Row
	self.BeadPlateRoadItemList = {}
end

function BeadPlateRoadView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function BeadPlateRoadView:FindView(tf)
	self.uiFormScript = tf:GetComponent(typeof(self.UIFormScript))
	self.uiListScript = tf:Find("BeadPlateRoad/BeadPlateItemList"):GetComponent(typeof(self.UIListScript))
	self.uiListScript.InstantiateElementCallback = function (go) self:CreateBeadPlateRoadItem(go) end
end

function BeadPlateRoadView:InitViewData()
	self.uiListScript:Initialize(self.uiFormScript)
end

function BeadPlateRoadView:AddEventListenner()
	
end

function BeadPlateRoadView:InitBeadPlateRoadView()
	if self.uiListScript ~= nil then
		self.uiListScript:ResetContentPosition()
	end
	self.BeadPlateRoadItemList ={}
	local column = self:GetBeadPlateRoadItemCount()
	self.uiListScript:SetElementAmount(column) 
	self.uiListScript:MoveElementInScrollArea(column-1,true)
end


function BeadPlateRoadView:GetBeadPlateRoadItemCount()
	local column,tmp2 = math.modf(#self.gameData.PrizeHistoryRecord/self.Row) 
	local mold = #self.gameData.PrizeHistoryRecord % self.Row
	if mold > 0 then
		column = column + 1
	end
	if column<6 then
		column = 6
	end
	return column
end

-- function BeadPlateRoadView:UpdateRecordItemView()
-- 	self.RecordItemList ={}
-- 	self.isPlayAnimation = true
-- 	self.uiListScript:SetElementAmount(#self.gameData.PrizeHistoryRecord)
-- 	self.uiListScript:MoveElementInScrollArea(#self.gameData.PrizeHistoryRecord -1,true)
-- end

function BeadPlateRoadView:CreateBeadPlateRoadItem(go)
	local beadPlateRoadItem = RoadManager.GetInstance().BeadPlateRoadItem.New(go)
    table.insert(self.BeadPlateRoadItemList,beadPlateRoadItem)
end
