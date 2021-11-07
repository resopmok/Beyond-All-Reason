DefenderHST = class(Module)

function DefenderHST:Name()
	return "DefenderHST"
end

function DefenderHST:internalName()
	return "defenderhst"
end


function DefenderHST:Init()
	self.DebugEnabled = true
	self.distal = 0
end
--Spring.GetUnitDirection ( number unitID )
--Spring.GetUnitVelocity ( number unitID )
function DefenderHST:Update()
	local f = game:Frame()
	if f % 179 ~= 0 then
		return
	end
	map:EraseAll(6)
	self.CENTER = api.Position()
	local count = 0
	self.distal = 0
	local media = 0
	local mediaz = 0
	local countmedia = 0
	self.distalUnit = nil
	local myunits = game:GetUnits() --game:GetFriendlies()???
	self:EchoDebug('myunits',#myunits)
	if not myunits then return end
	for i,u in pairs(myunits) do
		local ut = self.ai.armyhst.unitTable[u:Name()]
		if not ut.isWeapon then
			local upos = u:GetPosition()
			self.CENTER.x = self.CENTER.x + upos.x
			self.CENTER.y = self.CENTER.y + upos.y
			self.CENTER.z = self.CENTER.z + upos.z
			count = count+1
		end
	end
	self.CENTER.x = self.CENTER.x / count
	self.CENTER.y = self.CENTER.y / count
	self.CENTER.z = self.CENTER.z / count
	self:EchoDebug('CENTER',self.CENTER.x,self.CENTER.z, 'count',count)
	for i,u in pairs(myunits) do
		local ut = self.ai.armyhst.unitTable[u:Name()]
		if ut.isImmobile then
			local upos = u:GetPosition()
			local dist = self.ai.tool:Distance(self.CENTER,upos)
			media = media + dist
			if self.distal  > dist then
				self.distalUnit = u
			end
			self.distal = math.max(self.distal,dist)

			countmedia = countmedia + 1
		end
	end
	media = media /countmedia
	map:DrawCircle(self.CENTER, media, {1,0,0,1}, nil, false, 6)
	map:DrawCircle(self.CENTER, self.distal, {0,1,0,1}, nil, false, 6)
	map:DrawCircle(self.CENTER, (media+self.distal)/2, {0,0,1,1}, nil, false, 6)
end

