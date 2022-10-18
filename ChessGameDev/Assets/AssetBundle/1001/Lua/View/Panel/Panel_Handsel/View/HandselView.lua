HandselView=Class()

function HandselView:ctor(gameObj)
	self:Init(gameObj)
	
end

function HandselView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	
end


function HandselView:InitData()
	self.handselCount=HandselManager.GetInstance().handselCount
	self.HandselObjList={}
end



function HandselView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
end


function HandselView:FindView(tf)
	for i=1,self.handselCount do
		local TempObj=tf:Find("Panel/Handsel/Handsel"..i).gameObject
		table.insert(self.HandselObjList,TempObj)
	end
end