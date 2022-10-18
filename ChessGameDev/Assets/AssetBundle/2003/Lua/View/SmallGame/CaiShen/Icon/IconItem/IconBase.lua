IconBase=Class()

function IconBase:ctor()
	self:BaseInit()

end

function IconBase:BaseInit ()
	self:InitBaseData()
end


function IconBase:InitBaseData()
	self.gamedata=GameManager.GetInstance().gameData
	self.GameConfig=self.gamedata.GameConfig
	self.Image=GameManager.GetInstance().Image
end



function IconBase:InitIconBase(gameObj)
	self:BuildIconBase(gameObj)
	self:InitBaseView()
end


function IconBase:BuildIconBase(gameObj)
	self.gameObject=gameObj
	self:FindBaseView(gameObj)
end


function IconBase:FindBaseView(gameObj)
	local tf=gameObj.transform
	self:FindBaseIconView(tf)
	
end


function IconBase:FindBaseIconView(tf)
	self.IconImage=tf:Find("Icon/Image"):GetComponent(typeof(self.Image))
	self.IconRandomImage=tf:Find("ImageRandom"):GetComponent(typeof(self.Image))
end


function IconBase:InitBaseView()
	self:IsShowIconImage(true)
	self:IsShowIconRandomImage(false)
end


function IconBase:IsShowIconImage(isShow)
	CommonHelper.SetActive(self.IconImage.gameObject,isShow)
end


function IconBase:IsShowIconRandomImage(isShow)
	CommonHelper.SetActive(self.IconRandomImage.gameObject,isShow)
end




function IconBase:SetIocnParent(parentObj)
	CommonHelper.AddToParentGameObject(self.gameObject,parentObj)
end


function IconBase:RecycleIconToGameObjectPool(poolType)
	GameObjectPoolManager.GetInstance():ReCycleToGameObject(self.gameObject,poolType)
end


function IconBase:BaseChangeIconRandomImage(newImage)
	self.IconRandomImage.sprite=newImage
end


function IconBase:BaseChangeIconImage(newImage)
	self.IconImage.sprite=newImage
end

function IconBase:SetIconRunState()
	self:IsShowIconImage(false)
	self:IsShowIconRandomImage(true)
end



function IconBase:PlayBaseIconAnim()
	self:IsShowIconImage(false)
	self:IsShowIconRandomImage(false)
end


function IconBase:StopPlayBaseIconAnim()
	self:IsShowIconImage(true)
	self:IsShowIconRandomImage(false)
end




function IconBase:__delete()
	self.GameConfig=nil
	self.gamedata=nil
    self.Image=nil
	self.IconImage=nil
	self.IconRandomImage=nil
	self.gameObject=nil
end
