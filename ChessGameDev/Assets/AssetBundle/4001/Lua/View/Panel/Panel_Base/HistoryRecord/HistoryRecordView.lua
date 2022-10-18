HistoryRecordView=Class()

function HistoryRecordView:ctor(gameObj)
	self:Init(gameObj)
end

function HistoryRecordView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function HistoryRecordView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.UIFormScript = GameManager.GetInstance().UIFormScript
	self.UIListScript = GameManager.GetInstance().UIListScript
	self.RecordItemList = {}
	self.isPlayAnimation = false
end

function HistoryRecordView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function HistoryRecordView:FindView(tf)
	self.uiFormScript = tf:GetComponent(typeof(self.UIFormScript))

	self.uiListScript = tf:Find("HistoryRecordPanel/RecordItemList"):GetComponent(typeof(self.UIListScript))
	self.uiListScript.InstantiateElementCallback = function (go) self:CreateRecordItem(go) end
	
	self.RecordBtn = tf:Find("HistoryRecordPanel/RecordBtn"):GetComponent(typeof(self.Button))
end

function HistoryRecordView:InitViewData()
	self.uiListScript:Initialize(self.uiFormScript)
end

function HistoryRecordView:AddEventListenner()
	self.RecordBtn.onClick:AddListener(function () self:OnClickRecord() end)
end

function HistoryRecordView:InitRecordItemView()
	if self.uiListScript ~= nil then
		self.uiListScript:ResetContentPosition()
	end
	self.isPlayAnimation = false
	self.RecordItemList ={}
	self.uiListScript:SetElementAmount(#self.gameData.PrizeHistoryRecord)
	self.uiListScript:MoveElementInScrollArea(#self.gameData.PrizeHistoryRecord -1,true)
end

function HistoryRecordView:UpdateRecordItemView()
	self.RecordItemList ={}
	self.isPlayAnimation = true
	self.uiListScript:SetElementAmount(#self.gameData.PrizeHistoryRecord)
	self.uiListScript:MoveElementInScrollArea(#self.gameData.PrizeHistoryRecord -1,true)
end

function HistoryRecordView:CreateRecordItem(go)
	local recordItem = BaseFctManager.GetInstance().HistoryRecordItem.New(go)
    table.insert(self.RecordItemList,recordItem)
end

function HistoryRecordView:OnClickRecord()
	AudioManager.GetInstance():PlayNormalAudio(27)
	RoadManager.GetInstance():OpenRoadPanel()
end
