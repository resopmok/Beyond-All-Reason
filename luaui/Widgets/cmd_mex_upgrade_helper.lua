function widget:GetInfo()
	return {
		name = "MexUpg Helper",
		desc = "",
		author = "author: BigHead",
		date = "September 13, 2007",
		license = "GNU GPL, v2 or later",
		layer = -100,
		enabled = true -- loaded by default?
	}
end

local upgradeMouseCursor = "upgmex"

local CMD_UPGRADEMEX = 31244

local builderDefs = nil

local GetUnitDefID = Spring.GetUnitDefID
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetSelectedUnits = Spring.GetSelectedUnits
local TraceScreenRay = Spring.TraceScreenRay
local GetActiveCommand = Spring.GetActiveCommand
local GetSelectedUnitsCount = Spring.GetSelectedUnitsCount

local rightClickUpgradeParams

local function registerUpgradePairs(v)
	builderDefs = v
	return true
end

function widget:Initialize()
	widgetHandler:RegisterGlobal('registerUpgradePairs', registerUpgradePairs)
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal('registerUpgradePairs')
end

function widget:UpdateLayout(commandsChanged, page, alt, ctrl, meta, shift)
	return true
end

function widget:GameFrame(n)
	if n > 1 then
		Spring.SendCommands({ "luarules registerUpgradePairs 1" })
		widgetHandler:RemoveCallIn("GameFrame")
	end
end

function widget:MousePress(x, y, b)
	if rightClickUpgradeParams then
		local alt, ctrl, meta, shift = Spring.GetModKeyState()
		local options = {}
		if shift then
			options = { "shift" }
		end
		GiveOrderToUnit(rightClickUpgradeParams.builderID, CMD_UPGRADEMEX, { rightClickUpgradeParams.mexID }, options)
		return true
	end
end

function widget:IsAbove(x, y)
	if not builderDefs then
		return
	end
	rightClickUpgradeParams = nil

	if GetActiveCommand() ~= 0 then
		return false
	end

	if GetSelectedUnitsCount() ~= 1 then
		return false
	end

	local selectedUnits = GetSelectedUnits()

	local builderID = selectedUnits[1]
	local upgradePairs = builderDefs[GetUnitDefID(builderID)]

	if not upgradePairs then
		return false
	end

	local type, unitID = TraceScreenRay(x, y)

	if type ~= "unit" then
		return false
	end

	local upgradeTo = upgradePairs[GetUnitDefID(unitID)]
	if not upgradeTo then
		return false
	end

	rightClickUpgradeParams = { builderID = builderID, mexID = unitID, upgradeTo = upgradeTo }

	Spring.SetMouseCursor(upgradeMouseCursor)
	return true
end
