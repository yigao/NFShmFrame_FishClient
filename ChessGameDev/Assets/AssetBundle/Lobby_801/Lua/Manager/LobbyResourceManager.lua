LobbyResourceManager=Class()

local Instance=nil
function LobbyResourceManager:ctor()
	Instance=self
	self:Init()
end

function LobbyResourceManager.GetInstance()
	if Instance==nil then
		LobbyResourceManager.New()
	end
	return Instance
end

function LobbyResourceManager:Init ()
	self:InitData()
	self:InitView()
end

function LobbyResourceManager:InitData()
	self.gameData=LobbyManager.GetInstance().gameData
	self.ResourcesTotalCount=0
	self.CurrentLoadedResourcesTotalCount=0
end

function LobbyResourceManager:InitView()
	self:CalculateTotalResourcesCount()
end

function LobbyResourceManager:CalculateTotalResourcesCount()
	local totalCount=0
	local gameConfig=self.gameData.LobbyConfig
	
	totalCount=totalCount + #gameConfig.LobbyExcelConfig
	
	totalCount=totalCount + #gameConfig.LobbyExcelConfigByte

	totalCount = totalCount + #gameConfig.LobbyFormRes

	totalCount = totalCount + #gameConfig.GameItemRes

	totalCount = totalCount + #gameConfig.BGRes

	totalCount = totalCount + #gameConfig.FontsRes

	totalCount = totalCount + #gameConfig.AudioRes

	self.atlasCount = 0
	for k,v in pairs(gameConfig.SpriteAtalsRes) do
		totalCount=totalCount+1
		self.atlasCount = self.atlasCount + 1
	end

	self.ResourcesTotalCount=totalCount
	Debug.LogError("资源总数量为：==>"..totalCount)
end


function LobbyResourceManager:LoadProgressBarEvent()
	self.CurrentLoadedResourcesTotalCount=self.CurrentLoadedResourcesTotalCount+1
	local silder=string.format("%.3f",self.CurrentLoadedResourcesTotalCount/self.ResourcesTotalCount)
	--Debug.LogError(silder)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.GameProgressBar_EventName,false,tonumber(silder))
	if self.CurrentLoadedResourcesTotalCount==self.ResourcesTotalCount then
		self:LoadResCompleteCallBack()
	end
end

function LobbyResourceManager:LoadResCompleteCallBack()
	--Debug.LogError("资源加载完成")
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.LoadLobbyAssetsComplete_EventName)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LobbyResourceManager:CorotineLoadResources()
	self.queue={}
	LobbyLoadingSystem.GetInstance():Open()
	table.insert(self.queue,function() self:InitAddProtoBuffer() end)
	table.insert(self.queue,function() self:InitLobbyExcelConfig() end)
	table.insert(self.queue,function() self:InitSpriteAtlas() end)
	table.insert(self.queue,function() self:InitBGTexture() end)
	table.insert(self.queue,function() self:InitLobbyFonts() end)
	table.insert(self.queue,function() self:CreateAudio() end)
	table.insert(self.queue,function() self:InitFormPrefab() end)
	table.insert(self.queue,function() self:InitGameItemPrefab() end)
	self:ExcuteLoadResourcesQueue()
end

function LobbyResourceManager:ExcuteLoadResourcesQueue()
	if next(self.queue) then
		local excute=table.remove(self.queue,1)
		startCorotine(excute,self)
	end
end

function LobbyResourceManager:InitAddProtoBuffer()
	yield_return(0)
	for i=1,#self.gameData.LobbyConfig.LobbyExcelConfig do 
		LobbyManager.GetInstance():LoadGameProtoBufferFile(0,self.gameData.LobbyConfig.LobbyExcelConfig[i])
		self:LoadProgressBarEvent()
	end
	self:ExcuteLoadResourcesQueue()
end

function LobbyResourceManager:InitLobbyExcelConfig()
	yield_return(0)
	local lobbyExcelConfig=self.gameData.LobbyConfig.LobbyExcelConfigByte
	for i=1,#lobbyExcelConfig do
		--print(lobbyExcelConfig[i].path)
		local text=LobbyManager.GetInstance():LoadGameResuorceText(lobbyExcelConfig[i].path)
		--print(#(text.data))
		local data=LuaProtoBufManager.Decode(lobbyExcelConfig[i].data,text.data)
		--pt(data[lobbyExcelConfig[i].name])
		self.gameData.lobbyExcelConfigList[lobbyExcelConfig[i].name]=data[lobbyExcelConfig[i].name]
		self:LoadProgressBarEvent()
	end
	self:ExcuteLoadResourcesQueue()
end

--------------------------------------------------------------------------------------------------------------
LobbyResourceManager.AtlasCallBackFunc=function (name,atlasCallBack)
	--Debug.LogError("AtlasCallBackFunc")
	--Debug.LogError(name)
	if LobbyManager.GetInstance().gameData.AllAtlasList[name] == nil then
		local fullPath=LobbyManager.GetInstance().gameData.LobbyConfig.SpriteAtalsRes[name]
		local assetType=typeof(CS.UnityEngine.U2D.SpriteAtlas)
		if fullPath==nil then Debug.LogError("图集加载失败===>"..name) return end
		local AtlasCallBackFunc=function (gameObj)
			if gameObj and gameObj.content then
				--Debug.LogError(gameObj.content)
				LobbyManager.GetInstance().gameData.AllAtlasList[name]=gameObj.content
				atlasCallBack(gameObj.content)
			else
				Debug.LogError("资源加载失败==>"..fullPath)
			end
		end
		--图集不能自动删除SpriteAtlasAB包，其它地方需要引用，退出游戏的时候自动销毁
		LobbyManager.GetInstance():AsyncLoadResource(fullPath,assetType,AtlasCallBackFunc,true,false)
	else
		atlasCallBack(LobbyManager.GetInstance().gameData.AllAtlasList[name])
	end
end


function LobbyResourceManager:AutoBuildLobbySpriteAtlas()
	CommonHelper.RemoveSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
	CommonHelper.AddSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
end


function LobbyResourceManager:RemoveCurrenLobbySpriteAtlas()
	CommonHelper.RemoveSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
	CommonHelper.AddSpriteAtlas(LobbyResourceManager.AtlasCallBackFunc)
end


function LobbyResourceManager:InitSpriteAtlas(  )
	local count = 0
	for k,v in pairs(self.gameData.LobbyConfig.SpriteAtalsRes) do
		local AtlasCallBack=function (gameObj)
			if gameObj and gameObj.content then
				LobbyManager.GetInstance().gameData.AllAtlasList[k]=gameObj.content
				self:LoadProgressBarEvent()
				count=count + 1
				if count == self.atlasCount then
					self:AutoBuildLobbySpriteAtlas()
					self:ExcuteLoadResourcesQueue()
				end
			else
				Debug.LogError("大厅图集加载失败==>"..v)
			end
		end
		yield_return(0)
		LobbyManager.GetInstance():AsyncLoadResource(v,typeof(CS.UnityEngine.U2D.SpriteAtlas),AtlasCallBack,true,false)
	end		
end


function LobbyResourceManager:InitLobbyFonts()
	local totalCount=#self.gameData.LobbyConfig.FontsRes
	local count = 0
	for k,v in pairs(self.gameData.LobbyConfig.FontsRes) do
		local CreateFontCallBack=function (gameObj)
			if gameObj and gameObj.content then
				self:LoadProgressBarEvent()
				count=count + 1
				if count == totalCount then
					self:ExcuteLoadResourcesQueue()
				end
			else
				Debug.LogError("资源加载失败==>"..k)
			end
		end
		yield_return(0)
		LobbyManager.GetInstance():AsyncLoadResource(v.path,typeof(CS.UnityEngine.Font),CreateFontCallBack,true,false)	
	end
end


function LobbyResourceManager:InitBGTexture()
	local totalCount=#self.gameData.LobbyConfig.BGRes
	local count = 0
	for k,v in pairs(self.gameData.LobbyConfig.BGRes) do
		local CreateBGTexCallBack=function (gameObj)
			if gameObj and gameObj.content then
				self:LoadProgressBarEvent()
				count=count + 1
				if count == totalCount then
					self:ExcuteLoadResourcesQueue()
				end
			else
				Debug.LogError("资源加载失败==>"..k)
			end
		end
		yield_return(0)
		LobbyManager.GetInstance():AsyncLoadResource(v.path,typeof(CS.UnityEngine.Texture2D),CreateBGTexCallBack,true,false)	
	end
end

function LobbyResourceManager:CreateAudio()
	local totalCount=#self.gameData.LobbyConfig.AudioRes
	local count = totalCount
	if totalCount>0 then
		for k,v in pairs(self.gameData.LobbyConfig.AudioRes) do		
			local CreateAudioCallBackFunc=function (gameObj)
				if gameObj and gameObj.content then
					local prefab=CSScript.GameObject.Instantiate(gameObj.content)
					LobbyAudioManager.New(prefab)
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
			LobbyManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),CreateAudioCallBackFunc)
		end
	else
		self:ExcuteLoadResourcesQueue()
	end
end


function LobbyResourceManager:InitFormPrefab(  )
	local totalCount=#self.gameData.LobbyConfig.LobbyFormRes
	local count=0
	if totalCount>0 then
		for k,v in pairs(self.gameData.LobbyConfig.LobbyFormRes) do
			local FormCallBack=function (gameObj)
				if gameObj and gameObj.content then
					local uiForm = CommonHelper.Instantiate(gameObj.content):GetComponent(typeof(CS.UIFormScript))
					uiForm.formPath = CSScript.GlobalConfigManager.Hall_Name.."/"..v.path
					uiForm.useFormPool = true					
					CSScript.UIManager:RecycleForm(uiForm)
					CSScript.UIManager:SetObjPool(uiForm.gameObject)
					count=count+1
					self:LoadProgressBarEvent()
					if count == totalCount then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			LobbyManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),FormCallBack)
		end		
	end
end

function LobbyResourceManager:InitGameItemPrefab(  )
	local totalCount=#self.gameData.LobbyConfig.GameItemRes
	local count=0
	if totalCount>0 then
		for k,v in pairs(self.gameData.LobbyConfig.GameItemRes) do
			local GameItemCallBack=function (gameObj)
				if gameObj and gameObj.content then
					local gameItemObj = CommonHelper.Instantiate(gameObj.content)
					LobbyManager.GetInstance().gameData.GameItemResList[v.name]=gameItemObj
					CSScript.UIManager:SetObjPool(gameItemObj)
					self:LoadProgressBarEvent()
					if count == totalCount then
						self:ExcuteLoadResourcesQueue()
					end
				else
					Debug.LogError("资源加载失败==>"..v.path)
				end
			end
			yield_return(0)
			LobbyManager.GetInstance():AsyncLoadResource(v.path,typeof(CSScript.GameObject),GameItemCallBack)
		end		
	end	
end

function LobbyResourceManager:__delete()
	Instance= nil
end







