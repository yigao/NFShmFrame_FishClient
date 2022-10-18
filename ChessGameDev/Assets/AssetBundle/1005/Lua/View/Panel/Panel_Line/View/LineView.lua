LineView=Class()

function LineView:ctor(gameObj)
	self:Init(gameObj)

end

function LineView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function LineView:InitData()
	self.LineList={}
end



function LineView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function LineView:FindView(tf)
	for i=1,9 do
		local tempLine=tf:Find("Line"..i).gameObject
		table.insert(self.LineList,tempLine)
	end
end