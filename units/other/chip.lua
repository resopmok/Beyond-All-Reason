local unitName = Spring.I18N('units.names.chip')

return {
	chip = {
		blocking = true,
		buildcostenergy = 0,
		buildcostmetal = 0,
		buildpic = "other/chip.dds",
		buildtime = 255,
		canattack = false,
		canmove = true,
		canrepeat = false,
		capturable = false,
		category = "OBJECT",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "12 1.7 12",
		collisionvolumetype = "CylY",
		crushresistance = 2500,
		description = Spring.I18N('units.descriptions.chip'),
		explodeas = "blank",
		footprintx = 1,
		footprintz = 1,
		hidedamage = true,
		idleautoheal = 0,
		mass = 25,
		maxdamage = 500000,
		maxslope = 64,
		maxvelocity = 1,
		maxwaterdepth = 0,
		movementclass = "CRITTERH",
		name = unitName,
		objectname = "chip.s3o",
		reclaimable = false,
		repairable = false,
		script = "chip.lua",
		seismicsignature = 0,
		selfdestructas = "blank",
		sightdistance = 0,
		sonarstealth = true,
		stealth = true,
		usebuildinggrounddecal = false,
		yardmap = "f",
		customparams = {
			unitgroup = 'util',
			model_author = "Floris",
			nohealthbars = true,
			subfolder = "other",
		},
	},
}
