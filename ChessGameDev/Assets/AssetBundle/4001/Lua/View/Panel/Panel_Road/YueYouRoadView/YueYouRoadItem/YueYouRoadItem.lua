YueYouRoadItem = Class()

function YueYouRoadItem:ctor(gameObj)
    self:Init(gameObj)
end

function YueYouRoadItem:Init(gameObj)
    self:InitData()
    self:InitView(gameObj)
    self:InitViewData()
end

function YueYouRoadItem:InitData(  )
    self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
    self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text
    self.Animator = GameManager.GetInstance().Animator
    self.UIListElementScript = GameManager.GetInstance().UIListElementScript 
    self.Row = RoadManager.GetInstance().Row
    self.yueYouRoadObjList = {}
end

function YueYouRoadItem:InitView(gameObj)
    local mtrans=gameObj.transform
    self:FindView(mtrans)
end

function YueYouRoadItem:InitViewData()
    self:HideYueYouRoadItem()
end

function YueYouRoadItem:FindView(tf)
    for i = 1,12 do 
        if self.yueYouRoadObjList[i] == nil then
            self.yueYouRoadObjList[i] = {}
        end
        local tempTrans = tf:Find("item"..i)
        for j = 1,2 do 
            local imageObject = tempTrans:Find("image0"..j).gameObject
            table.insert(self.yueYouRoadObjList[i],imageObject)
        end
    end
    self.uiListElementScript = tf:GetComponent(typeof(self.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableYueYouRoadItem(index) end
    -- self.animator = tf:GetComponent(typeof(self.Animator))
end

function YueYouRoadItem:HideYueYouRoadItem()
    for i = 1,12 do
        for j = 1,#self.yueYouRoadObjList[i] do
            CommonHelper.SetActive(self.yueYouRoadObjList[i][j],false)
        end
    end
end

function YueYouRoadItem:OnEnableYueYouRoadItem(index)
    self:ShowUIView(index)
end

function YueYouRoadItem:ShowUIView(index)
    self:HideYueYouRoadItem()
    for i = 1,#RoadManager.GetInstance().yueYouRoadDataList do
        if RoadManager.GetInstance().yueYouRoadDataList[i].XPoint == (index + 1) then
            local row = RoadManager.GetInstance().yueYouRoadDataList[i].YPoint
            local result = RoadManager.GetInstance().yueYouRoadDataList[i].WinResult
            if result == 1 then
                CommonHelper.SetActive(self.yueYouRoadObjList[row][1],true)
                CommonHelper.SetActive(self.yueYouRoadObjList[row][2],false)
            elseif result == 0 then
                CommonHelper.SetActive(self.yueYouRoadObjList[row][1],false)
                CommonHelper.SetActive(self.yueYouRoadObjList[row][2],true)
            end
        elseif  RoadManager.GetInstance().yueYouRoadDataList[i].XPoint == (index + 2) then
            local row = RoadManager.GetInstance().yueYouRoadDataList[i].YPoint + 6
            local result = RoadManager.GetInstance().yueYouRoadDataList[i].WinResult
            if result == 1 then
                CommonHelper.SetActive(self.yueYouRoadObjList[row][1],true)
                CommonHelper.SetActive(self.yueYouRoadObjList[row][2],false)
            elseif result == 0 then
                CommonHelper.SetActive(self.yueYouRoadObjList[row][1],false)
                CommonHelper.SetActive(self.yueYouRoadObjList[row][2],true)
            end
        end
    end
end
