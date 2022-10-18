PoolView=Class()


function PoolView:ctor(obj)
	self:Init(obj)

end

function PoolView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function PoolView:InitData()
	self.PoolList={}
end



function PoolView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function PoolView:FindView(tf)
	local PoolObj=tf:Find("Pool_Icon").gameObject			--1：Icon
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_BonusIcon").gameObject			--2：BonusIcon
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_Effect").gameObject				--3：Effect
	table.insert(self.PoolList,PoolObj)
	
end