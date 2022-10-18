TipsFish=Class(FishBase)

function TipsFish:ctor()
	self:Init()

end

function TipsFish:Init ()
	self:InitData()
end


function TipsFish:InitData()
	self.AnimParams={"Fish_Move"}
	
end


function TipsFish:BuildFish(vo,obj)
	self:InitBaseFish(vo,obj)
	self:FindView()
	self:InitViewData()
end


function TipsFish:ResetFishState(vo)
	self:ResetBaseFishStateData(vo)
	self:PlayAnim(1,false)
end



function TipsFish:FindView()
	local mTransfrom=self.gameObject.transform
	self.SpineAnim=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
	self.SpineMeshRenderer=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
end



function TipsFish:InitViewData()
	self:PlayAnim(1,false)
	
end


function TipsFish:PlayAnim(index,isLoop)
	if self.SpineAnim then
		local animName=self.AnimParams[index]
		if animName then
			self.SpineAnim.loop=isLoop
			self.SpineAnim.state:SetAnimation(0,animName,isLoop)
		end
	end
end



function TipsFish:SetMainFishOrder(orderIndex)
	if self.SpineMeshRenderer then
		self.SpineMeshRenderer.sortingOrder=orderIndex
	end
end


function TipsFish:FishNormalDie()
	
	
end




function TipsFish:__delete()
	
	
end