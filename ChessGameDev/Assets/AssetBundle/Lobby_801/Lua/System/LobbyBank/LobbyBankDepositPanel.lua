LobbyBankDepositPanel = Class()

function LobbyBankDepositPanel:ctor()
    self:Init()
end

function LobbyBankDepositPanel:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyBankDepositPanel:InitData(  )
    self.depositMoney = 0
end

function LobbyBankDepositPanel:InitView(  )
    self.panelTransform = nil
    self.panelGameObject = nil
end

function LobbyBankDepositPanel:ReInit(  )
    self.depositMoney = 0
end

function LobbyBankDepositPanel:OpenUIPanel(go)
    self.depositMoney = 0
    self:GetUIComponent(go)
    self:ShowUIComponent()
end

function LobbyBankDepositPanel:RefreshUIPanel(  )
    self.depositMoney = 0
    self:ShowUIComponent()
end

function LobbyBankDepositPanel:GetUIComponent(go)
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

    if self.current_money_hanzi_text == nil then
        self.current_money_hanzi_text = self.panelTransform:Find("MoneyToBank/current_money_hanzi"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.gameToBank_inputField == nil then
        self.gameToBank_inputField =  self.panelTransform:Find("MoneyToBank/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    end
    if self.gameToBank_inputField ~= nil then
		if self.gameToBank_inputField.onValueChanged.RemoveAllListeners then
			self.gameToBank_inputField.onValueChanged:RemoveAllListeners()
		end
        
        self.inputCallBack = function(str) self:DepositInputFieldOnChange(str) end
        self.gameToBank_inputField.onValueChanged:AddListener(self.inputCallBack)
    end

    if self.deposit_slider == nil then
        self.deposit_slider =  self.panelTransform:Find("Slider"):GetComponent(typeof(CS.UnityEngine.UI.Slider))
    end
    
    if self.deposit_slider ~= nil then
		if self.deposit_slider.onValueChanged.RemoveAllListeners then
			 self.deposit_slider.onValueChanged:RemoveAllListeners()
		end
       
        self.sliderCallBack = function (value) self:OnSliderValueChange(value) end
        self.deposit_slider.onValueChanged:AddListener(self.sliderCallBack)
    end

    if self.maxEventScript == nil then
        local go = self.panelTransform:Find("Max_Btn").gameObject
        self.maxEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.maxEventScript == nil then 
            self.maxEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if  self.maxEventScript ~= nil and self.maxEventScript.onMiniPointerClickCallBack == nil then
        self.maxEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:MaxOnPointerClick(pointerEventData) end
    end

    if self.depositEventScript == nil then
        local go = self.panelTransform:Find("Deposit_Btn").gameObject
        self.depositEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.depositEventScript == nil then 
            self.depositEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.depositEventScript ~= nil and  self.depositEventScript.onMiniPointerClickCallBack== nil then
        self.depositEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:DepositOnPointerClick(pointerEventData) end
    end
end

function LobbyBankDepositPanel:RemoveUIComponent()
    self.panelGameObject = nil
    self.panelTransform = nil
end


function LobbyBankDepositPanel:ShowUIComponent()
    self.game_money_text.text = LobbyBankSystem.GetInstance().bankVo.gameMoney
    self.bank_money_text.text =  LobbyBankSystem.GetInstance().bankVo.bankMoney

    if  self.gameToBank_inputField ~= nil then
        self.gameToBank_inputField.text = nil
    end

    self:ShowUppercaseChineseNumbers(0)

    if self.deposit_slider ~= nil then
        self.deposit_slider.value = 0
    end
end


function LobbyBankDepositPanel:DepositInputFieldOnChange(str)
    if str ~= nil and string.len(str)>0 then
        self.depositMoney =math.floor(tonumber(str))
        self:ShowUppercaseChineseNumbers(self.depositMoney)
        self.deposit_slider.onValueChanged:RemoveListener(self.sliderCallBack)
        if(math.floor(LobbyBankSystem.GetInstance().bankVo.gameMoney) >= 1) then
            self.deposit_slider.value = self.depositMoney/LobbyBankSystem.GetInstance().bankVo.gameMoney
        end
        self.deposit_slider.onValueChanged:AddListener(self.sliderCallBack)
    else
        self.depositMoney =math.floor(tonumber(0))
        self:ShowUppercaseChineseNumbers(self.depositMoney) 
    end
end

function LobbyBankDepositPanel:OnSliderValueChange(value)
    self.depositMoney = math.floor(value * LobbyBankSystem.GetInstance().bankVo.gameMoney)
    self.gameToBank_inputField.onValueChanged:RemoveListener(self.inputCallBack)
    self.gameToBank_inputField.text = tostring(self.depositMoney) 
    self.gameToBank_inputField.onValueChanged:AddListener(self.inputCallBack)
end

function LobbyBankDepositPanel:ShowUppercaseChineseNumbers(money)
    local hanZiRMB = LobbyBankSystem.GetInstance():NumberToString(money)
    if hanZiRMB ~= nil then
        self.current_money_hanzi_text.text = "("..hanZiRMB..")"
    end
end

function LobbyBankDepositPanel:RechargeOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyBankSystem.GetInstance().RequestDepositMoneyMsg(self.depositMoney)
end

function LobbyBankDepositPanel:MaxOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self.deposit_slider.onValueChanged:RemoveListener(self.sliderCallBack)
    self.gameToBank_inputField.onValueChanged:RemoveListener(self.inputCallBack)
    self.depositMoney = LobbyBankSystem.GetInstance().bankVo.gameMoney
    self.gameToBank_inputField.text = tostring(self.depositMoney)
    self.deposit_slider.value = 1
    self:ShowUppercaseChineseNumbers(self.depositMoney)
    self.deposit_slider.onValueChanged:AddListener(self.sliderCallBack)
    self.gameToBank_inputField.onValueChanged:AddListener(self.inputCallBack)
end

function LobbyBankDepositPanel:DepositOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if self.depositMoney >= 1 then
        LobbyBankSystem.GetInstance():RequestDepositMoneyMsg(self.depositMoney)
    else
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Bank_Deposit_Money_Error)
    end
end

function LobbyBankDepositPanel:CloseForm()
    
end


function LobbyBankDepositPanel:RemoveUIComponent()
    
    self.panelGameObject = nil
    self.panelTransform = nil
    self.game_money_text = nil
    self.bank_money_text = nil
    self.current_money_hanzi_text = nil 

    if self.rechargeEventScript ~= nil then
        self.rechargeEventScript.onMiniPointerClickCallBack = nil 
    end
    self.rechargeEventScript = nil


    if self.gameToBank_inputField ~= nil then
        -- self.gameToBank_inputField.onEndEdit:RemoveListener(self.inputResult)
       
        self.gameToBank_inputField.onValueChanged:RemoveListener(self.inputCallBack)
    end

    if self.deposit_slider == nil then
        self.deposit_slider.onValueChanged:RemoveListener(self.sliderCallBack)
    end
    self.deposit_slider = nil

    if self.maxEventScript ~= nil then
        self.maxEventScript.onMiniPointerClickCallBack = nil
    end
    self.maxEventScript = nil
    
    if self.depositEventScript ~= nil then
        self.depositEventScript.onMiniPointerClickCallBack = nil
    end
    self.depositEventScript = nil
end

function LobbyBankDepositPanel:__delete()
    self:RemoveUIComponent()
end