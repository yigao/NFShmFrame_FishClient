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
end


function BombManager:InitViewData()	
	
end



function BombManager:CheckFishState(hitFishMsg)
	local tempFish,playerIns=FishManager.GetInstance():GetCheckLockSaveFish(hitFishMsg)
	if tempFish and playerIns then
		self:SetFishDieProcess(hitFishMsg,tempFish,playerIns)
	end
end


function BombManager:SetFixedScreenBombProcess(fishMsg)
	local bombIns=self:BuildBombInstance(fishMsg)
	if bombIns and fishMsg.mainFishType==self.FishTBombype.FixedScreenType then
		bombIns:FixedScreenProcess(fishMsg)
	end
end




function BombManager:SetFishDieProcess(hitFishMsg,hitFish,playerIns)
	
	local bombIns=self:BuildBombInstance(hitFishMsg)
	if bombIns then
		bombIns:SetFishDieProcess(hitFishMsg,hitFish,playerIns)
	end
end



function BombManager:BuildBombInstance(hitFishMsg)
	local fishType=hitFishMsg.mainFishType--hitFishMsg.FishVo.FishConfig.fishRuleType--
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
	elseif fishType==self.FishTBombype.LightningChainType then
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
	elseif fishType==self.FishTBombype.NormalBombType then
		bombIns=self.NormalBombFishType.New()
	else
		Debug.LogError("未定义类型fishType==>"..fishType)
		return nil
	end
	
	bombIns.IsUsing=true
	table.insert(self.BombFishTypeInsList[fishType],bombIns)
		
	return bombIns
end













