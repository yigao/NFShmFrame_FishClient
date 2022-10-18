SmallRoadItem = Class()

function SmallRoadItem:ctor(gameObj)
    self:Init(gameObj)
end

function SmallRoadItem:Init(gameObj)
    self:InitData()
    self:InitView(gameObj)
    self:InitViewData()
end

function SmallRoadItem:InitData(  )
    self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
    self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text
    self.Animator = GameManager.GetInstance().Animator
    self.UIListElementScript = GameManager.GetInstance().UIListElementScript 
    self.Row = RoadManager.GetInstance().Row
    self.smallRoadObjList = {}
end

function SmallRoadItem:InitView(gameObj)
    local mtrans=gameObj.transform
    self:FindView(mtrans)
end

function SmallRoadItem:InitViewData()
    self:HideSmallRoadItem()
end

function SmallRoadItem:FindView(tf)
    for i = 1,12 do 
        if self.smallRoadObjList[i] == nil then
            self.smallRoadObjList[i] = {}
        end
        local tempTrans = tf:Find("item"..i)
        for j = 1,2 do 
            local imageObject = tempTrans:Find("image0"..j).gameObject
            table.insert(self.smallRoadObjList[i],imageObject)
        end
    end
    self.uiListElementScript = tf:GetComponent(typeof(self.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableSmallRoadItem(index) end
end

function SmallRoadItem:HideSmallRoadItem()
    for i = 1,12 do
        for j = 1,#self.smallRoadObjList[i] do
            CommonHelper.SetActive(self.smallRoadObjList[i][j],false)
        end
    end
end

function SmallRoadItem:OnEnableSmallRoadItem(index)
    self:ShowUIView(index)
end

function SmallRoadItem:ShowUIView(index)
    self:HideSmallRoadItem()
    for i = 1,#RoadManager.GetInstance().smallRoadDataList do
        if RoadManager.GetInstance().smallRoadDataList[i].XPoint == (index + 1) then
            local row = RoadManager.GetInstance().smallRoadDataList[i].YPoint
            local result = RoadManager.GetInstance().smallRoadDataList[i].WinResult
            if result == 1 then
                CommonHelper.SetActive(self.smallRoadObjList[row][1],true)
                CommonHelper.SetActive(self.smallRoadObjList[row][2],false)
            elseif result == 0 then
                CommonHelper.SetActive(self.smallRoadObjList[row][1],false)
                CommonHelper.SetActive(self.smallRoadObjList[row][2],true)
            end
        elseif  RoadManager.GetInstance().smallRoadDataList[i].XPoint == (index + 2) then
            local row = RoadManager.GetInstance().smallRoadDataList[i].YPoint + 6
            local result = RoadManager.GetInstance().smallRoadDataList[i].WinResult
            if result == 1 then
                CommonHelper.SetActive(self.smallRoadObjList[row][1],true)
                CommonHelper.SetActive(self.smallRoadObjList[row][2],false)
            elseif result == 0 then
                CommonHelper.SetActive(self.smallRoadObjList[row][1],false)
                CommonHelper.SetActive(self.smallRoadObjList[row][2],true)
            end
        end
    end
end
