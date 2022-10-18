LotteryHostoryView=Class()

function LotteryHostoryView:ctor(gameObj)
	self:Init(gameObj)

end

function LotteryHostoryView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function LotteryHostoryView:InitData()
	self.LotterHostoryObjList={}
end



function LotteryHostoryView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function LotteryHostoryView:FindView(tf)
	for i=1,15 do
		local tempLH=tf:Find("Tips/HostoryWinTips/HTips"..i).gameObject
		table.insert(self.LotterHostoryObjList,tempLH)
	end
end


function LotteryHostoryView:InitViewData()
	
end


