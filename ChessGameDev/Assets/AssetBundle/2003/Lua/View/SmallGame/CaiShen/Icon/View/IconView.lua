IconView=Class()

function IconView:ctor(gameObj)
	self:Init(gameObj)

end

function IconView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function IconView:InitData()
	self.gamedata=GameManager.GetInstance().gameData
	self.GameConfig=self.gamedata.GameConfig
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
	self:FindResult(tf)
end


function IconView:FindIconItem(tf)
	for i=1,self.GameConfig.IconItemTotalCount do
		local tempIcon=tf:Find("StartPanel/ItemList/Item"..(i-1)).gameObject
		table.insert(self.IconItemList,tempIcon)
	end
end


function IconView:FindIconCoordinateInfo(tf)
	for i=1,self.GameConfig.Coordinate_COL do
		local tempMontpoint=tf:Find("StartPanel/ScrollPanel/IconScrollParent/IconScroll"..i).gameObject
		table.insert(self.IconMountGroup,tempMontpoint)
	end
end


function IconView:FindResult(tf)
	self.StartPanel=tf:Find("StartPanel").gameObject
	self.ResultPanel=tf:Find("ResultEffect").gameObject
	--self.ResultAnim=self.ResultPanel:GetComponent(typeof(GameManager.GetInstance().Animation))
	self.ResultText=tf:Find("ResultEffect/Text"):GetComponent(typeof(GameManager.GetInstance().Text))
end


function IconView:IsShowStartPanel(isShow)
	CommonHelper.SetActive(self.StartPanel,isShow)
end

function IconView:IsShowResultPanel(isShow)
	CommonHelper.SetActive(self.ResultPanel,isShow)
end

function IconView:SetResultText(score)
	self.ResultText.text="+"..CommonHelper.FormatBaseProportionalScore(score)
end


