MainIconView=Class()

function MainIconView:ctor(gameObj)
	self:Init(gameObj)

end

function MainIconView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	
end


function MainIconView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Animation=GameManager.GetInstance().Animation
	
	self.MainIconParentList={}
	self.MainIconItemList={}
end



function MainIconView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function MainIconView:FindView(tf)
	self:FindMainIconView(tf)
	self:FindMainIconItemView(tf)
end


function MainIconView:FindMainIconView(tf)
	for i=1,24 do
		local tempIcon=tf:Find("BasePanel/MainPanel/MainIconPosList/Icon"..i).gameObject
		if tempIcon then
			table.insert(self.MainIconParentList,tempIcon)
		else
			Debug.LogError("查找bonus主图异常")
		end
	end
end


function MainIconView:FindMainIconItemView(tf)
	for i=1,9 do
		local tempIcon=tf:Find("BasePanel/MainPanel/BonusItem/BonusItem"..(i-1)).gameObject
		if tempIcon then
			table.insert(self.MainIconItemList,tempIcon)
		else
			Debug.LogError("查找bonusItem图标异常")
		end
	end
	
end







function MainIconView:InitViewData()
	
end



function MainIconView:__delete()

end