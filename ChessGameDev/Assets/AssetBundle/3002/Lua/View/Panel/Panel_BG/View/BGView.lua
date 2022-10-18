BGView=Class()

function BGView:ctor(gameObj)
	self:Init(gameObj)

end

function BGView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function BGView:InitData()
	self.MainBGList={}
	self.IconBGList={}
	self.BKBGList={}
end



function BGView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function BGView:FindView(tf)
	
end





