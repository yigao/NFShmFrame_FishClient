GameBaseController=Class()

function GameBaseController:ctor()
	self.RequireList={}
end 

function GameBaseController:BaseInit()
	CommonHelper.LoaderLuaScripts(self.RequireList)
end


function GameBaseController:SendNetMessage(msgID,msgDatas)
	LuaNetwork.SendNetworkMsgLua(self.gameId,msgID,msgDatas)
end


function GameBaseController:SendLobbyNetMessage(msgID,msgDatas)
	LuaNetwork.SendNetworkMsgLua(0,msgID,msgDatas)
end


function GameBaseController:AddScriptsPath(path)
	local scriptPath = nil
	
	if self.gameId == 0 then
		scriptPath="H/Lua/"..path
	else
		scriptPath="G/"..self.gameId.."/Lua/"..path
	end
	table.insert(self.RequireList,scriptPath)
	return scriptPath
end

function GameBaseController:UnloadScripts()
	for i=1, #self.RequireList do
		package.preload[self.RequireList[i]]=nil
		package.loaded[self.RequireList[i]]=nil
		local name = string.gsub(self.RequireList[i],"[%w]*/","")
		--Debug.LogError(name)
		_G[name] = nil
	end
	self.RequireList={}
	collectgarbage()
end



function GameBaseController:LoadManifestFile(gameId)
	if gameId == 0 then
		local hallName =string.lower(CSScript.GlobalConfigManager.Hall_Name)
		CSScript.ResourceManager:LoadManifestFile(hallName.."/"..hallName)
	else
		CSScript.ResourceManager:LoadManifestFile(gameId.."/"..gameId)
	end
end


function GameBaseController:UnloadManifestAssetBundle(gameId,isDelete)
	CSScript.LuaManager:RemoveGameLuaBundle(gameId)
	CSScript.ResourceManager:UnloadManifestPackerAssetBundle(gameId.."/"..gameId,isDelete)
end



function GameBaseController:LoadGameProtoBufferFile(gameId,filePath)
	local protocPath = nil
	if gameId == 0 then
		protocPath="H/Common/ProtoBuffer/"..filePath
	else
		protocPath="G/"..gameId.."/Common/ProtoBuffer/"..filePath
	end
	return LuaProtoBufManager.LoadProtocFiles(protocPath)
end



function GameBaseController:AsyncLoadResource(assetPath,assetType,completeCallBack,isCache,isUnload)
	if isCache==nil then isCache=false end
	if isUnload==nil then isUnload=true end
	local fullPath = nil
	if self.gameId == 0 then
		fullPath = CSScript.GlobalConfigManager.Hall_Name.."/"..assetPath
	else
		fullPath = self.gameId.."/"..assetPath
	end
	CSScript.ResourceManager:AsyncGetResource(fullPath,assetType,completeCallBack,isCache,isUnload)
end



function GameBaseController:LoadResource(assetPath,assetType,isCache,isUnload)
	if isCache==nil then isCache=false end
	if isUnload==nil then isUnload=true end
	
	local fullPath = nil
	if self.gameId == 0 then
		fullPath = CSScript.GlobalConfigManager.Hall_Name.."/"..assetPath
	else
		fullPath = self.gameId.."/"..assetPath
	end
	local prefabBase= CSScript.ResourceManager:GetResource(fullPath,assetType,isCache,isUnload)
	if prefabBase and prefabBase.content then
		return prefabBase.content
	else
		Debug.LogError("资源加载失败==>"..fullPath)
	end
	return nil
end



function GameBaseController:LoadGameResuorce(fullPath,isCache,isUnload)
	local prefabBase= self:LoadResource(fullPath,typeof(CSScript.GameObject),isCache,isUnload)
	if prefabBase then
		return prefabBase
	end
	return nil
end



function GameBaseController:LoadGameResuorceText(textPath,isCache,isUnload)
	local prefabBase= self:LoadResource(textPath,typeof(CS.UnityEngine.TextAsset),isCache,isUnload)
	if prefabBase  then
		return prefabBase
	end
	return nil
end



function GameBaseController:GetPlayerSeatByServerChairId(index)
	if self.gameUIManager.gameData.PlayerChairId>=((self.gameUIManager.gameData.PlayerTotalCount/2)+1) then
		if index>=((self.gameUIManager.gameData.PlayerTotalCount/2)+1) then
		  return index-(self.gameUIManager.gameData.PlayerTotalCount/2)
		else
		  return index+(self.gameUIManager.gameData.PlayerTotalCount/2)
		end
	end
	return index

end


function GameBaseController:GetChessCardPlayerSeatByServerChairId(index)
	local currentIndex=index-self.gameData.PlayerChairId
	if currentIndex<0 then
		currentIndex=self.gameData.PlayerTotalCount+currentIndex
		return currentIndex+1
	end
	return currentIndex+1
end


function GameBaseController:ShowUITips(tipsContext,showTime)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.GameEventOpenTipsForm_EventName,false,tipsContext,showTime)
end


function GameBaseController:__delete()
	
end