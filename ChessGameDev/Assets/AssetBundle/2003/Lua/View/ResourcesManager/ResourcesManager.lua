ResourcesManager=Class()

local Instance=nil
function ResourcesManager:ctor()
	Instance=self
	self:Init()
end

function ResourcesManager.GetInstance()
	if Instance==nil then
		ResourcesManager.New()
	end
	return Instance
end


function ResourcesManager:Init ()
	self:InitData()
	
	self:InitView()

end



function ResourcesManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.SpriteAtlas=GameManager.GetInstance().SpriteAtlas
	self.ResourcesTotalCount=0
	self.CurrentLoadedResourcesTotalCount=0
	self.FishPackResList={}
	self.PlayerPrefabList={}
	self.atlasCount = 0
end



function ResourcesManager:InitView()
	self:CalculateTotalResourcesCount()
end



function ResourcesManager:CalculateTotalResourcesCount()
	local totalCount=0
	local gameConfig=self.gameData.GameConfig
	
	totalCount=totalCount+1			--主游戏资源
	
	totalCount=totalCount+#gameConfig.FishConfig
	
	totalCount=totalCount+#gameConfig.FishConfigByte
	
	totalCount=totalCount+#gameConfig.FishPackRes
	
	totalCount=totalCount+#gameConfig.FishRes
	
	totalCount=totalCount+#gameConfig.BulletRes
	
	totalCount=totalCount+#gameConfig.NetRes
	
	totalCount=totalCount+#gameConfig.PlayerRes
	
	totalCount=totalCount+#gameConfig.GoldRes
	
	totalCount=totalCount+#gameConfig.ScoreRes

	totalCount=totalCount+#gameConfig.PlusTipsRes

	totalCount = totalCount + #gameConfig.BigAwardTipsRes

	totalCount=totalCount+#gameConfig.EffectRes
	
	totalCount = totalCount+#gameConfig.FishOutTipsRes

	totalCount=totalCount+#gameConfig.AudioRes
	
	totalCount = totalCount + #gameConfig.LightningRes
	
	totalCount= totalCount+ #gameConfig.TipsContentRes
	
	for k,v in pairs(gameConfig.GamePanelRes) do
		totalCount=totalCount+1
	end
	self.atlasCount = 0
	for k,v in pairs(gameConfig.GameSetRes) do
		totalCount=totalCount+1
		self.atlasCount  = self.atlasCount + 1
	end

	self.ResourcesTotalCount=totalCount
	Debug.LogError("资源总数量为：==>"..totalCount)
end


function ResourcesManager:LoadProgressBarEvent()
	self.CurrentLoadedResourcesTotalCount=self.CurrentLoadedResourcesTotalCount+1
	local silder=string.format("%.3f",self.CurrentLoadedResourcesTotalCount/self.ResourcesTotalCount)
	--Debug.LogError(silder)
	--print("UUUUUUUUUUUUUUUU :",self.CurrentLoadedResourcesTotalCount)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.GameProgressBar_EventName,false,tonumber(silder))
	if self.CurrentLoadedResourcesTotalCount==self.ResourcesTotalCount then
		self:LoadResCompleteCallBack()
	end
end

function ResourcesManager:LoadResCompleteCallBack()
	Debug.LogError("资源加载完成")
	GameManager.GetInstance():LoadResourcesCompleteCallBack()
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ResourcesManager:CorotineLoadResources()	
	self.queue={}
	CommonHelper.RemoveSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
	table.insert(self.queue,function() self:InitAddProtoBuffer() end)
	table.insert(self.queue,function() self:InitGameConfig() end)
	table.insert(self.queue,function() self:InitGameGroup() end)
	table.insert(self.queue,function() self:InitSpriteAtlas() end)
	table.insert(self.queue,function() self:InitFishResources() end)
	table.insert(self.queue,function() self:CreateFishPool() end)
	table.insert(self.queue,function() self:CreateBulletPool() end)
	table.insert(self.queue,function() self:CreatePlayerPrefab() end)
	table.insert(self.queue,function() self:CreateNetPool() end)
	table.insert(self.queue,function() self:CreateGoldPool() end)
	table.insert(self.queue,function() self:CreateScorePool() end)
	table.insert(self.queue,function() self:CreatePlusTipsPool() end)
	table.insert(self.queue,function() self:CreateGameSetPanel() end)
	table.insert(self.queue,function() self:CreateAudio() end)
	table.insert(self.queue,function() self:CreateEffectPool() end)
	table.insert(self.queue,function() self:CreateFishOutTipsPool() end)
	table.insert(self.queue,function() self:CreateBigAwardTipsPool() end)
	table.insert(self.queue,function() self:CreateLightningPool() end)
	table.insert(self.queue,function() self:CreateTipsContentPool() end)
	
	self:ExcuteLoadResourcesQueue()
end


function ResourcesManager:ExcuteLoadResourcesQueue()
	if next(self.queue) then
		local excute=table.remove(self.queue,1)
		startCorotine(excute,self)
	end
end


----------------------------------------------------------------初始化FishConfig-------------------------------------------------------------------------

function ResourcesManager:InitAddProtoBuffer()
	yield_return(0)
	for i=1,#self.gameData.GameConfig.FishConfig do
		GameManager.GetInstance():LoadGameProtoBufferFile(GameManager.GetInstance().gameId,self.gameData.GameConfig.FishConfig[i])
		self:LoadProgressBarEvent()
	end
	self:ExcuteLoadResourcesQueue()
end

function ResourcesManager:InitGameConfig()
	yield_return(0)
	local fishConfig=self.gameData.GameConfig.FishConfigByte
	for i=1,#fishConfig do
		--print(fishConfig[i].path)
		local text=GameManager.GetInstance():LoadGameResuorceText(fishConfig[i].path)
		--print(#(text.data))
		local data=LuaProtoBufManager.Decode(fishConfig[i].data,text.data)
		--pt(data[fishConfig[i].name])
		self.gameData.gameConfigList[fishConfig[i].name]=data[fishConfig[i].name]
		self:LoadProgressBarEvent()
	end
	self:SetFishConfigAudio()
	self.gameData.gameConfigList.FishConfigList=self:AlignGameConfig(self.gameData.gameConfigList.FishConfigList)
	self.gameData.gameConfigList.CoinEffectConfigList=self:AlignGameConfig(self.gameData.gameConfigList.CoinEffectConfigList)
	self.gameData.gameConfigList.DieEffectConfigList=self:AlignGameConfig(self.gameData.gameConfigList.DieEffectConfigList)
	self.gameData.gameConfigList.ScoreEffectConfigList=self:AlignGameConfig(self.gameData.gameConfigList.ScoreEffectConfigList)
	self.gameData.gameConfigList.PlusTipsEffectConfigList=self:AlignGameConfig(self.gameData.gameConfigList.PlusTipsEffectConfigList)
	self.gameData.gameConfigList.BigAwardTipsEffectConfigList=self:AlignGameConfig(self.gameData.gameConfigList.BigAwardTipsEffectConfigList)
	
	self:ExcuteLoadResourcesQueue()
	--pt(self.gameData.gameConfigList.FishConfigList)
end

function ResourcesManager:AlignGameConfig(gameConfig)
	local tempList={}
	for i=1,#gameConfig do
		local id=gameConfig[i].id
		tempList[id]=gameConfig[i]
	end
	return tempList
end


function ResourcesManager:SetFishConfigAudio()
	for i=1,#self.gameData.gameConfigList.FishConfigList do
		local SplitStrCallBackFunc=function (targetStr)
			local tempList={}
			for j=0,targetStr.Length-1 do
				table.insert(tempList,tonumber(targetStr[j]))
			end
			self.gameData.gameConfigList.FishConfigList[i].FishDieAudio=tempList
		end
		CommonHelper.StringSpilt(self.gameData.gameConfigList.FishConfigList[i].FishDieAudio,",",SplitStrCallBackFunc)
	end
end



--------------------------------------------------------------------------------------------------------------


ResourcesManager.AtlasCallBackFunc=function (name,atlasCallBack)
	--Debug.LogError("AtlasCallBackFunc")
	--Debug.LogError(name)
	if(GameManager.GetInstance().gameData.AllAtlasList[name]==nil) then
		local fullPath=GameManager.GetInstance().gameData.GameConfig.GameSetRes[name]
		local assetType=typeof(GameManager.GetInstance().SpriteAtlas)
		if fullPath==nil then Debug.LogError("图集加载失败===>"..name) return end
		local AtlasCallBackFunc=function (gameObj)
			if gameObj and gameObj.content then
				--Debug.LogError(gameObj.content)
				GameManager.GetInstance().gameData.AllAtlasList[name]=gameObj.content
				atlasCallBack(gameObj.content)
			else
				Debug.LogError("资源加载失败==>"..fullPath)
			end
		end
		--图集不能自动删除SpriteAtlasAB包，其它地方需要引用，退出游戏的时候自动销毁
		GameManager.GetInstance():AsyncLoadResource(fullPath,assetType,AtlasCallBackFunc,false,false)
	else
		atlasCallBack(GameManager.GetInstance().gameData.AllAtlasList[name])
	end
end


function ResourcesManager:AutoBuildGameSpriteAtlas()
	
	CommonHelper.RemoveSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
	CommonHelper.AddSpriteAtlas(ResourcesManager.AtlasCallBackFunc)
	
end


function ResourcesManager:RemoveCurrentGameSpriteAtlas()
	CommonHelper.RemoveSpriteAtlas(ResourcesManager.AtlasCallBackFunc)
	CommonHelper.AddSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
end


function ResourcesManager:InitGameGroup(  )
	yield_return(0)
	GameManager.GetInstance():InitGameGroup()
	self:LoadProgressBarEvent()
	self:ExcuteLoadResourcesQueue()
end

function ResourcesManager:InitSpriteAtlas()
	local count = 0
	for k,v in pairs(self.gameData.GameConfig.GameSetRes) do
		local CreateSpriteAtlasCallBack=function (gameObj)
			if gameObj and gameObj.content then
				GameManager.GetInstance().gameData.AllAtlasList[k]=gameObj.content
				self:LoadProgressBarEvent()
				count=count + 1
				if count == self.atlasCount then
					self:AutoBuildGameSpriteAtlas()
					self:ExcuteLoadResourcesQueue()
				end
			else
				Debug.LogError("资源加载失败==>"..k)
			end
		end
		yield_return(0)
		GameManager.GetInstance():AsyncLoadResource(v,typeof(self.SpriteAtlas),CreateSpriteAtlasCallBack,false,false)	
	end
end




function ResourcesManager:InitFishResources()
	local totalCount=#self.gameData.GameConfig.FishPackRes
	local count=0
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.FishPackRes) do
			local CreateFishCallBack=function (gameObj)
				--Debug.LogError(gameObj.content)
				if gameObj and gameObj.content then
					self.FishPackResList[v.name]=CommonHelper.Instantiate(gameObj.content)
					count=count+1
					self:LoadProgressBarEvent()
					if count==totalCount then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateFishCallBack)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end


function ResourcesManager:CreateFishPool()
	local totalCount=#self.gameData.GameConfig.FishRes
	local count=0
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.FishRes) do
			yield_return(0)
			local parentPrefab = self.FishPackResList[v.ParentName]
			local prefab = parentPrefab.transform:Find(v.name).gameObject
			GameObjectPoolManager.GetInstance():AddGameObjectPool(prefab,v.amout,v.name,GameObjectPoolManager.PoolType.FishPool)
			self:LoadProgressBarEvent()
		end
	end
	self:DeleteAllFishPackResources()
	self:ExcuteLoadResourcesQueue()
end


function ResourcesManager:CreateBulletPool()
	local totalCount=#self.gameData.GameConfig.BulletRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.BulletRes) do
			local CreateBulletPoolCallBack=function (gameObj)
				if gameObj and gameObj.content then
					local tempBullet=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempBullet,v.amout,v.name,GameObjectPoolManager.PoolType.BulletPool)
					CommonHelper.Destroy(tempBullet)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateBulletPoolCallBack)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end



function ResourcesManager:DeleteAllFishPackResources()
	for k,v in pairs(self.FishPackResList) do
		CommonHelper.Destroy(v)
	end
	self.FishPackResList=nil
end


function ResourcesManager:CreateNetPool()
	local totalCount=#self.gameData.GameConfig.NetRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.NetRes) do
			local CreateNetPoolCallBack=function (gameObj)
				if gameObj and gameObj.content then
					local tempNet=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempNet,v.amout,v.name,GameObjectPoolManager.PoolType.NetPool)
					CommonHelper.Destroy(tempNet)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateNetPoolCallBack)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
	
end


function ResourcesManager:CreatePlayerPrefab()
	local totalCount=#self.gameData.GameConfig.PlayerRes
	local count = totalCount
	local index = 0
	if totalCount>0 then
		for k,v in ipairs(self.gameData.GameConfig.PlayerRes) do
			local CreatePlayerPrefabCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					self:LoadProgressBarEvent()
					local tempPlayer=CommonHelper.Instantiate(gameObj.content)
					PlayerManager.GetInstance():InitPlayerInfo(k,tempPlayer)
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreatePlayerPrefabCallBackFunc)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
	
	
end



function ResourcesManager:CreateGoldPool()
	local totalCount=#self.gameData.GameConfig.GoldRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.GoldRes) do		
			local CreateGoldPoolCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local tempGold=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempGold,v.amout,v.name,GameObjectPoolManager.PoolType.GoldPool)
					CommonHelper.Destroy(tempGold)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateGoldPoolCallBackFunc)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
	
	
end


function ResourcesManager:CreateScorePool()
	local totalCount=#self.gameData.GameConfig.ScoreRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.ScoreRes) do		
			local CreateScorePoolCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local tempScore=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempScore,v.amout,v.name,GameObjectPoolManager.PoolType.ScorePool)
					CommonHelper.Destroy(tempScore)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateScorePoolCallBackFunc)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end

function ResourcesManager:CreatePlusTipsPool()
	local totalCount=#self.gameData.GameConfig.PlusTipsRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.PlusTipsRes) do		
			local CreatePlusTipsPoolCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local tempPlusTips=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempPlusTips,v.amout,v.name,GameObjectPoolManager.PoolType.PlusTips)
					CommonHelper.Destroy(tempPlusTips)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreatePlusTipsPoolCallBackFunc)
			
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end


function ResourcesManager:CreateBigAwardTipsPool()
	local totalCount=#self.gameData.GameConfig.BigAwardTipsRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.BigAwardTipsRes) do		
			local CreateBigAwardTipsPoolCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local tempBigAwardTips=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempBigAwardTips,v.amout,v.name,GameObjectPoolManager.PoolType.BigAwardTipsPool)
					CommonHelper.Destroy(tempBigAwardTips)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateBigAwardTipsPoolCallBackFunc)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end



function ResourcesManager:CreateEffectPool()
	local totalCount=#self.gameData.GameConfig.EffectRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.EffectRes) do		
			local CreateEffectPoolCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local tempEffect=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempEffect,v.amout,v.name,GameObjectPoolManager.PoolType.EffectPool)
					CommonHelper.Destroy(tempEffect)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateEffectPoolCallBackFunc)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end

function ResourcesManager:CreateFishOutTipsPool()
	local totalCount=#self.gameData.GameConfig.FishOutTipsRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.FishOutTipsRes) do		
			local CreateFishOutTipsPoolCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local tempFishOutTips=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempFishOutTips,v.amout,v.name,GameObjectPoolManager.PoolType.FishOutTipsPool)
					CommonHelper.Destroy(tempFishOutTips)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateFishOutTipsPoolCallBackFunc)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end


function ResourcesManager:CreateAudio()
	local totalCount=#self.gameData.GameConfig.AudioRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.AudioRes) do		
			local CreateAudioCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local prefab=CSScript.GameObject.Instantiate(gameObj.content)
					AudioManager.New(prefab)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateAudioCallBackFunc)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end



function ResourcesManager:CreateGameSetPanel()
	local gameSetPath=self.gameData.GameConfig.GamePanelRes.GameSetPanel
	local CreateGameSetPanelCallBackFunc=function (gameObj)
		if gameObj and gameObj.content then
			local autoSetPanel=CommonHelper.Instantiate(gameObj.content)
			CommonHelper.AddToParentGameObject(autoSetPanel,GameUIManager.GetInstance().GamePanelRoot)
			GameSetManager.GetInstance():InitPlayerSetPanel(autoSetPanel)
			self:LoadProgressBarEvent()
			
			self:ExcuteLoadResourcesQueue()
		else
			Debug.LogError("资源加载失败==>"..gameSetPath)
		end
	end
	yield_return(0)
	GameManager.GetInstance():AsyncLoadResource(gameSetPath,typeof(CSScript.GameObject),CreateGameSetPanelCallBackFunc)
end



function ResourcesManager:CreateLightningPool()
	local totalCount=#self.gameData.GameConfig.LightningRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.LightningRes) do		
			local CreateLightningPoolCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local tempLightning=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempLightning,v.amout,v.name,GameObjectPoolManager.PoolType.LightningPool)
					CommonHelper.Destroy(tempLightning)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateLightningPoolCallBackFunc)
		end
	end
end


function ResourcesManager:CreateTipsContentPool()
	local totalCount=#self.gameData.GameConfig.TipsContentRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.GameConfig.TipsContentRes) do		
			local CreateTipsContentPoolCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local tempLightning=CommonHelper.Instantiate(gameObj.content)
					GameObjectPoolManager.GetInstance():AddGameObjectPool(tempLightning,v.amout,v.name,GameObjectPoolManager.PoolType.TipsContent)
					CommonHelper.Destroy(tempLightning)
					self:LoadProgressBarEvent()
					count=count-1
					if count<=0 then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			GameManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateTipsContentPoolCallBackFunc)
		end
	end
end


function ResourcesManager:__delete()
	self.FishPackResList=nil
	
end







