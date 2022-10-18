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
	self.IconMaskMountGroup={}
	self.SelectionIconCount=16
	self.SelectionIconItemList={}
	self.SelectionIconMountGroup={}
end



function IconView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function IconView:FindView(tf)
	self:FindIconItem(tf)
	self:FindIconCoordinateInfo(tf)
	self:FindIconMaskCoordinateInfo(tf)
	self:FindSelectionIconItem(tf)
	self:FindSelectionIconCoordinateInfo(tf)
	
	self:FindIconMask(tf)
	self:FindSilderTips(tf)
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



function IconView:FindIconMaskCoordinateInfo(tf)
	for i=1,self.GameConfig.Coordinate_COL do
		local tempMontpoint=tf:Find("ScrollPanel/IconMaskScrollParent/IconScroll"..i).gameObject
		table.insert(self.IconMaskMountGroup,tempMontpoint)
	end
end


function IconView:FindSelectionIconItem(tf)
	for i=1,self.SelectionIconCount do
		local selectionIcon=tf:Find("MinSelectItemPanel/MidSelectItem"..i).gameObject
		table.insert(self.SelectionIconItemList,selectionIcon)
	end
end


function IconView:FindSelectionIconCoordinateInfo(tf)
	for i=1,2 do
		local tempMontpoint=tf:Find("ScrollWinSelectionPanel/IconScrollParent/IconScroll"..i).gameObject
		table.insert(self.SelectionIconMountGroup,tempMontpoint)
	end
end


function IconView:FindIconMask(tf)
	self.iconMaskObj=tf:Find("IconImageMask").gameObject
	CommonHelper.SetActive(self.iconMaskObj,false)
end



function IconView:FindSilderTips(tf)
	self.sliderTipskObj=tf:Find("SliderTipsPanel").gameObject
end

