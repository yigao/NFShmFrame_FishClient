--lua端打印日志必须使用如下接口，方便管理
LogManager={}
LogManager.IsPrintLog=CSScript.LuaManager.IsOpenLuaLog
function printLuaLog(...)
	if LogManager.IsPrintLog then
		print(...)
	end
end

Debug={}

function Debug.Log(strMsg)
	if LogManager.IsPrintLog==false then  return end
	CSScript.Log(strMsg)
end

function Debug.LogError(strMsg)
	if LogManager.IsPrintLog==false then  return end
	CSScript.Log.Error(strMsg)
end

function pt(...)
	if LogManager.IsPrintLog then
		local arg={...}
		local has=false
		for _,v in pairs(arg) do
			if v and type(v)=="table" then
				has=true
				break
			end
		end
		if not has then
			print(...)
		end
		
		local content=""
		for _,v in pairs(arg) do
			if v=="table" then
				content=content..tostring(v).."\n"
			else
				content=content.."==>[T]:"..LuaPrint(v,limit),debug.traceback().."\n"
			end
			print(content)
		end
		
	end
end


function LuaPrint(lua_table,limit,indent,step)
	step=step or 0
	indent=indent or 0
	local content=""
	if limit~=nil then
		if step>limit then
			return "..."
		end
	end
	if step>10 then
		return content.."..."
	end
	if lua_table==nil then
		return "nil"
	end
	if type(lua_table)=="userdata"  or type(lua_table)=="lightuserdata" or type(lua_table)=="thread" then
		return tostring(lua_table)
	end

	if type(lua_table)=="string"  or type(lua_table)=="number"  then
		return "[No-Table]:"..lua_table
	end
	
	for k,v in pairs(lua_table) do
		if k~="_class_type" then
			local szBuffer=""
			 Typev=type(v)
			if Typev =="table" then
				szBuffer="{"
			end
			local szPrefix=string.rep("  ",indent)
			if Typev=="table" and v._fields then
				local kk,vv=next(v._fields)
				if type(vv)=="table" then
					content=content.."\n\t"..kk.name.."={"..LuaPrint(vv._fields,5,indent+1,step+1).."}"
				else
					content=content.."\n\t"..kk.name.."="..vv
				end
			else
				if type(k)=="table" then
					if k.name then
						if type(v)~="table" then
							content=content.."\n"..k.name.."="..v
						else
							content=content.."\n"..k.name.." = list:"
							local tmp="\n"
							for ka,va in ipairs(v) do
								tmp=tmp.."#"..ka.."_"..tostring(va)
							end
							content=content..tmp
						end
					end
					
				elseif type(k)=="function" then
					content=content.."\n fun=function"
				else
					 formatting=szPrefix..tostring(k).." = "..szBuffer
					if Typev=="table" then
						content=content.."\n"..formatting
						content=content..LuaPrint(v,limit,indent+1,step+1)
						content=content.."\n"..szPrefix.."},"
					else
						local szValue=""
						if Typev=="string" then
							szValue=string.format("%q",v)
						else
							szValue=tostring(v)
						end
						content=content.."\n"..formatting..(szValue or "nil")..","
					end
				end
				
				
			end
		end
	end
	return content
end

return LogManager