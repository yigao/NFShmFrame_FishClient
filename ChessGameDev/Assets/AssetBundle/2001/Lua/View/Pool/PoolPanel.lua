PoolPanel=Class()


function PoolPanel:ctor(obj)
	self:Init(obj)

end

function PoolPanel:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function PoolPanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.PoolList={}
end



function PoolPanel:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:GetFishRootObj()
end


function PoolPanel:FindView(tf)
	local PoolObj=tf:Find("Pool_Fish").gameObject		--1：FishPool
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_Bullet").gameObject		--2：BulletPool
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_Net").gameObject		--3：NetPool
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_Gold").gameObject		--4：GoldPool
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_Score").gameObject	--5：Pool_Score
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_PlusTips").gameObject	--6：Pool_Score
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_Effect").gameObject	--7：Pool_Effect
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_FishOutTips").gameObject	--8：FishOutTips
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_BigAwardTips").gameObject	--BigAwardTips
	table.insert(self.PoolList,PoolObj)
	PoolObj=tf:Find("Pool_Lightning").gameObject	--10Lightning
	table.insert(self.PoolList,PoolObj)
end


function PoolPanel:GetFishRootObj()
	self.ShakeCamera=self.PoolList[1]:GetComponent(typeof(CS.ShakeCamera))
	if self.ShakeCamera==nil then
		self.ShakeCamera=self.PoolList[1]:AddComponent(typeof(CS.ShakeCamera))
	end
	self.ShakeCamera.enabled=false
	return self.ShakeCamera
end



