RoadView=Class()

function RoadView:ctor(gameObj)
	self:Init(gameObj)
end

function RoadView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function RoadView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Text = GameManager.GetInstance().Text
end

function RoadView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function RoadView:FindView(tf)
	self.CloseBtn = tf:Find("Close_Btn"):GetComponent(typeof(self.Button))
	self.DragNumber_Text = tf:Find("Result/Dragon/number"):GetComponent(typeof(self.Text))
	self.PeaceNumber_Text = tf:Find("Result/Peace/number"):GetComponent(typeof(self.Text))
	self.TigerNumber_Text = tf:Find("Result/Tiger/number"):GetComponent(typeof(self.Text))
	self.TotalNumber_Text = tf:Find("Result/Total/number"):GetComponent(typeof(self.Text))
end

function RoadView:InitViewData()

end

function RoadView:InitRoadView()
	self.DragNumber_Text.text = RoadManager.GetInstance():GetDragonNumber()
	self.PeaceNumber_Text.text = RoadManager.GetInstance():GetPeaceNumber()
	self.TigerNumber_Text.text = RoadManager.GetInstance():GetTigerNumber()
	self.TotalNumber_Text.text = #self.gameData.PrizeHistoryRecord
end

function RoadView:AddEventListenner()
	self.CloseBtn.onClick:AddListener(function () self:OnClickClose() end)
end


function RoadView:OnClickClose()
	RoadManager.GetInstance():IsShowRoadPanel(false)
end
