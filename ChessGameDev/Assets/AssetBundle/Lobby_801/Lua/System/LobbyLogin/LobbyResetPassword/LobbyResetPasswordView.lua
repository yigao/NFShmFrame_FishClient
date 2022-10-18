LobbyResetPasswordView = Class()

function LobbyResetPasswordView:ctor()
    
	self:Init()
    self.ResetPasswordForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyLoginForm/LobbyResetPasswordForm/LobbyResetPasswordForm.prefab"	
end

function LobbyResetPasswordView:Init()
	self:InitData()
	self:InitView()
end

function LobbyResetPasswordView:InitData()

end

function LobbyResetPasswordView:InitView()
	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    
	self.inputFieldNewPwd = nil
    self.inputFieldAgainNewPwd = nil

    self.closeEventScirpt = nil
    self.confirmEventScirpt = nil
end

--初始化ui界面
function LobbyResetPasswordView:OpenForm()

    self:GetUIComponent()

    self:ShowUIComponent()
end


function LobbyResetPasswordView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.ResetPasswordForm_Path,true)

    if form == nil then
        Debug.LogError("打开重置密码窗口失败："..self.ResetPasswordForm_Path)
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

	if self.inputFieldNewPwd == nil then
		self.inputFieldNewPwd = self.formTransform:Find("Animator/InputNewPwdPanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end

	if self.inputFieldAgainNewPwd == nil then
		self.inputFieldAgainNewPwd = self.formTransform:Find("Animator/InputAgainNewPwdPanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
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

function LobbyResetPasswordView:ShowUIComponent()
    if self.inputFieldNewPwd ~= nil then
		self.inputFieldNewPwd.text = nil
	end

	if self.inputFieldAgainNewPwd ~= nil then
		self.inputFieldAgainNewPwd.text = nil
	end
end


function LobbyResetPasswordView:ConfirmOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    local onePassword = CommonHelper.TrimStr(self.inputFieldNewPwd.text)
    local twoPassword= CommonHelper.TrimStr(self.inputFieldAgainNewPwd.text)
    if onePassword == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_Password)
        return
    end

    if twoPassword == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Again_Input_Password)
        return
    end

    if string.len(onePassword)< 6 or string.len(onePassword)>10 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Psd_Lenght_Error)
        return
    end

    if string.len(twoPassword)< 6 or string.len(twoPassword)>10 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Psd_Lenght_Error)
        return
    end


    if onePassword~= twoPassword then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Enter_Password_Inconsistent)
        return
    end
	LobbyLoginSystem.GetInstance():RequestChangePasswordMsg(onePassword)
end

function LobbyResetPasswordView:PasswordChangeSucceed()
    local onePassword = CommonHelper.TrimStr(self.inputFieldNewPwd.text)
    LobbyLoginSystem.GetInstance().loginVo:SetPassword(onePassword)
end

function LobbyResetPasswordView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
	self:CloseForm()
end

function LobbyResetPasswordView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyResetPasswordView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end

	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    
    self.inputFieldNewPwd = nil
    self.inputFieldAgainNewPwd = nil

	if self.confirmEventScirpt ~= nil then
        self.confirmEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.confirmEventScirpt = nil
	
	if self.closeEventScirpt ~= nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.closeEventScirpt = nil
end

function LobbyResetPasswordView:__delete( )
    self:RemoveUIComponent()
end

