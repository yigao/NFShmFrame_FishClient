PlayerRankItem = Class()

function PlayerRankItem:ctor(gameObj)
    self:Init(gameObj)
end

function PlayerRankItem:Init(gameObj)
    self:InitData()
    self:InitView(gameObj)
end

function PlayerRankItem:InitData(  )
    self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
    self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text 
    self.UIListElementScript = GameManager.GetInstance().UIListElementScript 
    self.currentRankVo = nil
    self.huangGuanObjList = {}
end

function PlayerRankItem:InitView(gameObj)
    local mtrans=gameObj.transform
    self:FindView(mtrans)
end

function PlayerRankItem:FindView(tf)
    self.head_icon_image = tf:Find("head_icon"):GetComponent(typeof(self.Image))
    self.name_text = tf:Find("name"):GetComponent(typeof(self.Text))
    self.money_number_text = tf:Find("money"):GetComponent(typeof(self.Text))
    self.shenSuanZi_Image_Obj = tf:Find("rank/shensuanzi").gameObject
    for i = 1,5 do 
        local tempObject = tf:Find("rank/huangguan"..i).gameObject
        table.insert(self.huangGuanObjList,tempObject)
    end
    self.uiListElementScript = tf:GetComponent(typeof(self.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableRankItem(index) end
end

function PlayerRankItem:OnEnableRankItem(index)
    self.currentRankVo = PlayerManager.GetInstance().playerVoList[index + 1]
    self:ShowUIView(index)
end

function PlayerRankItem:ShowUIView(index)
    self.name_text.text =  self.currentRankVo.user_name
    self.money_number_text.text =  self.currentRankVo.user_money
    self.head_icon_image.sprite = LobbyHallCoreSystem.GetInstance():GetAllocateHeadImage(self.currentRankVo.usFaceId)
    for i = 1,#self.huangGuanObjList do 
        CommonHelper.SetActive(self.huangGuanObjList[i],false)
    end

    if index == 0 then
        CommonHelper.SetActive(self.shenSuanZi_Image_Obj,true)
    elseif index  == 1 then
        CommonHelper.SetActive(self.shenSuanZi_Image_Obj,false)
        CommonHelper.SetActive(self.huangGuanObjList[index],true)
    elseif index == 2 then
        CommonHelper.SetActive(self.shenSuanZi_Image_Obj,false)
        CommonHelper.SetActive(self.huangGuanObjList[index],true)
    elseif index == 3 then
        CommonHelper.SetActive(self.shenSuanZi_Image_Obj,false)  
        CommonHelper.SetActive(self.huangGuanObjList[index],true)   
    elseif index == 4 then
        CommonHelper.SetActive(self.shenSuanZi_Image_Obj,false)
        CommonHelper.SetActive(self.huangGuanObjList[index],true)
    elseif index == 5 then
        CommonHelper.SetActive(self.shenSuanZi_Image_Obj,false)
        CommonHelper.SetActive(self.huangGuanObjList[index],true)
    else
        CommonHelper.SetActive(self.shenSuanZi_Image_Obj,false)
    end
end
