function gadget:GetInfo()
	return {
		name = "Mex Upgrader Gadget",
		desc = "Upgrades mexes.",
		author = "author: BigHead, modified by DeadnightWarrior",
		date = "September 13, 2007",
		license = "GNU GPL, v2 or later",
		layer = 0,
		enabled = true
	}
end

local modoption_unba = Spring.GetModOptions().unba

local ignoreWeapons = false --if the only weapon is a shield it is ignored
local ignoreStealth = false

local math_sqrt = math.sqrt

local GetTeamUnits = Spring.GetTeamUnits
local GetUnitDefID = Spring.GetUnitDefID
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetUnitPosition = Spring.GetUnitPosition
local GetGroundHeight = Spring.GetGroundHeight
local GetUnitTeam = Spring.GetUnitTeam
local GetCommandQueue = Spring.GetCommandQueue
local FindUnitCmdDesc = Spring.FindUnitCmdDesc
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local SendMessageToTeam = Spring.SendMessageToTeam
local ValidUnitID = Spring.ValidUnitID
local GetUnitIsDead = Spring.GetUnitIsDead

local builderDefs = {}
local mexDefs = {}

local mexes = {}
local builders = {}

local IDLE = 0
local FOLLOWING_ORDERS = 1
local RECLAIMING = 2
local BUILDING = 3

local scheduledBuilders = {}
local addFakeReclaim = {}
local addCommands = {}

local CMD_RECLAIM = CMD.RECLAIM
local CMD_STOP = CMD.STOP
local CMD_INSERT = CMD.INSERT
local CMD_OPT_INTERNAL = CMD.OPT_INTERNAL

local CMD_AUTOMEX = 31143
local CMD_UPGRADEMEX = 31244

local ONTooltip = "Metal extractors are upgraded\nautomatically by this builder."
local OFFTooltip = "Metal extractors wont be upgraded\nautomatically by this builder."

local autoMexCmdDesc = {
	id = CMD_AUTOMEX,
	type = CMDTYPE.ICON_MODE,
	name = 'Auto Mex Upgrade',
	cursor = 'upgmex',
	action = 'automex',
	tooltip = ONTooltip,
	params = { '0', 'UpgMex OFF', 'UpgMex ON' }
}

local upgradeMexCmdDesc = {
	id = CMD_UPGRADEMEX,
	type = CMDTYPE.ICON_UNIT_OR_AREA,
	name = 'Upgrade Mex',
	cursor = 'upgmex',
	action = 'upgrademex',
	tooltip = 'Upgrade Mex',
	hidden = false,
	params = {}
}

local function processMexData(mexDefID, mexDef, upgradePairs)
	for defID, def in pairs(mexDefs) do
		--mexDef.water won't match; "water" mexes are the same as land mexes.
		if (mexDef.water == def.water or mexDef.water ~= def.water) and (ignoreStealth or mexDef.stealth == def.stealth) and (ignoreWeapons or mexDef.armed == def.armed) then
			if mexDef.extractsMetal > def.extractsMetal then
				if not upgradePairs then
					upgradePairs = {}
				end
				local upgrader = upgradePairs[defID]
				if not upgrader or mexDef.extractsMetal > mexDefs[upgrader].extractsMetal then
					upgradePairs[defID] = mexDefID
				end
			end
		end
	end

	return upgradePairs
end

local function determine()
	-- register cursor
	Spring.AssignMouseCursor("upgmex", "cursorupgmex", false)
	Spring.AssignMouseCursor("areamex", "cursorareamex", false)
	-- show the command in the queue
	Spring.SetCustomCommandDrawData(CMD_UPGRADEMEX, "upgrademex", { 0.75, 0.75, 0.75, 0.7 }, true)
	Spring.SetCustomCommandDrawData(CMD_AUTOMEX, "automex", { 0.75, 0.75, 0.75, 0.7 }, true)

	local tmpbuilders = {}
	for unitDefID, unitDef in pairs(UnitDefs) do
		if unitDef.isBuilder and unitDef.canAssist then
			tmpbuilders[#tmpbuilders + 1] = unitDefID
		else
			local extractsMetal = unitDef.extractsMetal
			if extractsMetal > 0 then
				local mexDef = {}
				mexDef.extractsMetal = extractsMetal
				if #unitDef.weapons <= 1 then
					if #unitDef.weapons == 1 and WeaponDefs[unitDef.weapons[1].weaponDef].isShield then
						mexDef.armed = #unitDef.weapons < 0
					else
						mexDef.armed = #unitDef.weapons > 0
					end
				else
					mexDef.armed = #unitDef.weapons > 0
				end
				mexDef.stealth = unitDef.stealth
				mexDef.water = unitDef.minWaterDepth >= 0
				mexDefs[unitDefID] = mexDef
			end
		end
	end

	for _, unitDefID in ipairs(tmpbuilders) do
		local upgradePairs = nil
		for _, optionID in ipairs(UnitDefs[unitDefID].buildOptions) do
			local mexDef = mexDefs[optionID]
			if mexDef then
				upgradePairs = processMexData(optionID, mexDef, upgradePairs)
			end
		end
		if upgradePairs then
			builderDefs[unitDefID] = upgradePairs
		end
	end
end

if gadgetHandler:IsSyncedCode() then

	local isCommander = {}
	local unitXsize = {}
	for unitDefID, unitDef in pairs(UnitDefs) do
		if unitDef.customParams.iscommander then
			isCommander[unitDefID] = true
		end
		unitXsize[unitDefID] = unitDef.xsize
	end

	local function orderBuilder(unitID, mexID)
		addCommands[unitID] = { cmd = CMD_INSERT, params = { 1, CMD_UPGRADEMEX, CMD_OPT_INTERNAL, mexID }, options = { "alt" } }

		gadgetHandler:UpdateCallIn("GameFrame")
	end

	local function getDistance(unitID, mexID, teamID)
		local x1, _, y1 = GetUnitPosition(unitID)
		local mex = mexes[teamID][mexID]
		local x2, y2 = mex.x, mex.z

		if not (x1 and y1 and x2 and y2) then
			return math.huge
		end --hack

		return math_sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
	end

	local function getDistanceFromPosition(x1, y1, mexID, teamID)
		local mex = mexes[teamID][mexID]
		local x2, y2 = mex.x, mex.z

		if not (x2 and y2) then
			return math.huge
		end --hack

		return math_sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
	end

	local function getUnitPhase(unitID, teamID)
		local commands = GetCommandQueue(unitID, 1)
		if #commands == 0 then
			return IDLE
		end
		local cmd = commands[1]
		local builder = builders[teamID][unitID]

		if cmd.id == CMD_RECLAIM and cmd.params[1] == builder.targetMex then
			return RECLAIMING

		elseif builder.targetUpgrade and cmd.id == builder.targetUpgrade then
			return BUILDING
		else
			return FOLLOWING_ORDERS
		end
	end

	local function assignClosestBuilder(mexID, mex, teamID)
		local bestDistance = nil
		local bestBuilder, bestBuilderID = nil, nil
		local mexDefID = mex.unitDefID

		for unitID, builder in pairs(builders[teamID]) do
			if builder.autoUpgrade and getUnitPhase(unitID, teamID) == IDLE then
				local upgradePairs = builderDefs[builder.unitDefID]
				local upgradeTo = upgradePairs[mexDefID]
				if upgradeTo then
					local dist = getDistance(unitID, mexID, teamID)
					if not bestDistance or dist < bestDistance then
						bestDistance = dist
						bestBuilder = builder
						bestBuilderID = unitID
					end
				end
			end
		end

		if bestBuilder then
			orderBuilder(bestBuilderID, mexID)
		end
	end

	local function updateCommand(unitID, insertID, cmd)
		local cmdDescId = FindUnitCmdDesc(unitID, cmd.id)
		if not cmdDescId then
			InsertUnitCmdDesc(unitID, insertID, cmd)
		else
			EditUnitCmdDesc(unitID, cmdDescId, cmd)
		end
	end

	local function addLayoutCommands(unitID)
		local insertID = FindUnitCmdDesc(unitID, CMD.CLOAK) or
			FindUnitCmdDesc(unitID, CMD.ONOFF) or
			FindUnitCmdDesc(unitID, CMD.TRAJECTORY) or
			FindUnitCmdDesc(unitID, CMD.REPEAT) or
			FindUnitCmdDesc(unitID, CMD.MOVE_STATE) or
			FindUnitCmdDesc(unitID, CMD.FIRE_STATE) or
			123456 -- back of the pack

		autoMexCmdDesc.params[1] = '0'
		updateCommand(unitID, insertID + 1, autoMexCmdDesc)
		updateCommand(unitID, insertID + 2, upgradeMexCmdDesc)
	end

	local function registerUnit(unitID, unitDefID, unitTeam)
		if builderDefs[unitDefID] then
			local builder = {}
			builder.unitDefID = unitDefID
			builder.autoUpgrade = false
			builder.buildDistance = UnitDefs[unitDefID].buildDistance
			builder.teamID = unitTeam
			builder.maxDepth = UnitDefs[unitDefID].maxWaterDepth or 9999
			builder.minDepth = UnitDefs[unitDefID].minWaterDepth or 9999
			builders[unitTeam][unitID] = builder

			addLayoutCommands(unitID)

		elseif mexDefs[unitDefID] then
			local mex = {}
			mex.unitDefID = unitDefID
			mex.teamID = unitTeam
			mex.x, mex.y, mex.z = GetUnitPosition(unitID)
			mexes[unitTeam][unitID] = mex
			assignClosestBuilder(unitID, mex, unitTeam)
		end
	end

	local function registerUnits()
		local teams = Spring.GetTeamList()
		for _, teamID in ipairs(teams) do
			builders[teamID] = {}
			mexes[teamID] = {}
			local units = GetTeamUnits(teamID)
			for i = 1, #units do
				local unitID = units[i]
				local unitDefID = GetUnitDefID(unitID)
				registerUnit(unitID, unitDefID, teamID)
			end
		end
	end

	function gadget:Initialize()
		determine()
		registerUnits()
	end

	-- This part of the code actually does somethings (upgrades mexes)
	function gadget:GameFrame(n)
		for unitID, data in pairs(addCommands) do
			GiveOrderToUnit(unitID, data.cmd, data.params, data.options)
		end
		addCommands = {}

		for unitID, data in pairs(scheduledBuilders) do
			local teamID = GetUnitTeam(unitID)
			if builders[teamID] then
				local builder = builders[teamID][unitID]
				local y = GetGroundHeight(builder.targetX, builder.targetZ)
				local blockers = {}
				local hsize = unitXsize[builder.targetUpgrade] * 4
				for x = builder.targetX - hsize + 4, builder.targetX + hsize, 8 do
					for z = builder.targetZ - hsize + 4, builder.targetZ + hsize, 8 do
						local typ, blocker = Spring.GetGroundBlocked(x, z)
						if blocker and not blockers[blocker] then
							GiveOrderToUnit(unitID, CMD.RECLAIM, { blocker }, { "shift" })
							blockers[blocker] = true
						end
					end
				end
				GiveOrderToUnit(unitID, CMD_INSERT, { -1, -builder.targetUpgrade, CMD_OPT_INTERNAL, builder.targetX, y, builder.targetZ, 0 }, { "shift", "alt" })
				builder.orderTaken = true
			end
		end
		scheduledBuilders = {}

		for unitID, _ in pairs(addFakeReclaim) do
			local commands = GetCommandQueue(unitID, 20)
			for i = 1, #commands do
				local cmd = commands[i]
				if cmd.id == CMD_UPGRADEMEX and not (commands[i + 1] and commands[i + 1].id == CMD_RECLAIM) then
					GiveOrderToUnit(unitID, CMD_INSERT, { i, CMD_RECLAIM, CMD_OPT_INTERNAL + 1, cmd.params[1] }, { "alt" })
				end
			end

		end
		addFakeReclaim = {}

		gadgetHandler:RemoveCallIn("GameFrame")
	end

	local function getClosestMex(unitID, upgradePairs, teamID, mexesInRange)
		local bestDistance = nil
		local bestMexID, bestMexDefID = nil, nil

		if not mexesInRange then
			mexesInRange = mexes[teamID]
		end

		for mexID, mex in pairs(mexesInRange) do
			if not mex.assignedBuilder then
				local mexDefID = mex.unitDefID
				local upgradeTo = upgradePairs[mexDefID]
				if upgradeTo then
					local dist = getDistance(unitID, mexID, teamID)
					local mexDepth = select(2, GetUnitPosition(mexID))
					if mexDepth >= -builders[teamID][unitID].maxDepth and mexDepth <= -builders[teamID][unitID].minDepth then
						if not bestDistance or dist < bestDistance then
							bestDistance = dist
							bestMexID, bestMexDefID = mexID, mexDefID
						end
					end
				end
			end
		end

		return bestMexID, bestMexDefID
	end

	local function upgradeClosestMex(unitID, teamID, mexesInRange)
		local builder = builders[teamID][unitID]
		local upgradePairs = builderDefs[builder.unitDefID]

		local mexID = getClosestMex(unitID, upgradePairs, teamID, mexesInRange)

		if not mexID then
			SendToUnsynced('NothingToUpgrade',teamID, builder.unitDefID)
			return false
		end

		orderBuilder(unitID, mexID)
		return true
	end

	local function autoUpgradeDisabled(unitID, teamID)
		local builder = builders[teamID][unitID]
		builder.autoUpgrade = false
		if getUnitPhase(unitID, teamID) == RECLAIMING then
			mexes[teamID][builder.targetMex].assignedBuilder = nil
			GiveOrderToUnit(unitID, CMD_STOP, {}, 0)
		end
	end

	local function autoUpgradeEnabled(unitID, teamID)
		local builder = builders[teamID][unitID]
		builder.autoUpgrade = true
		local phase = getUnitPhase(unitID, teamID)
		if phase ~= BUILDING then
			local upgradePairs = builderDefs[builder.unitDefID]
			if getClosestMex(unitID, upgradePairs, teamID) then
				upgradeClosestMex(unitID, teamID)
			end
		end
	end

	local function upgradeMex(unitID, mexID, teamID)
		local builder = builders[teamID][unitID]
		local mex = mexes[teamID][mexID]
		if not mex then
			return
		end
		local upgradePairs = builderDefs[builder.unitDefID]

		builder.targetMex = mexID
		builder.targetUpgrade = upgradePairs[mex.unitDefID]
		builder.targetX = mex.x
		builder.targetY = mex.y
		builder.targetZ = mex.z

		mex.assignedBuilder = unitID

		gadgetHandler:UpdateCallIn("GameFrame")
		scheduledBuilders[unitID] = mexID
	end

	local function unregisterUnit(unitID, unitDefID, unitTeam, destroyed)
		local mex = mexes[unitTeam][unitID]
		local builder = builders[unitTeam][unitID]

		if mex then
			local builderID = mex.assignedBuilder
			if builderID then
				builder = builders[unitTeam][builderID]
				if builder and not (destroyed and getDistance(builderID, unitID, unitTeam) < builder.buildDistance * 2) then
					upgradeClosestMex(builderID, unitTeam)
				end
			end

			mexes[unitTeam][unitID] = nil
		elseif builder then
			if getUnitPhase(unitID, unitTeam) == RECLAIMING then
				local mex = mexes[unitTeam][builder.targetMex]
				if mexes[unitTeam][builder.targetMex] then
					mexes[unitTeam][builder.targetMex].assignedBuilder = nil
				end
				if mex then
					assignClosestBuilder(builder.targetMex, mex, unitTeam)
				end
			end

			builders[unitTeam][unitID] = nil
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
		unregisterUnit(unitID, unitDefID, unitTeam, true)
	end

	function gadget:UnitIdle(unitID, unitDefID, unitTeam)
		local builder = builders[unitTeam][unitID]
		if builder then

			if builder.autoUpgrade then
				upgradeClosestMex(unitID, unitTeam)
			end
		end
	end

	function gadget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
		unregisterUnit(unitID, unitDefID, unitTeam, false)
	end

	function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
		if not modoption_unba and not isCommander[unitDefID] then
			registerUnit(unitID, unitDefID, unitTeam)
		end
	end

	function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
		if not modoption_unba and not isCommander[unitDefID] then
			registerUnit(unitID, unitDefID, unitTeam)
		end
	end

	--------------------------
	-- Gadget Button
	--------------------------
	local ON, OFF = 1, 0

	function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag, playerID, fromSynced, fromLua)
		local builder = builders[teamID][unitID]
		if cmdID == CMD_UPGRADEMEX then
			if not cmdParams[2] then
				-- Unit
				local mex = mexes[teamID][cmdParams[1]]
				if mex and builder then
					local upgradePairs = builderDefs[builder.unitDefID]
					local upgradeTo = upgradePairs[mex.unitDefID]
					if upgradeTo then
						addFakeReclaim[unitID] = true;
						gadgetHandler:UpdateCallIn("GameFrame")
						return true
					end
				end
			else
				-- Circle
				return true
			end

			return false
		elseif cmdID ~= CMD_AUTOMEX then
			if builder and builder.targetMex and ValidUnitID(builder.targetMex) and (not GetUnitIsDead(builder.targetMex)) and (getUnitPhase(unitID, teamID) == RECLAIMING) and mexes[teamID][builder.targetMex] then
				mexes[teamID][builder.targetMex].assignedBuilder = nil
			end
			return true
		end
		local cmdDescID = FindUnitCmdDesc(unitID, CMD_AUTOMEX)
		if cmdDescID == nil then
			return
		end

		local status = cmdParams[1]
		local tooltip
		if status == OFF then
			autoUpgradeDisabled(unitID, teamID)
			tooltip = OFFTooltip
			status = OFF
		else
			autoUpgradeEnabled(unitID, teamID)
			tooltip = ONTooltip
			status = ON
		end
		autoMexCmdDesc.params[1] = status
		EditUnitCmdDesc(unitID, cmdDescID, {
			params = autoMexCmdDesc.params,
			tooltip = tooltip
		})

		return false
	end

	function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
		if cmdID ~= CMD_UPGRADEMEX or not unitID or not unitDefID then
			return false
		end

		local builder = builders[teamID][unitID]
		if not builder then
			return false
		end

		if not cmdParams[2] then
			-- Unit
			if not builder.orderTaken then
				local mexID = cmdParams[1]

				upgradeMex(unitID, mexID, teamID)
				return true, false
			else
				builder.orderTaken = false
				return true, true
			end
		else
			--Circle
			local x, y, z, radius = cmdParams[1], cmdParams[2], cmdParams[3], cmdParams[4]

			local mexesInRange = {}
			local canUpgrade = false
			for mexID, mex in pairs(mexes[teamID]) do

				if not mex.assignedBuilder and getDistanceFromPosition(x, z, mexID, teamID) < radius then
					mexesInRange[mexID] = mexes[teamID][mexID]
					canUpgrade = true
				end
			end

			if canUpgrade then

				local upgradePairs = builderDefs[builder.unitDefID]
				local mexID = getClosestMex(unitID, upgradePairs, teamID, mexesInRange)

				if mexID then
					addCommands[unitID] = { cmd = CMD_INSERT, params = { 0, CMD_UPGRADEMEX, CMD_OPT_INTERNAL, mexID }, options = { "alt" } }
					gadgetHandler:UpdateCallIn("GameFrame")

					return true, false
				end
			end

			return true, true
		end
	end

else

	local bDefs = {}

	local function nothingToUpgrade(_, team, unitDefId)
		if Script.LuaUI('GadgetMessageProxy') then
			local message = Script.LuaUI.GadgetMessageProxy('ui.mexUpgrader.noMexes', { unitDefId = unitDefId })
			SendMessageToTeam(team, message)
		end
	end

	local function RegisterUpgradePairs(_, val)
		if Script.LuaUI("registerUpgradePairs") then
			Script.LuaUI.registerUpgradePairs(bDefs)
		end
		return true
	end

	function gadget:Initialize()
		determine()

		for k, v in pairs(builderDefs) do
			local upgradePairs = {}
			for k2, v2 in pairs(v) do
				upgradePairs[k2] = v2
			end
			bDefs[k] = upgradePairs
		end

		gadgetHandler:AddSyncAction('NothingToUpgrade', nothingToUpgrade)
		gadgetHandler:AddChatAction("registerUpgradePairs", RegisterUpgradePairs, "toggles registerUpgradePairs setting")
	end

	function gadget:Shutdown()
		gadgetHandler:RemoveChatAction("registerUpgradePairs")
	end

end
