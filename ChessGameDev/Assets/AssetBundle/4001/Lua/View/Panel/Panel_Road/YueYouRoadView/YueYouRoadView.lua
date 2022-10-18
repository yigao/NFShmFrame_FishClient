YueYouRoadView=Class()

function YueYouRoadView:ctor(gameObj)
	self:Init(gameObj)
end

function YueYouRoadView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function YueYouRoadView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.UIFormScript = GameManager.GetInstance().UIFormScript
	self.UIListScript = GameManager.GetInstance().UIListScript
	self.Row = RoadManager.GetInstance().Row
	self.YueYouRoadItemList = {}
	-- self.isPlayAnimation = false
end

function YueYouRoadView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function YueYouRoadView:FindView(tf)
	self.uiFormScript = tf:GetComponent(typeof(self.UIFormScript))
	self.uiListScript = tf:Find("YueYouRoad/YueYouItemList"):GetComponent(typeof(self.UIListScript))
	self.uiListScript.InstantiateElementCallback = function (go) self:CreateYueYouRoadItem(go) end
end

function YueYouRoadView:InitViewData()
	self.uiListScript:Initialize(self.uiFormScript)
end


function YueYouRoadView:AddEventListenner()
	
end

function YueYouRoadView:InitYueYouRoadView()
	if self.uiListScript ~= nil then
		self.uiListScript:ResetContentPosition()
	end
	-- self.isPlayAnimation = false
	self.YueYouRoadItemList ={}
	local column = self:GetYueYouRoadItemCount()
	self.uiListScript:SetElementAmount(column) 
	self.uiListScript:MoveElementInScrollArea(column-1,true)
end


function YueYouRoadView:GetYueYouRoadItemCount()
	local column = 0
	for i = 1,#RoadManager.GetInstance().yueYouRoadDataList do
		if RoadManager.GetInstance().yueYouRoadDataList[i].XPoint >= column then
			column = RoadManager.GetInstance().yueYouRoadDataList[i].XPoint
		end
	end
	local tmp = math.ceil(column/2)
	if tmp<9 then
		tmp = 9
	end
	return tmp
end

-- function YueYouRoadView:UpdateRecordItemView()
-- 	self.RecordItemList ={}
-- 	self.isPlayAnimation = true
-- 	self.uiListScript:SetElementAmount(#self.gameData.PrizeHistoryRecord)
-- 	self.uiListScript:MoveElementInScrollArea(#self.gameData.PrizeHistoryRecord -1,true)
-- end

function YueYouRoadView:CreateYueYouRoadItem(go)
	local yueYouRoadItem = RoadManager.GetInstance().YueYouRoadItem.New(go)
    table.insert(self.YueYouRoadItemList,yueYouRoadItem)
end
