SmallGameManager=Class()

local Instance=nil
function SmallGameManager:ctor()
	Instance=self
	self:Init()
end

function SmallGameManager.GetInstance()
	if Instance==nil then
		Instance=SmallGameManager.New()
	end
	return Instance
end


function SmallGameManager:Init ()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
end



function SmallGameManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.SmallGameType={
		HaiShenType=101,
		XYJinNiuType=102,
		CaiShenType=103,
	}
	self.SmallGmaeRsNameList={
		[101]="HaiShenEffect",
		[102]="JinNiuEffect",
		[103]="CaiShenEffect",
	}
	
	self.SmallGameLoadStateList={
		[101]=false,
		[102]=false,
		[103]=false,
	}
end

function SmallGameManager:AddScripts()
	self.ScriptsPathList={
			"/View/SmallGame/HaiShen/HaiShenManager",
			"/View/SmallGame/JinNiu/JinNiuManager",
			"/View/SmallGame/CaiShen/CaiShenManager",
		}
end


function SmallGameManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function SmallGameManager:InitInstance()
	HaiShenManager.GetInstance()
	JinNiuManager.GetInstance()
	CaiShenManager.GetInstance()
end



function SmallGameManager:EnterHaiShenGame(data)
	local isLoaded=self.SmallGameLoadStateList[self.SmallGameType.HaiShenType]
	if isLoaded==false then
		self.HaiShenEffect=GameObjectPoolManager.GetInstance():GetGameObject(self.SmallGmaeRsNameList[self.SmallGameType.HaiShenType],GameObjectPoolManager.PoolType.EffectPool)
		HaiShenManager.GetInstance():InitHaiShenViewData(self.HaiShenEffect)
		self.SmallGameLoadStateList[self.SmallGameType.HaiShenType]=true
	end
	
	local DelayStartHaiShenFunc=function ()
		if self.HaiShenTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.HaiShenTimer)
		end
		AudioManager.GetInstance():PlayBGAudio(34)
		HaiShenManager.GetInstance():ResetHaiShenStateData(data)
	end
	self.HaiShenTimer=TimerManager.GetInstance():CreateTimerInstance(1,DelayStartHaiShenFunc)
end


function SmallGameManager:EnterXYJiNiuGame(data)
	local isLoaded=self.SmallGameLoadStateList[self.SmallGameType.XYJinNiuType]
	if isLoaded==false then
		self.JinNiuEffect=GameObjectPoolManager.GetInstance():GetGameObject(self.SmallGmaeRsNameList[self.SmallGameType.XYJinNiuType],GameObjectPoolManager.PoolType.EffectPool)
		JinNiuManager.GetInstance():ResetJinNiuViewData(self.JinNiuEffect)
		self.SmallGameLoadStateList[self.SmallGameType.XYJinNiuType]=true
	end
	local DelayStartXYJinNiuFunc=function ()
		if self.XYJinNiuTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.XYJinNiuTimer)
		end
		AudioManager.GetInstance():PlayBGAudio(34)
		JinNiuManager.GetInstance():ResetXYJinNiuStateData(data)
	end
	self.XYJinNiuTimer=TimerManager.GetInstance():CreateTimerInstance(1,DelayStartXYJinNiuFunc)
end


function SmallGameManager:EnterCaiShenGame(data)
	local isLoaded=self.SmallGameLoadStateList[self.SmallGameType.CaiShenType]
	if isLoaded==false then
		self.CaiShenEffect=GameObjectPoolManager.GetInstance():GetGameObject(self.SmallGmaeRsNameList[self.SmallGameType.CaiShenType],GameObjectPoolManager.PoolType.EffectPool)
		CaiShenManager.GetInstance():ResetCaiShenViewData(self.CaiShenEffect)
		self.SmallGameLoadStateList[self.SmallGameType.CaiShenType]=true
	end
	local DelayStartCaiShenFunc=function ()
		if self.CaiShenTimer then
			TimerManager.GetInstance():RecycleTimerIns(self.CaiShenTimer)
		end
		AudioManager.GetInstance():PlayBGAudio(34)
		CaiShenManager.GetInstance():ResetCaiShenStateData(data)
	end
	self.CaiShenTimer=TimerManager.GetInstance():CreateTimerInstance(1,DelayStartCaiShenFunc)
end



function SmallGameManager:ClearAllSmallGameState()
	HaiShenManager.GetInstance():IsShowHaiShenPanel(false)
	JinNiuManager.GetInstance():IsShowJinNiuPanel(false)
	CaiShenManager.GetInstance():IsShowCaiShenPanel(false)
end


function SmallGameManager:__delete()
	HaiShenManager.GetInstance():Destroy()
	JinNiuManager.GetInstance():Destroy()
	CaiShenManager.GetInstance():Destroy()
end