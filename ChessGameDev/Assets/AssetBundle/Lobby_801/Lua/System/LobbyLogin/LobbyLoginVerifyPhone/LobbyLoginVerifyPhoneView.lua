LobbyLoginVerifyPhoneView = Class()

function LobbyLoginVerifyPhoneView:ctor()
    
	self:Init()
    self.LoginVerifyPhoneForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyLoginForm/LobbyLoginVerifyPhoneForm/LobbyLoginVerifyPhoneForm.prefab"	
end

function LobbyLoginVerifyPhoneView:Init()
	self:InitData()
	self:InitView()
end

function LobbyLoginVerifyPhoneView:InitData()
    self.phoneNumber = nil
    self.time = 60
    self.timeElapse = 0
    self.isBeginCode = false
    self.updateItemNum = -1
    self.isReceiveCode = false 
end

function LobbyLoginVerifyPhoneView:InitView()
	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
	self.gameObject = nil

    self.time_text = nil
    self.code_btn_text = nil

	self.phoneNumber_text = nil
	self.inputFieldVerificationCode = nil 

    self.closeEventScirpt = nil
    self.getVerificationCodeEventScript = nil
    self.confirmEventScirpt = nil
    
end

function LobbyLoginVerifyPhoneView:ReInit()
    self.timeElapse = self.time
    self.isBeginCode = false
    self.updateItemNum = -1
    self.isReceiveCode = false 
    self.phoneNumber = nil
end


--初始化ui界面
function LobbyLoginVerifyPhoneView:OpenForm(phoneNumber)
    self:ReInit()
    self.phoneNumber = phoneNumber

    self:GetUIComponent()

    self:ShowUIComponent()

    if self.updateItemNum == -1 then
        self.updateItemNum = CommonHelper.AddUpdate(self)
    end
end


function LobbyLoginVerifyPhoneView:GetUIComponent()

    local form = CSScript.UIManager:OpenForm(self.LoginVerifyPhoneForm_Path,true)

    if form == nil then
        Debug.LogError("打开验证手机号码登录窗口失败："..self.LoginVerifyPhoneForm_Path)
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

	if self.phoneNumber_text == nil then
		self.phoneNumber_text = self.formTransform:Find("Animator/PhoneNumberPanel/Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
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


    if self.confirmEventScirpt == nil then 
        local go = self.formTransform:Find("Animator/Confirm_Btn").gameObject
        self.confirmEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.confirmEventScirpt == nil then
            self.confirmEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    
    if self.confirmEventScirpt ~= nil and self.confirmEventScirpt.onMiniPointerClickCallBack == nil then
        self.confirmEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:ConfirmOnPointerClick(pointerEventData) end
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


function LobbyLoginVerifyPhoneView:ShowUIComponent()
    self.phoneNumber_text.text = self.phoneNumber
end

function LobbyLoginVerifyPhoneView:Update()
    if self.isBeginCode == true then
        self.timeElapse = self.timeElapse - CSScript.Time.deltaTime
        self.time_text.text = math.ceil(self.timeElapse).." (S)"
        if self.timeElapse <= 0 then
            self.isBeginCode = false
            self:ShowVerificationCodeCountdown(false)
        end
    end
end


function LobbyLoginVerifyPhoneView:GetVerificationCodeOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if self.isBeginCode == false then
        local phoneNumber = CommonHelper.TrimStr(self.phoneNumber)
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
        LobbyLoginSystem.GetInstance():RequestPhoneAutoCodeMsg(self.phoneNumber,HallLuaDefine.PhoneCodeType.Change_Device_Code)
    else
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Operate_Frequently) 
    end
end

function LobbyLoginVerifyPhoneView:ShowVerificationCodeCountdown(isDispaly)
    if self.time_text then
        CommonHelper.SetActive(self.time_text.gameObject,isDispaly)
    end

    if self.code_btn_text then
        CommonHelper.SetActive(self.code_btn_text.gameObject,(not isDispaly))
    end
end


function LobbyLoginVerifyPhoneView:IsReceiveVerificationCode(isReceiveCode)
    self.isReceiveCode = isReceiveCode
end


function LobbyLoginVerifyPhoneView:ConfirmOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    local verificationCode = CommonHelper.TrimStr(self.inputFieldVerificationCode.text)
    if self.isReceiveCode == false then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Get_Verification_Code_First)
        return
    end
    
    if verificationCode == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_Verification_Code)
        return
    end
    LobbyLoginSystem.GetInstance():RequestCheckPhoneCodeMsg(self.phoneNumber,verificationCode)
end

function LobbyLoginVerifyPhoneView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end


function LobbyLoginVerifyPhoneView:BeginLoginGame()
    

end

function LobbyLoginVerifyPhoneView:CloseForm()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
end

function LobbyLoginVerifyPhoneView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil

    self.phoneNumber_text = nil
	self.inputFieldVerificationCode = nil 

    self.time_text = nil
    self.code_btn_text = nil

	if self.getVerificationCodeEventScript ~= nil then
        self.getVerificationCodeEventScript.onMiniPointerClickCallBack = nil
    end
	self.getVerificationCodeEventScript = nil
	
	if self.confirmEventScirpt ~= nil then
        self.confirmEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.confirmEventScirpt = nil

	if self.closeEventScirpt ~= nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.closeEventScirpt = nil
end

function LobbyLoginVerifyPhoneView:__delete( )
    self:RemoveUIComponent()
end

