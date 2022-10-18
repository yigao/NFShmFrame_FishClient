IconSelectView=Class()

function IconSelectView:ctor(gameObj)
	self:Init(gameObj)

end

function IconSelectView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function IconSelectView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Image=GameManager.GetInstance().Image
	self.IconAtlasName="FXGZSpriteAtlas"
	self.RightImagePrefixName="UIBet"
	self.MidImagePrefixName="UIBetBig"
	self.RightIconList={}
	self.MidIconList={}
end



function IconSelectView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function IconSelectView:FindView(tf)
	self:FindRightIconSelectView(tf)
	self:FindMidIconSelectView(tf)
end


function IconSelectView:FindRightIconSelectView(tf)
	self.rightIconSelectPanel=tf:Find("Select").gameObject
	for i=1,5 do
		local tempIcon=tf:Find("Select/Icon/Image"..i):GetComponent(typeof(self.Image))
		table.insert(self.RightIconList,tempIcon)
	end
	
end


function IconSelectView:FindMidIconSelectView(tf)
	self.MidIconSelectPanel=tf:Find("Mid").gameObject
	for i=1,5 do
		local tempIcon=tf:Find("Mid/Icon/Image"..i):GetComponent(typeof(self.Image))
		table.insert(self.MidIconList,tempIcon)
	end
	
end


function IconSelectView:InitViewData()
	self:IsShowMidPanel(false)
	
end


function IconSelectView:IsShowMidPanel(isShow)
	CommonHelper.SetActive(self.MidIconSelectPanel,isShow)
end


function IconSelectView:SetRightSelectIconImage(index,isSelect)
	if index<=#self.RightIconList then
		local imageName=self.RightImagePrefixName..index
		if isSelect then
			imageName=imageName.."_Golden"
		end
		local tempImage=self.gameData.AllAtlasList[self.IconAtlasName]:GetSprite(imageName)
		if tempImage then
			self.RightIconList[index].sprite=tempImage
		end
		
	end
end


function IconSelectView:SetMidSelectIconImage(index,isSelect)
	if index<=#self.MidIconList then
		local imageName=self.MidImagePrefixName..index
		if isSelect then
			imageName=imageName.."_Golden"
		end
		local tempImage=self.gameData.AllAtlasList[self.IconAtlasName]:GetSprite(imageName)
		if tempImage then
			self.MidIconList[index].sprite=tempImage
		end
	end
end