function widget:GetInfo()
	return {
		name = "TeamPlatter", -- GL4
		desc = "Draw geometric primitives at any unit",
		author = "Beherith, Floris",
		date = "November 2021",
		license = "GNU GPL, v2 or later",
		layer = -1,
		enabled = false,
	}
end

-- Configurable Parts:
local texture = "luaui/images/solid.png"
local opacity = 0.25
local skipOwnTeam = false

---- GL4 Backend Stuff----
local selectionVBO = nil
local selectShader = nil
local luaShaderDir = "LuaUI/Widgets/Include/"

-- Localize for speedups:
local glStencilFunc         = gl.StencilFunc
local glStencilOp           = gl.StencilOp
local glStencilTest         = gl.StencilTest
local glStencilMask         = gl.StencilMask
local glDepthTest           = gl.DepthTest
local glTexture             = gl.Texture
local glClear               = gl.Clear
local GL_ALWAYS             = GL.ALWAYS
local GL_NOTEQUAL           = GL.NOTEQUAL
local GL_KEEP               = 0x1E00 --GL.KEEP
local GL_STENCIL_BUFFER_BIT = GL.STENCIL_BUFFER_BIT
local GL_REPLACE            = GL.REPLACE
local GL_POINTS				= GL.POINTS

local spGetUnitMoveTypeData = Spring.GetUnitMoveTypeData
local spValidUnitID = Spring.ValidUnitID

local unitTeam = {}
local unitUnitDefID = {}

local spec, fullview = Spring.GetSpectatingState()
local myTeamID = Spring.GetMyTeamID()
local gaiaTeamID = Spring.GetGaiaTeamID()

local unitScale = {}
local unitCanFly = {}
local unitBuilding = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	unitScale[unitDefID] = (7.5 * ( unitDef.xsize^2 + unitDef.zsize^2 ) ^ 0.5) + 8
	if unitDef.canFly then
		unitCanFly[unitDefID] = true
		unitScale[unitDefID] = unitScale[unitDefID] * 0.7
	elseif unitDef.isBuilding or unitDef.isFactory or unitDef.speed==0 then
		unitBuilding[unitDefID] = {
			unitDef.xsize * 8.2 + 12,
			unitDef.zsize * 8.2 + 12
		}
	end
end

local function AddPrimitiveAtUnit(unitID)
	local gf = Spring.GetGameFrame()

	if not unitUnitDefID[unitID] then
		unitUnitDefID[unitID] = Spring.GetUnitDefID(unitID)
	end
	local unitDefID = unitUnitDefID[unitID]
	if unitDefID == nil then return end -- these cant be selected

	local numVertices = 64 -- default to cornered rectangle
	local cornersize = 0

	local radius = unitScale[unitDefID]

	if not unitTeam[unitID] then
		unitTeam[unitID] = Spring.GetUnitTeam(unitID)
	end

	local additionalheight = 0
	local width, length
	if unitCanFly[unitDefID] then
		numVertices = 3 -- triangles for planes
		width = radius
		length = radius
	elseif unitBuilding[unitDefID] then
		width = unitBuilding[unitDefID][1]
		length = unitBuilding[unitDefID][2]
		cornersize = (width + length) * 0.075
		numVertices = 2
	else
		width = radius
		length = radius
	end

	pushElementInstance(
		selectionVBO, -- push into this Instance VBO Table
		{
			length, width, cornersize, additionalheight,  -- lengthwidthcornerheight
			unitTeam[unitID], -- teamID
			numVertices, -- how many trianges should we make
			gf, 0, 0, 0, -- the gameFrame (for animations), and any other parameters one might want to add
			0, 1, 0, 1, -- These are our default UV atlas tranformations
			0, 0, 0, 0 -- these are just padding zeros, that will get filled in
		},
		unitID, -- this is the key inside the VBO TAble,
		true, -- update existing element
		nil, -- noupload, dont use unless you
		unitID -- last one should be UNITID?
	)
end

function widget:Update(dt)
	spec, fullview = Spring.GetSpectatingState()
end

local drawFrame = 0
function widget:DrawWorldPreUnit()
	if Spring.IsGUIHidden() then
		return
	end
	drawFrame = drawFrame + 1
	if selectionVBO.usedElements > 0 then
		--if drawFrame % 100 == 0 then Spring.Echo("selectionVBO.usedElements",selectionVBO.usedElements) end
		local disticon
		if Spring.GetConfigInt("UnitIconsAsUI", 1) == 1 then
			disticon = Spring.GetConfigInt("uniticon_fadevanish", 1800)
			disticon = disticon * 3
		else
			disticon = Spring.GetConfigInt("UnitIconDist", 200)
			disticon = disticon * 27 -- should be sqrt(750) but not really
		end
		--gl.Culling(false)
		glTexture(0, texture)
		selectShader:Activate()
		selectShader:SetUniform("iconDistance",disticon) -- pass
		glStencilTest(true) --https://learnopengl.com/Advanced-OpenGL/Stencil-testing
		glDepthTest(true)
		glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE) -- Set The Stencil Buffer To 1 Where Draw Any Polygon		this to the shader
		glClear(GL_STENCIL_BUFFER_BIT ) -- set stencil buffer to 0

		glStencilFunc(GL_NOTEQUAL, 1, 1) -- use NOTEQUAL instead of ALWAYS to ensure that overlapping transparent fragments dont get written multiple times
		glStencilMask(1)

		selectShader:SetUniform("addRadius", 0)
		selectionVBO.VAO:DrawArrays(GL_POINTS, selectionVBO.usedElements)

		glStencilFunc(GL_NOTEQUAL, 1, 1)
		glStencilMask(0)
		glDepthTest(true)

		selectShader:SetUniform("addRadius", 0.15)
		selectionVBO.VAO:DrawArrays(GL_POINTS, selectionVBO.usedElements)

		glStencilMask(1)
		glStencilFunc(GL_ALWAYS, 1, 1)
		glDepthTest(true)

		selectShader:Deactivate()
		glTexture(0, false)
	end
end

local function RemovePrimitive(unitID)
	if selectionVBO.instanceIDtoIndex[unitID] then
		popElementInstance(selectionVBO, unitID)
	end
end

local function AddUnit(unitID, unitDefID, unitTeamID)
	if (not skipOwnTeam or unitTeamID ~= myTeamID) and unitTeamID ~= gaiaTeamID then
		unitTeam[unitID] = unitTeamID
		unitUnitDefID[unitID] = unitDefID
		AddPrimitiveAtUnit(unitID)
	end
end

local function RemoveUnit(unitID, unitDefID, unitTeamID)
	if (not skipOwnTeam or unitTeamID ~= myTeamID) and unitTeamID ~= gaiaTeamID then
		RemovePrimitive(unitID)
		unitTeam[unitID] = nil
		unitUnitDefID[unitID] = nil
	end
end

function widget:UnitTaken(unitID, unitDefID, oldTeamID, newTeamID)
	if unitTeam[unitID] then
		RemoveUnit(unitID, unitDefID, oldTeamID)
		AddUnit(unitID, unitDefID, unitTeam)
	end
end

function widget:UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
	if spValidUnitID(unitID) then
		unitDefID = unitDefID or Spring.GetUnitDefID(unitID)
		AddUnit(unitID, unitDefID, unitTeam)
	end
end

function widget:UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
	if not fullview then
		unitDefID = unitDefID or Spring.GetUnitDefID(unitID)
		RemoveUnit(unitID, unitDefID, unitTeam)
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	AddUnit(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	RemoveUnit(unitID, unitDefID, unitTeam)
end

function widget.RenderUnitDestroyed(unitID, unitDefID, unitTeam)
	RemoveUnit(unitID, unitDefID, unitTeam)
end

-- wont be called for enemy units nor can it read spGetUnitMoveTypeData(unitID).aircraftState anyway
function widget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer)
	if unitCanFly[unitDefID] and spGetUnitMoveTypeData(unitID).aircraftState == "crashing" then
		RemoveUnit(unitID, unitDefID, unitTeam)
	end
end

local function init()
	local DPatUnit = VFS.Include(luaShaderDir.."DrawPrimitiveAtUnit.lua")
	local InitDrawPrimitiveAtUnit = DPatUnit.InitDrawPrimitiveAtUnit
	local shaderConfig = DPatUnit.shaderConfig -- MAKE SURE YOU READ THE SHADERCONFIG TABLE!
	shaderConfig.TRANSPARENCY = opacity
	shaderConfig.ANIMATION = 0
	shaderConfig.HEIGHTOFFSET = 3.99
	selectionVBO, selectShader = InitDrawPrimitiveAtUnit(shaderConfig, "selectedUnits")

	for _, unitID in ipairs(Spring.GetAllUnits()) do
		AddUnit(unitID, Spring.GetUnitDefID(unitID), Spring.GetUnitTeam(unitID))
	end
end

function widget:Initialize()
	init()
	WG['teamplatter'] = {}
	WG['teamplatter'].getOpacity = function()
		return opacity
	end
	WG['teamplatter'].setOpacity = function(value)
		opacity = value
		init()
	end
	WG['teamplatter'].getSkipOwnTeam = function()
		return skipOwnTeam
	end
	WG['teamplatter'].setSkipOwnTeam = function(value)
		skipOwnTeam = value
		init()
	end
end

function widget:Shutdown()
	WG['teamplatter'] = nil
end

function widget:GetConfigData(data)
	return {
		opacity = opacity,
		skipOwnTeam = skipOwnTeam,
	}
end

function widget:SetConfigData(data)
	opacity = data.opacity or opacity
	skipOwnTeam = data.skipOwnTeam or skipOwnTeam
end
