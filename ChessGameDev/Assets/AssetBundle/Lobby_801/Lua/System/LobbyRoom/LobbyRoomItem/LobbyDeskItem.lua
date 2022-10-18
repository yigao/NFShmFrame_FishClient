LobbyDeskItem = Class()

function LobbyDeskItem:ctor()
    self.itemGameObject = nil
    self.itemTransform = nil
    self.parent = nil
    self.deskVo = nil
    self.chairItemList = nil
    self.DeskItem_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyRoomForm/RoomItem/DeskItem.prefab"
end

function LobbyDeskItem:Init(deskData,parent)
    self.parent = parent
    self.deskVo = deskData
    self:GetUIComponent()
    self:ShowUIComponent()  
end

function LobbyDeskItem:GetUIComponent()
    if self.itemGameObject == nil then
        local prefab = CSScript.ResourceManager:GetResource(self.DeskItem_Path,typeof(CSScript.GameObject),false,false).content
        self.itemGameObject = CSScript.GameObject.Instantiate(prefab)
    end

    if self.itemTransform == nil then
        self.itemTransform = self.itemGameObject.transform
        self.itemTransform:SetParent(self.parent)
        self.itemTransform.localPosition = CSScript.Vector3.zero
        self.itemTransform.localScale= CSScript.Vector3.one
        self.itemTransform.localEulerAngles = CSScript.Vector3.zero
    end

    if  self.chairItemList == nil then
        self.chairItemList = {}
        for i =1,#self.deskVo.chairVoList do 
            local chairItem  = LobbyChairItem.New()
            table.insert(self.chairItemList,chairItem)
        end
    end
end

function LobbyDeskItem:ShowUIComponent()
    for i =1,#self.deskVo.chairVoList do 
        local chairItemTrans = self.itemTransform:Find("ChairIndex".. i)
        self.chairItemList[i]:Init(self.deskVo.deskId,self.deskVo.chairVoList[i],chairItemTrans)
    end   
end

function LobbyDeskItem:RemoveUIComponent()
    for i = 1,#self.chairItemList do
        self.chairItemList[i]:Destroy()
    end
    if self.itemGameObject  then
        CSScript.GameObject.Destroy(self.itemGameObject)
    end
    self.itemGameObject = nil
    self.itemTransform = nil
    self.parent = nil
end


function LobbyDeskItem:__delete()
	self:RemoveUIComponent()
end
