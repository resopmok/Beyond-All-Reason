local unitName = "Epic Serpent"

return {
	armserpt3 = {
		acceleration = 0.02,
		activatewhenbuilt = true,
		brakerate = 0.02,
		buildcostenergy = 225000,
		buildcostmetal = 15000,
		buildpic = "armserpt3.DDS",
		buildtime = 250000,
		canmove = true,
		category = "ALL NOTLAND MOBILE WEAPON NOTAIR NOTHOVER CANBEUW SURFACE EMPABLE UNDERWATER",
		collisionvolumeoffsets = "0 -4 0",
		collisionvolumescales = "90 38 114",
		collisionvolumetype = "box",
		corpse = "DEAD",
		description = "Multi-Target Battle Sub",
		explodeas = "mediumExplosionGeneric-uw",
		footprintx = 6,
		footprintz = 6,
		icontype = "sea",
		idleautoheal = 15,
		idletime = 900,
		maxdamage = 24000,
		maxvelocity = 1.5,
		minwaterdepth = 30,
		movementclass = "UBOAT6",
		name = unitName,
		nochasecategory = "VTOL",
		objectname = "Units/scavboss/ARMSERPT3.s3o",
		script = "Units/scavboss/ARMSERPT3.cob",
		seismicsignature = 0,
		selfdestructas = "mediumExplosionGenericSelfd-uw",
		sightdistance = 950,
		stealth = true,
		sonardistance = 800,
		turninplace = true,
		turninplaceanglelimit = 90,
		turnrate = 400,
		upright = true,
		waterline = 80, --45,
		customparams = {
			unitgroup = 'sub',
			model_author = "FireStorm",
			normaltex = "unittextures/Arm_normal.dds",
			subfolder = "armships/t2",
			techlevel = 3,
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "6.17767333984 -3.80371093733e-06 -10.6119995117",
				collisionvolumescales = "42.614654541 20.1074523926 56.7760009766",
				collisionvolumetype = "Box",
				damage = 24000,
				description = "Epic Serpent Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 6,
				footprintz = 6,
				height = 10,
				hitdensity = 100,
				metal = 7500,
				object = "Units/scavboss/armserpt3_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "55.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 12000,
				description = "Epic Serpent Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 6,
				footprintz = 6,
				height = 4,
				hitdensity = 100,
				metal = 3750,
				object = "Units/arm3X3F.s3o",
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
				[1] = "suarmmov",
			},
			select = {
				[1] = "suarmsel",
			},
		},
		weapondefs = {
			armserp_weapon = {
				areaofeffect = 16,
				avoidfeature = false,
				avoidfriendly = false,
				burnblow = true,
				collidefriendly = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				explosiongenerator = "custom:genericshellexplosion-large-uw",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				model = "torpedo.s3o",
				name = "Heavy guided torpedo launcher",
				noselfdamage = true,
				range = 800,
				reloadtime = 6,
				soundhit = "xplodep1",
				soundstart = "torpedo1",
				startvelocity = 150,
				tolerance = 8000,
				tracks = true,
				turnrate = 1750,
				turret = true,
				waterweapon = true,
				weaponacceleration = 25,
				weapontimer = 3,
				weapontype = "TorpedoLauncher",
				weaponvelocity = 220,
				damage = {
					default = 1650,
					subs = 1110,
					commanders = 750,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "HOVER NOTSHIP",
				def = "ARMSERP_WEAPON",
				maindir = "0 0.2 1",
				maxangledif = 60,
				onlytargetcategory = "NOTHOVER",
			},
			[2] = {
				badtargetcategory = "HOVER NOTSHIP",
				def = "ARMSERP_WEAPON",
				maindir = "-0.3826 0.2 0.9238",
				maxangledif = 60,
				onlytargetcategory = "NOTHOVER",
			},
			[3] = {
				badtargetcategory = "HOVER NOTSHIP",
				def = "ARMSERP_WEAPON",
				maindir = "-0.9238 0.2 0.3826",
				maxangledif = 60,
				onlytargetcategory = "NOTHOVER",
			},
			[4] = {
				badtargetcategory = "HOVER NOTSHIP",
				def = "ARMSERP_WEAPON",
				maindir = "0.3826 0.2 0.9238",
				maxangledif = 60,
				onlytargetcategory = "NOTHOVER",
			},
			[5] = {
				badtargetcategory = "HOVER NOTSHIP",
				def = "ARMSERP_WEAPON",
				maindir = "0.9238 0.2 0.3826",
				maxangledif = 60,
				onlytargetcategory = "NOTHOVER",
			},
		},
	},
}
