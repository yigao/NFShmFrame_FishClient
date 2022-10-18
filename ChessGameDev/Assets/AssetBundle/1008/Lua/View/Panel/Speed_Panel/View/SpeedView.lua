SpeedView=Class()

function SpeedView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
end

function SpeedView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function SpeedView:InitData()
	self.SpeedEffectList={}
	
end



function SpeedView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function SpeedView:FindView(tf)
	for i=1,3 do
		local tempEffect=tf:Find("AddEffectPanel/Speed"..i).gameObject
		table.insert(self.SpeedEffectList,tempEffect)
	end
end



function SpeedView:InitViewData()
	self:HideAllSpeedEffectPanel()
end


function SpeedView:IsShowSpeedEffectPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.SpeedEffectList,isShow,true,false,false)
end


function SpeedView:HideAllSpeedEffectPanel()
	self:IsShowSpeedEffectPanel(0,true)
end


