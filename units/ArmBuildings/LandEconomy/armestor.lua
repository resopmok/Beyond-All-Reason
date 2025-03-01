local unitName = Spring.I18N('units.names.armestor')

return {
	armestor = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 4096,
		buildcostenergy = 1700,
		buildcostmetal = 170,
		buildpic = "ARMESTOR.DDS",
		buildtime = 4119,
		canrepeat = false,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "42 34 42",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = Spring.I18N('units.descriptions.armestor'),
		energystorage = 6000,
		explodeas = "energystorage",
		footprintx = 3,
		footprintz = 3,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 1700,
		maxslope = 10,
		maxwaterdepth = 0,
		name = unitName,
		objectname = "Units/ARMESTOR.s3o",
		script = "Units/ARMESTOR.cob",
		seismicsignature = 0,
		selfdestructas = "energystorageSelfd",
		sightdistance = 273,
		yardmap = "ooooooooo",
		customparams = {
			usebuildinggrounddecal = true,
			buildinggrounddecaltype = "decals/armestor_aoplane.dds",
			buildinggrounddecalsizey = 5,
			buildinggrounddecalsizex = 5,
			buildinggrounddecaldecayspeed = 30,
			unitgroup = 'energy',
			model_author = "Cremuss",
			normaltex = "unittextures/Arm_normal.dds",
			removestop = true,
			removewait = true,
			subfolder = "armbuildings/landeconomy",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.0361251831055 -3.17626953112e-05 -0.330192565918",
				collisionvolumescales = "39.6697540283 34.9461364746 42.0973052979",
				collisionvolumetype = "Box",
				damage = 1020,
				description = Spring.I18N('units.dead', { name = unitName }),
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 40,
				hitdensity = 100,
				metal = 103,
				object = "Units/armestor_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "85.0 14.0 6.0",
				collisionvolumetype = "cylY",
				damage = 510,
				description = Spring.I18N('units.heap', { name = unitName }),
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 4,
				hitdensity = 100,
				metal = 41,
				object = "Units/arm4X4C.s3o",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "storngy1",
			},
		},
	},
}
