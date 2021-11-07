
local DebugDrawEnabled = false


LosHST = class(Module)

local sqrt = math.sqrt
local losGridElmos = 128
local losGridElmosHalf = losGridElmos / 2
local gridSizeX
local gridSizeZ

function LosHST:Name()
	return "LosHST"
end

function LosHST:internalName()
	return "loshst"
end



function LosHST:Init()
	self.DebugEnabled = false
	self.knownEnemies = {}
	self.ai.friendlyTeamID = {}
end

function LosHST:Update()
	local f = self.game:Frame()
	if f % 23 == 0 then
		--self.RADAR = scanEnemies2()
        self.ai.friendlyTeamID = {}
        self.ai.friendlyTeamID[self.game:GetTeamID()] = true
        for teamID, _ in pairs(self.ai.alliedTeamIds) do
            self.ai.friendlyTeamID[teamID] = true
        end
		-- update enemy jamming and populate list of enemies
		local enemies = self.game:GetEnemies()
		if enemies ~= nil then
			local enemyList = {}
			for i, e in pairs(enemies) do
				--self:unitLosState(e:ID())
				local upos = e:GetPosition()
				if not upos then --is dead
					self:cleanEnemy(e:ID())
				elseif self.ai.buildsitehst:isInMap(upos) then
					enemy = self:scanEnemy(e)
					if enemy then
						self.knownEnemies[e:ID()] = enemy
					end
				end
			end
		end
		self:Draw() --debugit
	end
end

function LosHST:UnitDead(unit)
	if self.knownEnemies[unit:ID()] then
		self:cleanEnemy(unit:ID())
	end
end

function LosHST:UnitDamaged(unit, attacker, damage)
	if  attacker ~= nil then --forse siamo arrivati che anora qua devo controllare chi ally è perchè magari in attacco fa casino
		self:scanEnemy(attacker,true) --a shoting unit is individuable by a medium player so is managed as a unit in LOS :full view
	end
end

function LosHST:cleanEnemy(id)

	if self.ai.IDsWeAreAttacking[id] then
		--self.ai.attackhst:TargetDied(self.ai.IDsWeAreAttacking[id])
	end
	if self.ai.IDsWeAreRaiding[id] then
		--self.ai.raidhst:TargetDied(self.ai.IDsWeAreRaiding[id])
	end
	if self.knownEnemies[id] then
		self:EchoDebug('clean',id,self.knownEnemies[id].name,self.knownEnemies[id].guls,self.knownEnemies[id].mobile)
		table.remove(self.knownEnemies,id)
	end
end

function LosHST:scanEnemy(enemy,isShoting)
	-- game:SendToConsole("updating known enemies")
	local t = {} --a temporary table
	local id = enemy:ID()
	t.name = enemy:Name()
	local ut =self.ai.armyhst.unitTable[t.name]
	if not t.name then
		self:Warn('nil name')
	end
	t.position = enemy:GetPosition() --if is died pos is nil -- exixtance check

	--we are interessed where the unit is right now, this is the threatening DEFENSIVE
	t.HIT = ut.HIT -- this is the most important OFFENSIVE data
	t.hitBy = ut.hitBy
	t.layer = ut.layer
	t.knownid = true
	t.hidden = false
	t.mobile = ut.speed > 0
	t.health = enemy:GetHealth()
	local moveType =ut.mtype

	if not t.position then
		self:cleanEnemy(id)
	else
		if not enemy:IsCloaked() or isShoting then --full view
			local GULS = Spring.GetUnitLosState(id ,self.ai.allyId,true)
			t.guls = GULS
			if GULS >= 7 or isShoting then
				t.speed = Spring.GetUnitVelocity ( id ) --TODO keep dir and speed
				t.los = true
				t.knownEnemy = true
				t.detect = true
				if moveType == 'air' then
					t.air = true --seem cheat but it's not cause a player distingue a airplain in the enemy units
					self.ai.needAntiAir = true --TODO need to move from here
				elseif t.position.y < 0 then
					t.uw = true
					if moveType == 'amp' then
						t.amp = true
					elseif t.moveType == 'sub' then
						t.sub = true
					else
						self:Warn('unespected moveType underWater',t.position.x,t.position.z,t.name,moveType)
					end
				else
					t.surface = true
					if self.ai.maphst:IsUnderWater(t.position) then --TEST
						t.water = true
					else
						t.ground = true
					end
				end
			elseif GULS == 6 and not self.ai.armyhst.unitTable[t.name].stealth and not Spring.IsUnitInJammer ( id, self.ai.allyId )  then --radar +prevlos
				if t.immobile then
					t.los = true
				end
				t.radar = true
				t.speed = Spring.GetUnitVelocity ( id ) --TODO keep dir and speed
				t.knownid = false
				t.knownEnemy = true
				t.detect = false

			elseif GULS == 2   and not self.ai.armyhst.unitTable[t.name].stealth and not Spring.IsUnitInJammer ( id, self.ai.allyId )  then --radar
				t.radar = true
				t.speed = Spring.GetUnitVelocity ( id ) --TODO keep dir and speed
				t.knownid = false
				t.knownEnemy = true
				t.detect = false
			elseif GULS == 4 then --no radar, no los, i know you are there
				if t.mobile then
					t.hidden = true --is somewhere
				else
					--immobile are where we know
				end
			elseif GULS == 0 then
				--totally unknow
				t = nil
				self:cleanEnemy(id)
			else
				self:Warn('unespected GULS response',GULS,id,t.position)
				self:cleanEnemy(id)
			end
		end
	end
	return t
end

function LosHST:IsKnownEnemy(unit)
	local id = unit:ID()
	return self.knownEnemies[id]
end


function LosHST:LosPos(upos)
	local LosOrRadar, inLos, inRadar, jammed = Spring.GetPositionLosState(upos.x, upos.y, upos.z, self.ai.allyId)
	if inLos then return 'inLos' end
	if Spring.IsPosInAirLos(upos.x, upos.y, upos.z, self.ai.allyId) then return 'inAir' end
	if inRadar and upos.y < 0 and not jammed then return 'inSonar' end
	if inRadar and upos.y >= 0 and not jammed then return 'inRadar' end
	return 'blind'
end

function LosHST:Draw()
	self.map:EraseAll(5)

	for id,data in pairs(self.knownEnemies) do

		local u = self.game:GetUnitByID(id)
		u:EraseHighlight(nil, nil, 5 )
-- 		self:Warn('unitidlosdraw',id,u:GetPosition())
-- 		print(u:GetPosition())
 		if not u:GetPosition() then
 			self:Warn('unit dead',id)
 			self:cleanEnemy(id)

-- 		self:Warn('losname',data.name)

		else
			self:Warn(data.name,data.guls)
			if data.los then
				if data.air then
					u:DrawHighlight({1,1,0,1} , nil, 5 )
				end
				if data.uw then
					u:DrawHighlight({1,0,1,1} , nil, 5 )
				end
				if data.water then
					u:DrawHighlight({0,1,1,1} , nil, 5 )
				end
				if data.ground then
					u:DrawHighlight({1,0,0,1} , nil, 5 )
				end
			end
			if data.radar then
				u:DrawHighlight({1,1,1,1} , nil, 5 )
			end
			if data.hidden then
				u:DrawHighlight({0,0,0,1} , nil, 5 )
			end
			if not data.mobile then
				u:DrawHighlight({0,1,0,1} , nil, 5 )
			end
		end
	end
end




--[[ suggested of beherith
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
2 0010  just already seen but not in R or L usable for a building that we know its already there and mobile that is there but where?

1 0001 not in radar not in los but continous.... IMPOSSIBLE
]]--





--[[ 1los 2 prev los 3 in rad 4 continous rad maybe this is correct
LOS
15 1111 have the los so other info are useless LOS
14 1110
13 1101
12 1100
11 1011
10 1010
9  1001
8  1000 last of LOS first time i see it

7 0111 see one time, in radar with continous LOS

RADAR
6 0110 see one time, in radar but intermittent so is RADAR
5 0101 see one time, no in radar but have continous radar?? IMPOSSIBLE
4 0100 see on time, now HIDDEN

3 0011 never seen ,in radar, with continous coverage ?? IMPOSSIBLE
2 0010 just in radar, never seen RADAR

1 0001 not in radar not in los but continous.... IMPOSSIBLE
]]--


--[[int LuaSyncedRead::GetUnitLosState(lua_State* L)
{
    const CUnit* unit = ParseUnit(L, __func__, 1);
    if (unit == nullptr)
        return 0;

    const int allyTeamID = GetEffectiveLosAllyTeam(L, 2);
    unsigned short losStatus;
    if (allyTeamID < 0) {
        losStatus = (allyTeamID == CEventClient::AllAccessTeam) ? (LOS_ALL_MASK_BITS | LOS_ALL_BITS) : 0;
    } else {
        losStatus = unit->losStatus[allyTeamID];
    }

    constexpr int currMask = LOS_INLOS   | LOS_INRADAR;
    constexpr int prevMask = LOS_PREVLOS | LOS_CONTRADAR;

    const bool isTyped = ((losStatus & prevMask) == prevMask);

    if (luaL_optboolean(L, 3, false)) {
        // return a numeric value
        if (!CLuaHandle::GetHandleFullRead(L))
            losStatus &= ((prevMask * isTyped) | currMask);

        lua_pushnumber(L, losStatus);
        return 1;
    }

    lua_createtable(L, 0, 3);
    if (losStatus & LOS_INLOS) {
        HSTR_PUSH_BOOL(L, "los", true);
    }
    if (losStatus & LOS_INRADAR) {
        HSTR_PUSH_BOOL(L, "radar", true);
    }
    if ((losStatus & LOS_INLOS) || isTyped) {
        HSTR_PUSH_BOOL(L, "typed", true);
    }
    return 1;
}
ugh this is nasty
ok raw means it returns number instead of table
so the numeric integer of the mask bits
and I dont think you can get wether a unit is seen in airlos or regular los
its either seen or not
raw is generally preferred, as is much faster in than creating a table
isnt 'typed' meaning that its a radar dot that has been revealed or not?
I definately think so
so if you use raw = true
then result = 15 ( 1 1 1 1 ) means in radar, in los, known unittype
also, if result is > 2, that means that the unitdefID is known
cause the unitdefID of a unit is 'forgotten' if the unit leaves radar
so the key info here is these 4 bits:
I think the bits might be:
bit 0 : LOS_INLOS, unit is in LOS right now,
bit 1 : LOS_INRADAR unit is in radar right now,
bit 2: LOS_PREVLOS unit was in los at least once already, so the unitDefID can be queried
bit 3: LOS_CONTRADAR: unit has had continous radar coverage since it was spotted in LOS]]--
