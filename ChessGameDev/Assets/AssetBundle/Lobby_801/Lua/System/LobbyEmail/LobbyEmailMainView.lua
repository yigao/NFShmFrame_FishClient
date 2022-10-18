LobbyEmailMainView = Class()

function LobbyEmailMainView:ctor()
    self.EmailForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyEmailForm/LobbyEmailMainForm.prefab"	
    self:Init()
end

function LobbyEmailMainView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyEmailMainView:InitData(  )
    self.EmailItemList = {}
end

function LobbyEmailMainView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.empty_gameObject = nil
    self.listEmail_gameObject = nil
    self.uiListScript = nil
    self.closeEventScript = nil
    self.allGouXuanGameObject = nil
    self.selectAllEventScript = nil
    self.readAllEventScript = nil 
    self.deleteEmailEventScript = nil 
end

function LobbyEmailMainView:ReInit()

end
--初始化ui界面
function LobbyEmailMainView:OpenForm()
    self:ReInit()
    self:GetUIComponent()
end


function LobbyEmailMainView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.EmailForm_Path,true)

    if form == nil then
        Debug.LogError("打开邮件窗口失败："..self.EmailForm_Path)
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

    if self.empty_gameObject == nil then
        self.empty_gameObject = self.formTransform:Find("Animator/Empty").gameObject
    end

    if  self.empty_gameObject ~= nil then
        self.empty_gameObject:SetActive(false)
    end
   
    if self.listEmail_gameObject == nil then
        self.listEmail_gameObject = self.formTransform:Find("Animator/EmailItemList").gameObject
    end

    if self.listEmail_gameObject ~= nil then
        self.listEmail_gameObject:SetActive(false)
    end

    if self.uiListScript == nil then
        self.uiListScript = self.formTransform:Find("Animator/EmailItemList"):GetComponent(typeof(CS.UIListScript))
        self.uiListScript.InstantiateElementCallback = function (go) self:CreateEmailItem(go) end
    end

    if self.uiListScript ~= nil then
        self.uiListScript:ResetContentPosition()
    end

    if self.closeEventScript == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScript == nil then 
            self.closeEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        
    end
    if self.closeEventScript ~= nil and self.closeEventScript.onMiniPointerClickCallBack == nil then
        self.closeEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end

    if self.allGouXuanGameObject == nil then
        self.allGouXuanGameObject = self.formTransform:Find("Animator/SelectAll_Btn/gou_image").gameObject
    end

    if self.allGouXuanGameObject ~= nil then
        self.allGouXuanGameObject:SetActive(false)
    end

    if self.selectAllEventScript == nil then 
        local go = self.formTransform:Find("Animator/SelectAll_Btn").gameObject
        self.selectAllEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.selectAllEventScript == nil then
            self.selectAllEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.selectAllEventScript ~= nil and self.selectAllEventScript.onMiniPointerClickCallBack == nil then
        self.selectAllEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:SelectAllOnPointerClick(pointerEventData) end
    end

    if self.readAllEventScript == nil then
        local go = self.formTransform:Find("Animator/ReadAll_Btn").gameObject
        self.readAllEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.readAllEventScript == nil then
            self.readAllEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.readAllEventScript ~= nil and self.readAllEventScript.onMiniPointerClickCallBack == nil then
        self.readAllEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ReadAllOnPointerClick(pointerEventData) end
    end

    if self.deleteEmailEventScript == nil then
        local go = self.formTransform:Find("Animator/DeleteEmail_Btn").gameObject
        self.deleteEmailEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.deleteEmailEventScript == nil then
            self.deleteEmailEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.deleteEmailEventScript ~= nil and self.deleteEmailEventScript.onMiniPointerClickCallBack == nil then
        self.deleteEmailEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:DeleteEmailOnPointerClick(pointerEventData) end
    end 
end

function LobbyEmailMainView:ShowUIComponent()
    if self.uiFormScript ~= nil and self.uiFormScript:IsCanvasEnabled() == true then
        self:IsDisplaySelectAll()
        if (LobbyEmailSystem.GetInstance().emailVoList) and (#LobbyEmailSystem.GetInstance().emailVoList > 0) then
            self:IsDisplayEmailItem(true)
            self.uiListScript:SetElementAmount(#LobbyEmailSystem.GetInstance().emailVoList)
        else
            self:IsDisplayEmailItem(false)
        end
    end
end

function LobbyEmailMainView:RefreshUIComponent( ... )
    if self.uiFormScript ~= nil and self.uiFormScript:IsCanvasEnabled() == true then
        for i = 1,#self.EmailItemList do
            self.EmailItemList[i]:RefreshUIComponent()
        end
    end
end

function LobbyEmailMainView:CreateEmailItem(go)
    local emailItem = EmailItem.New(go)
    table.insert(self.EmailItemList,emailItem)
end

function LobbyEmailMainView:IsDisplayEmailItem(isDisplay)
    CommonHelper.SetActive(self.listEmail_gameObject,isDisplay)
    CommonHelper.SetActive(self.empty_gameObject,not isDisplay)
end

function LobbyEmailMainView:CloseOnPointerClick(  )
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyEmailMainView:SelectAllOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if LobbyEmailSystem.GetInstance().isSelectAll == true then
        LobbyEmailSystem.GetInstance().isSelectAll = false
    else
        LobbyEmailSystem.GetInstance().isSelectAll = true
    end
    self:IsDisplaySelectAll()
    LobbyEmailSystem.GetInstance():UpdateEmailSelectAll()
    for i=1,#self.EmailItemList do
        self.EmailItemList[i]:IsDisplayGouXuan()
    end
end

function LobbyEmailMainView:ReadAllOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
	LobbyEmailSystem.GetInstance():RequestReadEmailMsg(0)
end

function LobbyEmailMainView:DeleteEmailOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    local delteEamilList = nil
    for i=1,#LobbyEmailSystem.GetInstance().emailVoList do
        if LobbyEmailSystem.GetInstance().emailVoList[i].isGouXuan == true then
            if delteEamilList == nil  then delteEamilList = {} end
            table.insert(delteEamilList,LobbyEmailSystem.GetInstance().emailVoList[i].id)
        end
    end

    if delteEamilList then
        LobbyEmailSystem.GetInstance():RequestDeleteEmailMsg(delteEamilList)
    else
        XLuaUIManager.GetInstance():OpenTipsForm(10300)
    end
end

function LobbyEmailMainView:IsDisplaySelectAll()
    if  LobbyEmailSystem.GetInstance().isSelectAll ==  true then
        CommonHelper.SetActive(self.allGouXuanGameObject,true)
    else
        CommonHelper.SetActive(self.allGouXuanGameObject,false)
    end
end

function LobbyEmailMainView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyEmailMainView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.empty_gameObject = nil
    self.listEmail_gameObject = nil
    self.allGouXuanGameObject = nil

    if self.uiListScript.InstantiateElementCallback ~= nil then
        self.uiListScript.InstantiateElementCallback = nil
    end

    if self.closeEventScript ~= nil then
        self.closeEventScript.onMiniPointerClickCallBack = nil
    end
    self.closeEventScript = nil

    if self.selectAllEventScript ~= nil then
        self.selectAllEventScript.onMiniPointerClickCallBack = nil
    end
    self.selectAllEventScript = nil

    if self.readAllEventScript ~= nil then
        self.readAllEventScript.onMiniPointerClickCallBack = nil 
    end
    self.readAllEventScript = nil

    if self.deleteEmailEventScript ~= nil then
        self.deleteEmailEventScript.onMiniPointerClickCallBack = nil 
    end
    self.deleteEmailEventScript = nil

    for i =1,#self.EmailItemList do
        self.EmailItemList[i]:Destroy()
    end
    self.EmailItemList = {}
end

function LobbyEmailMainView:__delete( )
    self:RemoveUIComponent()
end

