IconItem=Class(IconBase)

function IconItem:ctor()
	self:Init()

end

function IconItem:Init ()
	self:InitData()
end


function IconItem:InitData()
	self.IconAtlasName="NDSSpriteAtlas"
	
end


function IconItem:BuildIconItem(gameObj)
	self:InitIconBase(gameObj)
	self:FindView()
	self:InitViewData()
end


function IconItem:FindView()
	
end


function IconItem:InitViewData()
	
end



function IconItem:ChangeIconRandomImage(iconNum,isFuzzy)
	isFuzzy=isFuzzy or false
	local imageName=nil
	if isFuzzy then
		imageName=IconManager.GetInstance():GetMainIconItemFuzzyImageNameByIconNum(iconNum)
	else
		imageName=IconManager.GetInstance():GetMainIconItemImageNameByIconNum(iconNum)
	end
	
	local tempImage=self.gamedata.AllAtlasList[self.IconAtlasName]:GetSprite(imageName)
	if tempImage then
		self:BaseChangeIconRandomImage(tempImage)
	else
		Debug.LogError("获取图集中的image为nil==>"..imageName)
	end
	
end












function IconItem:__delete()

end






