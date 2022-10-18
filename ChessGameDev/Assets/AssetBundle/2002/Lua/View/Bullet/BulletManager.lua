BulletManager=Class()

local Instance=nil
function BulletManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function BulletManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end



function BulletManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllBulletInsList={}
	self.CurrentUseBulletInsList={}
	self.BulletPrefabName="bullet_1"
	
end

function BulletManager:AddScripts()
	self.ScriptsPathList={
		"/View/Bullet/BulletVo/BulletBase",
		"/View/Bullet/BulletVo/Bullet",
	}
end


function BulletManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function BulletManager:InitView(gameObj)
	
end


function BulletManager:InitInstance()
	self.Bullet=Bullet
	
end


function BulletManager:InitViewData()	
	
end



function BulletManager:LocalCreatBullet(myChairId,bulletUID,bulletSpeedIndex,bulletIntervalTimeIndex,bulletLevel,bulletAngle)
	local msg={}
	msg.BulletUID=bulletUID
	msg.ChairId=myChairId
	msg.BulletSpeedIndex=bulletSpeedIndex
	msg.BulletIntervalTimeIndex=bulletIntervalTimeIndex
	msg.BulletLevel=bulletLevel
	--msg.BulletAngle=bulletAngle
	self:CreateBullet(msg,false)
end


function BulletManager:CreateBullet(bulletVo,isServerCallBack)
	local bulletIns=self:GetBullet(bulletVo)
	local playerIndex=GameManager.GetInstance():GetPlayerSeatByServerChairId(bulletVo.ChairId)
	local playerIns=PlayerManager.GetInstance():GetPlayerInsBySeatId(playerIndex)
	if playerIns then
		bulletIns:SetBulletTargetPlayer(playerIns)
		if isServerCallBack then
			playerIns:ServerToShootBullet(bulletIns)
		else
			playerIns:LocalToShootBullet(bulletIns)
		end
	else
		Debug.LogError("当前位置玩家不存在==>"..bulletVo.ChairId)
	end
	
	
end


function BulletManager:ParseBulletMsg(msg)
	local vo={}
	vo.BulletUID=msg.usBulletId
	vo.BulletAngle=msg.sAngle
	vo.BulletSpeedIndex=msg.usSpeedIndex
	vo.BulletIntervalTimeIndex=msg.usIntervalIndex
	vo.BulletLevel=msg.usLevelIndex
	vo.ChairId=msg.usChairId
	vo.ErrorCode=msg.usErrorCode
	vo.usProcUserChairId=msg.usProcUserChairId	--机器人指定真实玩家座位号上传子弹击中消息
	
	return vo
end


function BulletManager:GetBullet(vo)
	if self.AllBulletInsList and next(self.AllBulletInsList) then
		local bulletIns=table.remove(self.AllBulletInsList,1)
		if bulletIns then
			bulletIns:UpdateBulletVo(vo)
			bulletIns:BaseInitViewData()
			if(self.CurrentUseBulletInsList[vo.ChairId])==nil then
				self.CurrentUseBulletInsList[vo.ChairId]={}
			end
			self.CurrentUseBulletInsList[vo.ChairId][vo.BulletUID]=bulletIns
			return bulletIns
		else
			Debug.LogError("创建Bullet失败"..vo.BulletUID)
		end
		
	else
		local tempBT=GameObjectPoolManager.GetInstance():GetGameObject(self.BulletPrefabName,GameObjectPoolManager.PoolType.BulletPool)
		local bulletIns=self.Bullet.New(tempBT)
		if bulletIns then
			bulletIns:UpdateBulletVo(vo)
			if(self.CurrentUseBulletInsList[vo.ChairId])==nil then
				self.CurrentUseBulletInsList[vo.ChairId]={}
			end
			self.CurrentUseBulletInsList[vo.ChairId][vo.BulletUID]=bulletIns
			return bulletIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(tempBT,GameObjectPoolManager.PoolType.BulletPool)
			Debug.LogError("创建Bullet失败"..vo.BulletUID)
		end
		
	end
	return nil
end


function BulletManager:GetPlayerBulletCount(chairdID)
	if self.CurrentUseBulletInsList and self.CurrentUseBulletInsList[chairdID] then
		local count=0
		for k,v in pairs(self.CurrentUseBulletInsList[chairdID]) do
			count=count+1
		end
		return count
	end
	return 0
end


function BulletManager:RecycleBullet(bulletIns)
	--Debug.LogError("移除子弹：==>"..bulletIns.BulletVo.BulletUID)
	local tempBullet=self.CurrentUseBulletInsList[bulletIns.BulletVo.ChairId][bulletIns.BulletVo.BulletUID]
	if tempBullet then
		if not self.AllBulletInsList then
			self.AllBulletInsList={}
		end
		table.insert(self.AllBulletInsList,tempBullet)
		self.CurrentUseBulletInsList[bulletIns.BulletVo.ChairId][bulletIns.BulletVo.BulletUID]=nil
	else
		Debug.LogError("移除的Bullet为nil==>UID"..bulletIns.BulletVo.BulletUID)
	end
end


function BulletManager:ClearAllBullet()
	if self.CurrentUseBulletInsList  then
		for k,v in pairs(self.CurrentUseBulletInsList) do
			for _k,_v in pairs(v) do
				--_v.isCanDestroy=true
				_v:Destroy()
				self:RecycleBullet(_v)
			end
			
		end
			
	end
	
	if self.AllBulletInsList  then
		for k1,v1 in pairs(self.AllBulletInsList) do
			v1:Destroy()
		end
	end
	
end


function BulletManager:UpdateRemoveBullet()
	if self.CurrentUseBulletInsList  then
		for k,v in pairs(self.CurrentUseBulletInsList) do
			if next(v) then
				for _k,_v in pairs(v) do
					if _v.isCanDestroy then
						_v:Destroy()
						self:RecycleBullet(_v)
					end
				end
			end
			
		end
		
	end
	
end


function BulletManager:Update()
	self:UpdateRemoveBullet()
	
end



function BulletManager.GetInstance()
	if Instance==nil then
		--Instance=BulletManager.New()
	end
	return Instance
end


--------------------------------------------------------------handle事件回调-----------------------------------------------------

function BulletManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_ShootBulletRsp"),self.ResponesBulletNetMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_AutoShootRsp"),self.ResponesAutoShootBulletSwitchNetMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_BulletSpeedRsp"),self.ResponesBulletSpeedNetMsg,self)
end

function BulletManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_ShootBulletRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_AutoShootRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_BulletSpeedRsp"))
end


-----------------------------------------------------------CreateBullet
function BulletManager:RequestSendBulletMsg(bulletAngle,bulletUID)
	local sendBullet={}
	sendBullet.sAngle=bulletAngle
	sendBullet.usBulletId=bulletUID
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.ShootBulletReq", sendBullet)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_ShootBulletReq"),bytes)
end


--子弹
function BulletManager:ResponesBulletNetMsg(msg)
	if GameManager.GetInstance().IsFocus==false then return end
	--Debug.LogError("Bullet事件回调==>10006")
	local data=LuaProtoBufManager.Decode("Fish_Msg.ShootBulletRsp",msg)
	--pt(data)
	self:ResponesBulletMsg(data)
end



function BulletManager:ResponesBulletMsg(msg)
	local BulletVo=self:ParseBulletMsg(msg)
	if BulletVo.ErrorCode==0 then
		if BulletVo.ChairId~=self.gameData.PlayerChairId then
			self:CreateBullet(BulletVo,true)
		end
	end
end


---------------------------------------------------------------AutoShootSwitch
function BulletManager:RequestAutoShootBulletSwitchMsg(sendMsg)
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.AutoShootReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_AutoShootReq"),bytes)
end



function BulletManager:ResponesAutoShootBulletSwitchNetMsg(msg)
	--Debug.LogError("AutoShoot事件回调==>10014")
	local data=LuaProtoBufManager.Decode("Fish_Msg.AutoShootRsp",msg)
	--pt(data)
	self:ResponesAutoShootBulletMsgProcess(data)
end

function BulletManager:ResponesAutoShootBulletMsgProcess(CBMsg)
	
end


---------------------------------------------------------------BulletSpeed
function BulletManager:RequestBulletSpeedNetMsg(sendMsg)
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.BulletSpeedReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_BulletSpeedReq"),bytes)
end



function BulletManager:ResponesBulletSpeedNetMsg(msg)
	--Debug.LogError("BulletSpeed事件回调==>10016")
	local data=LuaProtoBufManager.Decode("Fish_Msg.BulletSpeedRsp",msg)
	--pt(data)
	
end


function BulletManager:__delete()
	self:RemoveEventListenner()
	self.updateName=nil
	self.AllBulletInsList=nil
	self.CurrentUseBulletInsList=nil
	self.BulletPrefabName=nil
	self.Bullet=nil
end