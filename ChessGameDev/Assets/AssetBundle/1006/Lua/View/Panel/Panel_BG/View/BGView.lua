BGView=Class()

function BGView:ctor(gameObj)
	self:Init(gameObj)

end

function BGView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function BGView:InitData()
	self.MainBGList={}
	self.IconBGList={}
	self.BKBGList={}
end



function BGView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function BGView:FindView(tf)
	self:FindMainBGView(tf)
end


function BGView:FindMainBGView(tf)
	for i=1,2 do
		local tempBG=tf:Find("AllBg/BG"..(i)).gameObject
		table.insert(self.MainBGList,tempBG)
	end
end




