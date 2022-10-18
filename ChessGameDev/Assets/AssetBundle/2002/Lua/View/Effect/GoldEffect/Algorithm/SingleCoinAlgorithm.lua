SingleCoinAlgorithm=Class()

function SingleCoinAlgorithm:ctor()
	self:Init()
end


function SingleCoinAlgorithm:Init ()
	self:InitData()
end


function SingleCoinAlgorithm:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	
end

function SingleCoinAlgorithm:GetMuiltpleGoldEffect(targetTf,width,height,radius,offset)
	self:ResetState(targetTf,radius,width,height,offset)
	return self:BuildAlgo()
end


function SingleCoinAlgorithm:ResetState(targetTf,radius,width,height,offset)
	self.TargetTf=targetTf
	self.Radius=radius
	self.Width = width
	self.Height = height
	self.Offset = offset
end

local PoissonDiskSample = CS.PoissonDiskSample
function SingleCoinAlgorithm:BuildAlgo()
	local bornPosList = PoissonDiskSample.GetCoinCoordinate(self.Width,self.Height,self.Radius,self.TargetTf,self.Offset)
	return bornPosList
end



