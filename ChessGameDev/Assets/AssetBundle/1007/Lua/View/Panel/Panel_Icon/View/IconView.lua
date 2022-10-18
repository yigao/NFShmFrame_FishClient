IconView=Class()

function IconView:ctor(gameObj)
	self:Init(gameObj)

end

function IconView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function IconView:InitData()
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.gamedata=GameManager.GetInstance().gameData
	self.IconItemList={}
	self.IconMountGroup={}
end



function IconView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function IconView:FindView(tf)
	self:FindIconItem(tf)
	self:FindIconCoordinateInfo(tf)
end


function IconView:FindIconItem(tf)
	for i=1,self.GameConfig.IconItemTotalCount do
		local tempIcon=tf:Find("ItemPanel/Item"..(i-1)).gameObject
		table.insert(self.IconItemList,tempIcon)
	end
end


function IconView:FindIconCoordinateInfo(tf)
	for i=1,self.GameConfig.Coordinate_COL do
		local tempMontpoint=tf:Find("ScrollPanel/IconScrollParent/IconScroll"..i).gameObject
		table.insert(self.IconMountGroup,tempMontpoint)
	end
end


