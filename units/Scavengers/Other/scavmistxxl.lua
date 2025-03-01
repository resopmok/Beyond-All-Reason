local unitName = Spring.I18N('units.names.scavmistxxl')

return {
	scavmistxxl = {
		acceleration = 0.207,
		autoheal = 25,
		brakerate = 0.6486,
		buildcostenergy = 25500,
		buildcostmetal = 2550,
		buildpic = "scavengers/SCAVMIST.DDS",
		buildtime = 25500,
		canmove = true,
		category = "ALL BOT MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "64 24 64",
		collisionvolumetype = "CylY",
		--corpse = "DEAD",
		description = Spring.I18N('units.descriptions.scavmistxxl'),
		explodeas = "mistexplosm",
		floater = true,
		footprintx = 4,
		footprintz = 4,
		hidedamage = true,
		idleautoheal = 5,
		idletime = 600,
		mass = 1000,
		maxdamage = 2550,
		maxvelocity = 2.0,
		maxwaterdepth = 0,
		movementclass = "SCAVMIST",
		name = unitName,
		nochasecategory = "ALL",
		objectname = "scavs/scavmistflare.s3o",
		script = "scavs/SCAVMIST.cob",
		seismicsignature = 0,
		selfdestructas = "mistexplosm",
		selfdestructcountdown = 0,
		sightdistance = 750,
		stealth = true,
		strafetoattack = true,
		turninplace = true,
		turninplaceanglelimit = 90,
		turninplacespeedlimit = 1.5,
		turnrate = 1200,
		unitname = "scavmistxxl",
		customparams = {
			model_author = "IceXuick",
			normaltex = "unittextures/Arm_normal.dds",
			paralyzemultiplier = 0.001,
			subfolder = "scavengers",
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:scavmist",
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
				[1] = "count1",
			},
			ok = {
				[1] = "spider2",
			},
			select = {
				[1] = "spider",
			},
		},
		weapondefs = {
			lightningsurgexxl = {
				areaofeffect = 20,
				avoidFriendly = false,
				avoidFeature = false,
				collideFriendly = false,
				beamttl = 0,
				burst = 8,
				burstrate = 0.03333,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				duration = 0,
				edgeeffectiveness = 0.25,
				explosiongenerator = "custom:lightning_storm_scavmist",
				firestarter = 75,
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				intensity = 0,
				laserFlareSize = 0,
				name = "Super Heavy Electrical Scavenger Surge",
				noselfdamage = true,
				range = 250,
				reloadtime = 3,
				rgbcolor = "0 0 0",
				soundhit = "xploelc2",
				soundhitwet = "sizzle",
				soundstart = "lghthvy2",
				soundtrigger = true,
				targetmoveerror = 0.15,
				thickness = 0,
				turret = true,
				weapontype = "LightningCannon",
				weaponvelocity = 100,
				customparams = {
					expl_light_color = "0.7 0.3 1",
					light_color = "0.0 0.0 0",
				},
				damage = {
					commanders = 50,
					bombers = 52,
					default = 220,
					fighters = 52,
					subs = 4,
					vtol = 52,
				},
			},
		},
		weapons = {
			[1] = {
				def = "lightningsurgexxl",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
