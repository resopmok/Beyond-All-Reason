local constructorController = VFS.Include("luarules/gadgets/scavengers/Modules/constructor_controller.lua")
local airUnitList = VFS.Include("luarules/gadgets/scavengers/Configs/BYAR/UnitLists/air.lua")
local landUnitList = VFS.Include("luarules/gadgets/scavengers/Configs/BYAR/UnitLists/land.lua")
local seaUnitList = VFS.Include("luarules/gadgets/scavengers/Configs/BYAR/UnitLists/sea.lua")
local constructorUnitList = VFS.Include("luarules/gadgets/scavengers/Configs/BYAR/UnitLists/constructors.lua")
local staticUnitList = VFS.Include("luarules/gadgets/scavengers/Configs/BYAR/UnitLists/staticunits.lua")

local ReinforcementsCountPerTeam = {}
local TryingToSpawnReinforcements = {}
local ReinforcementsFaction = {}
local ReinforcementsChancePerTeam = {}
local numOfSpawnBeaconsTeamsForSpawn = {}
local CaptureProgressForBeacons = {}

FriendlyResurrectors = {}
FriendlyCollectors = {}
FriendlyReclaimers = {}

function CaptureBeacons(n)
	local scavengerunits = Spring.GetTeamUnits(GaiaTeamID)
	local spGetUnitTeam = Spring.GetUnitTeam

	for i = 1,#scavengerunits do
		local scav = scavengerunits[i]
		local scavDef = Spring.GetUnitDefID(scav)
		if scavSpawnBeacon[scav] then
			if not CaptureProgressForBeacons[scav] then
				CaptureProgressForBeacons[scav] = 0
				Spring.SetUnitHealth(scav, {capture = CaptureProgressForBeacons[scav]})
			end
			local posx,posy,posz = Spring.GetUnitPosition(scav)
			--Spring.Echo("posx "..posx)
			--Spring.Echo("posz "..posz)
			unitsAround = Spring.GetUnitsInCylinder(posx, posz, 256)
			--Spring.Echo("#unitsAround "..#unitsAround)
			CapturingUnits = {}
			CapturingUnitsTeam = {}
			CapturingUnitsTeamTest = {}
			local TeamsCapturing = 0
			CapturingUnits[scav] = 0

			for j = 1,#unitsAround do
				local unitID = unitsAround[j]
				local unitTeamID = spGetUnitTeam(unitID)
				local unitAllyTeam = Spring.GetUnitAllyTeam(unitID)
				local LuaAI = Spring.GetTeamLuaAI(unitTeamID)
				local _,_,_,isAI,_,_ = Spring.GetTeamInfo(unitTeamID)
				if (not LuaAI) and unitTeamID ~= GaiaTeamID and unitTeamID ~= Spring.GetGaiaTeamID() and (not isAI) then
					captureraiTeam = false
				else
					captureraiTeam = false -- true
				end
				if not CapturingUnitsTeamTest[unitAllyTeam] then
					CapturingUnitsTeamTest[unitAllyTeam] = true
					if unitTeamID ~= GaiaTeamID and captureraiTeam == false then
						TeamsCapturing = TeamsCapturing + 1
						if TeamsCapturing > 1 then
							break
						end
					end
				end
				captureraiTeam = nil
			end

			for j = 1,#unitsAround do
				local unitID = unitsAround[j]
				local unitTeamID = spGetUnitTeam(unitID)
				if not CapturingUnitsTeam[unitTeamID] then
					CapturingUnitsTeam[unitTeamID] = 0
				end
				local unitDefID = Spring.GetUnitDefID(unitID)
				local LuaAI = Spring.GetTeamLuaAI(unitTeamID)
				local _,_,_,isAI,_,_ = Spring.GetTeamInfo(unitTeamID)

				if (not LuaAI) and unitTeamID ~= GaiaTeamID and unitTeamID ~= Spring.GetGaiaTeamID() and (not isAI) then
					captureraiTeam = false
				else
					captureraiTeam = false -- true
				end

				if not CapturingUnitsTeam[unitTeamID] then
					CapturingUnitsTeam[unitTeamID] = 0
				end

				if staticUnitList.BeaconCaptureExclusionsID[unitDefID] then
					IsUnitExcluded = true
				else
					IsUnitExcluded = false
				end

				local _,_,_,testCaptureProgress = Spring.GetUnitHealth(scav)
				if testCaptureProgress ~= CaptureProgressForBeacons[scav] then
					CaptureProgressForBeacons[scav] = testCaptureProgress
				end
				if unitDefID == scavDef then
					CaptureProgressForBeacons[scav] = CaptureProgressForBeacons[scav] - 0.0005
					--Spring.Echo("uncapturing myself")
				elseif captureraiTeam == false and unitTeamID ~= GaiaTeamID and unitTeamID ~= Spring.GetGaiaTeamID() and IsUnitExcluded == false and (not UnitDefs[unitDefID].canFly) then
					CaptureProgressForBeacons[scav] = CaptureProgressForBeacons[scav] + ((UnitDefs[unitDefID].metalCost)/800)*0.001
					CapturingUnitsTeam[unitTeamID] = CapturingUnitsTeam[unitTeamID] + 1
					--Spring.Echo("capturing scav beacon")
				end
				if CaptureProgressForBeacons[scav] < 0 then
					CaptureProgressForBeacons[scav] = 0
					--Spring.Echo("capture below 0")
				end
				if CaptureProgressForBeacons[scav] > 1 then
					CaptureProgressForBeacons[scav] = 1
					--Spring.Echo("capture above 1")
				end
				if unitTeamID == GaiaTeamID and (not unitDefID == scavDef) then
					CaptureProgressForBeacons[scav] = CaptureProgressForBeacons[scav] - 1
					--Spring.Echo("uncapturing our beacon")
				end
				Spring.SetUnitHealth(scav, {capture = CaptureProgressForBeacons[scav]})

				if TeamsCapturing < 2 and captureraiTeam == false and CaptureProgressForBeacons[scav] >= 1 then
					Spring.TransferUnit(scav, unitTeamID, false)
					CaptureProgressForBeacons[scav] = 0
					Spring.SetUnitHealth(scav, {capture = 0})
					captureraiTeam = nil
					break
				end
				captureraiTeam = nil
				IsUnitExcluded = nil
			end
			CapturingUnits = nil
			CapturingUnitsTeam = nil
			unitsAround = nil
		end
	end
end

function SetBeaconsResourceProduction(n)
	if globalScore then
		local units = Spring.GetAllUnits()
		local minutes = math.ceil(Spring.GetGameSeconds()/300)
		local beaconmetalproduction = minutes
		local beaconenergyproduction = beaconmetalproduction*20
		for i = 1,#units do
			local unitID = units[i]
			local unitDefID = Spring.GetUnitDefID(unitID)
			local name = UnitDefs[unitDefID].name
			if name ==	"scavengerdroppodbeacon_scav" then
				-- Spring.AddUnitResource(unitID, "m", beaconmetalproduction)
				-- Spring.AddUnitResource(unitID, "e", beaconenergyproduction)
			end
		end
	end
end


function spawnPlayerReinforcements(n)
    --mapsizeX
    --mapsizeZ
    --ScavengerStartboxXMin
    --ScavengerStartboxZMin
    --ScavengerStartboxXMax
    --ScavengerStartboxZMax
    --GaiaTeamID
    --GaiaAllyTeamID
    --posCheck(posx, posy, posz, posradius)
    --posOccupied(posx, posy, posz, posradius)
	if scavengerGamePhase ~= "initial" then
		for _,teamID in ipairs(Spring.GetTeamList()) do
			local LuaAI = Spring.GetTeamLuaAI(teamID)
			local _,teamLeader,isDead,isAI,_,allyTeamID = Spring.GetTeamInfo(teamID)

			if (not LuaAI) and teamID ~= GaiaTeamID and teamID ~= Spring.GetGaiaTeamID() and (not isAI) then
				local playerName = Spring.GetPlayerInfo(teamLeader)
				if not numOfSpawnBeaconsTeams[teamID] then
					numOfSpawnBeaconsTeams[teamID] = 0
				end
				if not numOfSpawnBeaconsTeamsForSpawn[teamID] or numOfSpawnBeaconsTeamsForSpawn[teamID] == 0 then
					numOfSpawnBeaconsTeamsForSpawn[teamID] = 1
				else
					numOfSpawnBeaconsTeamsForSpawn[teamID] = numOfSpawnBeaconsTeams[teamID] + 1
				end


				if not ReinforcementsCountPerTeam[teamID] then
					ReinforcementsCountPerTeam[teamID] = 0
				end
				if not ReinforcementsChancePerTeam[teamID] then
					ReinforcementsChancePerTeam[teamID] = math.ceil(((unitSpawnerModuleConfig.spawnchance)/numOfSpawnBeaconsTeamsForSpawn[teamID])*2.5)
				end

				if not isDead then
					if TryingToSpawnReinforcements[teamID] == true then
						local playerunits = Spring.GetTeamUnits(teamID)
						PlayerSpawnBeacons = {}
						for i = 1,#playerunits do
							local playerbeacon = playerunits[i]
							local playerbeaconDef = Spring.GetUnitDefID(playerbeacon)
							local UnitName = UnitDefs[playerbeaconDef].name
							if UnitName == "scavengerdroppodbeacon_scav" then
								table.insert(PlayerSpawnBeacons,playerbeacon)
							end
						end
						--numOfSpawnBeaconsTeams[teamID] = 10
						if #PlayerSpawnBeacons == 1 then --numOfSpawnBeaconsTeams[teamID] == 1 then
							pickedBeacon = PlayerSpawnBeacons[1]
						elseif #PlayerSpawnBeacons > 1 then--numOfSpawnBeaconsTeams[teamID] > 1 then
							pickedBeacon = PlayerSpawnBeacons[math_random(1,#PlayerSpawnBeacons)]
						else
							pickedBeacon = nil
							TryingToSpawnReinforcements[teamID] = false
							ReinforcementsChancePerTeam[teamID] = math.ceil(((unitSpawnerModuleConfig.spawnchance)/numOfSpawnBeaconsTeamsForSpawn[teamID])*2.5)
						end
						PlayerSpawnBeacons = nil
						if pickedBeacon then
							if not globalScore then
								teamsCheck()
							end
							local groupsize = math.ceil((bestTeamScore / unitSpawnerModuleConfig.globalscoreperoneunit)*0.75)
							--local groupsize = math.ceil(groupsize*2)
							--if scorePerTeam[teamID] < bestTeamScore*2 then
								--groupsize = math.ceil(groupsize*2)
							--end
							local posradius = 80
							local posx,posy,posz = Spring.GetUnitPosition(pickedBeacon)
							local posy = Spring.GetGroundHeight(posx, posz)
							local spawnTier = math_random(1,100)
							local aircraftchance = math_random(0,unitSpawnerModuleConfig.aircraftchance)
							if aircraftchance == 0 then
								if spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 then
									groupunit = airUnitList.T1[math_random(1,#airUnitList.T1)]
									groupsize = groupsize*unitSpawnerModuleConfig.airmultiplier*unitSpawnerModuleConfig.t1multiplier*0.9
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 then
									groupunit = airUnitList.T2[math_random(1,#airUnitList.T2)]
									groupsize = groupsize*unitSpawnerModuleConfig.airmultiplier*unitSpawnerModuleConfig.t2multiplier*0.75
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 + TierSpawnChances.T3 then
									groupunit = airUnitList.T3[math_random(1,#airUnitList.T3)]
									groupsize = groupsize*unitSpawnerModuleConfig.airmultiplier*unitSpawnerModuleConfig.t3multiplier*0.5
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 + TierSpawnChances.T3 + TierSpawnChances.T4 then
									groupunit = airUnitList.T4[math_random(1,#airUnitList.T4)]
									groupsize = groupsize*unitSpawnerModuleConfig.airmultiplier*unitSpawnerModuleConfig.t4multiplier*0.25
								end
							elseif posy > -20 then
								if spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 then
									groupunit = landUnitList.T1[math_random(1,#landUnitList.T1)]
									groupsize = groupsize*unitSpawnerModuleConfig.landmultiplier*unitSpawnerModuleConfig.t1multiplier*0.9
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 then
									groupunit = landUnitList.T2[math_random(1,#landUnitList.T2)]
									groupsize = groupsize*unitSpawnerModuleConfig.landmultiplier*unitSpawnerModuleConfig.t2multiplier*0.75
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 + TierSpawnChances.T3 then
									groupunit = landUnitList.T3[math_random(1,#landUnitList.T3)]
									groupsize = groupsize*unitSpawnerModuleConfig.landmultiplier*unitSpawnerModuleConfig.t3multiplier*0.5
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 + TierSpawnChances.T3 + TierSpawnChances.T4 then
									groupunit = landUnitList.T4[math_random(1,#landUnitList.T4)]
									groupsize = groupsize*unitSpawnerModuleConfig.landmultiplier*unitSpawnerModuleConfig.t4multiplier*0.25
								end
							elseif posy <= -20 then
								if spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 then
									groupunit = seaUnitList.T1[math_random(1,#seaUnitList.T1)]
									groupsize = groupsize*unitSpawnerModuleConfig.seamultiplier*unitSpawnerModuleConfig.t1multiplier*0.9
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 then
									groupunit = seaUnitList.T2[math_random(1,#seaUnitList.T2)]
									groupsize = groupsize*unitSpawnerModuleConfig.seamultiplier*unitSpawnerModuleConfig.t2multiplier*0.75
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 + TierSpawnChances.T3 then
									groupunit = seaUnitList.T3[math_random(1,#seaUnitList.T3)]
									groupsize = groupsize*unitSpawnerModuleConfig.seamultiplier*unitSpawnerModuleConfig.t3multiplier*0.5
								elseif spawnTier <= TierSpawnChances.T0 + TierSpawnChances.T1 + TierSpawnChances.T2 + TierSpawnChances.T3 + TierSpawnChances.T4 then
									groupunit = seaUnitList.T4[math_random(1,#seaUnitList.T4)]
									groupsize = groupsize*unitSpawnerModuleConfig.seamultiplier*unitSpawnerModuleConfig.t4multiplier*0.25
								end
							end

							SendToUnsynced('ScavFriendlyReinforcements', playerName, groupunit)

							for a = 1,math.ceil(groupsize) do
								--local posradius = posradius+(groupsize*8)
								local posx = posx+(math_random(-posradius,posradius))
								local posz = posz+(math_random(-posradius,posradius))
								local newposy = Spring.GetGroundHeight(posx, posz)
								Spring.CreateUnit("scavengerdroppodfriendly", posx, posy, posz, math_random(0,3), teamID)
								local ReUnit = Spring.CreateUnit(groupunit, posx, posy, posz, math_random(0,3), teamID)
								Spring.SetUnitNoSelect(ReUnit, true)
								Spring.GiveOrderToUnit(ReUnit,CMD.FIRE_STATE,{2},0)
								Spring.GiveOrderToUnit(ReUnit,CMD.MOVE_STATE,{2},0)
								table.insert(ActiveReinforcementUnits, ReUnit)

								local unitDefID = Spring.GetUnitDefID(ReUnit)
								UnitSuffixLenght[ReUnit] = string.len(scavconfig.unitnamesuffix)
								if scavconfig.modules.constructorControllerModule then
									if constructorControllerModuleConfig.useresurrectors then
										if constructorUnitList.ResurrectorsID[unitDefID] then
											FriendlyResurrectors[ReUnit] = true
										end

										if constructorUnitList.ResurrectorsSeaID[unitDefID] then
											FriendlyResurrectors[ReUnit] = true
										end
									end

									if constructorControllerModuleConfig.usecollectors then
										if constructorUnitList.CollectorsID[unitDefID] then
											if math_random(0,100) <= 10 then
												FriendlyCollectors[ReUnit] = true
											else
												FriendlyReclaimers[ReUnit] = true
											end
										end
									end
								end
							end

							groupunit = nil
							groupsize = nil
							TryingToSpawnReinforcements[teamID] = false
							ReinforcementsCountPerTeam[teamID] = ReinforcementsCountPerTeam[teamID] + 1
						end
					else
						local r = math_random(0,ReinforcementsChancePerTeam[teamID])
						if r == 0 or ReinforcementsCountPerTeam[teamID] == 0 then
							TryingToSpawnReinforcements[teamID] = true
							ReinforcementsChancePerTeam[teamID] = math.ceil(((unitSpawnerModuleConfig.spawnchance)/numOfSpawnBeaconsTeamsForSpawn[teamID])*5)
						else
							TryingToSpawnReinforcements[teamID] = false
							ReinforcementsChancePerTeam[teamID] = ReinforcementsChancePerTeam[teamID] - 1
						end
					end
				end
			end
		end
	end
	pickedBeacon = nil
end

function ReinforcementsMoveOrder(n)
	if #ActiveReinforcementUnits > 0 then
		for i = 1,#ActiveReinforcementUnits do
			local unitID = ActiveReinforcementUnits[i]
			if unitID then
				local unitDefID = Spring.GetUnitDefID(unitID)
				if unitDefID then
					local UnitName = UnitDefs[unitDefID].name
					UnitSuffixLenght[unitID] = string.len(scavconfig.unitnamesuffix)
					FriendlyArmyOrders = true

					if scavconfig.modules.constructorControllerModule then
						if constructorControllerModuleConfig.useresurrectors then
							if FriendlyResurrectors[unitID] then
								constructorController.ResurrectorOrders(n, unitID)
								FriendlyArmyOrders = false
							end
						end

						if constructorControllerModuleConfig.usecollectors then
							if FriendlyCollectors[unitID] then
								constructorController.CollectorOrders(n, unitID)
								FriendlyArmyOrders = false
							end
							if FriendlyReclaimers[unitID] then
								constructorController.ReclaimerOrders(n, unitID)
								FriendlyArmyOrders = false
							end
						end
					end


					-- fallback - armyorders
					if FriendlyArmyOrders == true and Spring.GetCommandQueue(unitID, 0) <= 1 then

						local nearestEnemy = Spring.GetUnitNearestEnemy(unitID, 200000, false)
						if nearestEnemy then
							UnitRange = {}
							if UnitDefs[unitDefID].maxWeaponRange and UnitDefs[unitDefID].maxWeaponRange > 100 then
								UnitRange[unitID] = UnitDefs[unitDefID].maxWeaponRange
							else
								UnitRange[unitID] = 100
							end

							local x,y,z = Spring.GetUnitPosition(nearestEnemy)
							local y = Spring.GetGroundHeight(x, z)

							if (-(UnitDefs[unitDefID].minWaterDepth) > y) and (-(UnitDefs[unitDefID].maxWaterDepth) < y) or UnitDefs[unitDefID].canFly then
								local range = UnitRange[unitID]
								if range < 500 then
									range = 500
								end
								local x = x + math_random(-range*0.5,range*0.5)
								local z = z + math_random(-range*0.5,range*0.5)
								if UnitDefs[unitDefID].canFly then
									Spring.GiveOrderToUnit(unitID, CMD.FIGHT,{x,y,z}, {"shift", "alt", "ctrl"})
								elseif UnitRange[unitID] > unitControllerModuleConfig.minimumrangeforfight then
									Spring.GiveOrderToUnit(unitID, CMD.FIGHT,{x,y,z}, {"shift", "alt", "ctrl"})
								else
									Spring.GiveOrderToUnit(unitID, CMD.MOVE,{x,y,z}, {"shift", "alt", "ctrl"})
								end
							else
								local x = math.random(0, mapsizeX)
								local z = math.random(0, mapsizeZ)
								local y = Spring.GetGroundHeight(x,z)
								if (-(UnitDefs[unitDefID].minWaterDepth) > y) and (-(UnitDefs[unitDefID].maxWaterDepth) < y) or UnitDefs[unitDefID].canFly then
									Spring.GiveOrderToUnit(unitID, CMD.FIGHT,{x,y,z}, {"shift", "alt", "ctrl"})
								end
							end
						end
					end
					FriendlyArmyOrders = nil
					if n%600 == 0 then
						SelfDestructionControls(n, unitID, unitDefID, true)
					end
				end
			end
		end
	end
end
