PlayerView=Class()


function PlayerView:ctor(obj)
	self:Init(obj)

end

function PlayerView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function PlayerView:InitData()
	self.playerObjList={}
end



function PlayerView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function PlayerView:FindView(tf)
	for i=1,5 do
		local Obj=tf:Find("Panel/Player"..i).gameObject
		table.insert(self.playerObjList,Obj)
	end

end