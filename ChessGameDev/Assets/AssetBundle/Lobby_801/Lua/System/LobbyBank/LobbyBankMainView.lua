LobbyBankMainView = Class()

function LobbyBankMainView:ctor()
    self.BankForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyBankForm/LobbyBankForm.prefab"	
    self:Init()
end

function LobbyBankMainView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyBankMainView:InitData(  )
    self.currentSelectIndex = 1
end

function LobbyBankMainView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.btns_bg_list = nil

    self.btns_text_list = nil

    self.function_module_list = nil

    self.depositEventScript = nil 
    self.withdrawalEventScript = nil      
    self.transferEventScript = nil
    self.giftRecordEventScript = nil
    self.changePasswordEventScript = nil
    self.closeEventScript = nil

end

function LobbyBankMainView:ReInit()
    self.currentSelectIndex = 1
end
--初始化ui界面
function LobbyBankMainView:OpenForm()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
end


function LobbyBankMainView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.BankForm_Path,true)

    if form == nil then
        Debug.LogError("打开银行窗口失败："..self.BankForm_Path)
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

    if self.function_module_list == nil then
        self.function_module_list = {}
        local depositFunction_gameObject = self.formTransform:Find("Animator/FunctionPanel/DepositFunctionPanel").gameObject
        local withdrawalFunction_gameObject = self.formTransform:Find("Animator/FunctionPanel/WithdrawalFunctionPanel").gameObject
        local transferFunction_gameObject = self.formTransform:Find("Animator/FunctionPanel/TransferFunctionPanel").gameObject
        local giftRecordFunction_gameObject = self.formTransform:Find("Animator/FunctionPanel/GiftRecordFunctionPanel").gameObject
        local changePasswordFunction_gameObject = self.formTransform:Find("Animator/FunctionPanel/ChangePasswordFunctionPanel").gameObject
        table.insert(self.function_module_list,depositFunction_gameObject)
        table.insert(self.function_module_list,withdrawalFunction_gameObject)
        table.insert(self.function_module_list,transferFunction_gameObject)
        table.insert(self.function_module_list,giftRecordFunction_gameObject)
        table.insert(self.function_module_list,changePasswordFunction_gameObject)
    end

    if self.btns_bg_list == nil then
        self.btns_bg_list = {}
        local deposit_btn_bg_gameObject = self.formTransform:Find("Animator/BtnList/deposit_btn/bg").gameObject
        local withdrawal_btn_bg_gameObject = self.formTransform:Find("Animator/BtnList/withdrawal_btn/bg").gameObject
        local transfer_btn_bg_gameObject = self.formTransform:Find("Animator/BtnList/transfer_btn/bg").gameObject
        local giftRecord_btn_bg_gameObject = self.formTransform:Find("Animator/BtnList/giftRecord_btn/bg").gameObject
        local changePassword_btn_bg_gameObject = self.formTransform:Find("Animator/BtnList/changePassword_btn/bg").gameObject
        table.insert(self.btns_bg_list,deposit_btn_bg_gameObject)
        table.insert(self.btns_bg_list,withdrawal_btn_bg_gameObject)
        table.insert(self.btns_bg_list,transfer_btn_bg_gameObject)
        table.insert(self.btns_bg_list,giftRecord_btn_bg_gameObject)
        table.insert(self.btns_bg_list,changePassword_btn_bg_gameObject)
    end


    if self.btns_text_list == nil then
        self.btns_text_list = {}
        local deposit_btn_text = self.formTransform:Find("Animator/BtnList/deposit_btn/text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        local withdrawal_btn_text = self.formTransform:Find("Animator/BtnList/withdrawal_btn/text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        local transfer_btn_text = self.formTransform:Find("Animator/BtnList/transfer_btn/text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        local giftRecord_btn_text = self.formTransform:Find("Animator/BtnList/giftRecord_btn/text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        local changePassword_btn_text = self.formTransform:Find("Animator/BtnList/changePassword_btn/text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        table.insert(self.btns_text_list,deposit_btn_text)
        table.insert(self.btns_text_list,withdrawal_btn_text)
        table.insert(self.btns_text_list,transfer_btn_text)
        table.insert(self.btns_text_list,giftRecord_btn_text)
        table.insert(self.btns_text_list,changePassword_btn_text)
    end

    if self.depositEventScript == nil then 
        local go = self.formTransform:Find("Animator/BtnList/deposit_btn").gameObject
        self.depositEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.depositEventScript == nil then
            self.depositEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.depositEventScript ~= nil and self.depositEventScript.onMiniPointerClickCallBack == nil then
        self.depositEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:DepositOnPointerClick(pointerEventData) end
    end

    if self.withdrawalEventScript == nil then
        local go = self.formTransform:Find("Animator/BtnList/withdrawal_btn").gameObject
        self.withdrawalEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.withdrawalEventScript == nil then
            self.withdrawalEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        
    end
    if self.withdrawalEventScript ~= nil and self.withdrawalEventScript.onMiniPointerClickCallBack == nil then
        self.withdrawalEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:WithdrawalOnPointerClick(pointerEventData) end
    end

    if self.transferEventScript == nil then
        local go = self.formTransform:Find("Animator/BtnList/transfer_btn").gameObject
        self.transferEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.transferEventScript == nil then
            self.transferEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.transferEventScript ~= nil and self.transferEventScript.onMiniPointerClickCallBack == nil then
        self.transferEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:TransferOnPointerClick(pointerEventData) end
    end

    if self.giftRecordEventScript == nil then
        local go = self.formTransform:Find("Animator/BtnList/giftRecord_btn").gameObject
        self.giftRecordEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.giftRecordEventScript == nil then
            self.giftRecordEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.giftRecordEventScript ~= nil and self.giftRecordEventScript.onMiniPointerClickCallBack == nil then
        self.giftRecordEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:GiftRecordOnPointerClick(pointerEventData) end
    end

    if self.changePasswordEventScript == nil then
        local go = self.formTransform:Find("Animator/BtnList/changePassword_btn").gameObject
        self.changePasswordEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.changePasswordEventScript == nil then
            self.changePasswordEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.changePasswordEventScript ~= nil and self.changePasswordEventScript.onMiniPointerClickCallBack == nil then
        self.changePasswordEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ChangePasswordOnPointerClick(pointerEventData) end
    end
end

function LobbyBankMainView:ShowUIComponent()
    --self:IsDisplayFunctionPanle( self.currentSelectIndex)
    self:BankFirstUIPanel()
end


function LobbyBankMainView:RefresgUIComponent( ... )
    
end

function LobbyBankMainView:IsDisplayFunctionPanle(index)
    for i = 1,#self.btns_bg_list do
        if i == index then
            CommonHelper.SetActive(self.btns_bg_list[i],true)
        else
            CommonHelper.SetActive(self.btns_bg_list[i],false)
        end
    end

    for i = 1,#self.btns_text_list do
        if i == index then
            self.btns_text_list[i].color = CS.UnityEngine.Color(1,1,1,1)
        else
            self.btns_text_list[i].color = CS.UnityEngine.Color(0.72,0.68,0.91,1)
        end
    end

    for i = 1,#self.function_module_list do
        if i == index then
            CommonHelper.SetActive(self.function_module_list[i],true)
        else
            CommonHelper.SetActive(self.function_module_list[i],false)
        end
    end
end


function LobbyBankMainView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyBankMainView:DepositOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self:BankFirstUIPanel()
    -- if LobbyBankSystem.GetInstance().bankDepositPanel then
    --     self.currentSelectIndex = 1
    --     self:IsDisplayFunctionPanle( self.currentSelectIndex)
    --     LobbyBankSystem.GetInstance().bankDepositPanel:OpenUIPanel(self.function_module_list[self.currentSelectIndex])
    -- end
end

function LobbyBankMainView:BankFirstUIPanel()
    if LobbyBankSystem.GetInstance().bankDepositPanel then
        self.currentSelectIndex = 1
        self:IsDisplayFunctionPanle( self.currentSelectIndex)
        LobbyBankSystem.GetInstance().bankDepositPanel:OpenUIPanel(self.function_module_list[self.currentSelectIndex])
    end
end

function LobbyBankMainView:WithdrawalOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if LobbyBankSystem.GetInstance().bankWithdrawalPanel then
        self.currentSelectIndex = 2
        self:IsDisplayFunctionPanle( self.currentSelectIndex)
        LobbyBankSystem.GetInstance().bankWithdrawalPanel:OpenUIPanel(self.function_module_list[self.currentSelectIndex])
    end
end

function LobbyBankMainView:TransferOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if LobbyBankSystem.GetInstance().bankTransferPanel then 
        self.currentSelectIndex = 3
        self:IsDisplayFunctionPanle( self.currentSelectIndex)
        LobbyBankSystem.GetInstance().bankTransferPanel:OpenUIPanel(self.function_module_list[self.currentSelectIndex])
    end
end

function LobbyBankMainView:GiftRecordOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if LobbyBankSystem.GetInstance().bankGiftRecordPanel then 
        self.currentSelectIndex = 4
        self:IsDisplayFunctionPanle( self.currentSelectIndex)
        LobbyBankSystem.GetInstance().bankGiftRecordPanel:OpenUIPanel(self.function_module_list[self.currentSelectIndex])
    end
end

function LobbyBankMainView:ChangePasswordOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if LobbyBankSystem.GetInstance().bankChangePasswordPanel then 
        self.currentSelectIndex = 5
        self:IsDisplayFunctionPanle( self.currentSelectIndex)
        LobbyBankSystem.GetInstance().bankChangePasswordPanel:OpenUIPanel(self.function_module_list[self.currentSelectIndex])
    end
end

function LobbyBankMainView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyBankMainView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.btns_bg_list = nil

    self.btns_text_list = nil

    self.function_module_list = nil

    if self.depositEventScript ~= nil then
        self.depositEventScript.onPointerClickCallBack = nil
    end
    self.depositEventScript = nil

    if self.withdrawalEventScript ~= nil then
        self.withdrawalEventScript.onPointerClickCallBack = nil
    end
    self.withdrawalEventScript = nil

    if self.transferEventScript ~= nil then
        self.transferEventScript.onPointerClickCallBack = nil 
    end
    self.transferEventScript = nil

    if self.giftRecordEventScript ~= nil then
        self.giftRecordEventScript.onPointerClickCallBack = nil 
    end
    self.giftRecordEventScript = nil

    if self.changePasswordEventScript ~= nil then
        self.changePasswordEventScript.onPointerClickCallBack = nil 
    end
    self.changePasswordEventScript = nil

    if self.closeEventScript ~= nil then
        self.closeEventScript.onPointerClickCallBack = nil 
    end
    self.closeEventScript = nil
end

function LobbyBankMainView:__delete( )
    self:RemoveUIComponent()
end

