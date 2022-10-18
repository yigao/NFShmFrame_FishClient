JinNiuPanel=Class()

function JinNiuPanel:ctor()
	self:InitData()
end


function JinNiuPanel:InitData()
	self.SetAtlasName="GameSetSpriteAtlas"
	self.spriteName="goods_icon_goldcoin"
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.Animation=GameManager.GetInstance().Animation
end


function JinNiuPanel:ResetInit(gameObj)
	self.gameObject=gameObj
	self:FindView()
	self:InitViewData()
	self:AddBtnEventListenner()
end



function JinNiuPanel:FindView()
	local tf=self.gameObject.transform
	self.ResultPanel=tf:Find("Select").gameObject
	self.ResultImage=tf:Find("Select/Icon_prize"):GetComponent(typeof(self.Image))
	self.ResultText=tf:Find("Select/Icon_prize/Text"):GetComponent(typeof(self.Text))
	
	self.ChouJiangAnim=tf:Find("ZhuanPanJN/Black_bg"):GetComponent(typeof(self.Animation))
	self.StartBtn=tf:Find("ZhuanPanJN/Black_bg/Button"):GetComponent(typeof(self.Button))
	--self.RemainTimeText=tf:Find("ZhuanPanJN/Black_bg/Button/Text"):GetComponent(typeof(self.Text))
	
	self:FindItemView(tf)
	
	
end

function JinNiuPanel:FindItemView(tf)
	self.ItemPrizeList={}
	self.ItemPrizeList.Image={}
	self.ItemPrizeList.Text={}
	for i=1,6 do
		local tempItem=tf:Find("ZhuanPanJN/Black_bg/mask_panel/diban/Content/Icon_prize"..i):GetComponent(typeof(self.Image))
		table.insert(self.ItemPrizeList.Image,tempItem)
		tempItem=tf:Find("ZhuanPanJN/Black_bg/mask_panel/diban/Content/Icon_prize"..i.."/Text"):GetComponent(typeof(self.Text))
		table.insert(self.ItemPrizeList.Text,tempItem)
	end
end



function JinNiuPanel:InitViewData()
	
end


function JinNiuPanel:AddBtnEventListenner()
	self.StartBtn.onClick:AddListener(function () self:OnclickRunBtn() end)
	
end


function JinNiuPanel:IsShowResultPanel(isShow)
	CommonHelper.SetActive(self.ResultPanel,isShow)
end


function JinNiuPanel:PlayAnim()
	self.ChouJiangAnim:Play()
end


function JinNiuPanel:IsEnableStartBtn(isEnabled)
	self.StartBtn.enabled=isEnabled
end


function JinNiuPanel:SetSelectResult(imageIndex,score)
	self.ResultImage.sprite= GameManager.GetInstance().gameData.AllAtlasList[self.SetAtlasName]:GetSprite(self.spriteName..imageIndex)
	self.ResultText.text="金币"..CommonHelper.FormatBaseProportionalScore(score)
end




function JinNiuPanel:SetAllItemPrizeResult(itemPrizeList)
	for i=1,6 do
		local numR=math.random(1,6)
		self.ItemPrizeList.Image[i].sprite=GameManager.GetInstance().gameData.AllAtlasList[self.SetAtlasName]:GetSprite(self.spriteName..numR)
		self.ItemPrizeList.Text[i].text="金币"..CommonHelper.FormatBaseProportionalScore(itemPrizeList[numR])
	end
end


function JinNiuPanel:SetJinNiuResult(imageIndex,score)
	self.ItemPrizeList.Image[3].sprite=GameManager.GetInstance().gameData.AllAtlasList[self.SetAtlasName]:GetSprite(self.spriteName..imageIndex)
	self.ItemPrizeList.Text[3].text="金币"..CommonHelper.FormatBaseProportionalScore(score)
end




function JinNiuPanel:OnclickRunBtn()
	JinNiuManager.GetInstance():RequestStart()
	self:IsEnableStartBtn(false)
end




