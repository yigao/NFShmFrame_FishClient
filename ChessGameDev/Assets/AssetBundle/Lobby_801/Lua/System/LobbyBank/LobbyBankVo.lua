LobbyBankVo = Class()

function LobbyBankVo:ctor()	
	self.gameMoney = nil
	self.bankMoney = nil
end

function LobbyBankVo:SetBankData(gameMoney,bankMoney)
	self.gameMoney = gameMoney
	self.bankMoney = bankMoney
end

function LobbyBankVo:__delete( )
   
end


