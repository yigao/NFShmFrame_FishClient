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
	self.BonusIconCount=7
	self.BonusIconItemList={}
end



function IconView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function IconView:FindView(tf)
	self:FindIconItem(tf)
	self:FindIconCoordinateInfo(tf)
	--self:FindBonusIconItem(tf)
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


function IconView:FindBonusIconItem(tf)
	for i=1,self.BonusIconCount do
		local bonusIcon=tf:Find("BonusItemPanel/BonusItem"..i).gameObject
		table.insert(self.BonusIconItemList,bonusIcon)
	end
end

function IconView:FindIconMask(tf)
	self.iconMaskObj=tf:Find("IconImageMask").gameObject
	CommonHelper.SetActive(self.iconMaskObj,false)
end



function IconView:FindSilderTips(tf)
	self.sliderTipskObj=tf:Find("SliderTipsPanel").gameObject
end