BeBankerItem = Class()

function BeBankerItem:ctor(gameObj)
    self:Init(gameObj)
end

function BeBankerItem:Init(gameObj)
    self:InitData()
    self:InitView(gameObj)
end

function BeBankerItem:InitData(  )
    self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
    self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text 
    self.UIListElementScript = GameManager.GetInstance().UIListElementScript 
    self.curBeBankVo = nil
end

function BeBankerItem:InitView(gameObj)
    local mtrans=gameObj.transform
    self:FindView(mtrans)
end

function BeBankerItem:FindView(tf)
    self.name_text = tf:Find("name"):GetComponent(typeof(self.Text))
    self.money_number_text = tf:Find("money"):GetComponent(typeof(self.Text))
    self.uiListElementScript = tf:GetComponent(typeof(self.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableBeBankItem(index) end
end

function BeBankerItem:OnEnableBeBankItem(index)
    self.curBeBankVo = self.gameData.WaitBankerVoList[index + 1]
    self:ShowUIView()
end

function BeBankerItem:ShowUIView()
    self.name_text.text =  PlayerManager.GetInstance():GetPlayerVoByChairdId(self.curBeBankVo.usNtChairId).user_name
    self.money_number_text.text = CommonHelper.FormatBaseProportionalScore(self.curBeBankVo.ntMoney) 
end
