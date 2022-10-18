ModuleManager=Class()

local Instance=nil
function ModuleManager:ctor()
	Instance=self
	self:Init()
end

function ModuleManager.GetInstance()
	return Instance
end



function ModuleManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:CaculateResTotalCount()
	self:LoadGame()
end




function ModuleManager:InitData()
	CommonHelper.RemoveSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.gameData=GameManager.GetInstance().gameData
	self.currentLoadCompleteCount=0
	self.PreLoadModuleTotalCount=0
	self.atlasCount=0
	self.AllMoudeList={}
	self.isAtlasLoaded=false
	self.isConfigLoaded=false
	self.moduleQueue={}
	self.PreLoadMoudeList={
		[1]="GameUIManager",
		[2]="GameObjectPoolManager",
		[3]="BGManager",
		[4]="IconManager",
		[5]="BaseFctManager",
		[6]="AudioManager",
		[7]="HelpManager",
		[8]="HandselManager",
		[9]="WinManager",
		[10]="FreeGameManager",
		[11]="JackpotManager",
		[12]="SpeedManager",
	}
	
	
end


function ModuleManager:AddScripts()
	self.ScriptsPathList={
		"View/GameUIManager",
		"View/Panel/Panel_Pool/GameObjectPoolManager",
		"View/Panel/Panel_BG/BGManager",
		"View/Panel/Panel_Icon/IconManager",
		"View/Panel/Panel_Base/BaseFctManager",
		"View/Panel/Panel_Audio/AudioManager",
		"View/Panel/Panel_Help/HelpManager",
		"View/Panel/Panel_Handsel/HandselManager",
		"View/Panel/Panel_Win/WinManager",
		"View/Panel/Panel_FreeGame/FreeGameManager",
		"View/Panel/Panel_Jackpot/JackpotManager",
		"View/Panel/Speed_Panel/SpeedManager",
	}
end


function ModuleManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function ModuleManager:CaculateResTotalCount()
	self.PreLoadModuleTotalCount=self.PreLoadModuleTotalCount+#self.GameConfig.LineConfig
	self.PreLoadModuleTotalCount=self.PreLoadModuleTotalCount+#self.GameConfig.LineConfigByte
	
	for _,_v in pairs(self.GameConfig.GameSpriteAtlas) do
		self.atlasCount=self.atlasCount+1
		self.PreLoadModuleTotalCount=self.PreLoadModuleTotalCount+1
	end
	
	for k,v in pairs(self.PreLoadMoudeList) do
		self.PreLoadModuleTotalCount=self.PreLoadModuleTotalCount+1
		table.insert(self.AllMoudeList,v)
	end
end


function ModuleManager:LoadProgressBarEvent()
	self.currentLoadCompleteCount=self.currentLoadCompleteCount+1
	local silder=string.format("%.3f",self.currentLoadCompleteCount/self.PreLoadModuleTotalCount)
	--Debug.LogError(silder)
	--Debug.LogError(self.currentLoadCompleteCount)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.GameProgressBar_EventName,false,tonumber(silder))
	if self.currentLoadCompleteCount==self.PreLoadModuleTotalCount then
		GameManager.GetInstance():GameAssetLoadCompleteCallBack()
	end
end


function ModuleManager:PreLoadModuleCompleteCallBack()
	self:LoadProgressBarEvent()
	self:ExcuteLoadResourcesQueue()
end


function ModuleManager:LoadGame()
	local LoadingGameFunc=function ()
		self:InitAddProtoBuffer()
		yield_return(WaitForSeconds(0.1))
		self:ReloadingAtlas()
		
	end
	
	startCorotine(LoadingGameFunc)
end


function ModuleManager:ConfigAndAtlasLoadCompeleteCallBack()
	if self.isAtlasLoaded==true and self.isConfigLoaded==true then
		self:PreloadingModule()
	end
end


function ModuleManager:InitAddProtoBuffer()
	for i=1,#self.GameConfig.LineConfig do
		GameManager.GetInstance():LoadGameProtoBufferFile(GameManager.GetInstance().gameId,self.GameConfig.LineConfig[i])
		self:LoadProgressBarEvent()
		yield_return(WaitForSeconds(0.06))
	end
	self:InitGameConfig()
end


function ModuleManager:InitGameConfig()
	local LineConfig=self.GameConfig.LineConfigByte
	for i=1,#LineConfig do
		local text=GameManager.GetInstance():LoadGameResuorceText(LineConfig[i].path)
		yield_return(WaitForSeconds(0.06))
		local data=LuaProtoBufManager.Decode(LineConfig[i].data,text.data)
		--pt(data[LineConfig[i].name])
		self.gameData.gameConfigList[LineConfig[i].name]=data[LineConfig[i].name]
		self:LoadProgressBarEvent()
		yield_return(WaitForSeconds(0.06))
	end
	self.isConfigLoaded=true
	if self.isAtlasLoaded==true then
		self:ConfigAndAtlasLoadCompeleteCallBack()
	end
	
end

function ModuleManager:AlignGameConfig(gameConfig)
	local tempList={}
	for i=1,#gameConfig do
		local id=gameConfig[i].id
		tempList[id]=gameConfig[i]
	end
	return tempList
end



function ModuleManager:PreloadingModule()
	if #self.AllMoudeList>0 then
		for i=1,#self.AllMoudeList do
			--Debug.LogError(self.AllMoudeList[i])
			--_G[self.AllMoudeList[i]].GetInstance()
			table.insert(self.moduleQueue,_G[self.AllMoudeList[i]])
		end
		self:ExcuteLoadResourcesQueue()
		
	end
	
end


function ModuleManager:ExcuteLoadResourcesQueue()
	if next(self.moduleQueue) then
		local loadResourcesQueueFunc=function ()
			local moduleIns=table.remove(self.moduleQueue,1)
			yield_return(WaitForSeconds(0.1))
			moduleIns.GetInstance()
			--yield_return(WaitForSeconds(0.1))
		end
		startCorotine(loadResourcesQueueFunc)
	end
end



function ModuleManager:ReloadingAtlas()
	local count = 0
	for k,v in pairs(self.GameConfig.GameSpriteAtlas) do
		local CreateSpriteAtlasCallBack=function (gameObj)
			if gameObj and gameObj.content then
				GameManager.GetInstance().gameData.AllAtlasList[k]=gameObj.content
				self:LoadProgressBarEvent()
				count=count + 1
				if count == self.atlasCount then
					self:AutoBuildGameSpriteAtlas()
					self.isAtlasLoaded=true
					if self.isConfigLoaded==true then
						self:ConfigAndAtlasLoadCompeleteCallBack()
					end
				end
			else
				Debug.LogError("资源加载失败==>"..k)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(v,typeof(CS.UnityEngine.U2D.SpriteAtlas),CreateSpriteAtlasCallBack,false,false)	
		yield_return(WaitForSeconds(0.05))
	end
end



ModuleManager.AtlasCallBackFunc=function (name,atlasCallBack)
	--Debug.LogError("AtlasCallBackFunc")
	--Debug.LogError(name)
	if(GameManager.GetInstance().gameData.AllAtlasList[name]==nil) then
		local fullPath=GameManager.GetInstance().GameConfig.GameSpriteAtlas[name]
		local assetType=typeof(CS.UnityEngine.U2D.SpriteAtlas)
		if fullPath==nil then Debug.LogError("图集加载失败===>"..name) return end
		
		local AtlasCallBackFunc=function (gameObj)
			if gameObj and gameObj.content then
				GameManager.GetInstance().gameData.AllAtlasList[name]=gameObj.content
				atlasCallBack(gameObj.content)
			else
				Debug.LogError("资源加载失败==>"..fullPath)
			end
		end
		
		GameManager.GetInstance():AsyncLoadResource(fullPath,assetType,AtlasCallBackFunc,false,false)
	else
		atlasCallBack(GameManager.GetInstance().gameData.AllAtlasList[name])
	end
	

end



function ModuleManager:AutoBuildGameSpriteAtlas()
	CommonHelper.AddSpriteAtlas(ModuleManager.AtlasCallBackFunc)
end


function ModuleManager:RemoveCurrentGameSpriteAtlas()
	CommonHelper.RemoveSpriteAtlas(ModuleManager.AtlasCallBackFunc)
	CommonHelper.AddSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
end


