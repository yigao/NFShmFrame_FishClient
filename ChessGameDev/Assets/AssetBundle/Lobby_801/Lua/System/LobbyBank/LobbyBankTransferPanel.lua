LobbyBankTransferPanel = Class()

function LobbyBankTransferPanel:ctor()
    self:Init()
end

function LobbyBankTransferPanel:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyBankTransferPanel:InitData(  )
    self.receiverID = nil
    self.transferMoney = 0
    self.receiverTable = nil
    self.IsOpenTransferConfirmForm = false
end

function LobbyBankTransferPanel:InitView(  )
    self.panelTransform = nil
    self.panelGameObject = nil
end

function LobbyBankTransferPanel:ReInit(  )
    self.receiverID = nil
    self.transferMoney = 0
    self.receiverTable = nil
    self.IsOpenTransferConfirmForm = false
end

function LobbyBankTransferPanel:OpenUIPanel(go)
    self:GetUIComponent(go)

    self:ShowUIComponent()
end

function LobbyBankTransferPanel:RefreshUIPanel( )
    LobbyBankSystem.GetInstance().transferConfirmBankView:CloseForm()
    self:ReInit()
    self:ShowUIComponent()
end

function LobbyBankTransferPanel:GetUIComponent(go)
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

    if self.rechargeEventScript == nil then
        local go = self.panelTransform:Find("MoneyInfo/recharge_btn").gameObject
        self.rechargeEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.rechargeEventScript == nil then 
            self.rechargeEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.rechargeEventScript ~= nil and self.rechargeEventScript.onMiniPointerClickCallBack == nil then
        self.rechargeEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:RechargeOnPointerClick(pointerEventData) end
    end

    if self.receiver_inputField == nil then
        self.receiver_inputField =  self.panelTransform:Find("ReceiverID/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    end

    if self.transfer_money_inputField == nil then
        self.transfer_money_inputField =  self.panelTransform:Find("TransferNumber/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    end
  
    if self.transfer_money_inputField ~= nil then
		if self.transfer_money_inputField.onValueChanged.RemoveAllListeners then
			self.transfer_money_inputField.onValueChanged:RemoveAllListeners()
		end
        
        self.inputCallBack = function(str) self:TransferMoneyInputFieldOnChange(str) end
        self.transfer_money_inputField.onValueChanged:AddListener(self.inputCallBack)
    end
    

    if self.transfer_slider == nil then
        self.transfer_slider =  self.panelTransform:Find("Slider"):GetComponent(typeof(CS.UnityEngine.UI.Slider))
    end
    if self.transfer_slider ~= nil then
		if self.transfer_slider.onValueChanged.RemoveAllListeners then
			self.transfer_slider.onValueChanged:RemoveAllListeners()
		end
        
        self.sliderCallBack = function (value) self:OnSliderValueChange(value) end
        self.transfer_slider.onValueChanged:AddListener(self.sliderCallBack)
    end

    if self.checkUserEventScript == nil then
        local go = self.panelTransform:Find("CheckUser_Btn").gameObject
        self.checkUserEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.checkUserEventScript == nil then 
            self.checkUserEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.checkUserEventScript ~= nil and self.checkUserEventScript.onMiniPointerClickCallBack == nil then
        self.checkUserEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CheckUserOnPointerClick(pointerEventData) end
    end

    if self.maxEventScript == nil then
        local go = self.panelTransform:Find("Max_Btn").gameObject
        self.maxEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.maxEventScript == nil then 
            self.maxEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.maxEventScript ~= nil and self.maxEventScript.onMiniPointerClickCallBack == nil then
        self.maxEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:MaxOnPointerClick(pointerEventData) end
    end

    if self.transferEventScript == nil then
        local go = self.panelTransform:Find("Transfer_Btn").gameObject
        self.transferEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.transferEventScript == nil then 
            self.transferEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.transferEventScript ~= nil and self.transferEventScript.onMiniPointerClickCallBack == nil then
        self.transferEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:TransferOnPointerClick(pointerEventData) end
    end
end

function LobbyBankTransferPanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
end


function LobbyBankTransferPanel:ShowUIComponent()
    self.game_money_text.text = LobbyBankSystem.GetInstance().bankVo.gameMoney
    self.bank_money_text.text =  LobbyBankSystem.GetInstance().bankVo.bankMoney

    if  self.receiver_inputField ~= nil then
        self.receiver_inputField.text = nil
    end

    if  self.transfer_money_inputField ~= nil then
        self.transfer_money_inputField.text = nil
    end

    if self.transfer_slider ~= nil then
        self.transfer_slider.value = 0
    end
end


function LobbyBankTransferPanel:TransferMoneyInputFieldOnChange(str)
	if LobbyBankSystem.GetInstance().bankVo.bankMoney<=0 then
		XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_CheckBankBalance)
		str=0
		return
	end
    if str ~= nil and string.len(str)>0 then
        self.transferMoney = math.floor(tonumber(str))
		if self.transfer_slider.onValueChanged.RemoveListener then
			self.transfer_slider.onValueChanged:RemoveListener(self.sliderCallBack)
		end
        
        if(math.floor(LobbyBankSystem.GetInstance().bankVo.bankMoney) >= 1) then
            self.transfer_slider.value = self.transferMoney/LobbyBankSystem.GetInstance().bankVo.bankMoney
        end
        self.transfer_slider.onValueChanged:AddListener(self.sliderCallBack)
    end
end

function LobbyBankTransferPanel:OnSliderValueChange(value)
	if  self.transfer_money_inputField.onValueChanged.RemoveListener then
		self.transfer_money_inputField.onValueChanged:RemoveListener(self.inputCallBack)
	end
    
    self.transferMoney = math.floor(value * LobbyBankSystem.GetInstance().bankVo.bankMoney)
    self.transfer_money_inputField.text = tostring(self.transferMoney)
    self.transfer_money_inputField.onValueChanged:AddListener(self.inputCallBack)
   -- self.transfer_slider.onValueChanged:AddListener(self.sliderCallBack)
    --self.transfer_money_inputField.onValueChanged:AddListener(self.inputCallBack)
end

function LobbyBankTransferPanel:RechargeOnPointerClick(eventData)
    
end

function LobbyBankTransferPanel:SetReciverData(id,name)
    self.receiverTable ={}
    self.receiverTable.userID = id
    self.receiverTable.name = name  
end

function LobbyBankTransferPanel:CheckUserOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self.receiverID = tonumber(CommonHelper.TrimStr(self.receiver_inputField.text))
    if self.receiverID then
        local receiverList = {}
        table.insert(receiverList,self.receiverID)
        LobbyBankSystem.GetInstance():RequestQueryUserMsg(receiverList)
    else
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_User_ID)
    end
end

function LobbyBankTransferPanel:MaxOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self.transfer_slider.onValueChanged:RemoveListener(self.sliderCallBack)
   -- self.transfer_money_inputField.onValueChanged:RemoveListener(self.inputCallBack)
    self.transferMoney = LobbyBankSystem.GetInstance().bankVo.bankMoney
    self.transfer_money_inputField.text = tostring(self.transferMoney)
    self.transfer_slider.value = 1
end

function LobbyBankTransferPanel:TransferOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if self.transferMoney > 0 then
        self.IsOpenTransferConfirmForm = true
        self:OpenTransferConfirmForm()
    else
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Bank_Transfer_Money_Error)
    end
end

function LobbyBankTransferPanel:OpenTransferConfirmForm()
    if self.IsOpenTransferConfirmForm == true then
        if self.receiverTable then
            LobbyBankSystem.GetInstance().transferConfirmBankView:OpenForm(self.transferMoney,self.receiverTable)
            self.IsOpenTransferConfirmForm = false
        else
            self.receiverID = tonumber(CommonHelper.TrimStr(self.receiver_inputField.text))
            local receiverList = {}
            table.insert(receiverList,self.receiverID)
            LobbyBankSystem.GetInstance():RequestQueryUserMsg(receiverList) 
        end
    end
end

function LobbyBankTransferPanel:CloseForm()
    
end


function LobbyBankTransferPanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
    self.game_money_text = nil
    self.bank_money_text = nil

    if self.rechargeEventScript ~= nil then
        self.rechargeEventScript.onMiniPointerClickCallBack = nil
    end
    self.rechargeEventScript = nil
   
    if self.receiver_inputField ~= nil then
        self.receiver_inputField.onEndEdit:RemoveListener(self.receiverInputResult)
    end
    self.receiver_inputField = nil
   
    if self.transfer_money_inputField ~= nil then
        self.transfer_money_inputField.onValueChanged:RemoveListener(self.inputCallBack)
    end
    self.transfer_money_inputField = nil
    

    if self.transfer_slider ~= nil then
        self.transfer_slider.onValueChanged:RemoveListener(self.sliderCallBack)
    end
    self.transfer_slider = nil

    if self.checkUserEventScript ~= nil then
        self.checkUserEventScript.onMiniPointerClickCallBack = nil
    end
    self.checkUserEventScript = nil

    if self.maxEventScript ~= nil then
        self.maxEventScript.onMiniPointerClickCallBack = nil
    end
    self.maxEventScript = nil

    if self.transferEventScript ~= nil then
        self.transferEventScript.onMiniPointerClickCallBack = nil
    end
    self.transferEventScript = nil
end

function LobbyBankTransferPanel:__delete()
    self:RemoveUIComponent()
end