MidRunItemView=Class()

function MidRunItemView:ctor(gameObj)
	self:Init(gameObj)

end

function MidRunItemView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	
end


function MidRunItemView:InitData()
	self.BounsIconMountGroup={}
	self.MidIconSelectEffectList={}
end



function MidRunItemView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function MidRunItemView:FindView(tf)
	self:FindMidRunIconCoordinateInfo(tf)
	self:FindSelectIconEffect(tf)
end



function MidRunItemView:FindMidRunIconCoordinateInfo(tf)
	for i=1,4 do
		local tempMontpoint=tf:Find("BasePanel/MainPanel/RunIcoPanel/ScrollPanel/IconScroll"..i).gameObject
		table.insert(self.BounsIconMountGroup,tempMontpoint)
	end
end

function MidRunItemView:FindSelectIconEffect(tf)
	for i=1,4 do
		local tempEffect=tf:Find("BasePanel/MainPanel/RunIcoPanel/IconBg/SelectIconEffect/Image"..i).gameObject
		table.insert(self.MidIconSelectEffectList,tempEffect)
	end
end


function MidRunItemView:InitViewData()
	self:HideAllSelectEffect()
end


function MidRunItemView:HideAllSelectEffect()
	CommonHelper.IsShowPanel(0,self.MidIconSelectEffectList,true,true,false)
end

function MidRunItemView:IsShowSelectEffect(index)
	CommonHelper.IsShowPanel(index,self.MidIconSelectEffectList,true,true,true)
end



function MidRunItemView:__delete()

end