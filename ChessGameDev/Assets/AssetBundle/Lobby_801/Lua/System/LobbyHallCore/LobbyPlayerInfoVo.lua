LobbyPlayerInfoVo=Class()

function LobbyPlayerInfoVo:ctor()
	self:Init()
end



function LobbyPlayerInfoVo:Init()
	self:InitData()
end


function LobbyPlayerInfoVo:InitData()
	self.user_id = nil 		--用户唯一ID
	self.nick_name = nil	--用户昵称
	self.face_id = nil		--头像标识
	self.gender = nil 		--用户性别
	self.jetton = nil		--游戏的金币
	self.bank_jetton = nil	--银行的金币
	self.agent_id = nil		--代理标识
	self.phonenum = nil		--手机
	self.vip_level = nil	--VIP等级
	self.aread_id = nil		--运营商id
	self.referrer_id = nil	--推荐人id
	self.first_recharge = nil --是否首充
end

function LobbyPlayerInfoVo:SetUserDetailCommonData(args)
	local data = args[1]
	pt(args)
	self.user_id = data.user_id 		--用户唯一ID
	self.nick_name = data.detail_data.nick_name	--用户昵称
	self.face_id = data.detail_data.face_id		--头像标识
	self.gender = data.detail_data.gender 		--用户性别
	self.jetton = data.detail_data.jetton		--游戏的金币
	self.bank_jetton = data.detail_data.bank_jetton	--银行的金币
	self.agent_id = data.detail_data.agent_id		--代理标识
	self.phonenum = data.detail_data.phonenum		--手机
	self.vip_level = data.detail_data.vip_level	--VIP等级
	self.aread_id = data.detail_data.aread_id		--运营商id
	self.referrer_id = data.detail_data.referrer_id	--推荐人id
	self.first_recharge = data.detail_data.first_recharge --是否首充
end

function LobbyPlayerInfoVo:SetGameHeadImage(headId)
	self.face_id = headId
end

function LobbyPlayerInfoVo:SetNickName(nickName)
	self.nick_name = nickName
end

function LobbyPlayerInfoVo:SetPhoneNumber(phoneNumber)
	self.phonenum = phoneNumber
end

function LobbyPlayerInfoVo:SetLobbyMoney(gameMoney,bankMoney)
	self.jetton = gameMoney		--游戏的金币
	self.bank_jetton = bankMoney	--银行的金币
end

