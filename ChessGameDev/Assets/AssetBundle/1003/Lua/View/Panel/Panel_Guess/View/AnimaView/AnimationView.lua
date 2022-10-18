AnimationView=Class()

function AnimationView:ctor(gameObj)
	self:Init(gameObj)

end

function AnimationView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function AnimationView:InitData()
	self.Animator=GameManager.GetInstance().Animator
	self.BookmakerAnimaList={}
	self.LeftPesonAnimaList={}
	self.RightPesonAnimaList={}
end



function AnimationView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function AnimationView:FindView(tf)
	self:FindBookmakerView(tf)
	self:FindLeftPesonView(tf)
	self:FindRightPesonView(tf)
end


function AnimationView:FindBookmakerView(tf)
	local bkAnima=tf:Find("Bookmaker/BookmakerAnim/ReadyAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.BookmakerAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/BookmakerAnim/WaitAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.BookmakerAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/BookmakerAnim/OpenAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.BookmakerAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/BookmakerAnim/WinAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.BookmakerAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/BookmakerAnim/LoseAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.BookmakerAnimaList,bkAnima)
end


function AnimationView:FindLeftPesonView(tf)
	local bkAnima=tf:Find("Bookmaker/LeftAnim/LeftWaitAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.LeftPesonAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/LeftAnim/LeftLoseAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.LeftPesonAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/LeftAnim/LeftWin1Anim"):GetComponent(typeof(self.Animator))
	table.insert(self.LeftPesonAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/LeftAnim/LeftWin2Anim"):GetComponent(typeof(self.Animator))
	table.insert(self.LeftPesonAnimaList,bkAnima)
end


function AnimationView:FindRightPesonView(tf)
	local bkAnima=tf:Find("Bookmaker/RightAnim/RightWaitAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.RightPesonAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/RightAnim/RightLoseAnim"):GetComponent(typeof(self.Animator))
	table.insert(self.RightPesonAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/RightAnim/RightWin1Anim"):GetComponent(typeof(self.Animator))
	table.insert(self.RightPesonAnimaList,bkAnima)
	bkAnima=tf:Find("Bookmaker/RightAnim/RightWin2Anim"):GetComponent(typeof(self.Animator))
	table.insert(self.RightPesonAnimaList,bkAnima)
end


function AnimationView:InitViewData()
	--self:IsSelectPlay(1,self.BookmakerAnimaList,true)
	--self:IsSelectPlay(1,self.LeftPesonAnimaList,true)
	--self:IsSelectPlay(1,self.RightPesonAnimaList,true)
end


function AnimationView:IsSelectPlay(pIndex,targetList,isShow)
	CommonHelper.IsShowPanel(pIndex,targetList,isShow,false,false)
end



function AnimationView:PlayBookmakerAnim(index,isShow)
	self:IsSelectPlay(index,self.BookmakerAnimaList,isShow)
end



function AnimationView:PlayLeftPesonAnim(index,isShow)
	self:IsSelectPlay(index,self.LeftPesonAnimaList,isShow)
end



function AnimationView:PlayRightPesonAnim(index,isShow)
	self:IsSelectPlay(index,self.RightPesonAnimaList,isShow)
end

