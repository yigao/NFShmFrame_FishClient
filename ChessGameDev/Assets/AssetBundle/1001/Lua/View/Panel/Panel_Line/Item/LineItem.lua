LineItem=Class()

function LineItem:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
end

function LineItem:Init (gameObj)
	self:InitData()
	self:InitView()
end


function LineItem:InitData()
	
end



function LineItem:InitView()
	self:IsShowLine(false)
end


function LineItem:IsShowLine(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end