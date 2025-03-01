--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--https://gist.github.com/lhog/77f3fb10fed0c4e054b6c67eb24efeed#file-test_unitshape_instancing-lua-L177-L178

--------------------------------------------OLD AIRJETS---------------------------
function widget:GetInfo()
	return {
		name = "Airjets GL4",
		desc = "Thruster effects on air jet exhausts (auto limits and disables when low fps)",
		author = "GoogleFrog, jK, Floris, Beherith",
		date = "2021.05.16",
		license = "GNU GPL, v2 or later",
		layer = -1,
		enabled = true,
	}
end

-- TODO:
-- reflections
-- piece matrix
-- enemy units
-- crashy smores?
-- drawflags
-- rotate emit points of specific units
-- validate for crashing units
-- do plenty of bursty anims
-- expose as API?

--------------------------------------------------------------------------------
-- 'Speedups'
--------------------------------------------------------------------------------

local spGetUnitPieceInfo = Spring.GetUnitPieceInfo
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitPieceMap = Spring.GetUnitPieceMap
local spGetUnitIsActive = Spring.GetUnitIsActive
local spGetUnitMoveTypeData = Spring.GetUnitMoveTypeData
local spGetUnitVelocity = Spring.GetUnitVelocity
local spGetUnitTeam = Spring.GetUnitTeam
local glBlending = gl.Blending
local glTexture = gl.Texture

local GL_GREATER = GL.GREATER
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE = GL.ONE

local glAlphaTest = gl.AlphaTest
local glDepthTest = gl.DepthTest

local spValidUnitID = Spring.ValidUnitID

--------------------------------------------------------------------------------
-- Configuration
--------------------------------------------------------------------------------

local enableLights = true
local lightMult = 1.4

local effectDefs = {

	-- scouts
	["armpeep"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 4, length = 20, piece = "jet1", limit = true },
		{ color = { 0.7, 0.4, 0.1 }, width = 4, length = 20, piece = "jet2", limit = true },
	},
	["corfink"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 2.2, length = 15, piece = "thrusta", limit = true  },
		{ color = { 0.7, 0.4, 0.1 }, width = 2.2, length = 15, piece = "thrustb", limit = true  },
	},

	-- fighters
	["armfig"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 6, length = 45, piece = "thrust", limit = true },
	},
	["corveng"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 3, length = 20, piece = "thrust1", limit = true  },
		{ color = { 0.7, 0.4, 0.1 }, width = 3, length = 20, piece = "thrust2", limit = true  },
	},
	["armsfig"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 4, length = 25, piece = "thrust", limit = true },
	},
	["corsfig"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 3, length = 32, piece = "thrust", limit = true },
	},
	["armhawk"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 5, length = 35, piece = "thrust", limit = true },
	},
	["corvamp"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 35, piece = "thrusta", limit = true },
	},

	-- radar
	["armawac"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 30, piece = "thrust", light = 1 },
	},
	["corawac"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 4, length = 30, piece = "lthrust", light = 1 },
		{ color = { 0.2, 0.8, 0.2 }, width = 4, length = 30, piece = "mthrust", light = 1 },
		{ color = { 0.2, 0.8, 0.2 }, width = 4, length = 30, piece = "rthrust", light = 1 },
	},
	["corhunt"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 4, length = 37, piece = "thrust", light = 1 },
	},
	["armsehak"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 3.5, length = 37, piece = "thrust", light = 1 },
	},

	-- transports
	["armatlas"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 3, length = 12, piece = "thrustl", light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 3, length = 12, piece = "thrustr", light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 4, length = 15, piece = "thrustm", light = 1 }, --, xzVelocity = 1.5 -- removed xzVelocity else the other thrusters get disabled as well
	},
	["corvalk"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 6, length = 17, piece = "thrust1", emitVector = { 0, 1, 0 }, light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 6, length = 17, piece = "thrust3", emitVector = { 0, 1, 0 }, light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 6, length = 17, piece = "thrust2", emitVector = { 0, 1, 0 }, light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 6, length = 17, piece = "thrust4", emitVector = { 0, 1, 0 }, light = 1 },
	},
	["armdfly"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 35, piece = "thrusta", xzVelocity = 1.5, light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 35, piece = "thrustb", xzVelocity = 1.5, light = 1 },
	},
	["corseah"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 13, length = 25, piece = "thrustrra", emitVector = { 0, 1, 0 }, light = 0.75 },
		{ color = { 0.1, 0.4, 0.6 }, width = 13, length = 25, piece = "thrustrla", emitVector = { 0, 1, 0 }, light = 0.75 },
		{ color = { 0.1, 0.4, 0.6 }, width = 10, length = 25, piece = "thrustfra", emitVector = { 0, 1, 0 }, light = 0.75 },
		{ color = { 0.1, 0.4, 0.6 }, width = 10, length = 25, piece = "thrustfla", emitVector = { 0, 1, 0 }, light = 0.75 },
	},

	-- gunships
	["armkam"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 3, length = 28, piece = "thrusta", xzVelocity = 1.5, light = 1, emitVector = { 0, 1, 0 } },
		{ color = { 0.7, 0.4, 0.1 }, width = 3, length = 28, piece = "thrustb", xzVelocity = 1.5, light = 1, emitVector = { 0, 1, 0 } },
	},
	["armblade"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 25, piece = "thrust", light = 1, xzVelocity = 1.5 },
	},
	["corape"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 4, length = 16, piece = "rthrust", emitVector = { 0, 0, -1 }, xzVelocity = 1.5, light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 4, length = 16, piece = "lthrust", emitVector = { 0, 0, -1 }, xzVelocity = 1.5, light = 1 },
		--{color={0.1,0.4,0.6}, width=2.2, length=4.7, piece="lhthrust1", emitVector= {1,0,0}, light=1},
		--{color={0.1,0.4,0.6}, width=2.2, length=4.7, piece="rhthrust2", emitVector= {1,0,0}, light=1},
		--{color={0.1,0.4,0.6}, width=2.2, length=4.7, piece="lhthrust2", emitVector= {-1,0,0}, light=1},
		--{color={0.1,0.4,0.6}, width=2.2, length=4.7, piece="rhthrust1", emitVector= {-1,0,0}, light=1},
	},
	["armseap"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 5, length = 35, piece = "thrustm", light = 1 },
	},
	["corseap"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 3, length = 32, piece = "thrust", light = 1 },
	},
	["corcrw"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 12, length = 36, piece = "thrustrra", emitVector = { 0, 1, -1 }, light = 0.6 },
		{ color = { 0.1, 0.4, 0.6 }, width = 12, length = 36, piece = "thrustrla", emitVector = { 0, 1, -1 }, light = 0.6 },
		{ color = { 0.1, 0.4, 0.6 }, width = 10, length = 30, piece = "thrustfra", emitVector = { 0, 1, -1 }, light = 0.6 },
		{ color = { 0.1, 0.4, 0.6 }, width = 10, length = 30, piece = "thrustfla", emitVector = { 0, 1, -1 }, light = 0.6 },
	},
	["corcrwt4"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 19, length = 50, piece = "thrustrra", emitVector = { 0, 1, 0 }, light = 0.6 },
		{ color = { 0.1, 0.4, 0.6 }, width = 19, length = 50, piece = "thrustrla", emitVector = { 0, 1, 0 }, light = 0.6 },
		{ color = { 0.1, 0.4, 0.6 }, width = 17, length = 44, piece = "thrustfra", emitVector = { 0, 1, 0 }, light = 0.6 },
		{ color = { 0.1, 0.4, 0.6 }, width = 17, length = 44, piece = "thrustfla", emitVector = { 0, 1, 0 }, light = 0.6 },
	},
	["corcut"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 3.7, length = 15, piece = "thrusta", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 3.7, length = 15, piece = "thrustb", light = 1 },
	},
	--["armbrawl"] = {
	--	{ color = { 0.1, 0.4, 0.6 }, width = 3.7, length = 15, piece = "thrust1", light = 1 },
	--	{ color = { 0.1, 0.4, 0.6 }, width = 3.7, length = 15, piece = "thrust2", light = 1 },
	--},

	-- bombers
	["armstil"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 40, piece = "thrusta", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 40, piece = "thrustb", light = 1 },
	},
	["armthund"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 2, length = 17, piece = "thrust1", light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 2, length = 17, piece = "thrust2" },
		{ color = { 0.7, 0.4, 0.1 }, width = 2, length = 17, piece = "thrust3" },
		{ color = { 0.7, 0.4, 0.1 }, width = 2, length = 17, piece = "thrust4", light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 4, length = 25, piece = "thrustc", light = 1.3 },
	},
	["armthundt4"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 9, length = 60, piece = "thrust1", light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 9, length = 60, piece = "thrust2" },
		{ color = { 0.7, 0.4, 0.1 }, width = 9, length = 60, piece = "thrust3" },
		{ color = { 0.7, 0.4, 0.1 }, width = 9, length = 60, piece = "thrust4", light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 13, length = 85, piece = "thrustc", light = 1.3 },
	},
	["armpnix"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 7, length = 35, piece = "thrusta", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 7, length = 35, piece = "thrustb", light = 1 },
	},
	["corshad"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 4, length = 24, piece = "thrusta1", light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 4, length = 24, piece = "thrusta2", light = 1 },
		{ color = { 0.7, 0.4, 0.1 }, width = 5, length = 33, piece = "thrustb", light = 1 },
	},
	["armliche"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 44, piece = "thrusta", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 44, piece = "thrustb", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 3.5, length = 44, piece = "thrustc", light = 1 },
	},
	["cortitan"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 5, length = 35, piece = "thrusta1", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 5, length = 35, piece = "thrusta2", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 5, length = 35, piece = "thrustb1", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 5, length = 35, piece = "thrustb2", light = 1 },
	},
	["armlance"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 5, length = 40, piece = "thrust1", light = 1 },
	},
	["corhurc"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 8, length = 50, piece = "thrustb", light = 1 },
		{ color = { 0.1, 0.4, 0.6 }, width = 5, length = 35, piece = "thrusta1" },
		{ color = { 0.1, 0.4, 0.6 }, width = 5, length = 35, piece = "thrusta2" },
	},
	["armsb"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 4, length = 36, piece = "thrustc", light = 1 },
		{ color = { 0.2, 0.8, 0.2 }, width = 2.2, length = 18, piece = "thrusta", light = 1 },
		{ color = { 0.2, 0.8, 0.2 }, width = 2.2, length = 18, piece = "thrustb", light = 1 },
	},
	["corsb"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 3.3, length = 40, piece = "thrusta", light = 1 },
		{ color = { 0.2, 0.8, 0.2 }, width = 3.3, length = 40, piece = "thrustb", light = 1 },
	},

	-- construction
	["armca"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 6, length = 24, piece = "thrust", xzVelocity = 1.2 },
	},
	["armaca"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 6, length = 22, piece = "thrust", xzVelocity = 1.2 },
	},
	["corca"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 4, length = 15, piece = "thrust", xzVelocity = 1.2 },
	},
	["coraca"] = {
		{ color = { 0.1, 0.4, 0.6 }, width = 6, length = 22, piece = "thrust", xzVelocity = 1.2 },
	},
	["armcsa"] = {
		{ color = { 0.2, 0.8, 0.2 }, width = 5, length = 17, piece = "thrusta" },
		{ color = { 0.2, 0.8, 0.2 }, width = 5, length = 17, piece = "thrustb" },
	},

	-- flying ships
	["armfepocht4"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 13, length = 27, piece = "thrustl1", light = 0.62 },
		{ color = { 0.7, 0.4, 0.1 }, width = 13, length = 27, piece = "thrustr1", light = 0.62 },
		{ color = { 0.7, 0.4, 0.1 }, width = 17, length = 38, piece = "thrustl2", light = 0.62 },
		{ color = { 0.7, 0.4, 0.1 }, width = 17, length = 38, piece = "thrustr2", light = 0.62 },
	},
	["corfblackhyt4"] = {
		{ color = { 0.7, 0.4, 0.1 }, width = 14, length = 27, piece = "thrustl1", light = 0.62 },
		{ color = { 0.7, 0.4, 0.1 }, width = 14, length = 27, piece = "thrustr1", light = 0.62 },
		{ color = { 0.7, 0.4, 0.1 }, width = 19, length = 38, piece = "thrustl2", light = 0.62 },
		{ color = { 0.7, 0.4, 0.1 }, width = 19, length = 38, piece = "thrustr2", light = 0.62 },
	},
}

local function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

for name, effects in pairs(effectDefs) do
	if UnitDefNames[name..'_scav'] then
		effectDefs[name..'_scav'] = deepcopy(effects)
		for i,effect in pairs(effects) do
			effectDefs[name..'_scav'][i].color = {0.6, 0.12, 0.7}
		end
	end
end

local distortion = 0.008
local animSpeed = 3
local jitterWidthScale = 3
local jitterLengthScale = 3

local texture1 = "bitmaps/GPL/Lups/perlin_noise.jpg"    -- noise texture
--local texture1 = "luaui/images/perlin_noise_rgba_512.png"    -- noise texture
local texture2 = ":c:bitmaps/gpl/lups/jet2.bmp"        -- shape
local texture3 = ":c:bitmaps/GPL/Lups/jet.bmp"        -- jitter shape

local xzVelocityUnits = {}
local defs = {}
local limitDefs = {}
for name, effects in pairs(effectDefs) do
	for fx, data in pairs(effects) do
		if not effectDefs[name][fx].emitVector then
			effectDefs[name][fx].emitVector = { 0, 0, -1 }
		end
		if effectDefs[name][fx].xzVelocity then
			xzVelocityUnits[UnitDefNames[name].id] = effectDefs[name][fx].xzVelocity
		end
		if effectDefs[name][fx].limit then
			limitDefs[UnitDefNames[name].id] = true
		end
	end
	if UnitDefNames[name] then
		defs[UnitDefNames[name].id] = effectDefs[name]
	else
		Spring.Echo("Airjets: Error: unitdef name '"..name.."' doesnt exist")
	end
end
effectDefs = defs
defs = nil

local lightDefs = {}
for name, effects in pairs(effectDefs) do
	for fx, data in pairs(effects) do
		if data.light then
			lightDefs[name] = true
			effectDefs[name][fx].light = data.light * lightMult
		end
	end
end

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local activePlanes = {}
local inactivePlanes = {}
local lights = {}
local unitPieceOffset = {}

local shaders
local lastGameFrame = Spring.GetGameFrame()
local updateSec = 0

local spec, fullview = Spring.GetSpectatingState()

local enabled = true
local lighteffectsEnabled = false -- TODO (enableLights and WG['lighteffects'] ~= nil and WG['lighteffects'].enableThrusters)
-- GL4 Notes/TODO:
-- xzVelocityUnits is disabled
-- no FPS limited
-- draw in refract/reflect too?
-- A crashing aircraft can be neither destroyed nor go out ouf LOS before becoming an invalid unitID
-- GL4 Variables:

local quadVBO = nil
local jetInstanceVBO = nil
local jetShader = nil
local jitterShader = nil

local luaShaderDir = "LuaUI/Widgets/Include/"
local LuaShader = VFS.Include(luaShaderDir.."LuaShader.lua")
VFS.Include(luaShaderDir.."instancevbotable.lua")

local vsSrc =
[[#version 420
#extension GL_ARB_uniform_buffer_object : require
#extension GL_ARB_shader_storage_buffer_object : require
#extension GL_ARB_shading_language_420pack: require
#line 10000
uniform float timer;

uniform float iconDistance;
uniform int reflectionPass = 0;

layout (location = 0) in vec4 position_xy_uv;

layout (location = 1) in vec3 widthlengthtime; // time is gameframe spawned :D
layout (location = 2) in vec3 emitdir;
layout (location = 3) in vec3 color;
layout (location = 4) in uint pieceIndex;
layout (location = 5) in uvec4 instData; // unitID, teamID, ??

#define JITTERWIDTHSCALE 3
#define JITTERLENGTHSCALE 3
#define ANIMATION_SPEED 0.1

out DataVS {
	vec4 texCoords;
	vec4 jetcolor;
};

//__ENGINEUNIFORMBUFFERDEFS__

struct SUniformsBuffer {
    uint composite; //     u8 drawFlag; u8 unused1; u16 id;

    uint unused2;
    uint unused3;
    uint unused4;

    float maxHealth;
    float health;
    float unused5;
    float unused6;

    vec4 speed;
    vec4[5] userDefined; //can't use float[20] because float in arrays occupies 4 * float space
};

layout(std140, binding=1) readonly buffer UniformsBuffer {
    SUniformsBuffer uni[];
};
layout(std140, binding=0) readonly buffer MatrixBuffer {
	mat4 UnitPieces[];
};


mat4 rotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

//I've got different signs than https://github.com/dmnsgn/glsl-rotate/blob/master/rotation-3d-z.glsl (by applying the above to (0,0,1) axis
mat4 rotationMatrixZ(float angle)
{
    float s = sin(angle);
    float c = cos(angle);

    return mat4(  c,  -s, 0.0, 0.0,
				  s,   c, 0.0, 0.0,
				0.0, 0.0, 1.0, 0.0,
				0.0, 0.0, 0.0, 1.0);
}

bool vertexClipped(vec4 clipspace, float tolerance) {
  return any(lessThan(clipspace.xyz, -clipspace.www * tolerance)) ||
         any(greaterThan(clipspace.xyz, clipspace.www * tolerance));
}

#line 10468
void main()
{
	uint baseIndex = instData.x; // grab the correct offset into UnitPieces SSBO

	mat4 modelMatrix = UnitPieces[baseIndex]; //Find our matrix

	mat4 pieceMatrix = mat4mix(mat4(1.0), UnitPieces[baseIndex + pieceIndex + 1u], modelMatrix[3][3]);

	vec2 modulatedsize = widthlengthtime.xy * 1.5;
	// modulatedsize += rndVec3.xy * modulatedsize * 0.25; // not very pretty
	vec4 vertexPos = vec4(position_xy_uv.x * modulatedsize.x * 2.0, 0, position_xy_uv.y*modulatedsize.y * 0.66 ,1.0);

	mat4 worldMat = modelMatrix * pieceMatrix;
	//worldMat = modelMatrix;


	mat4 worldMatInv = transpose(worldMat);

	vec4 worldPos  = worldMat * vertexPos;

	vec3 modelNormal = vec3(0.0, 1.0, 0.0);
	vec3 modelAxis   = vec3(0.0, 0.0, 1.0);

	vec4 worldCamPos = cameraViewInv * vec4(0.0, 0.0, 0.0, 1.0);

	vec3 worldCamDir = normalize(worldCamPos.xyz - worldPos.xyz); //can use worldPosM instead of worldPos.xyz to prevent close-up distortion
	vec3 modelCamDir = normalize(mat3(worldMatInv) * worldCamDir);

	float s = modelCamDir.x < 0.0 ? -1.0 : 1.0;

	vec3 modelCamDirProj = normalize(modelCamDir - dot(modelCamDir, modelAxis) * modelAxis);
	float dotP = dot(modelCamDirProj, modelNormal);
	float angle = acos(dot(modelCamDirProj, modelNormal));

	mat4 rotMat = rotationMatrixZ(s * angle);

	mat4 VP = (reflectionPass == 0) ? cameraViewProj : reflectionViewProj;

	gl_Position = VP * worldMat * rotMat * vertexPos;
	//gl_Position = VP * worldMat  * vertexPos;

	texCoords.st = position_xy_uv.zw;
	texCoords.pq = position_xy_uv.zw;
	texCoords.q += timeInfo.x * ANIMATION_SPEED;

	jetcolor.rgb = color;
	jetcolor.a = clamp((timeInfo.x - widthlengthtime.z)*0.053, 0.0, 1.0);
	/*
	// VISIBILITY CULLING
	if (length(worldCamPos.xyz - worldPos.xyz) >  iconDistance) jetcolor.a = 0; // disable if unit is further than icondist
	if (dot(worldPos.xyz, worldPos.xyz) < 1.0) jetcolor.a = 0; // handle accidental zero matrix case
	if ((uni[instData.y].composite & 0x00000001u) == 0u )  jetcolor = vec4(0.0); // disable if drawflag is set to 0
	if (vertexClipped(VP * worldMat * vec4(0.0, 0.0, 0.0, 1.0), 1.2)) jetcolor.a = 0.0; // dont draw if way outside of view
	//jetcolor.a = 0.2;
	*/
}
]]

local fsSrc =
[[
#version 420
#extension GL_ARB_uniform_buffer_object : require
#extension GL_ARB_shading_language_420pack: require
#line 20000
uniform sampler2D noiseMap;
uniform sampler2D mask;

//__ENGINEUNIFORMBUFFERDEFS__

#define DISTORTION 0.01
in DataVS {
	vec4 texCoords;
	vec4 jetcolor;
};

out vec4 fragColor;

void main(void)
{
		vec2 displacement = texCoords.pq;

		vec2 txCoord = texCoords.st;
		txCoord.s += (texture2D(noiseMap, displacement * DISTORTION * 20.0).y - 0.5) * 40.0 * DISTORTION;
		txCoord.t +=  texture2D(noiseMap, displacement).x * (1.0-texCoords.t)        * 15.0 * DISTORTION;
		float opac = texture2D(mask,txCoord.st).r;

		fragColor.rgb  = opac * jetcolor.rgb; //color
		fragColor.rgb += pow(opac, 5.0 );     //white flame
		fragColor.a    = min(opac*1.5, 1.0); //
		fragColor.rgba = clamp(fragColor, 0.0, 1.0);

		fragColor.rgba *= jetcolor.a;
}
]]

local function goodbye(reason)
  Spring.Echo("Airjet GL4 widget exiting with reason: "..reason)
  widgetHandler:RemoveWidget()
end

local function initGL4()

	local engineUniformBufferDefs = LuaShader.GetEngineUniformBufferDefs()
	vsSrc = vsSrc:gsub("//__ENGINEUNIFORMBUFFERDEFS__", engineUniformBufferDefs)
	fsSrc = fsSrc:gsub("//__ENGINEUNIFORMBUFFERDEFS__", engineUniformBufferDefs)
	jetShader =  LuaShader(
    {
      vertex = vsSrc,
      fragment = fsSrc,
      --geometry = gsSrc, no geom shader for now
      uniformInt = {
        noiseMap = 0,
        mask = 1,
        },
	uniformFloat = {
        jetuniforms = {1,1,1,1}, --unused
		iconDistance = 1,
      },
    },
    "jetShader GL4"
  )
  shaderCompiled = jetShader:Initialize()
  if not shaderCompiled then goodbye("Failed to compile jetShader GL4 ") end
  local quadVBO,numVertices = makeRectVBO(-1,0,1,-1,0,1,1,0) --(minX,minY, maxX, maxY, minU, minV, maxU, maxV)
  local jetInstanceVBOLayout = {
		  {id = 1, name = 'widthlengthtime', size = 3}, -- widthlength
		  {id = 2, name = 'emitdir', size = 3}, --  emit dir
		  {id = 3, name = 'color', size = 3}, --- color
		  {id = 4, name = 'pieceIndex', type = GL.UNSIGNED_INT, size= 1},
		  {id = 5, name = 'instData', type = GL.UNSIGNED_INT, size= 4},
		}
  jetInstanceVBO = makeInstanceVBOTable(jetInstanceVBOLayout,256, "jetInstanceVBO", 5)
  jetInstanceVBO.numVertices = numVertices
  jetInstanceVBO.vertexVBO = quadVBO
  jetInstanceVBO.VAO = makeVAOandAttach(jetInstanceVBO.vertexVBO, jetInstanceVBO.instanceVBO)
  jetInstanceVBO.primitiveType = GL.TRIANGLES
  jetInstanceVBO.indexVBO = makeRectIndexVBO()
  jetInstanceVBO.VAO:AttachIndexBuffer(jetInstanceVBO.indexVBO)
end

--------------------------------------------------------------------------------
-- Draw Iteration
--------------------------------------------------------------------------------

local function DrawLights(unitID, unitDefID)
	local unitEffects = effectDefs[unitDefID]

	--glPushMatrix()
	--glUnitMultMatrix(unitID)
	for i = 1, #unitEffects do
		local fx = unitEffects[i]
		if fx.piecenum then
			--Spring.Echo(UnitDefs[unitDefID].name)		-- echo to find out which unit is has wrongly configured piecenames
			--// enter piece space
			--glPushMatrix()
			--glUnitPieceMultMatrix(unitID, fx.piecenum)
			--glScale(1, 1, -1)
			--glTexture(1, texture1)
			--glTexture(2, texture2)
			--glCallList(fx.dList)
			--glPopMatrix()

			-- add deferred light

			--[[
			if lighteffectsEnabled and lightDefs[unitDefID] then
				local unitPosX, unitPosY, unitPosZ = spGetUnitPosition(unitID)
				if unitPosZ then
					local _, yaw = spGetUnitRotation(unitID)
					if yaw then
						local lightOffset = unitPieceOffset[unitID..'_'..fx.piecenum]

						-- still just only Y thus inacurate
						local lightOffsetRotYx = lightOffset[1]*math_cos(3.1415+math_rad( 90+(((yaw+1.571)/6.2)*360) ))- lightOffset[3]*math_sin(3.1415+math_rad(90+ (((yaw+1.571)/6.2)*360) ))
						local lightOffsetRotYz = lightOffset[1]*math_sin(3.1415+math_rad( 90+(((yaw+1.571)/6.2)*360) ))+ lightOffset[3]*math_cos(3.1415+math_rad(90+ (((yaw+1.571)/6.2)*360) ))

						if not lights[unitID] then
							if not fx.color[4] then
								fx.color[4] = fx.light * 0.66
							end
							if not lights[unitID] then
								lights[unitID] = {}
							end
							lights[unitID][i] = WG['lighteffects'].createLight('thruster',unitPosX+lightOffsetRotYx, unitPosY+lightOffset[2], unitPosZ+lightOffsetRotYz, 0.8 * fx.width * fx.length, fx.color)
						elseif lights[unitID][i] then
							if not WG['lighteffects'].editLightPos(lights[unitID][i], unitPosX+lightOffsetRotYx, unitPosY+lightOffset[2], unitPosZ+lightOffsetRotYz) then
								fx.lightID = nil
							end
						end
					end
				end
			end
			]]--
		end
		--// leave piece space
	end

	--// leave unit space
	--glPopMatrix()
end

local function ValidateUnitIDs(unitIDkeys)
	local numunitids = 0
	local validunitids = 0
	local invalidunitids = {}
	local invalidstr = ''
	for indexpos, unitID in pairs(unitIDkeys) do
		numunitids = numunitids + 1
		if Spring.ValidUnitID(unitID) then
			validunitids = validunitids + 1
		else
			invalidunitids[#invalidunitids + 1] = unitID
			invalidstr = tostring(unitID) .. " " .. invalidstr
		end
	end
	if numunitids- validunitids > 0 then
		Spring.Echo("Airjets GL4", numunitids, "Valid", numunitids- validunitids, "invalid", invalidstr)
	end
end

local drawframe = 0
local function DrawParticles(isReflection)
	if not enabled then return false end
	-- validate unitID buffer
	drawframe = drawframe + 1
	if drawframe %99 == 1 then
		--Spring.Echo("Numairjets", jetInstanceVBO.usedElements)
	end


	gl.Culling(false)

	glDepthTest(true)

	glAlphaTest(GL_GREATER, 0)

	glTexture(0, texture1)
	glTexture(1, texture2)
	glBlending(GL_ONE, GL_ONE)
	jetShader:Activate()

	jetShader:SetUniformInt("reflectionPass", ((isReflection == true) and 1) or 0)
	--zlocal disticon
	--zif Spring.GetConfigInt("UnitIconsAsUI", 1) == 1 then
	--z	disticon = Spring.GetConfigInt("uniticon_fadevanish", 1800)
	--z	disticon = disticon * 3
	--zelse
	--z	disticon = Spring.GetConfigInt("UnitIconDist", 200)
	--z	disticon = disticon * 27 -- should be sqrt(750) but not really
	--zend
	--jetShader:SetUniform("iconDistance", disticon)

	drawInstanceVBO(jetInstanceVBO)

	jetShader:Deactivate()
	glTexture(0, false)
	glTexture(1, false)
	glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

	glAlphaTest(false)

	glDepthTest(false)
end


--------------------------------------------------------------------------------
-- Unit Handling
--------------------------------------------------------------------------------

local function RemoveLights(unitID)
	if lighteffectsEnabled and lights[unitID] then
		for i,v in pairs(lights[unitID]) do
			WG['lighteffects'].removeLight(lights[unitID][i], 3)
		end
		lights[unitID] = nil
	end
end

local function FinishInitialization(unitID, effectDef)
	local pieceMap = spGetUnitPieceMap(unitID)
	for i = 1, #effectDef do
		local fx = effectDef[i]
		if fx.piece then
			--Spring.Echo("FinishInitialization", fx.piece, pieceMap[fx.piece])
			fx.piecenum = pieceMap[fx.piece]
		end
		fx.width = fx.width*1.2
		fx.length = fx.length*1.5
	end
	effectDef.finishedInit = true
end

local function Activate(unitID, unitDefID, who, when)
	--Spring.Echo(Spring.GetGameFrame(), who, "Activate(unitID, unitDefID)",unitID, unitDefID)

	if not effectDefs[unitDefID].finishedInit then
		FinishInitialization(unitID, effectDefs[unitDefID])
	end

	inactivePlanes[unitID] = nil
	-- this unit already has lights assigned to it, clear it from inactive and done
	--if activePlanes[unitID] == unitDefID then return end

	activePlanes[unitID] = unitDefID

	if when ==  nil then when = 0 end --

	local unitEffects = effectDefs[unitDefID]
	for i = 1, #unitEffects do
		local effectDef = unitEffects[i]
		--Spring.Utilities.TableEcho(effectDef)
		local color = effectDef.color
		local emitVector = effectDef.emitVector
		local effectdata = {
			effectDef.width*0.4,effectDef.length, when,
			emitVector[1],emitVector[2],emitVector[3],
			color[1],color[2],color[3],
			--math.floor(math.random() * 5) ,
			effectDef.piecenum - 1,
			0,0,0,0, -- this is needed to keep the lua copy of the vbo the correct size

		}
		--Spring.Echo("Adding", tostring(unitID).."_"..tostring(effectDef.piecenum))
		pushElementInstance(jetInstanceVBO,effectdata,tostring(unitID).."_"..tostring(effectDef.piecenum), true, nil, unitID)
	end
end




local function Deactivate(unitID, unitDefID, who)
	--Spring.Echo(Spring.GetGameFrame(),who, "Deactivate(unitID, unitDefID)",unitID, unitDefID)

	activePlanes[unitID] = nil

	inactivePlanes[unitID] = unitDefID
	RemoveLights(unitID)

	local unitEffects = effectDefs[unitDefID]
	for i = 1, #unitEffects do
		local effectDef = unitEffects[i]
		airjetkey = tostring(unitID).."_"..tostring(effectDef.piecenum)
		if jetInstanceVBO.instanceIDtoIndex[airjetkey] then
			popElementInstance(jetInstanceVBO,tostring(unitID).."_"..tostring(effectDef.piecenum))
		end
	end
end

local function RemoveUnit(unitID, unitDefID, unitTeamID)
	--Spring.Echo("RemoveUnit(unitID, unitDefID, unitTeamID)",unitID, unitDefID, unitTeamID)
	if effectDefs[unitDefID] then
		Deactivate(unitID, unitDefID, "died")
		inactivePlanes[unitID] = nil
		activePlanes[unitID] = nil
		RemoveLights(unitID)
		for i = 1, #effectDefs[unitDefID] do
			if effectDefs[unitDefID][i].piecenum then
				unitPieceOffset[unitID..'_'..effectDefs[unitDefID][i].piecenum] = nil
			end
		end
	end
end

local function AddUnit(unitID, unitDefID, unitTeamID)
	if not effectDefs[unitDefID] then
		return false
	end
	Activate(unitID, unitDefID, "addunit")

	if lighteffectsEnabled and lightDefs[unitDefID] then
		for i = 1, #effectDefs[unitDefID] do
			if effectDefs[unitDefID][i].piecenum then
				unitPieceOffset[unitID..'_'..effectDefs[unitDefID][i].piecenum] = spGetUnitPieceInfo(unitID, effectDefs[unitDefID][i].piecenum).offset
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Widget Interface
--------------------------------------------------------------------------------

function widget:Update(dt)

	--if true then return end
	updateSec = updateSec + dt
	local gf = Spring.GetGameFrame()
	if gf ~= lastGameFrame and updateSec > 0.51 then		-- to limit the number of unit status checks
		--[[
		if Spring.GetGameFrame() > 0 then

			ValidateUnitIDs(jetInstanceVBO.indextoUnitID)
			local activecnt = 0
			local inactivecnt = 0
			for i, v in pairs(inactivePlanes) do inactivecnt = inactivecnt + 1 end
			for i, v in pairs(activePlanes) do activecnt = activecnt + 1 end
			Spring.Echo( Spring.GetGameFrame (), "airjetcount", jetInstanceVBO.usedElements, "active:", activecnt, "inactive", inactivecnt)
		end
		]]--
		ValidateUnitIDs(jetInstanceVBO.indextoUnitID)
		lastGameFrame = gf
		updateSec = 0
		for unitID, unitDefID in pairs(inactivePlanes) do
			-- always activate enemy planes

			if spGetUnitIsActive(unitID) or not Spring.IsUnitAllied(unitID) then
				if xzVelocityUnits[unitDefID] then
					local uvx,_,uvz = spGetUnitVelocity(unitID)
					if uvx * uvx + uvz * uvz > xzVelocityUnits[unitDefID] * xzVelocityUnits[unitDefID] then
						Activate(unitID, unitDefID,"updatewasinactive", spGetGameFrame() )
					end
				else
					Activate(unitID, unitDefID,"updatewasinactive", spGetGameFrame())
				end
			end
		end
		for unitID, unitDefID in pairs(activePlanes) do
			if Spring.ValidUnitID(unitID) then
				if not spGetUnitIsActive(unitID) then
					Deactivate(unitID, unitDefID,"updatewasinactive")
				else
					if xzVelocityUnits[unitDefID] then
						local uvx,_,uvz = spGetUnitVelocity(unitID)
						if uvx * uvx + uvz * uvz <= xzVelocityUnits[unitDefID] * xzVelocityUnits[unitDefID] then
							Deactivate(unitID, unitDefID,"tooslow")
						end
					end
				end
			else
				RemoveUnit(unitID, unitDefID, "invalid")
			end
		end
	end

	local prevLighteffectsEnabled = lighteffectsEnabled
	lighteffectsEnabled = (enableLights and WG['lighteffects'] ~= nil and WG['lighteffects'].enableThrusters)
	if lighteffectsEnabled ~= prevLighteffectsEnabled then
		for _, unitID in ipairs(Spring.GetAllUnits()) do
			local unitDefID = Spring.GetUnitDefID(unitID)
			RemoveUnit(unitID, unitDefID, spGetUnitTeam(unitID))
			AddUnit(unitID, unitDefID, spGetUnitTeam(unitID))
		end
	end
end

function widget:UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
	if spValidUnitID(unitID) then
		unitDefID = unitDefID or Spring.GetUnitDefID(unitID)
		--Spring.Echo("UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)",unitID, unitTeam, allyTeam, unitDefID)
		AddUnit(unitID, unitDefID, unitTeam)
	end
end

function widget:UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
	if not fullview then
		unitDefID = unitDefID or Spring.GetUnitDefID(unitID)
		--Spring.Echo("UnitLeftLos(unitID, unitDefID, unitTeam)",unitID, unitTeam, allyTeam, unitDefID)
		RemoveUnit(unitID, unitDefID, unitTeam)
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	--Spring.Echo("UnitCreated(unitID, unitDefID, unitTeam)",unitID, unitDefID, unitTeam)
	AddUnit(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	--Spring.Echo("UnitDestroyed(unitID, unitDefID, unitTeam)",unitID, unitDefID, unitTeam)
	RemoveUnit(unitID, unitDefID, unitTeam)
end


function widget.RenderUnitDestroyed(unitID, unitDefID, unitTeam)
	--Spring.Echo("RenderUnitDestroyed(unitID, unitDefID, unitTeam)",unitID, unitDefID, unitTeam)
	RemoveUnit(unitID, unitDefID, unitTeam)
end

-- wont be called for enemy units nor can it read spGetUnitMoveTypeData(unitID).aircraftState anyway
function widget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer)
	if effectDefs[unitDefID] and spGetUnitMoveTypeData(unitID).aircraftState == "crashing" then
		RemoveUnit(unitID, unitDefID, unitTeam)
	end
end


function widget:Update(dt)
	spec, fullview = Spring.GetSpectatingState()
end

function widget:DrawWorld()
	DrawParticles(false)
end


function widget:DrawWorldReflection()
	DrawParticles(true)
end



function widget:Initialize()
	initGL4()

	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitDefID = Spring.GetUnitDefID(unitID)
		AddUnit(unitID, unitDefID, spGetUnitTeam(unitID))
	end

	WG['airjets'] = {}

	WG['airjets'].addAirJet = function (unitID, piecenum, width, length, color3, emitVector) -- for WG external calls
		local airjetkey = tostring(unitID).."_"..tostring(piecenum)
		if emitVector == nil then emitVector = {0,0,-1} end
		pushElementInstance(
			jetInstanceVBO,
			{
				width*5, length*5, spGetGameFrame(),
				emitVector[1], emitVector[2], emitVector[3],
				color[1], color[2], color[3],
				piecenum,
				0,0,0,0 -- this is needed to keep the lua copy of the vbo the correct size
			},
			airjetkey,
			true, -- update exisiting
			nil,  -- noupload
			unitID -- unitID
			)
		return airjetkey
	end

	WG['airjets'].removeAirJet =  function (airjetkey) ---- for WG external calls
		return popElementInstance(jetInstanceVBO,airjetkey)
	end

end


function widget:Shutdown()
	for unitID, unitDefID in pairs(activePlanes) do
		RemoveUnit(unitID, unitDefID, spGetUnitTeam(unitID))
	end

end
