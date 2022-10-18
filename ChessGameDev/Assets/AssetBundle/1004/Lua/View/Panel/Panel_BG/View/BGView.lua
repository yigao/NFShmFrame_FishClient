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
	self.BGTipsList={}
end



function BGView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function BGView:FindView(tf)
	self:FindMainBGView(tf)
	self:FindIconBGView(tf)
	self:FindBKBGView(tf)
	self:FindBGTipsView(tf)
end


function BGView:FindMainBGView(tf)
	for i=1,2 do
		local tempBG=tf:Find("AllBg/BG"..(i)).gameObject
		table.insert(self.MainBGList,tempBG)
	end
end


function BGView:FindIconBGView(tf)
	for i=1,3 do
		local tempBG=tf:Find("AllBg/IconBG/IBG/BG"..(i)).gameObject
		table.insert(self.IconBGList,tempBG)
	end
end


function BGView:FindBKBGView(tf)
	for i=1,2 do
		local tempBG=tf:Find("AllBg/IconBG/IDIBan/DIBan"..(i)).gameObject
		table.insert(self.BKBGList,tempBG)
	end
end


function BGView:FindBGTipsView(tf)
	for i=1,3 do
		local tempBG=tf:Find("AllBg/BGTips/ImageBG/ImageTipsList/Image"..(i)).gameObject
		table.insert(self.BGTipsList,tempBG)
	end
end