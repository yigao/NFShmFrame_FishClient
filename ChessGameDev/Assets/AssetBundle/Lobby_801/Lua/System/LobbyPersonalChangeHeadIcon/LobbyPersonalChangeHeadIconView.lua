LobbyPersonalChangeHeadIconView = Class()

function LobbyPersonalChangeHeadIconView:ctor()
    self.PersonalHeadIcon_Form_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyPersonalChangeHeadIcon/LobbyPersonalChangeHeadIconForm.prefab"	
    self:Init()
end

function LobbyPersonalChangeHeadIconView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyPersonalChangeHeadIconView:InitData(  )
    
end

function LobbyPersonalChangeHeadIconView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.headIconItemList = nil
    self.scrollRect = nil
    self.closeEventScript = nil
end

function LobbyPersonalChangeHeadIconView:ReInit(  )
    
end

--初始化ui界面
function LobbyPersonalChangeHeadIconView:OpenForm()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
end


function LobbyPersonalChangeHeadIconView:GetUIComponent()

    local form =  XLuaUIManager.GetInstance():OpenForm(self.PersonalHeadIcon_Form_Path,true)

    if form == nil then
        Debug.LogError("打开更改头像窗口失败："..self.PersonalHeadIcon_Form_Path)
        return 
    end

    if self.uiFormScript~=nil and self.uiFormScript ~= form then
        self:RemoveUIComponent()
    end

    if self.uiFormScript == nil then
        self.uiFormScript = form
    end

    if self.formTransform == nil then
        self.formTransform = self.uiFormScript.transform
    end

    if self.formGameObject == nil then
        self.formGameObject = self.uiFormScript.gameObject
    end

    if self.scrollRect == nil then
        self.scrollRect = self.formTransform:Find("Animator/HeadList/ScrollView"):GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
    end

    if self.headIconItemList == nil then
        self.headIconItemList = {}
        local childCount = self.formTransform:Find("Animator/HeadList/ScrollView/Viewport/Content").childCount
        for i =1,childCount do
            local headIcon_gameObjct = self.formTransform:Find("Animator/HeadList/ScrollView/Viewport/Content/HeadIconItem"..i).gameObject 
            local headIconItem  = HeadIconItem.New(headIcon_gameObjct,i,self.scrollRect)
            table.insert(self.headIconItemList,headIconItem)
        end
    end

    if self.closeEventScript == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScript == nil then 
            self.closeEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        self.closeEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end
end

function LobbyPersonalChangeHeadIconView:ShowUIComponent()
    for i = 1,#self.headIconItemList do
        self.headIconItemList[i]:ReInit()
    end

    self:ShowHeadIconItem(LobbyHallCoreSystem.GetInstance().playerInfoVo.face_id)
end

function LobbyPersonalChangeHeadIconView:RefreshUIComponent( ... )
    
end

function LobbyPersonalChangeHeadIconView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyPersonalChangeHeadIconView:ShowHeadIconItem(index)
    for i = 1,#self.headIconItemList do
        if index == i then
            self.headIconItemList[i]:ShowHeadIconKung()
        else
            self.headIconItemList[i]:HideHeadIconKuang()
        end
    end
end

function LobbyPersonalChangeHeadIconView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyPersonalChangeHeadIconView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    if self.closeEventScript ~= nil then
        self.closeEventScript.onPointerClickCallBack = nil
    end
    self.closeEventScript = nil 

    for i = 1,#self.headIconItemList do
        self.headIconItemList[i]:Destroy()
    end
    self.headIconItemList = nil
end

function LobbyPersonalChangeHeadIconView:__delete( )
    self:RemoveUIComponent()
end

