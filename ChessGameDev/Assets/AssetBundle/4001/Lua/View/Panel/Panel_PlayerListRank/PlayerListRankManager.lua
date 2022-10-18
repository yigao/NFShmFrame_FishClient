PlayerListRankManager=Class()

local Instance=nil
function PlayerListRankManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function PlayerListRankManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_PlayerListRank
		local BuildTipsPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				PlayerListRankManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildTipsPanelCallBack)
		
	else
		return Instance
	end	
end

function PlayerListRankManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end

function PlayerListRankManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function PlayerListRankManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function PlayerListRankManager:InitData()
	
	
end


function PlayerListRankManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_PlayerListRank/View/PlayerListRankView",
		"View/Panel/Panel_PlayerListRank/View/PlayerRankItem/PlayerRankItem",
	}
end


function PlayerListRankManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function PlayerListRankManager:InitInstance()
	self.PlayerRankItem = PlayerRankItem
	self.PlayerListRankView=PlayerListRankView.New(self.gameObject)
end


function PlayerListRankManager:InitView()
	self:IsShowPlayerListRankPanel(false)
end

function PlayerListRankManager:OpenPlayerListRankPanel()
	self:IsShowPlayerListRankPanel(true)
	self.PlayerListRankView:ShowPlayerListItemView()
end

function PlayerListRankManager:IsShowPlayerListRankPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end

function PlayerListRankManager:__delete()

end