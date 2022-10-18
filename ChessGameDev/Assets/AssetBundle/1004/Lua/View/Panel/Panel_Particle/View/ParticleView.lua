ParticleView=Class()

function ParticleView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init()

end

function ParticleView:Init ()
	self:InitData()
	self:InitView()
end


function ParticleView:InitData()
	self.EffectObjList={}
end


function ParticleView:InitView()
	local mtrans=self.gameObject.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function ParticleView:FindView(tf)
	local tempEffectObj=tf:Find("Panel/ChangeWildEffect/WildEffect").gameObject
	table.insert(self.EffectObjList,tempEffectObj)
	tempEffectObj=tf:Find("Panel/GoldFlyEffect/GoldFlyEffect").gameObject
	table.insert(self.EffectObjList,tempEffectObj)
end


function ParticleView:InitViewData()
	for i=1,#self.EffectObjList do
		CommonHelper.SetActive(self.EffectObjList[i],false)
	end
end