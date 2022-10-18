EyeRoadItem = Class()

function EyeRoadItem:ctor(gameObj)
    self:Init(gameObj)
end

function EyeRoadItem:Init(gameObj)
    self:InitData()
    self:InitView(gameObj)
    self:InitViewData()
end

function EyeRoadItem:InitData(  )
    self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
    self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text
    self.Animator = GameManager.GetInstance().Animator
    self.UIListElementScript = GameManager.GetInstance().UIListElementScript 
    self.Row = RoadManager.GetInstance().Row
    self.eyeRoadObjList = {}
end

function EyeRoadItem:InitView(gameObj)
    local mtrans=gameObj.transform
    self:FindView(mtrans)
end

function EyeRoadItem:InitViewData()
    self:HideEyeRoadItem()
end

function EyeRoadItem:FindView(tf)
    for i = 1,12 do 
        if self.eyeRoadObjList[i] == nil then
            self.eyeRoadObjList[i] = {}
        end
        local tempTrans = tf:Find("item"..i)
        for j = 1,2 do 
            local imageObject = tempTrans:Find("image0"..j).gameObject
            table.insert(self.eyeRoadObjList[i],imageObject)
        end
    end
    self.uiListElementScript = tf:GetComponent(typeof(self.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableEyeRoadItem(index) end
end

function EyeRoadItem:HideEyeRoadItem()
    for i = 1,12 do
        for j = 1,#self.eyeRoadObjList[i] do
            CommonHelper.SetActive(self.eyeRoadObjList[i][j],false)
        end
    end
end

function EyeRoadItem:OnEnableEyeRoadItem(index)
    self:ShowUIView(index)
end

function EyeRoadItem:ShowUIView(index)
    index = index * 2
    self:HideEyeRoadItem()
    for i = 1,#RoadManager.GetInstance().eyeRoadDataList do
        if RoadManager.GetInstance().eyeRoadDataList[i].XPoint == (index + 1) then
            local row = RoadManager.GetInstance().eyeRoadDataList[i].YPoint
            local result = RoadManager.GetInstance().eyeRoadDataList[i].WinResult
            if result == 1 then
                CommonHelper.SetActive(self.eyeRoadObjList[row][1],true)
                CommonHelper.SetActive(self.eyeRoadObjList[row][2],false)
            elseif result == 0 then
                CommonHelper.SetActive(self.eyeRoadObjList[row][1],false)
                CommonHelper.SetActive(self.eyeRoadObjList[row][2],true)
            end
        elseif  RoadManager.GetInstance().eyeRoadDataList[i].XPoint == (index + 2) then
            local row = RoadManager.GetInstance().eyeRoadDataList[i].YPoint + 6
            local result = RoadManager.GetInstance().eyeRoadDataList[i].WinResult
            if result == 1 then
                CommonHelper.SetActive(self.eyeRoadObjList[row][1],true)
                CommonHelper.SetActive(self.eyeRoadObjList[row][2],false)
            elseif result == 0 then
                CommonHelper.SetActive(self.eyeRoadObjList[row][1],false)
                CommonHelper.SetActive(self.eyeRoadObjList[row][2],true)
            end
        end
    end
end

