IconSlide=Class()

function IconSlide:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function IconSlide:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function IconSlide:InitData()
	self.IsPress=false
	self.OnclickPos=CSScript.Vector3.zero
end



function IconSlide:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:AddEventListenner()
end


function IconSlide:FindView(tf)
	self.IconScrollParent=tf:Find("ScrollPanel/IconScrollParent")
	self.RawIconScrollParentPos=self.IconScrollParent.localPosition
	self.IconSlideEventScript=tf:Find("ScrollPanel/SlideIconImage").gameObject:AddComponent(typeof(CS.UIEventScript))
end


function IconSlide:AddEventListenner()
	self.IconSlideEventScript.onPressCallBack=function (isPress) self:OnclickStart(isPress) end
end


function IconSlide:OnclickStart(isPress)
	self.IsPress=isPress
	if isPress then
		self.OnclickPos=CSScript.Input.mousePosition
	else
		self.IconScrollParent.localPosition=self.RawIconScrollParentPos
	end
end


function IconSlide:Update()
	if self.IsPress and GameLogicManager.GetInstance():IsCanIconRunState() then
		local moveVec=CSScript.Input.mousePosition-self.OnclickPos
		self.IconScrollParent.localPosition=self.RawIconScrollParentPos+CSScript.Vector3(0,moveVec.y,0)
		if math.abs(moveVec.y)>15 then
			self.IsPress=false
			Debug.LogError("滑动开始滚动")
			GameLogicManager.GetInstance():StartGameIconRun()
			--return
		end
	end
end

