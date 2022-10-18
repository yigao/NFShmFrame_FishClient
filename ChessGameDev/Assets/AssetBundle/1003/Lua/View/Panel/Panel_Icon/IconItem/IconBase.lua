IconBase=Class()

function IconBase:ctor()
	self:BaseInit()

end

function IconBase:BaseInit ()
	self:InitBaseData()
end


function IconBase:InitBaseData()
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.gamedata=GameManager.GetInstance().gameData
	self.Image=GameManager.GetInstance().Image
	--self.Color=GameManager.GetInstance().Color
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
	self.IconEffectParent=tf:Find("IconEffects").gameObject
end


function IconBase:InitBaseView()
	self:IsShowIconImage(true)
	self:IsShowIconRandomImage(false)
	self:IsShowIconEffect(false)
end


function IconBase:IsShowIconImage(isShow)
	CommonHelper.SetActive(self.IconImage.gameObject,isShow)
end


function IconBase:IsShowIconRandomImage(isShow)
	CommonHelper.SetActive(self.IconRandomImage.gameObject,isShow)
end


function IconBase:IsShowIconEffect(isShow)
	CommonHelper.SetActive(self.IconEffectParent,isShow)
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


function IconBase:IsChangeMainImageColor(isChange)
	--[[print(self.IconImage)
	print(self.IconImage.material.color)
	if isChange then
		self.IconImage.material.color=CS.UnityEngine.Color(0.5,0.5,0.5)--self.Color(0.5,0.5,0.5)
	else
		self.IconImage.material.color=CS.UnityEngine.Color(1,1,1)--self.Color(1,1,1)
	end--]]
	
end


function IconBase:SetIconRunState()
	self:IsShowIconImage(false)
	self:IsShowIconRandomImage(true)
	self:IsShowIconEffect(false)
end



function IconBase:PlayBaseIconAnim()
	self:IsShowIconImage(false)
	self:IsShowIconRandomImage(false)
	self:IsShowIconEffect(true)
end


function IconBase:StopPlayBaseIconAnim()
	self:IsShowIconImage(true)
	self:IsShowIconRandomImage(false)
	self:IsShowIconEffect(false)
end




function IconBase:__delete()
	self.GameConfig=nil
	self.gamedata=nil
    self.Image=nil
	self.IconImage=nil
	self.IconRandomImage=nil
	self.IconEffectParent=nil
	self.gameObject=nil
end
