BombManager=Class()

local Instance=nil
function BombManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	
end


function BombManager.GetInstance()
	if Instance==nil then
		Instance=BombManager.New()
	end
	return Instance
end


function BombManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	
end



function BombManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.FishTBombype={			--死亡鱼类型
		NormalType=1,
		SameType=2,
		LightningChainType=3,
		SpawnType=4,
		FixedScreenType=5,
		DoubleRewardType=6,
		BulletType=7,
		SmallGameType=8,
		NormalBombType=9,
		LaserGunType = 10,
		DrillGunType = 11,
		SerialDrillGunType = 12,
		FireStormType = 13,
		BisonType = 14,
		MultBombType = 15,
		kingCrabType = 16,
		LightningChainRandType = 17,
		DelayBombType = 18,
	}
	self.BombFishTypeInsList={}
	
end

function BombManager:AddScripts()
	self.ScriptsPathList={
		"/View/Bomb/BoomType/BombBaseFish",
		"/View/Bomb/BoomType/NormalFishType",
		"/View/Bomb/BoomType/SameFishType",
		"/View/Bomb/BoomType/LightningChainFishType",
		"/View/Bomb/BoomType/SpawnFishType",
		"/View/Bomb/BoomType/NormalBombFishType",
		"/View/Bomb/BoomType/FixedScreenFishType",
		"/View/Bomb/BoomType/LaserGunFishType",
		"/View/Bomb/BoomType/DrillGunFishType",
		"/View/Bomb/BoomType/SerialDrillGunFishType",
		"/View/Bomb/BoomType/FireStormFishType",
		"/View/Bomb/BoomType/BisonFishType",
		"/View/Bomb/BoomType/kingCrabFishType",
	}
end


function BombManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function BombManager:InitView(gameObj)
	
end


function BombManager:InitInstance()
	self.NormalFishType=NormalFishType
	self.SameFishType=SameFishType
	self.LightningChainFishType=LightningChainFishType
	self.SpawnFishType=SpawnFishType
	self.NormalBombFishType=NormalBombFishType
	self.FixedScreenFishType=FixedScreenFishType
	self.LaserGunFishType = LaserGunFishType
	self.DrillGunFishType = DrillGunFishType
	self.SerialDrillGunFishType = SerialDrillGunFishType
	self.FireStormFishType = FireStormFishType
	self.BisonFishType = BisonFishType
	self.kingCrabFishType = kingCrabFishType
end

function BombManager:InitViewData()	
	
end

function BombManager:CheckFishState(hitFishMsg)
	local tempFish,playerIns=FishManager.GetInstance():GetCheckLockSaveFish(hitFishMsg)
	if tempFish and playerIns then
		self:SetFishDieProcess(hitFishMsg,tempFish,playerIns)
	else
		local bombIns=self:BuildBombInstance(hitFishMsg.mainFishType)
		if bombIns then
			bombIns:SubFishDieProcess(tempFish,playerIns,hitFishMsg)
			bombIns:Destroy()
		end
	end
end


function BombManager:KillPartFishSection(hitPartMsg)
	local hitFish=FishManager.GetInstance():GetUsingFishByFishUID(hitPartMsg.usHaiwangCrabId)
	local bombIns=self:BuildBombInstance(self.FishTBombype.kingCrabType)
	bombIns:RemoveFishPartProcess(hitFish,hitPartMsg.aryKilledParts)
end


function BombManager:SetFixedScreenBombProcess(fishMsg)
	local bombIns=self:BuildBombInstance(fishMsg.mainFishType)
	if bombIns and fishMsg.mainFishType==self.FishTBombype.FixedScreenType then
		bombIns:FixedScreenProcess(fishMsg)
	end
end

function BombManager:SetFishDieProcess(hitFishMsg,hitFish,playerIns)
	local bombIns=self:BuildBombInstance(hitFishMsg.mainFishType)
	if bombIns then
		bombIns:SetFishDieProcess(hitFishMsg,hitFish,playerIns)
	end
end

function BombManager:BuildBombInstance(mainFishType)
	local fishType=mainFishType--hitFishMsg.FishVo.FishConfig.fishRuleType--
	local bombIns=nil
	if self.BombFishTypeInsList[fishType]==nil then
		self.BombFishTypeInsList[fishType]={}
	end
	
	if #self.BombFishTypeInsList[fishType]>0 then
		for i=1,#self.BombFishTypeInsList[fishType] do
			if self.BombFishTypeInsList[fishType][i].IsUsing==false then
				self.BombFishTypeInsList[fishType][i].IsUsing=true
				return self.BombFishTypeInsList[fishType][i]
			end
		end
	end
	
	if fishType==self.FishTBombype.NormalType then
		bombIns=self.NormalFishType.New()
	elseif fishType==self.FishTBombype.SameType then
		bombIns=self.SameFishType.New()
	elseif fishType==self.FishTBombype.LightningChainType or fishType ==self.FishTBombype.LightningChainRandType then
		bombIns=self.LightningChainFishType.New()
	elseif fishType==self.FishTBombype.SpawnType then
		bombIns=self.SpawnFishType.New()
	elseif fishType==self.FishTBombype.FixedScreenType then
		bombIns=self.FixedScreenFishType.New()
	elseif fishType==self.FishTBombype.DoubleRewardType then
		Debug.LogError("未生成类型fishType==>"..fishType)
	elseif fishType==self.FishTBombype.BulletType then
		Debug.LogError("未生成类型fishType==>"..fishType)
	elseif fishType==self.FishTBombype.SmallGameType then
		Debug.LogError("未生成类型fishType==>"..fishType)
	elseif fishType==self.FishTBombype.NormalBombType or fishType == self.FishTBombype.DelayBombType or fishType == self.FishTBombype.MultBombType then
		bombIns=self.NormalBombFishType.New()
	elseif fishType==self.FishTBombype.LaserGunType then
		bombIns=self.LaserGunFishType.New()
	elseif fishType==self.FishTBombype.DrillGunType then
		bombIns=self.DrillGunFishType.New()
	elseif fishType == self.FishTBombype.FireStormType then
		bombIns = self.FireStormFishType.New()
	elseif fishType==self.FishTBombype.SerialDrillGunType then
		bombIns=self.SerialDrillGunFishType.New()
	elseif fishType==self.FishTBombype.BisonType then
		bombIns=self.BisonFishType.New()
	elseif fishType==self.FishTBombype.kingCrabType then
		bombIns=self.kingCrabFishType.New()
	else
		Debug.LogError("未定义类型fishType==>"..fishType)
		return nil
	end
	
	bombIns.IsUsing=true
	table.insert(self.BombFishTypeInsList[fishType],bombIns)
		
	return bombIns
end

function BombManager:__delete()
	self.BombFishTypeInsList = nil
end












