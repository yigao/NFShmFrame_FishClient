HandselItem=Class()

function HandselItem:ctor(gameObj)
	self:Init(gameObj)
	
end

function HandselItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function HandselItem:InitData()
	self.Text=GameManager.GetInstance().Text
end



function HandselItem:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
end


function HandselItem:FindView(tf)
	self.HandselValueText=tf:Find("TextValue"):GetComponent(typeof(self.Text))
end



function HandselItem:InitViewData()
	self:SetHandselValue(0)
end


function HandselItem:SetHandselValue(score)
	self.HandselValueText.text=CommonHelper.FormatBaseProportionalScore(score)
end


