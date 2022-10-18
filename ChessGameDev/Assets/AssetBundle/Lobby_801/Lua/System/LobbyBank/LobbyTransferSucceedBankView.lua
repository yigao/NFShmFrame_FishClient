LobbyTransferSucceedBankView = Class()

function LobbyTransferSucceedBankView:ctor()
    self.TransferConfirm_BankForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyBankForm/LobbyTransferSucceedBankForm.prefab"	
    self:Init()
end

function LobbyTransferSucceedBankView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyTransferSucceedBankView:InitData(  )
    self.transferData = nil
end

function LobbyTransferSucceedBankView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    
    self.transform_money_text = nil
    self.current_money_hanzi_text = nil
    self.receiver_name_text = nil
    self.receiver_id_text = nil
    self.giver_name_text = nil
    self.giver_id_text = nil
    self.data_text = nil

    self.closeEventScript = nil

    self.saveEventScript = nil
end

function LobbyTransferSucceedBankView:ReInit(transferData)
    self.transferData = transferData
end
--初始化ui界面
function LobbyTransferSucceedBankView:OpenForm(data)
    self:ReInit(data)
    self:GetUIComponent()
    self:ShowUIComponent()
end


function LobbyTransferSucceedBankView:GetUIComponent()

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

    if self.current_money_hanzi_text == nil then
        self.current_money_hanzi_text = self.formTransform:Find("Animator/UppercaseChineseNumber/money_chinese_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
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

    if self.data_text == nil then
        self.data_text = self.formTransform:Find("Animator/DataInfo/date_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.closeEventScript == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.closeEventScript == nil then 
            self.closeEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
    end
    if self.closeEventScript ~= nil and  self.closeEventScript.onPointerClickCallBack == nil then
        self.closeEventScript.onPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end

    if self.saveEventScript == nil then
        local go = self.formTransform:Find("Animator/Save_Btn").gameObject
        self.saveEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.saveEventScript == nil then 
            self.saveEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
    end
    if self.saveEventScrip ~= nil and self.saveEventScript.onPointerClickCallBack == nil then
        self.saveEventScript.onPointerClickCallBack = function(pointerEventData) self:SaveOnPointerClick(pointerEventData) end
    end
end

function LobbyTransferSucceedBankView:ShowUIComponent()
    self.transform_money_text.text = self.transferData.give_jetton

    self.current_money_hanzi_text.text = LobbyBankSystem.GetInstance():NumberToString(self.transferData.give_jetton)
    
    self.receiver_name_text.text = self.transferData.give_user_name
    
    self.receiver_id_text.text = "(ID："..self.transferData.give_user_id..")"
    
    self.giver_name_text.text =  self.transferData.user_name 
    
    self.giver_id_text.text =  "(ID："..self.transferData.user_id..")"  

    self.data_text.text = os.date("%Y-%m-%d      %H:%M:%S",self.transferData.create_time) 
end


function LobbyTransferSucceedBankView:RefreshUIComponent( ... )
    
end


function LobbyTransferSucceedBankView:CloseOnPointerClick(eventData)
    self:CloseForm()
end

function LobbyTransferSucceedBankView:SaveOnPointerClick(eventData)
    
end


function LobbyTransferSucceedBankView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyTransferSucceedBankView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    
    self.transform_money_text = nil
    self.current_money_hanzi_text = nil
    self.receiver_name_text = nil
    self.receiver_id_text = nil
    self.giver_name_text = nil
    self.giver_id_text = nil
    self.data_text = nil

    if self.closeEventScript ~= nil then
        self.closeEventScript.onPointerClickCallBack = nil
    end
    self.closeEventScript = nil

    if self.saveEventScript ~= nil then
        self.saveEventScript.onPointerClickCallBack = nil
    end
    self.saveEventScript = nil


end

function LobbyTransferSucceedBankView:__delete( )
    self:RemoveUIComponent()
end

