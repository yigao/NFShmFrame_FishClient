LobbyEnterBankView = Class()

function LobbyEnterBankView:ctor()
    self.Enter_BankForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyBankForm/LobbyEnterBankForm.prefab"	
    self:Init()
end

function LobbyEnterBankView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyEnterBankView:InitData(  )

end

function LobbyEnterBankView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.bank_password_inputField = nil 
    self.forgetPasswordEventScript = nil
    self.closeEventScript = nil
    self.confirmEventScript = nil      
end

function LobbyEnterBankView:ReInit()

end
--初始化ui界面
function LobbyEnterBankView:OpenForm()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
end


function LobbyEnterBankView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.Enter_BankForm_Path,true)

    if form == nil then
        Debug.LogError("打开银行窗口失败："..self.Enter_BankForm_Path)
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

    if self.bank_password_inputField == nil then
        self.bank_password_inputField =  self.formTransform:Find("Animator/InputBankPanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    end

    if self.bank_password_inputField ~= nil then
        self.bank_password_inputField.text = nil
    end

    if self.forgetPasswordEventScript == nil then
        local go = self.formTransform:Find("Animator/InputBankPanel/ForgetPassword_Btn").gameObject
        self.forgetPasswordEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.forgetPasswordEventScript == nil then 
            self.forgetPasswordEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.forgetPasswordEventScript ~= nil and self.forgetPasswordEventScript.onMiniPointerClickCallBack == nil then
        self.forgetPasswordEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ForgetPasswordOnPointerClick(pointerEventData) end
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

    if self.confirmEventScript == nil then
        local go = self.formTransform:Find("Animator/Confirm_Btn").gameObject
        self.confirmEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.confirmEventScript == nil then 
            self.confirmEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.confirmEventScript ~= nil and self.confirmEventScript.onMiniPointerClickCallBack == nil then
        self.confirmEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ConfirmOnPointerClick(pointerEventData) end
    end
end

function LobbyEnterBankView:ShowUIComponent()

end


function LobbyEnterBankView:RefresgUIComponent( ... )
    
end

function LobbyEnterBankView:ForgetPasswordOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    local phoneNum = tostring(LobbyHallCoreSystem.GetInstance().playerInfoVo.phonenum)
    if string.len(phoneNum) == 11 then
        LobbyBankSystem.GetInstance().bankVerifyPhoneView:OpenForm()
    else
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Bing_Phone_Modify_Bank_Pwd)
    end
end


function LobbyEnterBankView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyEnterBankView:ConfirmOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    local psd = CommonHelper.TrimStr(self.bank_password_inputField.text)
    LobbyBankSystem.GetInstance():RequestEnterBankMsg(psd)
end


function LobbyEnterBankView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyEnterBankView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.bank_password_inputField = nil

    if self.forgetPasswordEventScript ~= nil then
        self.forgetPasswordEventScript.onMiniPointerClickCallBack = nil 
    end
    self.forgetPasswordEventScript = nil

    if self.closeEventScript ~= nil then
        self.closeEventScript.onMiniPointerClickCallBack = nil 
    end
    self.closeEventScript = nil

    if self.confirmEventScript ~= nil then
        self.confirmEventScript.onMiniPointerClickCallBack = nil 
    end
    self.confirmEventScript = nil

    
end

function LobbyEnterBankView:__delete( )
    self:RemoveUIComponent()
end

