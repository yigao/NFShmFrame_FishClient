LobbyBankChangePasswordPanel = Class()

function LobbyBankChangePasswordPanel:ctor()
    self:Init()
end

function LobbyBankChangePasswordPanel:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyBankChangePasswordPanel:InitData(  )
    self.oldPsd = nil
    self.newPsd = nil
    self.confirmNewPsd = nil
end

function LobbyBankChangePasswordPanel:InitView(  )
    self.panelTransform = nil
    self.panelGameObject = nil
end

function LobbyBankChangePasswordPanel:ReInit(  )
    self.oldPsd = nil
    self.newPsd = nil
    self.confirmNewPsd = nil
end

function LobbyBankChangePasswordPanel:OpenUIPanel(go)
    self:ReInit()
    self:GetUIComponent(go)

    self:ShowUIComponent()
end

function LobbyBankChangePasswordPanel:RefreshUIPanel(  )
    self:ReInit()
    self:ShowUIComponent()
end

function LobbyBankChangePasswordPanel:GetUIComponent(go)
    if self.panelGameObject~=nil and self.panelGameObject~=go then
        self:RemoveUIComponent()
    end

    if self.panelGameObject == nil then
        self.panelGameObject = go
    end

    if self.panelTransform == nil then
        self.panelTransform = self.panelGameObject.transform
    end

    if self.game_money_text == nil then
        self.game_money_text = self.panelTransform:Find("MoneyInfo/CurrentMoney/game_money"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.bank_money_text == nil then
        self.bank_money_text = self.panelTransform:Find("MoneyInfo/BankMoney/bank_money"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end


    if self.old_password_inputField == nil then
        self.old_password_inputField =  self.panelTransform:Find("OldPassword/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    end

    if self.new_password_inputField == nil then
        self.new_password_inputField =  self.panelTransform:Find("NewPassword/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    end

    if self.confirm_newPassword_inputField == nil then
        self.confirm_newPassword_inputField =  self.panelTransform:Find("ConfirmNewPassword/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    end

    if self.modifyEventScript == nil then
        local go = self.panelTransform:Find("modify_Btn").gameObject
        self.modifyEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.modifyEventScript == nil then 
            self.modifyEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.modifyEventScript ~= nil and self.modifyEventScript.onMiniPointerClickCallBack == nil then
        self.modifyEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ModifyOnPointerClick(pointerEventData) end
    end
end


function LobbyBankChangePasswordPanel:ShowUIComponent()
    self.game_money_text.text = LobbyBankSystem.GetInstance().bankVo.gameMoney
    self.bank_money_text.text =  LobbyBankSystem.GetInstance().bankVo.bankMoney

    if self.old_password_inputField ~= nil then
        self.old_password_inputField.text = nil
    end

    if self.new_password_inputField ~= nil then
        self.new_password_inputField.text = nil
    end

    if self.confirm_newPassword_inputField ~= nil then
        self.confirm_newPassword_inputField.text = nil
    end
end

function LobbyBankChangePasswordPanel:OldPasswordInputFieldResult(str)
    self.oldPsd = str
end

function LobbyBankChangePasswordPanel:NewPasswordInputFieldResult(str)
    self.newPsd = str     
end

function LobbyBankChangePasswordPanel:ConfirmNewPasswordInputFieldResult(str)
    self.confirmNewPsd = str 
end

function LobbyBankChangePasswordPanel:ModifyOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    local oldPsd = CommonHelper.TrimStr(self.old_password_inputField.text)
    local newPsd = CommonHelper.TrimStr(self.new_password_inputField.text)
    local confirmNewPsd =CommonHelper.TrimStr(self.confirm_newPassword_inputField.text)

    if oldPsd == "" or newPsd == "" or confirmNewPsd  == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_Password)
        return
    end
    
    if string.len(oldPsd)< 6 or string.len(oldPsd)>10 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Psd_Lenght_Error)
        return
    end

    if string.len(newPsd)< 6 or string.len(newPsd)>10 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Psd_Lenght_Error)
        return
    end

    if string.len(confirmNewPsd)< 6 or string.len(confirmNewPsd)>10 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Psd_Lenght_Error)
        return
    end

    if newPsd~= confirmNewPsd then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Enter_Password_Inconsistent)
        return
    end

    LobbyBankSystem.GetInstance():RequestChangeBankPsdMsg(self.oldPsd,self.newPsd)
end


function LobbyBankChangePasswordPanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
    self.game_money_text = nil
    self.bank_money_text = nil

    self.old_password_inputField = nil
    self.new_password_inputField = nil
    self.confirm_newPassword_inputField = nil
  
    if self.modifyEventScript ~= nil then
        self.modifyEventScript.onMiniPointerClickCallBack = nil
    end
    self.modifyEventScript = nil
end

function LobbyBankChangePasswordPanel:__delete()
    self:RemoveUIComponent()
end