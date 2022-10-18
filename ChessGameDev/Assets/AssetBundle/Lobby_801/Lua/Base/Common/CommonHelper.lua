CommonHelper={}



function CommonHelper.SetGameFrameRate(targetFrameRate)
	CSScript.LuaManager:SetGameFrameRate(targetFrameRate)
end


function CommonHelper.ConfigLog(isPrint)
	LogManager.IsPrintLog=isPrint
end

--判断unity中的Object是否为null
function CommonHelper.IsNil(uobj)
    return uobj == nil or uobj:Equals(nil)
end

--添加Update
function CommonHelper.AddUpdate(self)
	if self.gameObject==nil or self.Update==nil then
		Debug.LogError("Updae的gameObject或Update方法为nil")
		Debug.LogError(debug.traceback())
	else
		local UpdateCallBackFunc=function ()
			self:Update()
		end
		return CSScript.UpdateManager:AddUpdateItem(self.gameObject,UpdateCallBackFunc)
	end
	return -1
end


function CommonHelper.RemoveUpdate(updateNum)
	if updateNum then
		CSScript.UpdateManager:RemoveUpdateItem(updateNum)
	end
end


function CommonHelper.IsContainKeyForDic(key,dic)	
	for k,v in pairs(dic) do
		if k==key then
			return true
		end
	end
	return false
end


function CommonHelper.IsContainValueForDic(targetV,dic)
	for k,v in pairs(dic) do
		if v==targetV then
			return true
		end
	end
	return false
end


function CommonHelper.PTDicForAllKey(dic)
	local temp={}
	for k,v in pairs(dic) do
		table.insert(temp,k)
	end
	Debug.LogError("表中AllKey数据为==>")
	pt(temp)
end




--将对象添加到父物体下
function CommonHelper.AddToParentGameObject(targetObj,parentObj)
	targetObj.transform:SetParent(parentObj.transform,false)
	targetObj.transform.localPosition=CSScript.Vector3.zero
	targetObj.transform.localScale=CSScript.Vector3.one
	targetObj.transform.localRotation=CS.UnityEngine.Quaternion.identity 
end

--添加对象到父物体并设置位置和缩放
function CommonHelper.AddToParentGameObjectAndSetPS(targetObj,parentObj,vectorPos,scale)
	targetObj.transform:SetParent(parentObj.transform,false)
	targetObj.transform.localPosition=vectorPos
	targetObj.transform.localScale=scale--CSScript.Vector3.one
end


function CommonHelper.ResetTransform(targetTf)
	targetTf.localPosition=CSScript.Vector3.zero
	targetTf.localScale=CSScript.Vector3.one
	targetTf.localRotation=CS.UnityEngine.Quaternion.identity 
end


--深拷贝
function CommonHelper.DeepCopyTable(targetTb)
	local tempTb={}
	if targetTb then
		for k,v in pairs(targetTb) do
			tempTb[k]=v
		end
	end
	return tempTb
end


function CommonHelper.IsEnableUGUIButton(button,isEnable)
	if button then
		isEnable=isEnable or false
		button.interactable=isEnable
	end
end


function CommonHelper.SetImageColor(image,color)
	image.color=color
end


function CommonHelper.SetActive(targetObj,isDisplay)
	targetObj:SetActive(isDisplay)
end


function CommonHelper.IsActive(gameObj)
	return gameObj.activeInHierarchy
end


function CommonHelper.IsShowPanel(pIndex,PList,isShow,isGameObject,isMultiple,isNeedParent)
	local show=isShow
	if isNeedParent==nil then
		isNeedParent=false
	end
	for i=1,#PList do
		if i==pIndex then
			show=isShow
		else
			show=(not isShow)
		end
		
		local TObj=nil
		if isGameObject==false then
			if isNeedParent==false then
				TObj=PList[i].gameObject
			else
				TObj=PList[i].transform.parent.gameObject
			end
			
		else
			TObj=PList[i]
		end
				
		if isMultiple  then
			if show==isShow then	
				TObj:SetActive(show)
				return	
			end
		else
			TObj:SetActive(show)
		end
		
	end
end



function CommonHelper.Instantiate(gameObj)
	local CloneObj=CSScript.GameObject.Instantiate(gameObj)
	CloneObj.transform.localPosition=CSScript.Vector3.zero
	CloneObj.transform.localScale=CSScript.Vector3.one
	return CloneObj
end


function CommonHelper.UnityObjectInstantiate(unityObj)
	local CloneObj=CSScript.GameObject.Instantiate(unityObj)
	return CloneObj
end


function CommonHelper.Destroy(gameObj)
	CSScript.GameObject.Destroy(gameObj)
end

function CommonHelper.DestroyImmediate(gameObj)
	CSScript.GameObject.DestroyImmediate(gameObj)
end

function CommonHelper.GetRandomTwo(params1,params2)
	return math.random(params1,params2)
end

function CommonHelper.GetRandom(params1,params2)
	return math.random(params1,params2)
end



--分割字符串
function CommonHelper.StringSpilt(tragetStr,splitStr,callbackFunc)
	CS.FileManager.StringSplit(tragetStr,splitStr,callbackFunc)
end




function CommonHelper.LoaderLuaScripts(allScritps)
	if allScritps  then
		if #allScritps>0 then
			for i=1,#allScritps do
				require(allScritps[i])
			end
		end
	end
end



function CommonHelper.AddSpriteAtlas(callBackFunc)
	CS.AtlasManager.instance:AddBindingSpriteAtlas(callBackFunc)
end


function CommonHelper.RemoveSpriteAtlas(callBackFunc)
	CS.AtlasManager.instance:RemoveBindingSpriteAtlas(callBackFunc)
end


--基础比例转换
function CommonHelper.FormatBaseProportionalScore(score)
	local baseRatio=1
	--print(score)
	local currentIntPart,currentDecimalPart=math.modf(tonumber(score)/baseRatio)
	--print("currentIntPart===>>>"..currentIntPart)
	--print("currentDecimalPart===>>>"..currentDecimalPart)
	if currentDecimalPart and currentDecimalPart>0 then
		local count=string.len(string.format("%.11f",currentDecimalPart))-2
		--print("小数部分长度===>>>"..count)
		if baseRatio<100 and baseRatio>0 then
			if count>7 then
				currentDecimalPart=string.format("%.7f",currentDecimalPart)
			end
		else
			if count>2 then
				currentDecimalPart=string.format("%.2f",currentDecimalPart)
			end
		end
		score=tonumber(currentIntPart)+tonumber(currentDecimalPart)
	else
		score=tonumber(currentIntPart)
	end
	--print("结果==>>>"..score)
	return score
end

--千分位转换
function CommonHelper.FormatThousandsProportionalScore(score)
	local thousandsScore=CommonHelper.FormatBaseProportionalScore(score)
	if thousandsScore  then
		local currentIntPart,currentDecimalPart=math.modf(tonumber(thousandsScore)/1)
		local absIntPart=math.abs(currentIntPart)
		if currentIntPart and absIntPart>=1000 then
			local count=string.len(absIntPart)
			local index=0
			local targetStr=""
			for i=count,1,-1 do
				index=index+1
				local curentIndexStr=string.sub(absIntPart,i,i)
				targetStr=curentIndexStr..targetStr
				local indexInt,indexDecimal=math.modf(index/3)
				if indexDecimal==0 then
					targetStr=","..targetStr		
				end
			end
			if currentIntPart<0 then
				targetStr="-"..targetStr
			end
			return targetStr
		end
		return currentIntPart
	else
		Debug.LogError("千分位转换异常==>>>>")
		Debug.LogError(score)
		thousandsScore=0
	end
	return thousandsScore
end

--亿万元转换
function CommonHelper.FormatUnitProportionalScore(score)
	return score
end

--字符串去除空格、tabel符
function CommonHelper.TrimStr(s) 
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end


function CommonHelper.SetScreenOrientation(isPortrait)
	CSScript.LuaManager:SetScreenOrientation(isPortrait)
end



function CommonHelper.AddOnApplicationFocus(addFunc,addObj)
	local onApplicationFocusFunc=function (isFocus)
		addFunc(addObj,isFocus)
	end
	CSScript.LuaManager.onApplicationFocus=onApplicationFocusFunc

end


function CommonHelper.RemoveOnApplicationFocus()
	CSScript.LuaManager.onApplicationFocus=nil
end


function CommonHelper.IsPlayingFromAnimationName(animation,animName)
	return CSScript.LuaManager:CheckCurrentAnimationIsPlaying(animation,animName)
end


function CommonHelper.ClearNetMsgQueue()
	CSScript.NetworkManager:ClearRecieveMsgQueue()
end



return CommonHelper
