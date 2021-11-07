ViewHST = class(Module)

function ViewHST:Name()
	return "ViewHST"
end

function ViewHST:internalName()
	return "viewhst"
end

function ViewHST:Update()
	local f = self.game:Frame()
	if f % 23 == 0 then
        self.ai.friendlyTeamID = {}
        self.ai.friendlyTeamID[self.game:GetTeamID()] = true
        for teamID, _ in pairs(self.ai.alliedTeamIds) do
            self.ai.friendlyTeamID[teamID] = true
        end
		-- update enemy jamming and populate list of enemies
		local enemies = self.game:GetEnemies()

		if enemies ~= nil then
			for i, e in pairs(enemies) do
				--self:unitLosState(e:ID())
				--local uname = e:Name()
				--local upos = e:GetPosition()

			end
		end
	end
end
--[[
LOS
15 1111 have the los so other info are useless LOS
14 1110
13 1101
12 1100
11 1011
10 1010
9  1001
8  1000 last of LOS
RADAR
7 0111 in radar, already seen and have continous coverage so keep the ID last IDDD
6 0110 in R already in L but intermittent so pure RADAR
5 0101 in radar, and in continous coverage after los, but never in los so IMPOSSIBLE
4 0100 in PURE radar, never in los

3 0011 just already seen but not in R or L tecnically IMPOSSIBLE
2 0010  just already seen but not in R or L usable for a building that we know its already there

1 0001 not in radar not in los but continous.... IMPOSSIBLE



]]--
function ViewHST:Init()
	self:DebugEnabled = false
	self.mobileLos = {}
	self.immobileLos = {}
	self.mobileRadar = {}
	self.immobileRadar = {}

end

function ViewHST:ScanEnemy(enemy)
	local Ename = enemy:Name()
	local Epos = enemy:GetPosition()
	local guls = Spring.GetUnitLosState(enemy:ID() ,0,true)
	local e = {}

	if self.ai.buildsitehst:isInMap(Epos) then
		if guls >= 6 then --in los or in radar with continous coverage so is a clear unit
			local Especs = self.ai.armyhst.unitTable[Ename]
			local EMetal = Especs.metalCost
			local Emtype = Especs.Mtype
			local Eweapon = Especs .
			if Especs.isBuilding then



			--LOS
		elseif guls == 4 then --pure radar, never see in a los
			--pure radar
		else
			self:Warn('getunitlosstate give unespectetd code',guls)
		end
	end
end



end
