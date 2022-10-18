IconManager=Class()

local Instance=nil
function IconManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function IconManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Icon
		local BuildIconPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				IconManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildIconPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function IconManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function IconManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function IconManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitViewData()
end


function IconManager:InitData()
	self.gamedata=GameManager.GetInstance().gameData
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.IconMark=1
	self.IconCInsList={}					--所有图标挂载列实例表
	self.AllIconItemInsList={}				--列索引对齐的图标实例列表
	self.MainIconImagePrefixName="Item"		--主游戏图标前缀
	self.IconFuzzyName="_Fuzzy"				--模糊图标标识
	
	self.BonusIconImagePrefixName="BonusItem"	--Bonus图标前缀
end


function IconManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Icon/View/IconView",
		"View/Panel/Panel_Icon/IconItem/IconBase",
		"View/Panel/Panel_Icon/IconItem/IconItem",
		"View/Panel/Panel_Icon/SCIcon/SCIconControl",
		"View/Panel/Panel_Icon/IconSlide/IconSlide",
	}
end


function IconManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function IconManager:InitInstance()
	self.IconSlide=IconSlide.New(self.gameObject)
	self.IconView=IconView.New(self.gameObject)
	self.IconItem=IconItem
	self.SCIconControl=SCIconControl
	
end

function IconManager:InitView()
	self.IconItemList=self.IconView.IconItemList
	self.IconMountGroup=self.IconView.IconMountGroup
	self.BonusIconItemList=self.IconView.BonusIconItemList
end



function IconManager:InitViewData()
	self:CreateBonusIconItemPool()
	self:CreateIconItemPool()
	self:BuildSCIconControl()
	self:RandomBuildAllIcon()
end


function IconManager:GetIconMark()
	self.IconMark=self.IconMark+1
	return self.IconMark
end


function IconManager:CreateBonusIconItemPool()
	for i=1,#self.BonusIconItemList do
		GameObjectPoolManager.GetInstance():AddGameObjectPool(self.BonusIconItemList[i],8,self.BonusIconItemList[i].gameObject.name,GameObjectPoolManager.PoolType.BonusIconPool)
	end
end


function IconManager:CreateIconItemPool()
	for i=1,#self.IconItemList do
		GameObjectPoolManager.GetInstance():AddGameObjectPool(self.IconItemList[i],30,self.IconItemList[i].gameObject.name,GameObjectPoolManager.PoolType.IconPool)
	end
end


function IconManager:BuildSCIconControl()
	for i=1,#self.IconMountGroup do
		local iconCInsT=self.SCIconControl.New(self.IconMountGroup[i])
		iconCInsT:SetColumnIndex(i)
		table.insert(self.IconCInsList,iconCInsT)
	end
end



function IconManager:RandomBuildAllIcon(iconNum)
	local tempIconNumList={}
	for i=1,self.GameConfig.Coordinate_COL do
		tempIconNumList[i]={}
		for j=1,self.GameConfig.Coordinate_ROW+1 do
			local randomNum= iconNum or math.random(0,self.GameConfig.IconItemTotalCount-1)
			table.insert(tempIconNumList[i],randomNum)
		end
	end
	self:InitAllIconItem(tempIconNumList)
end


function IconManager:InitAllIconItem(iconNumList)
	for i=1,#iconNumList do
		self.AllIconItemInsList[i]={}
		for j=1,#iconNumList[i] do
			local tempIconIns=self:GetMainIconItemInsByIconNum(iconNumList[i][j])
			table.insert(self.AllIconItemInsList[i],tempIconIns)
		end
	end
	
	for i=1,#self.AllIconItemInsList do
		self.IconCInsList[i]:AddMountPoint(self.AllIconItemInsList[i])
		self.IconCInsList[i]:SetIconInsList(self.AllIconItemInsList[i])
	end
end


function IconManager:GetIconItem(keyName,poolType)
	return GameObjectPoolManager.GetInstance():GetGameObject(keyName,poolType)
end


function IconManager:GetIconItembyIconNum(iconNum,iconPrefixName,poolType)
	local iconName=iconPrefixName..iconNum
	local tempIconItem=self:GetIconItem(iconName,poolType)
	return tempIconItem
end


function IconManager:GetIconItemInsByIconItem(iconItemObj)
	local iconIns=self.IconItem.New()
	iconIns:BuildIconItem(iconItemObj)
	return iconIns
end


--获取主游戏图标项
function IconManager:GetMainIconItemByIconNum(iconNum)
	local tempIconItem=self:GetIconItembyIconNum(iconNum,self.MainIconImagePrefixName,GameObjectPoolManager.PoolType.IconPool)
	if tempIconItem then
		return tempIconItem
	else
		Debug.LogError("获取图标项失败==>"..iconNum)
	end
end


--获取主游戏中的图标实例
function IconManager:GetMainIconItemInsByIconNum(iconNum)
	local tempIconItem=self:GetMainIconItemByIconNum(iconNum)
	if tempIconItem then
		return self:GetIconItemInsByIconItem(tempIconItem)
	end
	
end

--获取图标名字
function IconManager:GetIconItemImageNameByIconNum(IconImagePrefixName,iconNum)
	return IconImagePrefixName..iconNum
end

--获取主图标名字
function IconManager:GetMainIconItemImageNameByIconNum(iconNum)
	return self:GetIconItemImageNameByIconNum(self.MainIconImagePrefixName,iconNum)
end

--获取主模糊图标名字
function IconManager:GetMainIconItemFuzzyImageNameByIconNum(iconNum)
	return self:GetMainIconItemImageNameByIconNum(iconNum)..self.IconFuzzyName
end


--获取Bonus游戏图标项
function IconManager:GetBonusIconItemByIconNum(iconNum)
	local tempIconItem=self:GetIconItembyIconNum(iconNum,self.BonusIconImagePrefixName,GameObjectPoolManager.PoolType.BonusIconPool)
	if tempIconItem then
		return tempIconItem
	else
		Debug.LogError("获取Bonus图标项失败==>"..iconNum)
	end
end


--获取Bonus游戏中的图标实例
function IconManager:GetBonusIconItemInsByIconNum(iconNum)
	local tempIconItem=self:GetBonusIconItemByIconNum(iconNum)
	if tempIconItem then
		return self:GetIconItemInsByIconItem(tempIconItem)
	end
	
end


function IconManager:GetBonusIconItemImageNameByIconNum(iconNum)
	return self:GetIconItemImageNameByIconNum(self.BonusIconImagePrefixName,iconNum)
end


--获取Bonus模糊图标名字
function IconManager:GetBonusIconItemFuzzyImageNameByIconNum(iconNum)
	return self:GetIconItemImageNameByIconNum(self.BonusIconImagePrefixName,iconNum)..self.IconFuzzyName
end





function IconManager:StartSingleColumnIconRun(columnIndex,speed,isFuzzy)
	if self.IconCInsList then
		if self.IconCInsList[columnIndex] then
			self.IconCInsList[columnIndex]:NormalStartRun(speed,isFuzzy)
		else
			Debug.LogError("Start获取列滚动图标实例失败==>"..columnIndex)
		end
	end
end



function IconManager:StopSingleCoumnIconRun(columnIndex,columnIconResult)
	if self.IconCInsList then
		if self.IconCInsList[columnIndex] then
			self.IconCInsList[columnIndex]:NormalStopRun(columnIconResult)
		else
			Debug.LogError("Stop获取列滚动图标实例失败==>"..columnIndex)
		end
	end
end


function IconManager:GetSingleRunIconInsByCoordinate(colCoord,rowCoord)
	local tempSingeColumnIconInsList=self.IconCInsList[colCoord]
	local tempIconIns=tempSingeColumnIconInsList:GetSingleIconIns(rowCoord)
	if tempIconIns then
		return tempIconIns
	end
end


function IconManager:PlayAssignIconInsAnim(iconInsList)
	if iconInsList and #iconInsList>0 then
		for i=1,#iconInsList do
			iconInsList[i]:PlayBaseIconAnim()
		end
	end
end


function IconManager:StopPlayAssignIconInsAnim(iconInsList)
	if iconInsList and #iconInsList>0 then
		for i=1,#iconInsList do
			iconInsList[i]:StopPlayBaseIconAnim()
		end
	end
end






function IconManager:ClearAllIconItemInsListState()
	for i=1,#self.IconCInsList do
		self:StopPlayAssignIconInsAnim(self.IconCInsList[i]:GetIconInsList())
	end
end





function IconManager:IsShowIconMask(isShow)
	CommonHelper.SetActive(self.IconView.iconMaskObj,isShow)
end


function IconManager:IsCloseSilderTipsPanel()
	if CommonHelper.IsActive(self.IconView.sliderTipskObj) then
		CommonHelper.SetActive(self.IconView.sliderTipskObj,false)
	end
end


function IconManager:SetSingleColumnIconSpeedRun(columnIndex,runSpeed)
	if self.IconCInsList then
		if self.IconCInsList[columnIndex] then
			self.IconCInsList[columnIndex]:SetRunSpeed(runSpeed)
		else
			Debug.LogError("获取列滚动图标实例失败==>"..columnIndex)
		end
	end
end











function IconManager:__delete()
	Instance=nil
end
