LobbyBindMobilePhoneView = Class()

function LobbyBindMobilePhoneView:ctor()
	self:Init()
    self.LobbyBindMobilePhoneForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyBindMobilePhoneForm/LobbyBindMobilePhoneForm.prefab"	
end

function LobbyBindMobilePhoneView:Init()
	self:InitData()
	self:InitView()
end

function LobbyBindMobilePhoneView:InitData()
    self.time = 60
    self.timeElapse = 0
    self.isBeginCode = false
    self.updateItemNum = -1
    self.isReceiveCode = false
    self.bindDatas = {}
end

function LobbyBindMobilePhoneView:InitView()
	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
	self.gameObject = nil

	self.inputFieldNickname = nil
    self.inputFieldPassword = nil 
    self.inputAgainPassword = nil 

    self.randNickNameEventScirpt = nil
    self.closeEventScirpt = nil
    self.confirmEventScirpt = nil
end

function LobbyBindMobilePhoneView:ReInit()
    self.timeElapse = self.time
    self.isBeginCode = false
    self.updateItemNum = -1
    self.isReceiveCode = false
    self.bindDatas = {}
end

--初始化ui界面
function LobbyBindMobilePhoneView:OpenForm()
    self:ReInit()

    self:GetUIComponent()

    self:ShowUIComponent()

    if self.updateItemNum == -1 then
        self.updateItemNum = CommonHelper.AddUpdate(self)
    end
end


function LobbyBindMobilePhoneView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.LobbyBindMobilePhoneForm_Path,true)

    if form == nil then
        Debug.LogError("打开绑定手机号码窗口失败："..self.LobbyBindMobilePhoneForm_Path)
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

    if self.inputFieldNickname == nil then
		self.inputFieldNickname = self.formTransform:Find("Animator/InputNicknamePanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end

	if self.inputFieldPassword == nil then
		self.inputFieldPassword = self.formTransform:Find("Animator/InputPasswordPanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
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

    if self.randNickNameEventScirpt == nil then
        local go = self.formTransform:Find("Animator/InputNicknamePanel/GetNickName_Btn").gameObject
        self.randNickNameEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.randNickNameEventScirpt == nil then
            self.randNickNameEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.randNickNameEventScirpt ~= nil and self.randNickNameEventScirpt.onMiniPointerClickCallBack == nil then
        self.randNickNameEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:RandNickNamePointerClick(pointerEventData) end
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
end

function LobbyBindMobilePhoneView:ShowUIComponent()
    if self.inputFieldNickname ~= nil then
        self.inputFieldNickname.text = nil
    end

    if self.inputFieldPassword ~= nil then
		self.inputFieldPassword.text = nil
	end

    if self.inputAgainPassword ~= nil then
		self.inputAgainPassword.text = nil
	end
end

function LobbyBindMobilePhoneView:Update()
    if self.isBeginCode == true then
        self.timeElapse = self.timeElapse - CSScript.Time.deltaTime
        self.time_text.text = math.ceil(self.timeElapse).." (S)"
        if self.timeElapse <= 0 then
            self.isBeginCode = false
            self:ShowVerificationCodeCountdown(false)
        end
    end
end

function LobbyBindMobilePhoneView:ShowVerificationCodeCountdown(isDispaly)
    if self.time_text then
        CommonHelper.SetActive(self.time_text.gameObject,isDispaly)
    end

    if self.code_btn_text then
        CommonHelper.SetActive(self.code_btn_text.gameObject,(not isDispaly))
    end
end

function LobbyBindMobilePhoneView:GetVerificationCodeOnPointerClick(eventData)
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
        LobbyHallCoreSystem.GetInstance():RequestPlayerPhoneAutoCodeMsg(phoneNumber,HallLuaDefine.PhoneCodeType.Bind_Phone_Code)
    else
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Operate_Frequently) 
    end    
end

function LobbyBindMobilePhoneView:IsReceiveVerificationCode(isReceiveCode)
    self.isReceiveCode = isReceiveCode
end

function LobbyBindMobilePhoneView:RandNickNamePointerClick()
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    local nickName =HallLuaDefine.Game_Nickame_Str[math.random(1,#HallLuaDefine.Game_Nickame_Str)]
    self.inputFieldNickname.text = nickName
end

function LobbyBindMobilePhoneView:CloseOnPointerClick(eventData)
	self:CloseForm()
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
end

function LobbyBindMobilePhoneView:ConfirmOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    local onePassword = CommonHelper.TrimStr(self.inputFieldPassword.text)
   
    local nickName = CommonHelper.TrimStr(self.inputFieldNickname.text)

    local phoneNumber =CommonHelper.TrimStr(self.inputFieldMobilePhoneNumber.text)
    local len = string.len(phoneNumber)
    local verificationCode = CommonHelper.TrimStr(self.inputFieldVerificationCode.text)
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

    if nickName == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Nickname)
        return
    end

    if onePassword == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_Password)
        return
    end
    
    
    if string.len(onePassword)< 6 or string.len(onePassword)>10 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Psd_Lenght_Error)
        return
    end


    self.bindDatas = {}
    self.bindDatas.phone_num = phoneNumber
    self.bindDatas.nick_name = nickName
    self.bindDatas.password = onePassword
    self.bindDatas.device_id = CS.GlobalConfigManager.instance:GetDeviceUniqueIdentifier()

    LobbyHallCoreSystem.GetInstance():RequestPlayerCheckPhoneCodeMsg(phoneNumber,verificationCode)
end


function LobbyBindMobilePhoneView:SendBindPhoneMsg()
    LobbyHallCoreSystem.GetInstance():RequestBindPhoneMsg(self.bindDatas)
end

function LobbyBindMobilePhoneView:CloseForm()
    if self.updateItemNum ~= -1 then
        CommonHelper.RemoveUpdate(self.updateItemNum)
    end
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyBindMobilePhoneView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end

	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil
    
    self.inputFieldNickname = nil
    self.inputFieldPassword = nil 
    self.inputAgainPassword = nil 

	if self.randNickNameEventScirpt ~= nil then
        self.randNickNameEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.randNickNameEventScirpt = nil

	if self.closeEventScirpt ~= nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.closeEventScirpt = nil
	
	if self.confirmEventScirpt ~= nil then
        self.confirmEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.confirmEventScirpt = nil
end

function LobbyBindMobilePhoneView:__delete( )
    self:RemoveUIComponent()
end

