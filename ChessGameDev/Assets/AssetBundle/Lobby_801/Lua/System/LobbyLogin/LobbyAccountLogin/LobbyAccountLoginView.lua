LobbyAccountLoginView = Class()

function LobbyAccountLoginView:ctor()
    
	self:Init()
    self.LobbyAccountLoginForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyLoginForm/LobbyAccountLoginForm/LobbyAccountLoginForm.prefab"	
end

function LobbyAccountLoginView:Init()
	self:InitData()
	self:InitView()
end

function LobbyAccountLoginView:InitData()
    self.isGouXuan = true
end

function LobbyAccountLoginView:InitView()
	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
	
	self.inputFieldMobilePhoneNumber = nil
	self.inputFieldPassword = nil 

    self.closeEventScirpt = nil
    self.confirmEventScirpt = nil
    self.gouXuanEventScript = nil
    self.gouXuan_GameObject = nil
    self.forgetPasswordEventScript = nil
    self.registerEventScript= nil
end

function LobbyAccountLoginView:ReInit(  )
    self.isGouXuan = true
end

--初始化ui界面
function LobbyAccountLoginView:OpenForm()
    self:ReInit()

    self:GetUIComponent()

    self:ShowUIComponent()
end


function LobbyAccountLoginView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.LobbyAccountLoginForm_Path,true)

    if form == nil then
        Debug.LogError("打开登录窗口失败："..self.LobbyAccountLoginForm_Path)
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

	if self.inputFieldMobilePhoneNumber == nil then
		self.inputFieldMobilePhoneNumber = self.formTransform:Find("Animator/InputAccountPanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end

	if self.inputFieldPassword == nil then
		self.inputFieldPassword = self.formTransform:Find("Animator/InputPasswordPanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end

    if self.confirmEventScirpt == nil then 
        local go = self.formTransform:Find("Animator/Confirm_Btn").gameObject
        self.confirmEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.confirmEventScirpt == nil then
            self.confirmEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.confirmEventScirpt~=nil and self.confirmEventScirpt.onMiniPointerClickCallBack == nil then
        self.confirmEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:ConfirmOnPointerClick(pointerEventData) end
    end

    if self.closeEventScirpt == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScirpt == nil then
            self.closeEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.closeEventScirpt ~= nil and self.closeEventScirpt.onMiniPointerClickCallBack==nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end

    if self.gouXuanEventScript == nil then
        local go = self.formTransform:Find("Animator/Gou_Btn").gameObject
        self.gouXuanEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.gouXuanEventScript == nil then
            self.gouXuanEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        
    end
    if  self.gouXuanEventScript ~= nil and self.gouXuanEventScript.onMiniPointerClickCallBack == nil then
        self.gouXuanEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:GouXuanOnPointerClick(pointerEventData) end
    end


    if self.gouXuan_GameObject == nil then
        self.gouXuan_GameObject =  self.formTransform:Find("Animator/Gou_Btn/gou_image").gameObject
    end

    if self.forgetPasswordEventScript == nil then
        local go = self.formTransform:Find("Animator/Forget_Password_Btn").gameObject
        self.forgetPasswordEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.forgetPasswordEventScript == nil then
            self.forgetPasswordEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.forgetPasswordEventScript ~= nil and self.forgetPasswordEventScript.onMiniPointerClickCallBack == nil then
        self.forgetPasswordEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ForgetPasswordOnPointerClick(pointerEventData) end
    end


    if self.registerEventScript == nil then
        local go = self.formTransform:Find("Animator/Register_Btn").gameObject
        self.registerEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.registerEventScript == nil then
            self.registerEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end   
    end
    if self.registerEventScript ~= nil and self.registerEventScript.onMiniPointerClickCallBack == nil then
        self.registerEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:RegisterOnPointerClick(pointerEventData) end
    end
end

function LobbyAccountLoginView:ShowUIComponent()
    CommonHelper.SetActive(self.gouXuan_GameObject,self.isGouXuan)
    if self.inputFieldMobilePhoneNumber ~= nil then
        local tAccount = CommonHelper.TrimStr(LobbyLoginSystem.GetInstance().loginVo:GetSaveAccount())
        if tAccount ~= nil then
            self.inputFieldMobilePhoneNumber.text = tAccount
        else
            self.inputFieldMobilePhoneNumber.text = nil
        end 
	end

    if self.inputFieldPassword ~= nil then
        local pwd = CommonHelper.TrimStr(LobbyLoginSystem.GetInstance().loginVo:GetSavePassword())
        if pwd ~= nil then
            self.inputFieldPassword.text = pwd
        else
            self.inputFieldPassword.text = nil
        end
	end
end

function LobbyAccountLoginView:ConfirmOnPointerClick(eventData)    
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    local account =  CommonHelper.TrimStr(self.inputFieldMobilePhoneNumber.text)
    local password = CommonHelper.TrimStr(self.inputFieldPassword.text)

    if account == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_Account)
        return
    end

    if password == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_Password)
        return
    end

    if self.isGouXuan == false then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Need_Agree_Game_Serviece_Protocol)
        return
    end

    LobbyLoginSystem.GetInstance().loginVo:SetAccountAndPassword(account,password)
    LobbyLoginSystem.GetInstance():RequestAccountLoginMsg()
end

function LobbyAccountLoginView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyAccountLoginView:GouXuanOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self.isGouXuan = not self.isGouXuan
    CommonHelper.SetActive(self.gouXuan_GameObject,self.isGouXuan)
end

function LobbyAccountLoginView:ForgetPasswordOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyLoginSystem.GetInstance().resetPasswordVerificationMobilePhoneView:OpenForm()
end

function LobbyAccountLoginView:RegisterOnPointerClick(  )
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyLoginSystem.GetInstance().registerVerificationMobilePhoneView:OpenForm()
end

function LobbyAccountLoginView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyAccountLoginView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end

	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    
    
    self.inputFieldMobilePhoneNumber = nil
	self.inputFieldPassword = nil 

	if self.closeEventScirpt ~= nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.closeEventScirpt = nil
	
	if self.confirmEventScirpt ~= nil then
        self.confirmEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.confirmEventScirpt = nil

	if self.gouXuanEventScript ~= nil then
        self.gouXuanEventScript.onMiniPointerClickCallBack = nil
    end
    self.gouXuanEventScript = nil
    self.gouXuan_GameObject = nil
    
    
    if self.forgetPasswordEventScript ~= nil then
        self.forgetPasswordEventScript.onMiniPointerClickCallBack = nil
    end
    self.forgetPasswordEventScript = nil
    
    if self.registerEventScript ~= nil then
        self.registerEventScript.onMiniPointerClickCallBack = nil
    end
	self.registerEventScript = nil
end

function LobbyAccountLoginView:__delete( )
    self:RemoveUIComponent()
end

