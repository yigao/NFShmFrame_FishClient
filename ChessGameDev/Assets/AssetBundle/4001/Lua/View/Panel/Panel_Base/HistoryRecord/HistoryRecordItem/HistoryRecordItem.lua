HistoryRecordItem = Class()

function HistoryRecordItem:ctor(gameObj)
    self:Init(gameObj)
end

function HistoryRecordItem:Init(gameObj)
    self:InitData()
    self:InitView(gameObj)
end

function HistoryRecordItem:InitData(  )
    self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
    self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text
    self.Animator = GameManager.GetInstance().Animator
    self.UIListElementScript = GameManager.GetInstance().UIListElementScript 
    self.curRecordVo = nil
    self.resultObjList = {}
end

function HistoryRecordItem:InitView(gameObj)
    local mtrans=gameObj.transform
    self:FindView(mtrans)
end

function HistoryRecordItem:FindView(tf)
    for i = 1,3 do 
        local tempObject = tf:Find("obj/result_image_"..i).gameObject
        table.insert(self.resultObjList,tempObject)
    end

    self.uiListElementScript = tf:GetComponent(typeof(self.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableRecordItem(index) end

    self.animator = tf:GetComponent(typeof(self.Animator))
end

function HistoryRecordItem:OnEnableRecordItem(index)
    self.curRecordVo = self.gameData.PrizeHistoryRecord[index + 1]
    self:ShowUIView(index)
   
end

function HistoryRecordItem:ShowUIView(index)
    for i = 1,#self.resultObjList do 
        if i == self.curRecordVo then
            CommonHelper.SetActive(self.resultObjList[i],true)
        else
            CommonHelper.SetActive(self.resultObjList[i],false)
        end
    end

    if (index == (#self.gameData.PrizeHistoryRecord-1)) and (BaseFctManager.GetInstance().HistoryRecordView.isPlayAnimation == true) then
        self:PlayAnimation()
    end
end

function HistoryRecordItem:PlayAnimation()
    self.animator:Play("History_Record_Result02",0,0)
    BaseFctManager.GetInstance().HistoryRecordView.isPlayAnimation = false
end
