LobbyBankResetPasswordView = Class()

function LobbyBankResetPasswordView:ctor()
    
	self:Init()
    self.ResetPasswordForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyBankForm/LobbyBankResetPasswordForm.prefab"	
end

function LobbyBankResetPasswordView:Init()
	self:InitData()
	self:InitView()
end

function LobbyBankResetPasswordView:InitData()

end

function LobbyBankResetPasswordView:InitView()
	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    
	self.inputFieldNewPwd = nil
    self.inputFieldAgainNewPwd = nil

    self.closeEventScirpt = nil
    self.confirmEventScirpt = nil
end

--初始化ui界面
function LobbyBankResetPasswordView:OpenForm()
    self:GetUIComponent()

    self:ShowUIComponent()
end

function LobbyBankResetPasswordView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.ResetPasswordForm_Path,true)

    if form == nil then
        Debug.LogError("打开银行重置密码窗口失败："..self.ResetPasswordForm_Path)
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

function LobbyBankResetPasswordView:ShowUIComponent()
    if self.inputFieldNewPwd ~= nil then
		self.inputFieldNewPwd.text = nil
	end

	if self.inputFieldAgainNewPwd ~= nil then
		self.inputFieldAgainNewPwd.text = nil
	end
end


function LobbyBankResetPasswordView:ConfirmOnPointerClick(eventData)
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

    if onePassword~= twoPassword then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Enter_Password_Inconsistent)
        return
    end
	LobbyBankSystem.GetInstance():RequestBankResetPasswordMsg(LobbyHallCoreSystem.GetInstance().playerInfoVo.phonenum,onePassword)
end


function LobbyBankResetPasswordView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
	self:CloseForm()
end

function LobbyBankResetPasswordView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyBankResetPasswordView:RemoveUIComponent()
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

function LobbyBankResetPasswordView:__delete( )
    self:RemoveUIComponent()
end

