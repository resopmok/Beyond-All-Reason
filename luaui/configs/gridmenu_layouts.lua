local labGrids = {
	-- T1 bot
	armlab = {
		"armck", "armrectr", "armpw", "armflea",                -- T1 con, rez bot, peewee, flea
		"armrock", "armham", "armwar", "",                     -- rocko, hammer, warrior
		"", "", "armjeth",                                         -- aa bot
	},

	corlab = {
		"corck", "cornecro", "corak", "",                      -- T1 con, rez bot, AK
		"corstorm", "corthud", "", "",                        -- storm, thud
		"", "", "corcrash",                                        -- aa bot
	},
	-- T2 bot
	armalab = {
		"armack", "armfark", "armfast", "armspy",             -- T2 con, fark, zipper, spy
		"armmark", "armaser", "armzeus", "armmav",             -- radar bot, jammer bot, zeus, maverick
		"armfido", "armsnipe", "armaak", "armfboy",            -- fido, sniper, AA bot, fatboi
	},

	coralab = {
		"corack", "corfast", "corpyro", "corspy",               -- T2 con, freaker, pyro, spy
		"corvoyr", "corspec", "corcan", "corhrk",              -- radar bot, jammer bot, can, dominator
		"cormort", "corroach", "coraak", "corsumo",             -- morty, skuttle, AA bot, sumo
	},
	-- T1 vehicle
	armvp = {
		"armcv", "armmlv", "armflash", "armfav",        -- T1 con, minelayer, flash, scout
		"armstump", "armjanus", "armart", "",          -- stumpy, janus, arty
		"armbeaver", "armpincer", "armsam", "",        -- amphib con, amphib tank, missile truck
	},

	corvp = {
		"corcv", "cormlv", "corgator", "corfav",       -- T1 con, minelayer, gator, scout
		"corraid", "corlevlr", "corwolv", "",         -- raider, leveler, art
		"cormuskrat", "corgarp", "cormist", "",       -- amphib con, amphib tank, missile truck
	},

	-- T2 vehicle
	armavp = {
		"armacv", "armconsul", "armbull", "armmart",           -- T2 con, consul, bulldog, luger
		"armseer", "armjam", "armmanni", "armst",              -- radar, jammer, penetrator, gremlin
		"armlatnk", "armcroc", "armyork", "armmerl",           -- panther, triton, AA, merl
	},

	coravp = {
		"coracv", "corban", "correap", "cormart",              -- T2 con, banisher, reaper, pillager
		"corvrad", "coreter", "corgol", "cortrem",             -- radar, jammer, goli, tremor
		"corseal", "corparrow", "corsent", "corvroc",          -- croc, poison arrow, AA, diplomat
	},
	-- T1 air
	armap = {
		"armca", "armfig", "armkam", "armthund",           -- T1 con, fig, gunship, bomber
		"armpeep", "armatlas",                             -- radar, transport,
	},

	corap = {
		"corca", "corveng", "corbw", "corshad",              -- T1 con, fig, drone, bomber
		"corfink", "corvalk",                                -- radar, transport
	},
	-- T2 air
	armaap = {
		"armaca", "armhawk", "armbrawl", "armpnix",           -- T2 con, fig, gunship, bomber
		"armawac", "armdfly", "armlance", "armliche",         -- radar, transport, torpedo, liche
		"armblade", "armstil",                                -- blade, stiletto
	},

	coraap = {
		"coraca", "corvamp", "corape", "corhurc",              -- T2 con, fig, gunship, bomber
		"corawac", "corseah", "cortitan", "corcrw",            -- radar, transport, torpedo, krow
	},
	-- seaplanes
	armplat = {
		"armcsa", "armsfig", "armsaber", "armsb",           -- seaplane con, fig, gunship, bomber
		"armsehak", "armseap",                              -- radar, torpedo
	},

	corplat = {
		"corcsa", "corsfig", "corcut", "corsb",              -- seaplane con, fig, gunship, bomber
		"corhunt", "corseap",                                -- radar, torpedo
	},
	-- T1 boats
	armsy = {
		"armcs", "armrecl", "armdecade", "",              -- T1 sea con, rez sub, decade
		"armpship", "armroy", "", "",                    -- frigate, destroyer, transport ("armtship",)
		"armsub", "", "armpt",                            -- sub, PT boat
	},

	corsy = {
		"corcs", "correcl", "coresupp", "",               -- T1 sea con, rez sub, supporter, missile boat
		"corpship", "corroy", "", "",                    -- frigate, destroyer, transport ("cortship",)
		"corsub", "", "corpt",                            -- sub, missile boat
	},
	-- T2 boats
	armasy = {
		"armacsub", "armmls", "armcrus", "armmship",         -- T2 con sub, naval engineer, cruiser, rocket ship
		"armcarry", "armsjam", "armbats", "armepoch",        -- carrier, jammer, battleship, flagship
		"armsubk", "armserp", "armaas",                      -- sub killer, battlesub, AA
	},

	corasy = {
		"coracsub", "cormls", "corcrus", "cormmship",              -- T2 con sub, naval engineer, cruiser, rocket ship
		"corcarry", "corsjam", "corbats", "corblackhy",            -- carrier, jammer, battleship, flagship
		"corshark", "corssub", "corarch",                          -- sub killer, battlesub, AA
	},
	-- amphibious labs
	armamsub = {
		"armbeaver", "armdecom", "armpincer", "",
		"armcroc", "", "", "",
		"", "armjeth", "armaak",
	},

	coramsub = {
		"cormuskrat", "cordecom", "corgarp", "",
		"corseal", "corparrow", "", "",
		"", "corcrash", "coraak",
	},
	-- hover labs
	armhp = {
		"armch", "", "armsh", "",
		"armanac", "armmh", "", "",
		"", "", "armah",
	},

	corhp = {
		"corch", "", "corsh", "",
		"corsnap", "cormh", "corhal", "",
		"", "", "corah",
	},
	armfhp = {
		"armch", "", "armsh", "",
		"armanac", "armmh", "", "",
		"", "", "armah",
	},

	corfhp = {
		"corch", "", "corsh", "",
		"corsnap", "cormh", "corhal", "",
		"", "", "corah",
	},
}
local unitGrids = {
	-- Commanders
	armcom = {
		{
			{ "armmex", "armsolar", "armwin", },              -- mex, solar, wind
			{ "armmakr", "armtide", "armuwms", },             -- T1 converter, tidal, uw m storage
			{ "armestor", "armmstor", "armuwes", "armfmkr", }, -- e storage, m storage, uw e storage, floating converter
		},
		{
			{ "armllt", "armtl", },                          -- LLT, offshore torp launcher
			{ "armrl", "armfrt", },                          -- basic AA, floating AA
			{ "armdl", },                                    -- coastal torp launcher
		},
		{
			{ "armrad", "armeyes", "armdrag", },             -- radar, perimeter camera, dragon's teeth
			{ "armfrad", "armfdrag", },                      -- floating radar, shark's teeth
			{ },                                             -- empty
		},
		{
			{ "armlab", "armvp", "armap", "armsy", },        -- bot lab, veh lab, air lab, shipyard
			{ },                                             -- empty row
			{ "armhp", "armfhp", },                          -- hover lab, floating hover lab
		}
	},

	corcom = {
		{
			{ "cormex", "corsolar", "corwin", },                -- mex, solar, wind
			{ "cormakr", "cortide", "coruwms", },               -- T1 converter, tidal, uw m storage
			{ "corestor", "cormstor", "coruwes", "corfmkr",  }, -- e storage, m sotrage, uw e storage, floating converter
		},
		{
			{ "corllt", "cortl", },                          -- LLT, offshore torp launcher
			{ "corrl", "corfrt", },                          -- basic AA, floating AA
			{ "cordl", },                                    -- coastal torp launcher
		},
		{
			{ "corrad", "coreyes", "cordrag", },             -- radar, perimeter camera, dragon's teeth
			{ "corfrad", "corfdrag", },                      -- floating radar, shark's teeth
			{ },                                             -- empty
		},
		{
			{ "corlab", "corvp", "corap", "corsy", },        -- bot lab, veh lab, air lab, shipyard
			{ },                                             -- empty row
			{ "corhp", "corfhp", },                          -- hover lab, floating hover lab
		}
	},

	-- T1 bot con
	armck = {
		{
			{ "armmex", "armsolar", "armwin", "armadvsol", },  -- mex, solar, wind, adv. solar
			{ "armmakr", "armgeo", "armamex", },               -- T1 converter, geo, twilight, (tidal)
			{ "armestor", "armmstor", },                       -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "armllt", "armbeamer", "armhlt", "armclaw", },  -- LLT, beamer, HLT, lightning turret
			{ "armrl", "armferret", "armcir", },              -- basic AA, ferret, chainsaw
			{ "armdl", "armguard", },                         -- coastal torp launcher, guardian
		},
		{
			{ "armrad", "armeyes", "armdrag", "armjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "armjuno", },                                   -- juno, air repair pad aircon only
		},
		{
			{ "armlab", "armvp", "armap", "armsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "armnanotc", "armalab", },                      -- nano, T2 lab
			{ "armhp", },                                     -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	corck = {
		{
			{ "cormex", "corsolar", "corwin", "coradvsol", },   -- mex, solar, wind, adv. solar
			{ "cormakr", "corgeo", "corexp", },                 -- T1 converter, geo, exploiter, (tidal)
			{ "corestor", "cormstor", },                        -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "corllt", "corhllt", "corhlt", "cormaw", },     -- LLT, Double LLT, HLT, flame turret
			{ "corrl", "cormadsam", "corerad", },             -- basic AA, SAM, eradicator
			{ "cordl", "corpun", },                           -- coastal torp launcher, punisher
		},
		{
			{ "corrad", "coreyes", "cordrag", "corjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "corjuno", },                                   -- juno, air repair pad aircon only
		},
		{
			{ "corlab", "corvp", "corap", "corsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "cornanotc", "coralab", },                      -- nano, T2 lab
			{ "corhp", },                                     -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	-- T1 vehicle con
	armcv = {
		{
			{ "armmex", "armsolar", "armwin", "armadvsol", },  -- mex, solar, wind, adv. solar
			{ "armmakr", "armgeo", "armamex", },               -- T1 converter, geo, twilight, (tidal)
			{ "armestor", "armmstor", },                       -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "armllt", "armbeamer", "armhlt", "armclaw", },  -- LLT, beamer, HLT, lightning turret
			{ "armrl", "armferret", "armcir", },              -- basic AA, ferret, chainsaw
			{ "armdl", "armguard", },                         -- coastal torp launcher, guardian
		},
		{
			{ "armrad", "armeyes", "armdrag", "armjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "armjuno", },                                   -- juno, air repair pad aircon only
		},
		{
			{ "armlab", "armvp", "armap", "armsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "armnanotc", "armavp", },                       -- nano, T2 lab
			{ "armhp", },                                     -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	corcv = {
		{
			{ "cormex", "corsolar", "corwin", "coradvsol", },   -- mex, solar, wind, adv. solar
			{ "cormakr", "corgeo", "corexp", },                 -- T1 converter, geo, exploiter, (tidal)
			{ "corestor", "cormstor", },                        -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "corllt", "corhllt", "corhlt", "cormaw", },     -- LLT, Double LLT, HLT, flame turret
			{ "corrl", "cormadsam", "corerad", },             -- basic AA, SAM, eradicator
			{ "cordl", "corpun", },                           -- coastal torp launcher, punisher
		},
		{
			{ "corrad", "coreyes", "cordrag", "corjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "corjuno", },                                   -- juno, air repair pad aircon only
		},
		{
			{ "corlab", "corvp", "corap", "corsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "cornanotc", "coravp", },                       -- nano, T2 lab
			{ "corhp", },                                     -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	-- T1 air con
	armca = {
		{
			{ "armmex", "armsolar", "armwin", "armadvsol", },  -- mex, solar, wind, adv. solar
			{ "armmakr", "armgeo", "armamex", },               -- T1 converter, geo, twilight, (tidal)
			{ "armestor", "armmstor", },                       -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "armllt", "armbeamer", "armhlt", "armclaw", },  -- LLT, beamer, HLT, lightning turret
			{ "armrl", "armferret", "armcir", },              -- basic AA, ferret, chainsaw
			{ "armdl", "armguard", },                         -- coastal torp launcher, guardian
		},
		{
			{ "armrad", "armeyes", "armdrag", "armjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "armjuno", "armasp", },                         -- juno, air repair pad aircon only
		},
		{
			{ "armlab", "armvp", "armap", "armsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "armnanotc", "armaap", },                       -- nano, T2 lab
			{ "armhp", },                                     -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	corca = {
		{
			{ "cormex", "corsolar", "corwin", "coradvsol", },   -- mex, solar, wind, adv. solar
			{ "cormakr", "corgeo", "corexp", },                 -- T1 converter, geo, exploiter, (tidal)
			{ "corestor", "cormstor", },                        -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "corllt", "corhllt", "corhlt", "cormaw", },     -- LLT, Double LLT, HLT, flame turret
			{ "corrl", "cormadsam", "corerad", },             -- basic AA, SAM, eradicator
			{ "cordl", "corpun", },                           -- coastal torp launcher, punisher
		},
		{
			{ "corrad", "coreyes", "cordrag", "corjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "corjuno", "corasp", },                         -- juno, air repair pad aircon only
		},
		{
			{ "corlab", "corvp", "corap", "corsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "cornanotc", "coraap", },                       -- nano, T2 lab
			{ "corhp", },                                     -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	-- T1 sea con
	armcs = {
		{
			{ "armmex", "armtide", },                         -- mex, tidal
			{ "armfmkr", "armgeo", },                         -- floating T1 converter, geo
			{ "armuwes", "armuwms", },                        -- uw e stor, uw m stor
		},
		{
			{ "armtl", "armfhlt", },                          -- offshore torp launcher, floating HLT
			{ "armfrt", },                                    -- floating AA
			{ "armdl", "armguard", "armclaw", },              -- coastal torp launcher, guardian, lightning turret
		},
		{
			{ "armfrad", "armfdrag", },                       -- floating radar, shark's teeth
			{ "armeyes", "armdrag", },                        -- perimeter camera, dragon's teeth
		},
		{
			{ "armsy", "armfhp", "armamsub", "armplat", },    -- shipyard, floating hover, amphibious lab, seaplane lab
			{ "armnanotcplat", "armasy", },                   -- floating nano, T2 shipyard
			{ "armlab", "armvp", "armap", },                  -- bot lab, vehicle lab, air lab
		}
	},

	corcs = {
		{
			{ "cormex", "cortide", },                         -- mex, tidal
			{ "corfmkr", "corgeo", },                         -- floating T1 converter, geo
			{ "coruwes", "coruwms", },                        -- uw e stor, uw m stor
		},
		{
			{ "cortl", "corfhlt", },                          -- offshore torp launcher, floating HLT
			{ "corfrt", },                                    -- floating AA
			{ "cordl", "corpun", "cormaw", },                 -- coastal torp launcher, punisher, flame turret
		},
		{
			{ "corfrad", "corfdrag", },                       -- floating radar, shark's teeth
			{ "coreyes", "cordrag", },                        -- perimeter camera, dragon's teeth
		},
		{
			{ "corsy", "corfhp", "coramsub", "corplat", },    -- shipyard, floating hover, amphibious lab, seaplane lab
			{ "cornanotcplat", "corasy", },                   -- floating nano, T2 shipyard
			{ "corlab", "corvp", "corap", },                  -- bot lab, vehicle lab, air lab
		}
	},

	-- Hover cons
	armch = {
		{
			{ "armmex", "armsolar", "armwin", "armadvsol", },  -- mex, solar, wind, adv. solar
			{ "armmakr", "armgeo", "armamex", "armtide",  },   -- T1 converter, geo, twilight, (tidal)
			{ "armestor", "armmstor", "armuwes", "armfmkr", }, -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "armllt", "armbeamer", "armhlt", "armclaw", },  -- LLT, beamer, HLT, lightning turret
			{ "armrl", "armferret", "armcir", "armfrt",},     -- basic AA, ferret, chainsaw, floating AA
			{ "armdl", "armguard", "armtl", "armfhlt", },     -- coastal torp launcher, guardian, offshore torp launcher, floating HLT
		},
		{
			{ "armrad", "armeyes", "armdrag", "armjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "armjuno", },                                   -- juno, air repair pad aircon only
			{ "armfrad", "armfdrag", },                       -- floating radar, shark's teeth
		},
		{
			{ "armlab", "armvp", "armap", "armsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "armnanotc", "armnanotcplat", },                -- nano, floating nano
			{ "armhp", "armfhp", "armamsub", "armplat", },    -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	corch = {
		{
			{ "cormex", "corsolar", "corwin", "coradvsol", },   -- mex, solar, wind, adv. solar
			{ "cormakr", "corgeo", "corexp", "cortide", },      -- T1 converter, geo, exploiter, (tidal)
			{ "corestor", "cormstor", "coruwes", "corfmkr", },  -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "corllt", "corhllt", "corhlt", "cormaw", },     -- LLT, Double LLT, HLT, flame turret
			{ "corrl", "cormadsam", "corerad", },             -- basic AA, SAM, eradicator
			{ "cordl", "corpun", "cortl", "corfhlt", },       -- coastal torp launcher, punisher, offshore torp launcher, floating HLT
		},
		{
			{ "corrad", "coreyes", "cordrag", "corjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "corjuno", },                                   -- juno, air repair pad aircon only
			{ "corfrad", "corfdrag", },                       -- floating radar, shark's teeth
		},
		{
			{ "corlab", "corvp", "corap", "corsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "cornanotc", "cornanotcplat", },                -- nano, floating nano
			{ "corhp", "corfhp", "coramsub", "corplat", },    -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	-- Seaplane cons
	armcsa = {
		{
			{ "armmex", "armsolar", "armwin", "armadvsol", },  -- mex, solar, wind, adv. solar
			{ "armmakr", "armgeo", "armamex", "armtide",  },   -- T1 converter, geo, twilight, (tidal)
			{ "armestor", "armmstor", "armuwes", "armfmkr", }, -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "armllt", "armbeamer", "armhlt", "armclaw", },  -- LLT, beamer, HLT, lightning turret
			{ "armrl", "armferret", "armcir", "armfrt",},     -- basic AA, ferret, chainsaw, floating AA
			{ "armdl", "armguard", "armtl", "armfhlt", },     -- coastal torp launcher, guardian, offshore torp launcher, floating HLT
		},
		{
			{ "armrad", "armeyes", "armdrag", "armjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "armjuno", },                                   -- juno, air repair pad aircon only
			{ "armfrad", "armfdrag", },                       -- floating radar, shark's teeth
		},
		{
			{ "armlab", "armvp", "armap", "armsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "armnanotc", "armnanotcplat", },                -- nano, floating nano
			{ "armhp", "armfhp", "armamsub", "armplat", },    -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	corcsa = {
		{
			{ "cormex", "corsolar", "corwin", "coradvsol", },   -- mex, solar, wind, adv. solar
			{ "cormakr", "corgeo", "corexp", "cortide", },      -- T1 converter, geo, exploiter, (tidal)
			{ "corestor", "cormstor", "coruwes", "corfmkr", },  -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "corllt", "corhllt", "corhlt", "cormaw", },     -- LLT, Double LLT, HLT, flame turret
			{ "corrl", "cormadsam", "corerad", },             -- basic AA, SAM, eradicator
			{ "cordl", "corpun", "cortl", "corfhlt", },       -- coastal torp launcher, punisher, offshore torp launcher, floating HLT
		},
		{
			{ "corrad", "coreyes", "cordrag", "corjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "corjuno", },                                   -- juno, air repair pad aircon only
			{ "corfrad", "corfdrag", },                       -- floating radar, shark's teeth
		},
		{
			{ "corlab", "corvp", "corap", "corsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "cornanotc", "cornanotcplat", },                -- nano, floating nano
			{ "corhp", "corfhp", "coramsub", "corplat", },    -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	-- Amphibious vehicle cons
	armbeaver = {
		{
			{ "armmex", "armsolar", "armwin", "armadvsol", },  -- mex, solar, wind, adv. solar
			{ "armmakr", "armgeo", "armamex", "armtide",  },   -- T1 converter, geo, twilight, (tidal)
			{ "armestor", "armmstor", "armuwes", "armfmkr", }, -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "armllt", "armbeamer", "armhlt", "armclaw", },  -- LLT, beamer, HLT, lightning turret
			{ "armrl", "armferret", "armcir", "armfrt",},     -- basic AA, ferret, chainsaw, floating AA
			{ "armdl", "armguard", "armptl", "armfhlt", },     -- coastal torp launcher, guardian, offshore torp launcher, floating HLT
		},
		{
			{ "armrad", "armeyes", "armdrag", "armjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "armjuno", },                                   -- juno, air repair pad aircon only
			{ "armfrad", "armfdrag", },                       -- floating radar, shark's teeth
		},
		{
			{ "armlab", "armvp", "armap", "armsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "armnanotc", "armnanotcplat", "armavp", },      -- nano, floating nano, T2 veh lab
			{ "armhp", "armfhp", "armamsub", "armplat", },    -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	cormuskrat = {
		{
			{ "cormex", "corsolar", "corwin", "coradvsol", },   -- mex, solar, wind, adv. solar
			{ "cormakr", "corgeo", "corexp", "cortide", },      -- T1 converter, geo, exploiter, (tidal)
			{ "corestor", "cormstor", "coruwes", "corfmkr", },  -- e storage, m storage, (uw e stor), (fl. T1 converter)
		},
		{
			{ "corllt", "corhllt", "corhlt", "cormaw", },     -- LLT, Double LLT, HLT, flame turret
			{ "corrl", "cormadsam", "corerad", },             -- basic AA, SAM, eradicator
			{ "cordl", "corpun", "corptl", "corfhlt", },       -- coastal torp launcher, punisher, offshore torp launcher, floating HLT
		},
		{
			{ "corrad", "coreyes", "cordrag", "corjamt", },   -- radar, perimeter camera, dragon's teeth, jammer
			{ "corjuno", },                                   -- juno, air repair pad aircon only
			{ "corfrad", "corfdrag", },                       -- floating radar, shark's teeth
		},
		{
			{ "corlab", "corvp", "corap", "corsy", },         -- bot lab, veh lab, air lab, shipyard
			{ "cornanotc", "cornanotcplat", "coravp", },      -- nano, floating nano, T2 veh lab
			{ "corhp", "corfhp", "coramsub", "corplat", },    -- hover lab, floating hover lab, amphibious lab, seaplane lab
		}
	},

	--T2 bot cons
	armack = {
		{
			{ "armmoho", "armfus", "armafus", "armageo", },            -- moho, fusion, afus, T2 geo
			{ "armmmkr", "armgmm", "armckfus", },                      -- T2 converter, safe geo, cloaked fusion
			{ "armuwadves", "armuwadvms", },                           -- hardened energy storage, hardened metal storage
		},
		{
			{ "armpb", "armanni", "armamb", "armemp", },        -- pop-up gauss, annihilator, pop-up artillery, EMP missile
			{ "armflak", "armmercury", "armamd", },             -- flak, long-range AA, anti-nuke
			{ "armbrtha", "armvulc", "armsilo", },              -- LRPC, ICBM, lolcannon
		},
		{
			{ "armarad", "armtarg", "armfort", "armveil",  },   -- adv radar, targeting facility, wall, adv jammer
			{ "armsd", "armasp", "armdf", },                    -- intrusion counter, air repair pad, decoy fusion
			{ "armgate", },                                     -- shield
		},
		{
			{ "armlab", },                                      -- T1 lab,
			{ "armshltx", "armalab", },                         -- T3 lab, T2 lab
			{ },                                                --
		}
	},

	corack = {
		{
			{ "cormoho", "corfus", "corafus", "corageo", },     -- moho, fusion, afus, T2 geo
			{ "cormmkr", "corbhmth", "cormexp", },              -- T2 converter, behemoth, armed moho
			{ "coruwadves", "coruwadvms", },                    -- hardened energy storage, hardened metal storage,
		},
		{
			{ "corvipe", "cordoom", "cortoast", "cortron", },   -- pop-up gauss, DDM, pop-up artillery, tac nuke
			{ "corflak", "corscreamer", "corfmd", },            -- flak, long-range AA
			{ "corint", "corbuzz", "corsilo", },                -- LRPC, ICBM, lolcannon
		},
		{
			{ "corarad", "cortarg", "corfort", "corshroud", },  -- adv radar, targeting facility, wall, adv jammer
			{ "corsd", "corasp", },                             -- intrusion counter, air repair pad
			{ "corgate", },                                     -- anti-nuke, shield
		},
		{
			{ "corlab", },                                      -- T1 lab,
			{ "corgant", "coralab", },                          -- T3 lab, T2 lab
			{ },                                                --
		}
	},

	--T2 vehicle cons
	armacv = {
		{
			{ "armmoho", "armfus", "armafus", "armageo", },            -- moho, fusion, afus, T2 geo
			{ "armmmkr", "armgmm", "armckfus", },                      -- T2 converter, safe geo, cloaked fusion
			{ "armuwadves", "armuwadvms", },                           -- hardened energy storage, hardened metal storage
		},
		{
			{ "armpb", "armanni", "armamb", "armemp", },        -- pop-up gauss, annihilator, pop-up artillery, EMP missile
			{ "armflak", "armmercury", "armamd", },             -- flak, long-range AA, anti-nuke
			{ "armbrtha", "armvulc", "armsilo", },              -- LRPC, ICBM, lolcannon
		},
		{
			{ "armarad", "armtarg", "armfort", "armveil",  },   -- adv radar, targeting facility, wall, adv jammer
			{ "armsd", "armasp", "armdf", },                    -- intrusion counter, air repair pad, decoy fusion
			{ "armgate", },                                     -- shield
		},
		{
			{ "armvp", },                                       -- T1 lab,
			{ "armshltx", "armavp", },                          -- T3 lab, T2 lab
			{ },                                                --
		}
	},

	coracv = {
		{
			{ "cormoho", "corfus", "corafus", "corageo", },     -- moho, fusion, afus, T2 geo
			{ "cormmkr", "corbhmth", "cormexp", },              -- T2 converter, behemoth, armed moho
			{ "coruwadves", "coruwadvms", },                    -- hardened energy storage, hardened metal storage,
		},
		{
			{ "corvipe", "cordoom", "cortoast", "cortron", },   -- pop-up gauss, DDM, pop-up artillery, tac nuke
			{ "corflak", "corscreamer", "corfmd", },            -- flak, long-range AA
			{ "corint", "corbuzz", "corsilo", },                -- LRPC, ICBM, lolcannon
		},
		{
			{ "corarad", "cortarg", "corfort", "corshroud", },  -- adv radar, targeting facility, wall, adv jammer
			{ "corsd", "corasp", },                             -- intrusion counter, air repair pad
			{ "corgate", },                                     -- anti-nuke, shield
		},
		{
			{ "corvp", },                                       -- T1 lab,
			{ "corgant", "coravp", },                           -- T3 lab, T2 lab
			{ },                                                --
		}
	},

	--T2 air cons
	armaca = {
		{
			{ "armmoho", "armfus", "armafus", "armageo", },            -- moho, fusion, afus, T2 geo
			{ "armmmkr", "armgmm", "armckfus", },                      -- T2 converter, safe geo, cloaked fusion
			{ "armuwadves", "armuwadvms", },                           -- hardened energy storage, hardened metal storage
		},
		{
			{ "armpb", "armanni", "armamb", "armemp", },        -- pop-up gauss, annihilator, pop-up artillery, EMP missile
			{ "armflak", "armmercury", "armamd", },             -- flak, long-range AA, anti-nuke
			{ "armbrtha", "armvulc", "armsilo", },              -- LRPC, ICBM, lolcannon
		},
		{
			{ "armarad", "armtarg", "armfort", "armveil",  },    -- adv radar, targeting facility, wall, adv jammer
			{ "armsd", "armasp", "armdf", },                    -- intrusion counter, air repair pad, decoy fusion
			{ "armgate", },                                     -- shield
		},
		{
			{ "armap", },                                       -- T1 lab,
			{ "armshltx", "armaap", },                          -- T3 lab, T2 lab
			{ "armplat", },                                     -- seaplane lab (aircon only)
		}
	},

	coraca = {
		{
			{ "cormoho", "corfus", "corafus", "corageo", },     -- moho, fusion, afus, T2 geo
			{ "cormmkr", "corbhmth", "cormexp", },              -- T2 converter, behemoth, armed moho
			{ "coruwadves", "coruwadvms", },                    -- hardened energy storage, hardened metal storage,
		},
		{
			{ "corvipe", "cordoom", "cortoast", "cortron", },   -- pop-up gauss, DDM, pop-up artillery, tac nuke
			{ "corflak", "corscreamer", "corfmd", },            -- flak, long-range AA
			{ "corint", "corbuzz", "corsilo", },                -- LRPC, ICBM, lolcannon
		},
		{
			{ "corarad", "cortarg", "corfort", "corshroud", },  -- adv radar, targeting facility, wall, adv jammer
			{ "corsd", "corasp", },                             -- intrusion counter, air repair pad
			{ "corgate", },                                     -- anti-nuke, shield
		},
		{
			{ "corap", },                                       -- T1 lab,
			{ "corgant", "coraap", },                           -- T3 lab, T2 lab
			{ "corplat", },                                     -- seaplane lab (aircon only)
		}
	},

	--T2 sub cons
	armacsub = {
		{
			{ "armuwmme", "armuwfus", },                       -- uw moho, uw fusion,
			{ "armuwmmm", },                                   -- floating T2 converter
			{ "armuwadves", "armuwadvms", },                   -- uw e stor, uw metal stor
		},
		{
			{ "armatl", "armkraken", },                        -- adv torp launcher, floating heavy platform
			{ "armfflak", },                                   -- floating flak
			{ },                                               --
		},
		{
			{ "armason", "armfatf", },                         -- adv sonar, floating targeting facility
			{ },                                               --
			{ },                                               --
		},
		{
			{ "armsy", },                                      -- T1 shipyard
			{ "armshltxuw", "armasy", },                       -- amphibious gantry, T2 shipyard
			{ },                                               --
		}
	},

	coracsub = {
		{
			{ "coruwmme", "coruwfus", },                       -- uw moho, uw fusion,
			{ "coruwmmm", },                                   -- floating T2 converter
			{ "coruwadves", "coruwadvms", },                   -- uw e stor, uw metal stor
		},
		{
			{ "coratl", "corfdoom", },                         -- adv torp launcher, floating heavy platform
			{ "corenaa", },                                    -- floating flak
			{ },                                               --
		},
		{
			{ "corason", "corfatf", },                         -- adv sonar, floating targeting facility
			{ },                                               --
		},
		{
			{ "corsy", },                                      -- T1 shipyard
			{ "corgantuw", "corasy" },                         -- amphibious gantry, T2 shipyard
			{ },                                               --
		}
	},

	--minelayers
	armmlv = {
		{
			{ }, --
			{ },            --
			{ },          --
		},
		{
			{ },                          --
			{ },                          --
			{ },                                    --
		},
		{
			{ "armeyes", "armdrag", },                  -- camera, dragon's teeth
			{ },                                        --
			{ "armmine1", "armmine2", "armmine3", },    -- light mine, med mine, heavy mine
		},
		{
			{ },        --
			{ },                                             --
			{ },                          --
		}
	},

	cormlv = {
		{
			{ }, --
			{ },            --
			{ },          --
		},
		{
			{ },                          --
			{ },                          --
			{ },                                    --
		},
		{
			{ "coreyes", "cordrag", },                 -- camera, dragon's teeth
			{ },                                       --
			{ "cormine1", "cormine2", "cormine3", },   -- light mine, med mine, heavy mine
		},
		{
			{ },        --
			{ },                                             --
			{ },                          --
		}
	},

	--Decoy commanders
	armdecom = {
		{
			{ "armmex", "armsolar", "armwin", },               -- mex, solar, wind
			{ "armmakr", "armtide", "armuwms", },              -- T1 converter, tidal, uw ms storage
			{ "armestor", "armmstor", "armuwes", "armfmkr", }, -- e storage, m storage, uw e storage, floating T1 converter
		},
		{
			{ "armllt", },                                   -- LLT
			{ "armrl", },                                    -- basic AA
			{ },                                             --
		},
		{
			{ "armrad", },                                   -- radar
			{ },                                             --
			{ "armmine1", "armmine2", "armmine3", },         -- light mine, med mine, heavy mine
		},
		{
			{ },                                             --
			{ },                                             -- empty row
			{ },                                             --
		}
	},

	cordecom = {
		{
			{ "cormex", "corsolar", "corwin", },               -- mex, solar, wind
			{ "cormakr", "cortide", "coruwms", },              -- T1 converter, tidal, uw ms storage
			{ "corestor", "cormstor", "coruwes", "corfmkr", }, -- e storage, m storage, uw e storage, floating T1 converter
		},
		{
			{ "corllt", },                                   -- LLT
			{ "corrl", },                                    -- basic AA
			{ },                                             --
		},
		{
			{ "corrad", },                                   -- radar
			{ },                                             --
			{ "cormine1", "cormine2", "cormine3", },         -- light mine, med mine, heavy mine
		},
		{
			{ },                                             --
			{ },                                             -- empty row
			{ },                                             --
		}
	},

	--fark
	armfark = {
		{
			{ "armmex", "armsolar", "armwin", },   -- mex, solar, wind
			{ "armmakr", },                        -- T1 converter
			{ },                                   --
		},
		{
			{ },                                   --
			{ },                                   --
			{ },                                   --
		},
		{
			{ "armmark", "armeyes", "armaser", },  -- radar bot, perimeter camera, jammer bot
			{ },                                   --
			{ },                                   --
		},
		{
			{ },                                   --
			{ },                                   --
			{ },                                   --
		}
	},

	--freaker
	corfast = {
		{
			{ "cormex", "corsolar", },                                -- mex, solar
			{ },                                                      -- solar
			{ },                                                      --
		},
		{
			{ "corhllt", "corpyro", "cortoast", },                    -- HLLT, pyro, toaster
			{ "corflak", "cormadsam", "corcrash", "corak", },         -- flak, SAM, T1 aa bot, AK
			{ "cordl", "corroy", "coramph", },                        -- coastal torp launcher, destroyer, gimp
		},
		{
			{ "corarad", "coreyes", "corfort", "corshroud", },        -- adv radar, camera, wall, adv jammer
			{ },                                                      --
			{ "cormine2", },                                          -- med mine
		},
		{
			{ "corlab", "corck", },                                   -- bot lab, bot con
			{ "cornanotc", "corcs", },                                -- nano, sea con
			{ "cormando", },                                          -- commando
		}
	},

	--consul
	armconsul = {
		{
			{ "armmex", "armsolar", },                                -- mex, solar
			{ },                                                      --
			{ },                                                      --
		},
		{
			{ "armbeamer", "armfido", "armamb", "armmav", },          -- beamer, fido, ambusher, maverick
			{ "armflak", "armferret", "armjeth", "armpw", },          -- flak, ferret, T1 aa bot, peewee
			{ "armdl", "armroy", "armsptk", },                        -- coastal torp launcher, destroyer, missile spider
		},
		{
			{ "armarad", "armeyes", "armfort", "armveil", },          -- adv radar, camera, wall, adv jammer
			{ },                                                      --
			{ "armmine2" },                                           -- med. mine
		},
		{
			{ "armvp", "armcv", },                                    -- vehicle lab, T1 veh con
			{ "armnanotc", "armcs", },                                -- nano, sea con
			{ },                                                      --
		}
	},

	--commando
	cormando = {
		{
			{ }, --
			{ },            --
			{ },          --
		},
		{
			{ "cormaw", },                                           -- flame turret
			{ },                                                     --
			{ },                                                     --
		},
		{
			{ "corfink", "coreyes", "cordrag", "corjamt", },         -- scout plane, camera, dragon's teeth, jammer
			{ "corvalk", },                                          -- transport
			{ "cormine4" },                                          -- commando mine
		},
		{
			{ },        --
			{ },                                             --
			{ },                          --
		}
	},

	--naval engineers
	armmls = {
		{
			{ "armmex", "armtide", },                               -- mex, tidal
			{ },                                                    --
			{ },                                                    --
		},
		{
			{ "armtl", "armkraken", "armamb", "armfhlt", },         -- torp launcher, kraken, ambusher, fHLT
			{ "armfflak", "armpt", "armamph", },                    -- fl flak, PT boat, pelican
			{ "armdecade", "armroy", },                             -- decade, destroyer
		},
		{
			{ "armfrad", "armarad", },                              -- fl radar, adv radar
			{ },                                                    --
			{ "armfmine3", },                                       -- naval mine
		},
		{
			{ "armsy", "armcs", },                                  -- shipyard, sea con
			{ "armnanotcplat", },                                   -- fl nano
			{ },                                                    --
		}
	},

	cormls = {
		{
			{ "cormex", "cortide", },                              -- mex, tidal
			{ },                                                   --
			{ },                                                   --
		},
		{
			{ "cortl", "corfdoom", "cortoast", "corfhlt", },       -- torp launcher, fl DDM, toaster, fHLT
			{ "corenaa", "corpt", },                               -- fl flak, searcher
			{ "coresupp", "corroy", },                             -- supporter, destroyer
		},
		{
			{ "corfrad", "corarad", },                             -- fl radar, adv radar
			{ },                                                   --
			{ "corfmine3", },                                      -- naval mine
		},
		{
			{ "corsy", "corcs", },                                 -- shipyard, sea con
			{ "cornanotcplat", },                                  -- fl nano
			{ },                                                   --
		}
	},
}

return {
	LabGrids = labGrids,
	UnitGrids = unitGrids,
}
