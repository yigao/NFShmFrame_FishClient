IconItem=Class(IconBase)

function IconItem:ctor()
	self:Init()

end

function IconItem:Init ()
	self:InitData()
end


function IconItem:InitData()
	self.IconAtlasName="FXGZSpriteAtlas"
	self.IconNum=0
end


function IconItem:BuildIconItem(gameObj)
	self:InitIconBase(gameObj)
	self:FindView(gameObj)
	self:InitViewData()
end


function IconItem:FindView(gameObj)
	local tf=gameObj.transform
	self.WinAnim=tf:Find("IconEffects/Image")
	
	self.ShowAnim=tf:Find("IconEffects/Image1")
	
end


function IconItem:InitViewData()
	
end


function IconItem:SetIconNum(num)
	self.IconNum=num
end

function IconItem:GetIconNum()
  	return self.IconNum
end



function IconItem:PlayWinAnim(animName)
	if self.WinAnim then
		--self:IsShowIconEffect(true)
		CommonHelper.SetActive(self.WinAnim.gameObject,true)
		if self.ShowAnim then
			CommonHelper.SetActive(self.ShowAnim.gameObject,false)
		end
		
	end
end

function IconItem:PlayShowAnim()
	if self.ShowAnim then
		CommonHelper.SetActive(self.ShowAnim.gameObject,true)
		if self.WinAnim then
			CommonHelper.SetActive(self.WinAnim.gameObject,false)
		end
	end
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


function IconItem:AllocateChangeIconRandomImage(iconNum,IconFuzzyName)
	local imageName=IconManager.GetInstance():AllocateGetMainIconItemImageNameByIconNum(iconNum,IconFuzzyName)
	
	local tempImage=self.gamedata.AllAtlasList[self.IconAtlasName]:GetSprite(imageName)
	if tempImage then
		self:BaseChangeIconRandomImage(tempImage)
	else
		Debug.LogError("获取图集中的image为nil==>"..imageName)
	end
	
end





function IconItem:ChangGoldenToMainIcon(iconNum,isGolden)
	local imageName=IconManager.GetInstance():GetMainIconItemImageNameByIconNum(iconNum)
	if isGolden then
		imageName=imageName.."_G"
	end
	local tempImage=self.gamedata.AllAtlasList[self.IconAtlasName]:GetSprite(imageName)
	if tempImage then
		self:BaseChangeMainIconImage(tempImage)
	else
		Debug.LogError("ChangGoldenToMainIcon异常==>"..iconNum)
	end
	
end


function IconItem:AllocateChangMainIcon(iconNum,IconFuzzyName)
	local imageName=IconManager.GetInstance():GetMainIconItemImageNameByIconNum(iconNum)
	if IconFuzzyName then
		imageName=imageName..IconFuzzyName
	end
	local tempImage=self.gamedata.AllAtlasList[self.IconAtlasName]:GetSprite(imageName)
	if tempImage then
		self:BaseChangeMainIconImage(tempImage)
	else
		Debug.LogError("AllocateChangMainIcon异常==>"..iconNum..IconFuzzyName)
	end
	
end





function IconItem:__delete()

end






