LobbyResetPasswordVerificationMobilePhoneView = Class()

function LobbyResetPasswordVerificationMobilePhoneView:ctor()
    
	self:Init()
    self.ResetPasswordVerificationMobilePhoneForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyLoginForm/LobbyResetPasswordForm/LobbyResetPasswordVerificationMobilePhoneForm.prefab"	
end

function LobbyResetPasswordVerificationMobilePhoneView:Init()
	self:InitData()
	self:InitView()
end

function LobbyResetPasswordVerificationMobilePhoneView:InitData()
    self.time = 60
    self.timeElapse = 0
    self.isBeginCode = false
    self.updateItemNum = -1
    self.isReceiveCode = false 
end

function LobbyResetPasswordVerificationMobilePhoneView:InitView()
	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil
    
    self.time_text = nil
       
    self.code_btn_text = nil

	self.inputFieldMobilePhoneNumber = nil
	self.inputFieldVerificationCode = nil 

    self.closeEventScirpt = nil
    self.getVerificationCodeEventScript = nil
    self.nextStepEventScirpt = nil
end

function LobbyResetPasswordVerificationMobilePhoneView:ReInit()
    self.timeElapse = self.time
    self.isBeginCode = false
    self.updateItemNum = -1
    self.isReceiveCode = false 
end

--初始化ui界面
function LobbyResetPasswordVerificationMobilePhoneView:OpenForm()
    self:ReInit()

    self:GetUIComponent()

    self:ShowUIComponent()

    if self.updateItemNum == -1 then
        self.updateItemNum = CommonHelper.AddUpdate(self)
    end
end


function LobbyResetPasswordVerificationMobilePhoneView:GetUIComponent()

    local form =  XLuaUIManager.GetInstance():OpenForm(self.ResetPasswordVerificationMobilePhoneForm_Path,true)

    if form == nil then
        Debug.LogError("打开重置密码验证手机号码窗口失败："..self.ResetPasswordVerificationMobilePhoneForm_Path)
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
        self.gameObject = self.formGameObject
    end

	if self.inputFieldMobilePhoneNumber == nil then
		self.inputFieldMobilePhoneNumber = self.formTransform:Find("Animator/InputMobilePhonePanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end

	if self.inputFieldVerificationCode == nil then
		self.inputFieldVerificationCode = self.formTransform:Find("Animator/InputVerificationCodePanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end

    if self.getVerificationCodeEventScript == nil then
        local go = self.formTransform:Find("Animator/InputVerificationCodePanel/GetVerificationCode_Btn").gameObject
        self.getVerificationCodeEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.getVerificationCodeEventScript == nil then 
            self.getVerificationCodeEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.getVerificationCodeEventScript ~= nil and self.getVerificationCodeEventScript.onMiniPointerClickCallBack == nil then
        self.getVerificationCodeEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:GetVerificationCodeOnPointerClick(pointerEventData) end
    end

    if self.time_text == nil then
        self.time_text = self.formTransform:Find("Animator/InputVerificationCodePanel/GetVerificationCode_Btn/Time"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.code_btn_text == nil then
        self.code_btn_text = self.formTransform:Find("Animator/InputVerificationCodePanel/GetVerificationCode_Btn/Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end


    if self.nextStepEventScirpt == nil then 
        local go = self.formTransform:Find("Animator/NextStep_Btn").gameObject
        self.nextStepEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.nextStepEventScirpt == nil then
            self.nextStepEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.nextStepEventScirpt ~= nil and self.nextStepEventScirpt.onMiniPointerClickCallBack == nil then
        self.nextStepEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:NextStepOnPointerClick(pointerEventData) end
    end

    if self.closeEventScirpt == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScirpt == nil then
            self.closeEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.closeEventScirpt ~= nil and self.closeEventScirpt.onMiniPointerClickCallBack == nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end
end

function LobbyResetPasswordVerificationMobilePhoneView:ShowUIComponent()
    if self.inputFieldMobilePhoneNumber ~= nil then
        local tAccount = CommonHelper.TrimStr(CommonHelper.TrimStr(LobbyLoginSystem.GetInstance().loginVo:GetSaveAccount()))
        if tAccount ~= nil then
            self.inputFieldMobilePhoneNumber.text = tAccount
        else
            self.inputFieldMobilePhoneNumber.text = nil
        end
    end

    if self.inputFieldVerificationCode ~= nil then
        self.inputFieldVerificationCode.text = nil
    end

    self:ShowVerificationCodeCountdown(false)
end

function LobbyResetPasswordVerificationMobilePhoneView:Update()
    if self.isBeginCode == true then
        self.timeElapse = self.timeElapse - CSScript.Time.deltaTime
        self.time_text.text = math.ceil(self.timeElapse).." (S)"
        if self.timeElapse <= 0 then
            self.isBeginCode = false
            self:ShowVerificationCodeCountdown(false)
        end
    end
end

function LobbyResetPasswordVerificationMobilePhoneView:ShowVerificationCodeCountdown(isDispaly)
    if self.time_text then
        CommonHelper.SetActive(self.time_text.gameObject,isDispaly)
    end

    if self.code_btn_text then
        CommonHelper.SetActive(self.code_btn_text.gameObject,(not isDispaly))
    end
end

function LobbyResetPasswordVerificationMobilePhoneView:IsReceiveVerificationCode(isReceiveCode)
    self.isReceiveCode = isReceiveCode
end


function LobbyResetPasswordVerificationMobilePhoneView:GetVerificationCodeOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if self.isBeginCode == false then
        local phoneNumber =CommonHelper.TrimStr(self.inputFieldMobilePhoneNumber.text)
        local len = string.len(phoneNumber)
        if phoneNumber == "" then
            XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_PhoneNumber)
            return
        elseif len ~= 11 then
            XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Phone_Number_Format_Error)
            return
        end        
        self.isBeginCode = true
        self.timeElapse = self.time
        self:ShowVerificationCodeCountdown(true)
        LobbyLoginSystem.GetInstance():RequestPhoneAutoCodeMsg(phoneNumber,HallLuaDefine.PhoneCodeType.Change_Login_Password_Code)
    else
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Operate_Frequently) 
    end
end

function LobbyResetPasswordVerificationMobilePhoneView:NextStepOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    local phoneNumber =CommonHelper.TrimStr(self.inputFieldMobilePhoneNumber.text)
    local verificationCode = CommonHelper.TrimStr(self.inputFieldVerificationCode.text)
    local len = string.len(phoneNumber)
    if phoneNumber == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_PhoneNumber)
        return
    elseif len ~= 11 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Phone_Number_Format_Error)
        return
    end

    if self.isReceiveCode == false then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Get_Verification_Code_First)
        return
    end
    
    if verificationCode == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_Verification_Code)
        return
    end
    
    LobbyLoginSystem.GetInstance().loginVo:SetAccount(phoneNumber)
    LobbyLoginSystem.GetInstance():RequestCheckPhoneCodeMsg(phoneNumber,verificationCode)
end

function LobbyResetPasswordVerificationMobilePhoneView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyResetPasswordVerificationMobilePhoneView:CloseForm()
    if self.updateItemNum ~= -1 then
        CommonHelper.RemoveUpdate(self.updateItemNum)
    end

    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyResetPasswordVerificationMobilePhoneView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end

	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil

    self.time_text = nil
       
    self.code_btn_text = nil

	self.inputFieldMobilePhoneNumber = nil
	self.inputFieldPassword = nil 

	if self.getVerificationCodeEventScript ~= nil then
        self.getVerificationCodeEventScript.onMiniPointerClickCallBack = nil
    end
    self.getVerificationCodeEventScript = nil

	if self.nextStepEventScirpt ~= nil then
        self.nextStepEventScirpt.onMiniPointerClickCallBack = nil
    end
    self.nextStepEventScirpt = nil
    
    if self.closeEventScirpt ~= nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = nil
    end
    self.closeEventScirpt = nil
end

function LobbyResetPasswordVerificationMobilePhoneView:__delete( )
    self:RemoveUIComponent()
end

