SelectionIconItem=Class()

function SelectionIconItem:ctor(gameObj)
	self:Init(gameObj)

end

function SelectionIconItem:Init(gameObj)
	self:InitData()
	self:InitSelectionIconItem(gameObj)
end


function SelectionIconItem:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Animation=GameManager.GetInstance().Animation
	self.SelectionType=1
end



function SelectionIconItem:InitSelectionIconItem(gameObj)
	self:BuildSelectionIconItem(gameObj)
	self:InitView()
end


function SelectionIconItem:BuildSelectionIconItem(gameObj)
	self.gameObject=gameObj
	self:FindView(gameObj)
end


function SelectionIconItem:FindView(gameObj)
	local tf=gameObj.transform
	self:FindIconView(tf)
	
end


function SelectionIconItem:FindIconView(tf)
	self.IconAnim=tf:Find("Select"):GetComponent(typeof(self.Animation))
	
	local IconTextTransform=tf:Find("Select/Text")
	if IconTextTransform then
		self.IconText=IconTextTransform:GetComponent(typeof(self.Text))
	end
	
end


function SelectionIconItem:InitView()
	self:SetIconValue(0)
end


function SelectionIconItem:SetIconValue(score)
	if self.IconText then
		self.IconText.text=CommonHelper.FormatBaseProportionalScore(score)
	end
end


function SelectionIconItem:PlaySelectAnim()
	if self.IconAnim then
		self.IconAnim:Play()
	end
end

function SelectionIconItem:SetIocnParent(parentObj)
	CommonHelper.AddToParentGameObject(self.gameObject,parentObj)
end


function SelectionIconItem:SetSelectionType(sType)
	self.SelectionType=sType
end


function SelectionIconItem:GetSelectionType()
	return self.SelectionType
end