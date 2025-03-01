local unitName = "Epic Decade"

return {
	armdecadet3 = {
		acceleration = 0.03,
		brakerate = 0.03,
		buildangle = 16384,
		buildcostenergy = 160000,
		buildcostmetal = 8000,
		buildpic = "armdecadet3.DDS",
		buildtime = 90000,
		canmove = true,
		category = "ALL WEAPON NOTSUB SHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 0 -3",
		collisionvolumescales = "52 52 153",
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		description = "Rapid-fire Plasma Artillery Ship",
		explodeas = "hugeexplosiongeneric",
		floater = true,
		footprintx = 6,
		footprintz = 6,
		icontype = "sea",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 13000,
		maxvelocity = 2.3,
		minwaterdepth = 12,
		movementclass = "BOAT6",
		name = unitName,
		nochasecategory = "UNDERWATER VTOL",
		objectname = "Units/scavboss/ARMDECADET3.s3o",
		script = "Units/scavboss/ARMDECADET3.cob",
		seismicsignature = 0,
		selfdestructas = "hugeexplosiongenericSelfd",
		sightdistance = 600,
		turninplace = true,
		turninplaceanglelimit = 90,
		turnrate = 180,
		waterline = 0,
		customparams = {
			unitgroup = 'weapon',
			model_author = "FireStorm",
			normaltex = "unittextures/Arm_normal.dds",
			techlevel = 3,
			subfolder = "armships",
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "0 -10 -3",
				collisionvolumescales = "52 52 153",
				collisionvolumetype = "Box",
				damage = 26000,
				description = "Epic Decade Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 6,
				footprintz = 6,
				height = 20,
				hitdensity = 100,
				metal = 4000,
				object = "Units/scavboss/armdecadet3_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "85.0 14.0 6.0",
				collisionvolumetype = "cylY",
				damage = 13000,
				description = "Epic Decade Heap",
				energy = 0,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 2000,
				object = "Units/arm6X6D.s3o",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:barrelshot-tiny",
			},
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "sharmmov",
			},
			select = {
				[1] = "sharmsel",
			},
		},
		weapondefs = {
			armminivulc_weapon = {
				accuracy = 700,
				areaofeffect = 44.8,
				avoidfeature = false,
				avoidfriendly = true,
				avoidground = true,
				cegtag = "arty-heavy",
				collidefriendly = false,
				craterboost = 0.02,
				cratermult = 0.02,
				edgeeffectiveness = 0.9,
				energypershot = 1000,
				explosiongenerator = "custom:genericshellexplosion-medium-bomb",
				gravityaffected = "true",
				impulseboost = 0.1,
				impulsefactor = 0.1,
				name = "Mini Rapid-fire long-range plasma cannon",
				noselfdamage = true,
				range = 1300,
				reloadtime = 0.4,
				rgbcolor = "1, 0.4, 0",
				soundhit = "xplomed3",
				soundhitwet = "splshbig",
				soundstart = "cannon2",
				turret = true,
				weapontimer = 14,
				weapontype = "Cannon",
				weaponvelocity = 660,
				customparams = {
					expl_light_heat_radius_mult = 1.75,
				},
				damage = {
					default = 210,
					shields = 105,
				},
			},
		},
		weapons = {
			[1] = {
				def = "ARMMINIVULC_WEAPON",
				maindir = "0 0 1",
				maxangledif = 320,
				onlytargetcategory = "NOTSUB",
			},
			[2] = {
				def = "ARMMINIVULC_WEAPON",
				maindir = "0 0 -1",
				maxangledif = 320,
				onlytargetcategory = "NOTSUB",
			},
		},
	},
}
