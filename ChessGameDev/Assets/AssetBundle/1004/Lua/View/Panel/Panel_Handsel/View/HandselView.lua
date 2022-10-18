HandselView=Class()

function HandselView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function HandselView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function HandselView:InitData()
	self.HandselObjList={}
	self.Text=GameManager.GetInstance().Text
	self.IsPlayTips=false
end



function HandselView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:FindTipsView(mtrans)
end


function HandselView:InitViewData()
	self:IsShowTipsView(false)
end


function HandselView:FindView(tf)
	for i=1,4 do
		local TempObj=tf:Find("Panel/Handsel/Handsel"..i).gameObject
		table.insert(self.HandselObjList,TempObj)
	end
end


function HandselView:FindTipsView(tf)
	self.tipsPanel=tf:Find("Panel/TipsPanel").gameObject
	self.tipsView=tf:Find("Panel/TipsPanel/Tips").gameObject
	self.tipsText=tf:Find("Panel/TipsPanel/Tips/Image/Text"):GetComponent(typeof(self.Text))
end


function HandselView:IsShowTipsView(isShow)
	CommonHelper.SetActive(self.tipsView,isShow)
end


function HandselView:SetTipsText(content)
	self.tipsText.text=content
end


function HandselView:ResetTipsPos()
	self.tipsView.transform.localPosition=CSScript.Vector3(0,0,0)
end


function HandselView:SetTips(content)
	if self.IsPlayTips then  return end
	self:ResetTipsPos(0)
	self:SetTipsText(content)
	self:IsShowTipsView(true)
	self.IsPlayTips=true
end


function HandselView:Update()
	if self.IsPlayTips then
		self.tipsView.transform:Translate(CSScript.Time.deltaTime*0.3*CSScript.Vector3.up)
		if self.tipsView.transform.localPosition.y>=300 then
			self.IsPlayTips=false
			self:IsShowTipsView(false)
		end
	end
end

