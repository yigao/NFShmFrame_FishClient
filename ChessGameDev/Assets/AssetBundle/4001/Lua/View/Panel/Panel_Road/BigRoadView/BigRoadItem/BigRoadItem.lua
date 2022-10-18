BigRoadItem = Class()

function BigRoadItem:ctor(gameObj)
    self:Init(gameObj)
end

function BigRoadItem:Init(gameObj)
    self:InitData()
    self:InitView(gameObj)
    self:InitViewData()
end

function BigRoadItem:InitData(  )
    self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
    self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text
    self.Animator = GameManager.GetInstance().Animator
    self.UIListElementScript = GameManager.GetInstance().UIListElementScript 
    self.Row = RoadManager.GetInstance().Row
    self.BigRoadObjList = {}
end

function BigRoadItem:InitView(gameObj)
    local mtrans=gameObj.transform
    self:FindView(mtrans)
end

function BigRoadItem:InitViewData()
    self:HideBigRoadItem()
end

function BigRoadItem:FindView(tf)
    for i = 1,6 do 
        if self.BigRoadObjList[i] == nil then
            self.BigRoadObjList[i] = {}
        end
        local tempTrans = tf:Find("item"..i)
        for j = 1,2 do 
            local imageObject = tempTrans:Find("image0"..j).gameObject
            table.insert(self.BigRoadObjList[i],imageObject)
        end
    end
    self.uiListElementScript = tf:GetComponent(typeof(self.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableBigRoadItem(index) end
end

function BigRoadItem:HideBigRoadItem()
    for i = 1,6 do
        for j = 1,#self.BigRoadObjList[i] do
            CommonHelper.SetActive(self.BigRoadObjList[i][j],false)
        end
    end
end


function BigRoadItem:OnEnableBigRoadItem(index)
    self:ShowUIView(index)
end

function BigRoadItem:ShowUIView(index)
    self:HideBigRoadItem()
    for i = 1,#RoadManager.GetInstance().history do
        if RoadManager.GetInstance().history[i].XPoint == (index + 1) then
            local row = RoadManager.GetInstance().history[i].YPoint
            local result = RoadManager.GetInstance().history[i].WinResult
            if result == 1 then
                CommonHelper.SetActive(self.BigRoadObjList[row][1],true)
                CommonHelper.SetActive(self.BigRoadObjList[row][2],false)
            elseif result == 3 then
                CommonHelper.SetActive(self.BigRoadObjList[row][1],false)
                CommonHelper.SetActive(self.BigRoadObjList[row][2],true)
            end
        end
    end
end

