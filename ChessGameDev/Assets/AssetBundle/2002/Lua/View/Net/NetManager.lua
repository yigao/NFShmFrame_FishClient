NetManager=Class()

local Instance=nil
function NetManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)

end


function NetManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
end



function NetManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllNetInsList={}
	self.NetPrafabName="Net"
end

function NetManager:AddScripts()
	self.ScriptsPathList={
		"/View/Net/NetVo/Net",
	}
end


function NetManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function NetManager:InitView(gameObj)
	
end


function NetManager:InitInstance()
	self.Net=Net
	
end


function NetManager:InitViewData()	
	
end


function NetManager:GetNet(transPos)
	local tempNet=nil
	if self.AllNetInsList and next(self.AllNetInsList) then
		tempNet=table.remove(self.AllNetInsList,1)
		if tempNet then
			tempNet:ResetNetState()
			tempNet:SetNetPosition(transPos)
			return tempNet
		else
			Debug.LogError("获取net为nil")
		end	
	else
		local netItem=GameObjectPoolManager.GetInstance():GetGameObject(self.NetPrafabName,GameObjectPoolManager.PoolType.NetPool)
		if netItem then
			tempNet=self.Net.New(netItem)
			tempNet:SetNetPosition(transPos)
			return tempNet
		else
			Debug.LogError("获取netItem为nil")
		end
	end
	return nil
end


function NetManager:AddNet(netIns)
	netIns:Destroy()
	table.insert(self.AllNetInsList,netIns)
end



function NetManager.GetInstance()
	return Instance
end