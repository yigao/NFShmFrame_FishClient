LobbyLoginView = Class()

function LobbyLoginView:ctor()
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.visitorEventScript = nil
    self.weiXinEventScript = nil
    self.mobilePhoneEventScript = nil
    self.LoginForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyLoginForm/LobbyLoginForm.prefab"	
end

--初始化ui界面
function LobbyLoginView:OpenForm()

    self:GetUIComponent()

    self:ShowUIComponent()
end

function LobbyLoginView:GetUIComponent()

    local form = CSScript.UIManager:OpenForm(self.LoginForm_Path,true)

    if form == nil then
        Debug.LogError("打开登陆窗口失败："..self.LoginForm_Path)
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

    if self.visitorEventScript == nil then
        local go = self.formTransform:Find("Content/VisitonBtn").gameObject
        self.visitorEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.visitorEventScript == nil then 
            self.visitorEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.visitorEventScript ~= nil and self.visitorEventScript.onMiniPointerClickCallBack == nil then
        self.visitorEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:VisitorOnPointerClick(pointerEventData) end
    end
    
    if self.weiXinEventScript == nil then 
        local go = self.formTransform:Find("Content/WeiXinBtn").gameObject
        self.weiXinEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.weiXinEventScript == nil then
            self.weiXinEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.weiXinEventScript ~= nil and self.weiXinEventScript.onMiniPointerClickCallBack == nil then
        self.weiXinEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:WeiXinOnPointerClick(pointerEventData) end
    end

    if self.mobilePhoneEventScript == nil then
        local go = self.formTransform:Find("Content/MobliePhoneBtn").gameObject
        self.mobilePhoneEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.mobilePhoneEventScript == nil then
            self.mobilePhoneEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.mobilePhoneEventScript ~= nil and self.mobilePhoneEventScript.onMiniPointerClickCallBack == nil then
        self.mobilePhoneEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:MobilePhoneOnPointerClick(pointerEventData) end
    end
end

function LobbyLoginView:ShowUIComponent()

    
end

function LobbyLoginView:VisitorOnPointerClick(eventData)
    LobbyLoginSystem.GetInstance().loginVo:SetLoginType(LobbyLoginSystem.GetInstance().LoginType.Visiton)
    LobbyLoginSystem:GetInstance().loginVo.account = CS.GlobalConfigManager.instance:GetDeviceUniqueIdentifier() 
    LobbyLoginSystem:GetInstance().loginVo.password = CS.GlobalConfigManager.instance:GetDeviceUniqueIdentifier() 
    LobbyLoginSystem.GetInstance():RequestAccountLoginMsg()
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
end

function LobbyLoginView:WeiXinOnPointerClick(eventData)
    LobbyLoginSystem.GetInstance().loginVo:SetLoginType(LobbyLoginSystem.GetInstance().LoginType.WeiXin)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
end

function LobbyLoginView:MobilePhoneOnPointerClick(eventData)
    LobbyLoginSystem.GetInstance().loginVo:SetLoginType(LobbyLoginSystem.GetInstance().LoginType.MobilePhone)
    LobbyLoginSystem.GetInstance().accountLoginView:OpenForm()
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
end

function LobbyLoginView:CloseForm()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
end

function LobbyLoginView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    if self.visitorEventScript ~= nil then
        self.visitorEventScript.onMiniPointerClickCallBack = nil
    end
    self.visitorEventScript = nil

    if self.weiXinEventScript ~= nil then
        self.weiXinEventScript.onMiniPointerClickCallBack = nil
    end
    self.weiXinEventScript = nil

    if self.mobilePhoneEventScript ~= nil then
        self.mobilePhoneEventScript.onMiniPointerClickCallBack = nil 
    end
    self.mobilePhoneEventScript = nil
end

function LobbyLoginView:__delete( )
    self:RemoveUIComponent()
end

