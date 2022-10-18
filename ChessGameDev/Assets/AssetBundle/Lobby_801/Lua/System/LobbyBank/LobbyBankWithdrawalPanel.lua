LobbyBankWithdrawalPanel = Class()

function LobbyBankWithdrawalPanel:ctor()
    self:Init()
end

function LobbyBankWithdrawalPanel:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyBankWithdrawalPanel:InitData(  )
    self.withdrawalMoney = 0
end

function LobbyBankWithdrawalPanel:InitView(  )
    self.panelTransform = nil
    self.panelGameObject = nil
end

function LobbyBankDepositPanel:ReInit(  )
    self.withdrawalMoney = 0
end


function LobbyBankWithdrawalPanel:OpenUIPanel(go)
    self:GetUIComponent(go)

    self:ShowUIComponent()
end

function LobbyBankWithdrawalPanel:RefreshUIPanel(  )
    self:ShowUIComponent()
end

function LobbyBankWithdrawalPanel:GetUIComponent(go)
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

    if self.bankToGame_inputField == nil then
        self.bankToGame_inputField =  self.panelTransform:Find("BankMoneyToGame/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    end
    if  self.bankToGame_inputField ~= nil then
		if self.bankToGame_inputField.onValueChanged.RemoveAllListeners then
			self.bankToGame_inputField.onValueChanged:RemoveAllListeners()
		end
        self.inputCallBack = function(str) self:WithdrawalInputFieldOnChange(str) end
        self.bankToGame_inputField.onValueChanged:AddListener(self.inputCallBack)
    end

    if self.current_money_hanzi_text == nil then
        self.current_money_hanzi_text = self.panelTransform:Find("BankMoneyToGame/current_money_hanzi"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.withdrawal_slider == nil then
        self.withdrawal_slider =  self.panelTransform:Find("Slider"):GetComponent(typeof(CS.UnityEngine.UI.Slider))
    end
    if self.withdrawal_slider ~= nil then
		if self.withdrawal_slider.onValueChanged.RemoveAllListeners then
			self.withdrawal_slider.onValueChanged:RemoveAllListeners()
		end
        
        self.sliderCallBack = function (value) self:OnSliderValueChange(value) end
        self.withdrawal_slider.onValueChanged:AddListener(self.sliderCallBack)
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

    if self.withdrawalEventScript == nil then
        local go = self.panelTransform:Find("Withdrawal_Btn").gameObject
        self.withdrawalEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.withdrawalEventScript == nil then 
            self.withdrawalEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.withdrawalEventScript ~= nil and self.withdrawalEventScript.onMiniPointerClickCallBack == nil then
        self.withdrawalEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:WithdrawalOnPointerClick(pointerEventData) end
    end
end

function LobbyBankWithdrawalPanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
end


function LobbyBankWithdrawalPanel:ShowUIComponent()
    self.game_money_text.text = LobbyBankSystem.GetInstance().bankVo.gameMoney
    self.bank_money_text.text =  LobbyBankSystem.GetInstance().bankVo.bankMoney

    if  self.bankToGame_inputField ~= nil then
        self.bankToGame_inputField.text = nil
    end

    self:ShowUppercaseChineseNumbers(0)

    if self.withdrawal_slider ~= nil then
        self.withdrawal_slider.value = 0
    end
end

function LobbyBankWithdrawalPanel:WithdrawalInputFieldOnChange(str)
    if str ~= nil and string.len(str)>0 then
        self.withdrawalMoney = math.floor(tonumber(str))
        self:ShowUppercaseChineseNumbers(self.withdrawalMoney)
        self.withdrawal_slider.onValueChanged:RemoveListener(self.sliderCallBack)
        if(math.floor(LobbyBankSystem.GetInstance().bankVo.bankMoney) >= 1) then
            self.withdrawal_slider.value = self.withdrawalMoney/LobbyBankSystem.GetInstance().bankVo.bankMoney
        end
        self.withdrawal_slider.onValueChanged:AddListener(self.sliderCallBack)
    else
        self.withdrawalMoney =math.floor(tonumber(0))
        self:ShowUppercaseChineseNumbers(self.withdrawalMoney) 
    end
end

function LobbyBankWithdrawalPanel:OnSliderValueChange(value)
    self.withdrawalMoney = math.floor(value * LobbyBankSystem.GetInstance().bankVo.bankMoney)
    self.bankToGame_inputField.onValueChanged:RemoveListener(self.inputCallBack)
    self.bankToGame_inputField.text = tostring(self.withdrawalMoney)
    self.bankToGame_inputField.onValueChanged:AddListener(self.inputCallBack)
end

function LobbyBankWithdrawalPanel:ShowUppercaseChineseNumbers(money)
    local hanZiRMB = LobbyBankSystem.GetInstance():NumberToString(money)
    if hanZiRMB ~= nil then
        self.current_money_hanzi_text.text = "("..hanZiRMB..")"
    end
end

function LobbyBankWithdrawalPanel:RechargeOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
end

function LobbyBankWithdrawalPanel:MaxOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self.withdrawal_slider.onValueChanged:RemoveListener(self.sliderCallBack)
    self.bankToGame_inputField.onValueChanged:RemoveListener(self.inputCallBack)
    self.withdrawalMoney = LobbyBankSystem.GetInstance().bankVo.bankMoney
    self.bankToGame_inputField.text = tostring(self.withdrawalMoney)
    self.withdrawal_slider.value = 1
    self:ShowUppercaseChineseNumbers(self.withdrawalMoney)
    self.withdrawal_slider.onValueChanged:AddListener(self.sliderCallBack)
    self.bankToGame_inputField.onValueChanged:AddListener(self.inputCallBack)
end

function LobbyBankWithdrawalPanel:WithdrawalOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if self.withdrawalMoney >= 1 then
        LobbyBankSystem.GetInstance():RequestWithdrawalMoneyMsg(self.withdrawalMoney)
    else
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Bank_Withdrawal_Money_Error)
    end
end

function LobbyBankWithdrawalPanel:CloseForm()
    
end


function LobbyBankWithdrawalPanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
    self.game_money_text = nil
    self.bank_money_text = nil
    self.current_money_hanzi_text = nil

    if self.rechargeEventScript ~= nil then
        self.rechargeEventScript.onMiniPointerClickCallBack = nil
    end
    self.rechargeEventScript = nil
    
    if self.bankToGame_inputField ~= nil then
        self.bankToGame_inputField.onValueChanged:RemoveListener(self.inputCallBack)
    end
    self.bankToGame_inputField = nil

    if self.withdrawal_slider ~= nil then
        self.withdrawal_slider.onValueChanged:RemoveListener(self.sliderCallBack)
    end
    self.withdrawal_slider = nil

    if self.maxEventScript ~= nil then
        self.maxEventScript.onMiniPointerClickCallBack = nil
    end
    self.maxEventScript = nil

    if self.withdrawalEventScript ~= nil then
        self.withdrawalEventScript.onMiniPointerClickCallBack = nil
    end
    self.withdrawalEventScript = nil
end

function LobbyBankWithdrawalPanel:__delete()
    self:RemoveUIComponent()
end