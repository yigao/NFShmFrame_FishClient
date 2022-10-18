BonusIconItem=Class()

function BonusIconItem:ctor(gameObj)
	self:Init(gameObj)

end

function BonusIconItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	
end


function BonusIconItem:InitData()

	self.Animation=GameManager.GetInstance().Animation
	
	self.SelectIconAnimNameList={"IdleSelectIcon","SelectIcon"}
end



function BonusIconItem:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BonusIconItem:FindView(tf)
	self:FindBonusIconItemView(tf)

end


function BonusIconItem:FindBonusIconItemView(tf)
	self.ChangeIconImage=tf:Find("IconImage/BGImage").gameObject
	self.SelectIconImage=tf:Find("IconImage/SelectImage").gameObject
	self.SelectIconImageAnim=self.SelectIconImage:GetComponent(typeof(self.Animation))
end



function BonusIconItem:InitViewData()
	self:ResetView()
end



function BonusIconItem:IsShowChangeIconImagePanel(isShow)
	CommonHelper.SetActive(self.ChangeIconImage,isShow)
end

function BonusIconItem:IsShowSelectIconImagePanel(isShow)
	CommonHelper.SetActive(self.SelectIconImage,isShow)
end

function BonusIconItem:ResetView()
	self:IsShowChangeIconImagePanel(true)
	self:IsShowSelectIconImagePanel(false)
end


function BonusIconItem:PlaySelectIconAnim()
	self:IsShowSelectIconImagePanel(true)
	self:PlayAnim(2)
end

function BonusIconItem:PlayAnim(index)
	if self.SelectIconImageAnim then
		self.SelectIconImageAnim:Play(self.SelectIconAnimNameList[index])
	end
end




function BonusIconItem:__delete()

end