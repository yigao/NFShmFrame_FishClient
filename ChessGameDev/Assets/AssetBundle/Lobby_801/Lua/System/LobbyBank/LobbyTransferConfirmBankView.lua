LobbyTransferConfirmBankView = Class()

function LobbyTransferConfirmBankView:ctor()
    self.TransferConfirm_BankForm_Path =  CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyBankForm/LobbyTransferConfirmBankForm.prefab"	
    self:Init()
end

function LobbyTransferConfirmBankView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyTransferConfirmBankView:InitData(  )
    self.transferMoney = 0
    self.receiverInfo = nil
end

function LobbyTransferConfirmBankView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    
    self.transform_money_text = nil
    self.receiver_name_text = nil
    self.receiver_id_text = nil
    self.giver_name_text = nil
    self.giver_id_text = nil

    if self.closeEventScript ~= nil then
        self.closeEventScript.onMiniPointerClickCallBack = nil
    end
    self.closeEventScript = nil
    
    if self.confirmEventScript ~= nil then
        self.confirmEventScript.onPointerClickCallBack = nil
    end
    self.confirmEventScript = nil
end

function LobbyTransferConfirmBankView:ReInit(money,receiverInfo)
    self.transferMoney = money
    self.receiverInfo = receiverInfo
end
--初始化ui界面
function LobbyTransferConfirmBankView:OpenForm(money,data)
    self:ReInit(money,data)
    self:GetUIComponent()
    self:ShowUIComponent()
end


function LobbyTransferConfirmBankView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.TransferConfirm_BankForm_Path,true)

    if form == nil then
        Debug.LogError("打开转账确认窗口失败："..self.TransferConfirm_BankForm_Path)
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

    if self.transform_money_text == nil then
        self.transform_money_text = self.formTransform:Find("Animator/TransferMoneyInfo/money_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.receiver_name_text == nil then
        self.receiver_name_text = self.formTransform:Find("Animator/ReceiverInfo/name_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end
    if self.receiver_id_text == nil then
        self.receiver_id_text = self.formTransform:Find("Animator/ReceiverInfo/user_id_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.giver_name_text == nil then
        self.giver_name_text = self.formTransform:Find("Animator/GiverInfo/name_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end
    if self.giver_id_text == nil then
        self.giver_id_text =  self.formTransform:Find("Animator/GiverInfo/user_id_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
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

function LobbyTransferConfirmBankView:ShowUIComponent()
    self.transform_money_text.text = self.transferMoney

    self.receiver_name_text.text = self.receiverInfo.name
    
    self.receiver_id_text.text = "(ID："..self.receiverInfo.userID..")"
    
    self.giver_name_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.nick_name

    self.giver_id_text.text =  "(ID："..LobbyHallCoreSystem.GetInstance().playerInfoVo.user_id..")"
end


function LobbyTransferConfirmBankView:RefreshUIComponent( ... )
    
end

function LobbyTransferConfirmBankView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyTransferConfirmBankView:ConfirmOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyBankSystem.GetInstance():RequestBankTransferMsg(self.transferMoney,self.receiverInfo.userID)
end


function LobbyTransferConfirmBankView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyTransferConfirmBankView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
end

function LobbyTransferConfirmBankView:__delete( )
    self:RemoveUIComponent()
end

