IconItem=Class(IconBase)

function IconItem:ctor()
	self:Init()

end

function IconItem:Init ()
	self:InitData()
end


function IconItem:InitData()
	self.IconAtlasName="SLBSpriteAtlas"
	self.JackpotTypeName="UiJackpot_CH_"
end


function IconItem:BuildIconItem(gameObj)
	self:InitIconBase(gameObj)
	self:FindView(gameObj)
	self:InitViewData()
end


function IconItem:FindView(gameObj)
	local tf=gameObj.transform
	self.IconTextAnim=self.IconText:GetComponent(typeof(self.Animation))
	local winImage=tf:Find("WinImage")
	if winImage then
		self.WinImage=winImage:GetComponent(typeof(self.Image))
		self.WinImageAnim=winImage:GetComponent(typeof(self.Animation))
	end
	
	self.WinAnim=tf:Find("IconEffects/Image"):GetComponent(typeof(self.Animator))
	
	local ShowAnim=tf:Find("IconEffects/Image1")
	if ShowAnim then
		self.ShowAnim=ShowAnim:GetComponent(typeof(self.Animator))
	end
	
end


function IconItem:InitViewData()
	self:IsShowWinImage(false)
end



function IconItem:ChangeIconImage(iconNum,isFuzzy)
	local imageName=nil
	if isFuzzy then
		imageName=IconManager.GetInstance():GetMainIconItemFuzzyImageNameByIconNum(iconNum)
	else
		imageName=IconManager.GetInstance():GetMainIconItemImageNameByIconNum(iconNum)
	end
	local tempImage=self.gamedata.AllAtlasList[self.IconAtlasName]:GetSprite(imageName)
	if tempImage then
		self:BaseChangeIconImage(tempImage)
	else
		Debug.LogError("获取图集中的image为nil==>"..imageName)
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



function IconItem:ChangeBonusIconRandomImage(iconNum,isFuzzy)
	isFuzzy=isFuzzy or false
	local imageName=nil
	if isFuzzy then
		imageName=IconManager.GetInstance():GetBonusIconItemFuzzyImageNameByIconNum(iconNum)
	else
		imageName=IconManager.GetInstance():GetBonusIconItemImageNameByIconNum(iconNum)
	end
	
	local tempImage=self.gamedata.AllAtlasList[self.IconAtlasName]:GetSprite(imageName)
	if tempImage then
		self:BaseChangeIconRandomImage(tempImage)
	else
		Debug.LogError("获取图集中的image为nil==>"..imageName)
	end
	
end


function IconItem:IsShowWinImage(isShow)
	if self.WinImage then
		CommonHelper.SetActive(self.WinImage.gameObject,isShow)
	end
end


function IconItem:SetWinImage(imageNum)
	if self.WinImage then
		local image=self.gamedata.AllAtlasList[self.IconAtlasName]:GetSprite(self.JackpotTypeName..imageNum)
		if image then
			self.WinImage.sprite=image
		else
			Debug.LogError("获取鞭炮图标显示类型image异常==>"..imageNum)
		end
		
	end
end


function IconItem:PlayWinAnim(animName)
	if self.WinAnim then
		CommonHelper.SetActive(self.WinAnim.gameObject,true)
		if self.ShowAnim then
			CommonHelper.SetActive(self.ShowAnim.gameObject,false)
		end
		self:IsShowIconEffect(true)
		if animName then
			self.WinAnim:Play(animName)
		else
			self.WinAnim:Play()
		end
		
	end
end

function IconItem:PlayShowAnim()
	if self.ShowAnim then
		CommonHelper.SetActive(self.ShowAnim.gameObject,true)
		if self.WinAnim then
			CommonHelper.SetActive(self.WinAnim.gameObject,false)
		end
		self:IsShowIconEffect(true)
		--self.ShowAnim:Play()
	end
end


function IconItem:PlayTextAnim()
	if self.IconTextAnim then
		self.IconTextAnim:Play()
	end
end


function IconItem:PlaySLBRecieveScoreAnim()
	if self.IconTextAnim then
		self.IconTextAnim:Play()
	end
	if self.WinImageAnim then
		self.WinImageAnim:Play()
	end
end




function IconItem:__delete()

end






