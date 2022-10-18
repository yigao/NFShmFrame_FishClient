BeadPlateRoadItem = Class()

function BeadPlateRoadItem:ctor(gameObj)
    self:Init(gameObj)
end

function BeadPlateRoadItem:Init(gameObj)
    self:InitData()
    self:InitView(gameObj)
end

function BeadPlateRoadItem:InitData(  )
    self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
    self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text
    self.Animator = GameManager.GetInstance().Animator
    self.UIListElementScript = GameManager.GetInstance().UIListElementScript 
    self.Row = RoadManager.GetInstance().Row
    self.BeadPlateRoadObjList = {}
end

function BeadPlateRoadItem:InitView(gameObj)
    local mtrans=gameObj.transform
    self:FindView(mtrans)
end

function BeadPlateRoadItem:FindView(tf)
    for i = 1,6 do 
        if self.BeadPlateRoadObjList[i] == nil then
            self.BeadPlateRoadObjList[i] = {}
        end
        local tempTrans = tf:Find("item"..i)
        for j = 1,3 do 
            local imageObject = tempTrans:Find("image0"..j).gameObject
            table.insert(self.BeadPlateRoadObjList[i],imageObject)
        end
    end
    self.uiListElementScript = tf:GetComponent(typeof(self.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableBeadPlateRoadItem(index) end
end

function BeadPlateRoadItem:OnEnableBeadPlateRoadItem(index)
    self:ShowUIView(index)
end

function BeadPlateRoadItem:ShowUIView(index)
    for i = 1,#self.BeadPlateRoadObjList do 
        for j = 1,#self.BeadPlateRoadObjList[i] do
            if j == self.gameData.PrizeHistoryRecord[index*self.Row + i] then
                CommonHelper.SetActive(self.BeadPlateRoadObjList[i][j],true)
            else
                CommonHelper.SetActive(self.BeadPlateRoadObjList[i][j],false)
            end
        end
    end
end
