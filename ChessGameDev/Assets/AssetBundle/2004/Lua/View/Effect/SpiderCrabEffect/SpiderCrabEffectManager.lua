SpiderCrabEffectManager=Class()

local Instance=nil
function SpiderCrabEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end

function SpiderCrabEffectManager.GetInstance()
	return Instance
end

function SpiderCrabEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
end

function SpiderCrabEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.KingEffectType={			--面板展示类型
		Hurt=1,
		Kill=2,
		Board=3,
	}

	self.updateName="SpiderCrabEffectManager.Update"
	self.UpdateMark=0

	self.AllUseCrabBossHurtList = {}
	self.CurrentCrabBossHurtList = {}

	self.AllUseCrabBossScoreList={}
	self.CurrentCrabBossScoreList={}

	self.UID=1
	self.Vector2 = CS.UnityEngine.Vector2
	self.Animator=CS.UnityEngine.Animator
	self.Text=CS.UnityEngine.UI.Text
	self.Image = CS.UnityEngine.UI.Image
	self.Random = CS.UnityEngine.Random
	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.TweenExtensions = CS.DG.Tweening.TweenExtensions

	self.SpiderCrabBossHurt_Res = "SpiderCrabBossHurt"
	self.SpiderCrabBossScore_Res = "SpiderCrabBoardScore"
end
	
function SpiderCrabEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/SpiderCrabEffect/Effect/SpiderCrabBoardScore",
		"/View/Effect/SpiderCrabEffect/Effect/SpiderCrabBossHurt",
		"/View/Effect/SpiderCrabEffect/Effect/SpiderCrabKillInfo",
	}
end

function SpiderCrabEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end

function SpiderCrabEffectManager:InitView(gameObj)
	
end

function SpiderCrabEffectManager:InitInstance()
	self.SpiderCrabBoardScore = SpiderCrabBoardScore
	self.SpiderCrabBossHurt = SpiderCrabBossHurt
	self.SpiderCrabKillInfo = 	SpiderCrabKillInfo
end


function SpiderCrabEffectManager:InitViewData()	
	
end

function SpiderCrabEffectManager:GetSpiderCrabEffectUID()
	self.UID=self.UID+1
	return self.UID
end

function SpiderCrabEffectManager:CreateSpiderCrabBoardScore(chairID,partMul,selfScore,totalScore,totalMul,pos)
	local spiderCrabBossScoreVo=self:GetSpiderCrabBossScoreVo(chairID,partMul,selfScore,totalScore,totalMul)
	local tempSpiderCrabBoardScoreEffectIns=self:GetSpiderCrabBossScoreEffect(spiderCrabBossScoreVo)
	local targetPos = pos
	if tempSpiderCrabBoardScoreEffectIns then
		tempSpiderCrabBoardScoreEffectIns:ResetState(targetPos)
	end
	return spiderCrabBossScoreVo.UID
end


function SpiderCrabEffectManager:GetSpiderCrabBossScoreVo(chairID,partMul,selfScore,totalScore,totalMul)
	local vo={}
	vo.UID=self:GetSpiderCrabEffectUID()
	vo.ChairID = chairID
	vo.partMul = partMul
	vo.selfScore = selfScore
	vo.totalScore = totalScore
	vo.totalMul = totalMul
	vo.IsMe = (chairID == self.gameData.PlayerChairId)
	return vo		
end

function SpiderCrabEffectManager:GetSpiderCrabBossScoreEffect(spiderCrabBossScoreVo)
	if #self.AllUseCrabBossScoreList > 0 then
		local tempEffectIns=table.remove(self.AllUseCrabBossScoreList,1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(spiderCrabBossScoreVo)
			self.CurrentCrabBossScoreList[spiderCrabBossScoreVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("创建螃蟹死亡得分提示失败==>"..spiderCrabBossScoreVo.UID)
		end
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(self.SpiderCrabBossScore_Res,GameObjectPoolManager.PoolType.SpecialDeclarePool)
		local tempEffectIns=self.SpiderCrabBoardScore.New(effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(spiderCrabBossScoreVo)
			self.CurrentCrabBossScoreList[spiderCrabBossScoreVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.SpecialDeclarePool)
			Debug.LogError("创建螃蟹死亡得分提示失败==>"..spiderCrabBossScoreVo.UID)
		end
	end
	return nil
end


function SpiderCrabEffectManager:RecycleSpiderCrabBossScoreEffect(spiderCrabBossScoreEffectIns)
	if spiderCrabBossScoreEffectIns then
		if self.AllUseCrabBossScoreList==nil then
			self.AllUseCrabBossScoreList={}
		end
		table.insert(self.AllUseCrabBossScoreList,spiderCrabBossScoreEffectIns)
		self.CurrentCrabBossScoreList[spiderCrabBossScoreEffectIns.EffectVo.UID]=nil
	else
		Debug.LogError("移除的spiderCrabBossHurtEffectIns为nil==>UID"..spiderCrabBossScoreEffectIns.EffectVo.UID)
	end
end

function SpiderCrabEffectManager:ClearSpiderCrabBossScoreEffect()
	if self.CurrentCrabBossScoreList  then
		for k,v in pairs(self.CurrentCrabBossScoreList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveSpiderCrabBossScoreEffect()
	end
	self.CurrentCrabBossScoreList = {} 
end

function SpiderCrabEffectManager:UpdateRemoveSpiderCrabBossScoreEffect()
	if self.CurrentCrabBossScoreList and next(self.CurrentCrabBossScoreList) then
		for k,v in pairs(self.CurrentCrabBossScoreList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleSpiderCrabBossScoreEffect(v)
			end
		end
	end
end



function SpiderCrabEffectManager:CreateSpiderCrabBosshurt(chairID,hurtNum,hurtScore,pos)
	local spiderCrabBossHurtVo=self:GetSpiderCrabBossHurtVo(chairID,hurtNum,hurtScore)
	local tempSpiderCrabBossHurtEffectIns=self:GetSpiderCrabBossHurtEffect(spiderCrabBossHurtVo)
	local targetPos = pos
	if tempSpiderCrabBossHurtEffectIns then
		tempSpiderCrabBossHurtEffectIns:ResetState(targetPos)
	end
	return spiderCrabBossHurtVo.UID
end

function SpiderCrabEffectManager:GetSpiderCrabBossHurtVo(chairID,hurtNum,hurtScore)
	local vo={}
	vo.UID=self:GetSpiderCrabEffectUID()
	vo.ChairID = chairID
	vo.hurtNum = hurtNum
	vo.hurtScore = hurtScore
	vo.IsMe = (chairID == self.gameData.PlayerChairId)
	return vo	
end

function SpiderCrabEffectManager:GetSpiderCrabBossHurtEffect(spiderCrabBossHurtVo)
	if #self.AllUseCrabBossHurtList > 0 then
		local tempEffectIns=table.remove(self.AllUseCrabBossHurtList,1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(spiderCrabBossHurtVo)
			self.CurrentCrabBossHurtList[spiderCrabBossHurtVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("创建螃蟹得分提示失败==>"..spiderCrabBossHurtVo.UID)
		end
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(self.SpiderCrabBossHurt_Res,GameObjectPoolManager.PoolType.SpecialDeclarePool)
		local tempEffectIns=self.SpiderCrabBossHurt.New(effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(spiderCrabBossHurtVo)
			self.CurrentCrabBossHurtList[spiderCrabBossHurtVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.SpecialDeclarePool)
			Debug.LogError("创建螃蟹得分提示失败==>"..spiderCrabBossHurtVo.UID)
		end
	end
	return nil
end

function SpiderCrabEffectManager:RecycleSpiderCrabBossHurtEffect(spiderCrabBossHurtEffectIns)
	if spiderCrabBossHurtEffectIns then
		if self.AllUseCrabBossHurtList==nil then
			self.AllUseCrabBossHurtList={}
		end
		table.insert(self.AllUseCrabBossHurtList,spiderCrabBossHurtEffectIns)
		self.CurrentCrabBossHurtList[spiderCrabBossHurtEffectIns.EffectVo.UID]=nil
	else
		Debug.LogError("移除的spiderCrabBossHurtEffectIns为nil==>UID"..spiderCrabBossHurtEffectIns.EffectVo.UID)
	end
end

function SpiderCrabEffectManager:ClearSpiderCrabBossHurtEffect()
	if self.CurrentCrabBossHurtList  then
		for k,v in pairs(self.CurrentCrabBossHurtList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveSpiderCrabBossHurtEffect()
	end
	self.CurrentCrabBossHurtList = {}
end

function SpiderCrabEffectManager:UpdateRemoveSpiderCrabBossHurtEffect()
	if self.CurrentCrabBossHurtList and next(self.CurrentCrabBossHurtList) then
		for k,v in pairs(self.CurrentCrabBossHurtList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleSpiderCrabBossHurtEffect(v)
			end
		end
	end
end

function SpiderCrabEffectManager:Update()
	self:UpdateRemoveSpiderCrabBossHurtEffect()
	self:UpdateRemoveSpiderCrabBossScoreEffect()
end

function SpiderCrabEffectManager:__delete()
	self.AllUseCrabBossHurtList = nil
	self.CurrentCrabBossHurtList = nil

	self.AllUseCrabBossScoreList= nil
	self.CurrentCrabBossScoreList= nil

	self.Vector2 = nil
	self.Animator= nil
	self.Text = nil
	self.Image = nil
	self.Random = nil
	self.Tween = nil
	self.Sequence = nil
	self.Ease = nil
	self.DOTween = nil
	self.TweenExtensions = nil
end
