/**
 * @fileSahara Desert.xsS
 * @author  Anderson Paschoalon <anderson.paschoalon@gmail.com>
 * @version 1.0
 * @date 16/01/2020
 * @section LICENSE
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details at
 * https://www.gnu.org/copyleft/gpl.html
 *
 * @section DESCRIPTION
 *
 * My First implementation of this idea of a map. Few resources, especially wood.
 */

void main(void)
{
	rmCreateTrigger("signature");

	rmSwitchToTrigger(rmTriggerID("signature"));
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1",0);
	rmAddTriggerEffect("Send Chat");
	rmSetTriggerEffectParamInt("PlayerID",0);

   rmSetStatusText("",0.01);
   int playerTiles=25000;
   if(cMapSize == 1)
   {
      playerTiles = 50000;
      rmEchoInfo("Large map");
   }
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles/0.9);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);
   rmSetSeaLevel(0.0);
   rmSetSeaType("Egyptian Nile");
   rmTerrainInitialize("SandD");
   int classPlayer=rmDefineClass("player");
   int classPlayerCore=rmDefineClass("player core");
   rmDefineClass("corner");
   rmDefineClass("classHill");
   rmDefineClass("center");
   rmDefineClass("starting settlement");

   int edgeConstraint=rmCreateBoxConstraint("edge of map", rmXTilesToFraction(4), rmZTilesToFraction(4), 1.0-rmXTilesToFraction(4), 1.0-rmZTilesToFraction(4));
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
   int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 15.0);
   int wideCenterConstraint=rmCreateClassDistanceConstraint("elevation avoids center", rmClassID("center"), 50.0);
   int cornerConstraint=rmCreateClassDistanceConstraint("stay away from corner", rmClassID("corner"), 15.0);
   int cornerOverlapConstraint=rmCreateClassDistanceConstraint("don't overlap corner", rmClassID("corner"), 2.0);
   int shortAvoidSettlement=rmCreateTypeDistanceConstraint("objects avoid TC by short distance", "AbstractSettlement", 20.0);
   int farAvoidSettlement=rmCreateTypeDistanceConstraint("TCs avoid TCs by long distance", "AbstractSettlement", 40.0);
   int farStartingSettleConstraint=rmCreateClassDistanceConstraint("objects avoid player TCs", rmClassID("starting settlement"), 60.0);
   int avoidTower=rmCreateTypeDistanceConstraint("towers avoid towers", "tower", 20.0);
   int avoidTower2=rmCreateTypeDistanceConstraint("objects avoid towers", "tower", 22.0);
   int avoidGold=rmCreateTypeDistanceConstraint("avoid gold", "gold", 30.0);
   int shortAvoidGold=rmCreateTypeDistanceConstraint("short avoid gold", "gold", 10.0);
   int avoidHerdable=rmCreateTypeDistanceConstraint("avoid herdable", "herdable", 30.0);
   int avoidPredator=rmCreateTypeDistanceConstraint("avoid predator", "animalPredator", 20.0);
   int avoidFood=rmCreateTypeDistanceConstraint("avoid other food sources", "food", 6.0);
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "land", false, 10.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 10.0);
  
   int startingSettlementID=rmCreateObjectDef("starting settlement");
   rmAddObjectDefItem(startingSettlementID, "Settlement Level 1", 1, 0.0);
   rmAddObjectDefToClass(startingSettlementID, rmClassID("starting settlement"));
   rmSetObjectDefMinDistance(startingSettlementID, 0.0);
   rmSetObjectDefMaxDistance(startingSettlementID, 0.0);
   int startingTowerID=rmCreateObjectDef("Starting tower");
   rmAddObjectDefItem(startingTowerID, "tower", 1, 0.0);
   rmSetObjectDefMinDistance(startingTowerID, 22.0);
   rmSetObjectDefMaxDistance(startingTowerID, 28.0);
   rmAddObjectDefConstraint(startingTowerID, avoidTower);
   rmAddObjectDefConstraint(startingTowerID, avoidImpassableLand);
   int startingGoldID=rmCreateObjectDef("Starting gold");
   rmAddObjectDefItem(startingGoldID, "Gold mine small", 1, 0.0);
   rmSetObjectDefMinDistance(startingGoldID, 20.0);
   rmSetObjectDefMaxDistance(startingGoldID, 25.0);
   rmAddObjectDefConstraint(startingGoldID, avoidGold);
   rmAddObjectDefConstraint(startingGoldID, avoidImpassableLand);
   float pigNumber=rmRandFloat(2, 4);
   int closePigsID=rmCreateObjectDef("close pigs");
   rmAddObjectDefItem(closePigsID, "pig", pigNumber, 2.0);
   rmSetObjectDefMinDistance(closePigsID, 25.0);
   rmSetObjectDefMaxDistance(closePigsID, 30.0);
   rmAddObjectDefConstraint(closePigsID, avoidImpassableLand);
   rmAddObjectDefConstraint(closePigsID, avoidFood);
   int closeChickensID=rmCreateObjectDef("close Chickens");
   if(rmRandFloat(0,1)<0.8)
      rmAddObjectDefItem(closeChickensID, "goat", rmRandInt(30,30), 5.0);
   else
      rmAddObjectDefItem(closeChickensID, "goat", rmRandInt(30,30), 4.0);
   rmSetObjectDefMinDistance(closeChickensID, 20.0);
   rmSetObjectDefMaxDistance(closeChickensID, 25.0);
   rmAddObjectDefConstraint(closeChickensID, avoidImpassableLand);
   rmAddObjectDefConstraint(closeChickensID, avoidFood); 
   int closeBoarID=rmCreateObjectDef("close Boar");
   if(rmRandFloat(0,1)<0.7)
      rmAddObjectDefItem(closeBoarID, "crowned crane", rmRandInt(20,20), 4.0);
   else
      rmAddObjectDefItem(closeBoarID, "crowned crane", rmRandInt(20,20), 2.0);
   rmSetObjectDefMinDistance(closeBoarID, 30.0);
   rmSetObjectDefMaxDistance(closeBoarID, 50.0);
   rmAddObjectDefConstraint(closeBoarID, avoidImpassableLand);

   int stragglerTreeID=rmCreateObjectDef("straggler tree");


   rmAddObjectDefItem(stragglerTreeID, "palm tree", 1, 0.0);

   rmSetObjectDefMinDistance(stragglerTreeID, 12.0);
   rmSetObjectDefMaxDistance(stragglerTreeID, 15.0);
   int mediumGoldID=rmCreateObjectDef("medium gold");
   rmAddObjectDefItem(mediumGoldID, "Gold mine", 1, 0.0);
   rmSetObjectDefMinDistance(mediumGoldID, 40.0);
   rmSetObjectDefMaxDistance(mediumGoldID, 60.0);
   rmAddObjectDefConstraint(mediumGoldID, avoidGold);
   rmAddObjectDefConstraint(mediumGoldID, edgeConstraint);
   rmAddObjectDefConstraint(mediumGoldID, shortAvoidSettlement);
   rmAddObjectDefConstraint(mediumGoldID, avoidImpassableLand);
   rmAddObjectDefConstraint(mediumGoldID, farStartingSettleConstraint);
   int mediumPigsID=rmCreateObjectDef("medium pigs");
   rmAddObjectDefItem(mediumPigsID, "goat", 2, 4.0);
   rmSetObjectDefMinDistance(mediumPigsID, 50.0);
   rmSetObjectDefMaxDistance(mediumPigsID, 70.0);
   rmAddObjectDefConstraint(mediumPigsID, avoidImpassableLand);
   rmAddObjectDefConstraint(mediumPigsID, avoidHerdable);
   rmAddObjectDefConstraint(mediumPigsID, farStartingSettleConstraint);
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int playerFishID=rmCreateObjectDef("owned fish");
   rmAddObjectDefItem(playerFishID, "fish - mahi", 3, 10.0);
   rmSetObjectDefMinDistance(playerFishID, 0.0);
   rmSetObjectDefMaxDistance(playerFishID, 100.0);
   rmAddObjectDefConstraint(playerFishID, fishVsFishID);
   rmAddObjectDefConstraint(playerFishID, fishLand);
   int farGoldID=rmCreateObjectDef("far gold");
   rmAddObjectDefItem(farGoldID, "Gold mine", 1, 0.0);
   rmSetObjectDefMinDistance(farGoldID, 70.0);
   rmSetObjectDefMaxDistance(farGoldID, 160.0);
   rmAddObjectDefConstraint(farGoldID, avoidGold);
   rmAddObjectDefConstraint(farGoldID, avoidImpassableLand);
   rmAddObjectDefConstraint(farGoldID, shortAvoidSettlement);
   rmAddObjectDefConstraint(farGoldID, farStartingSettleConstraint);
   int farPigsID=rmCreateObjectDef("far pigs");
   rmAddObjectDefItem(farPigsID, "goat", 2, 4.0);
   rmSetObjectDefMinDistance(farPigsID, 80.0);
   rmSetObjectDefMaxDistance(farPigsID, 150.0);
   rmAddObjectDefConstraint(farPigsID, avoidImpassableLand);
   rmAddObjectDefConstraint(farPigsID, avoidHerdable);
   rmAddObjectDefConstraint(farPigsID, farStartingSettleConstraint);
   int farPredatorID=rmCreateObjectDef("far predator");
   float predatorSpecies=rmRandFloat(0, 1);
   if(predatorSpecies<0.5)   
      rmAddObjectDefItem(farPredatorID, "hyena", 2, 4.0);
   else
      rmAddObjectDefItem(farPredatorID, "hyena", 1, 4.0);
   rmSetObjectDefMinDistance(farPredatorID, 50.0);
   rmSetObjectDefMaxDistance(farPredatorID, 100.0);
   rmAddObjectDefConstraint(farPredatorID, avoidPredator);
   rmAddObjectDefConstraint(farPredatorID, farStartingSettleConstraint);
   rmAddObjectDefConstraint(farPredatorID, avoidImpassableLand);
   int farBerriesID=rmCreateObjectDef("far berries");

   int classBonusHuntable=rmDefineClass("bonus huntable");
   int avoidBonusHuntable=rmCreateClassDistanceConstraint("avoid bonus huntable", classBonusHuntable, 40.0);
   int avoidHuntable=rmCreateTypeDistanceConstraint("avoid huntable", "huntable", 20.0);
   int bonusHuntableID=rmCreateObjectDef("bonus huntable");

   int randomTreeID=rmCreateObjectDef("ramdom tree");
  
   rmAddObjectDefItem(randomTreeID, "Palm forest", 1, 0.0);

   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));

   rmAddObjectDefConstraint(randomTreeID, rmCreateTypeDistanceConstraint("ramdom tree", "all", 4.0));

   rmAddObjectDefConstraint(randomTreeID, shortAvoidSettlement);
   rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);

   int farhawkID=rmCreateObjectDef("far hawks");
   int relicID=rmCreateObjectDef("relic");
   rmAddObjectDefItem(relicID, "relic", 1, 0.0);
   rmSetObjectDefMinDistance(relicID, 60.0);
   rmSetObjectDefMaxDistance(relicID, 150.0);
   rmAddObjectDefConstraint(relicID, edgeConstraint);
   rmAddObjectDefConstraint(relicID, rmCreateTypeDistanceConstraint("relic vs relic", "relic", 70.0));
   rmAddObjectDefConstraint(relicID, farStartingSettleConstraint);
   rmAddObjectDefConstraint(relicID, avoidImpassableLand);

   rmSetStatusText("",0.20);
   rmSetTeamSpacingModifier(0.75);
   if(cNumberNonGaiaPlayers <4)
      rmPlacePlayersCircular(0.4, 0.43, rmDegreesToRadians(5.0));
   else
      rmPlacePlayersCircular(0.43, 0.45, rmDegreesToRadians(5.0));

   //******Cetral Lake*************

   int classForest=rmDefineClass("forest");
   int forestOneID = 0;
   int coreOneID = 0;

   // Create a forest
   forestOneID=rmCreateArea("forest one");
   rmSetAreaSize(forestOneID, 0.015, 0.015);
   rmSetAreaLocation(forestOneID, 0.5, 0.5);
   rmSetAreaForestType(forestOneID, "palm forest");
   rmAddAreaToClass(forestOneID, rmClassID("center"));
   rmSetAreaMinBlobs(forestOneID, 1);
   rmSetAreaMaxBlobs(forestOneID, 1);
   rmSetAreaSmoothDistance(forestOneID, 50);
   rmSetAreaCoherence(forestOneID, 0.25);
   rmAddAreaToClass(forestOneID, classForest);
   rmBuildArea(forestOneID);

   // Create the core lake
   coreOneID=rmCreateArea("core one");
   rmSetAreaSize(coreOneID, 0.01, 0.01);
   rmSetAreaLocation(coreOneID, 0.5, 0.5);
   rmSetAreaWaterType(coreOneID, "Egyptian Nile");
   rmAddAreaToClass(coreOneID, rmClassID("center"));
   rmSetAreaBaseHeight(coreOneID, 0.0);
   rmSetAreaMinBlobs(coreOneID, 1);
   rmSetAreaMaxBlobs(coreOneID, 1);
   rmSetAreaSmoothDistance(coreOneID, 50);
   rmSetAreaCoherence(coreOneID, 0.25);
   rmBuildArea(coreOneID);

   float monkeyChance=rmRandFloat(0, 1);
   if(cNumberPlayers > 3)
   {
      if(monkeyChance < 0.66)   
         {
            int monkeyIslandID=rmCreateArea("monkeyisland");
            int monkeyID=rmCreateObjectDef("monkey");
         }
   }
   float playerFraction=rmAreaTilesToFraction(3200);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, 0.9*playerFraction, 1.1*playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 4);
      rmSetAreaMaxBlobs(id, 5);
      rmSetAreaWarnFailure(id, false);
      rmSetAreaMinBlobDistance(id, 30.0);
      rmSetAreaMaxBlobDistance(id, 50.0);
      rmSetAreaSmoothDistance(id, 20);
      rmSetAreaCoherence(id, 0.20);
      rmSetAreaBaseHeight(id, 0.0); 
      rmSetAreaHeightBlend(id, 2);
      rmAddAreaConstraint(id, playerConstraint);
      if(cNumberNonGaiaPlayers < 4)
         rmAddAreaConstraint(id, smallMapPlayerConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaTerrainType(id, "SandC");
   }
   rmBuildAllAreas();
   for(i=1; <cNumberPlayers)
   {
      int id2=rmCreateArea("Player inner"+i, rmAreaID("player"+i));
      rmSetAreaSize(id2, rmAreaTilesToFraction(400), rmAreaTilesToFraction(600));
      rmSetAreaLocPlayer(id2, i);
      rmSetAreaTerrainType(id2, "SandD");
      rmSetAreaMinBlobs(id2, 1);
      rmSetAreaMaxBlobs(id2, 5);
      rmSetAreaWarnFailure(id2, false);
      rmSetAreaMinBlobDistance(id2, 16.0);
      rmSetAreaMaxBlobDistance(id2, 40.0);
      rmSetAreaCoherence(id2, 0.0);
      rmBuildArea(id2);
   }
   for(i=1; <cNumberPlayers*8)
   {
      int id3=rmCreateArea("Grass patch"+i);
      rmSetAreaSize(id3, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
      rmSetAreaTerrainType(id3, "SandC");
      rmAddAreaConstraint(id3, centerConstraint);
      rmSetAreaMinBlobs(id3, 1);
      rmSetAreaMaxBlobs(id3, 5);
      rmSetAreaWarnFailure(id3, false);
      rmSetAreaMinBlobDistance(id3, 16.0);
      rmSetAreaMaxBlobDistance(id3, 40.0);
      rmSetAreaCoherence(id3, 0.0);
      rmBuildArea(id3);
   }
   int flowerID =0;
   int id4 = 0;
   int stayInPatch=rmCreateEdgeDistanceConstraint("stay in patch", id4, 4.0);
   for(i=1; <cNumberPlayers*6)
   {
      id4=rmCreateArea("Grass patch 2"+i);
      rmSetAreaSize(id4, rmAreaTilesToFraction(5), rmAreaTilesToFraction(20));
      rmSetAreaTerrainType(id4, "SandD");
      rmAddAreaConstraint(id4, centerConstraint);
      rmSetAreaMinBlobs(id4, 1);
      rmSetAreaMaxBlobs(id4, 5);
      rmSetAreaWarnFailure(id4, false);
      rmSetAreaMinBlobDistance(id4, 16.0);
      rmSetAreaMaxBlobDistance(id4, 40.0);
      rmSetAreaCoherence(id4, 0.0);
      rmBuildArea(id4);

      flowerID=rmCreateObjectDef("grass"+i);
   }
   rmPlaceObjectDefPerPlayer(playerFishID, false);
   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "fish - mahi", 1, 9.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
   fishID=rmCreateObjectDef("fish2");
   rmAddObjectDefItem(fishID, "fish - perch", 1, 6.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 1*cNumberNonGaiaPlayers);
   rmSetStatusText("",0.40);
 
   int sharkLand = rmCreateTerrainDistanceConstraint("shark land", "land", true, 20.0);
   int sharkVssharkID=rmCreateTypeDistanceConstraint("shark v shark", "shark", 20.0);
   int sharkVssharkID2=rmCreateTypeDistanceConstraint("shark v orca", "orca", 20.0);
   int sharkVssharkID3=rmCreateTypeDistanceConstraint("shark v whale", "whale", 20.0);
   rmSetStatusText("",0.42);

   int sharkID=rmCreateObjectDef("shark");

   rmPlaceObjectDefPerPlayer(startingSettlementID, true);
   rmPlaceObjectDefPerPlayer(startingTowerID, true, 4);
   int numTries=6*cNumberNonGaiaPlayers;
   int avoidBuildings=rmCreateTypeDistanceConstraint("avoid buildings", "Building", 20.0);
   int failCount=0;
   for(i=0; <numTries)
   {
      int elevID=rmCreateArea("elev"+i);
      rmSetAreaSize(elevID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(80));
      rmSetAreaWarnFailure(elevID, false);
      rmAddAreaToClass(elevID, rmClassID("classHill"));
      rmAddAreaConstraint(elevID, avoidBuildings);
      rmAddAreaConstraint(elevID, centerConstraint);
      if(rmRandFloat(0.0, 1.0)<0.5)
         rmSetAreaTerrainType(elevID, "SandD"); 
      rmSetAreaBaseHeight(elevID, rmRandFloat(4.0, 7.0));
      rmSetAreaHeightBlend(elevID, 3);
      rmSetAreaMinBlobs(elevID, 1);
      rmSetAreaMaxBlobs(elevID, 5);
      rmSetAreaMinBlobDistance(elevID, 16.0);
      rmSetAreaMaxBlobDistance(elevID, 40.0);
      rmSetAreaCoherence(elevID, 0.0);
      if(rmBuildArea(elevID)==false)
      {
         failCount++;
         if(failCount==20)
            break;
      }
      else
         failCount=0;
   }
   numTries=15*cNumberNonGaiaPlayers;
   failCount=0;
   for(i=0; <numTries)
   {
      elevID=rmCreateArea("wrinkle"+i);
      rmSetAreaSize(elevID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(120));
      rmSetAreaWarnFailure(elevID, false);
      rmSetAreaBaseHeight(elevID, rmRandFloat(2.0, 4.0));
      rmSetAreaHeightBlend(elevID, 1);
      rmSetAreaMinBlobs(elevID, 1);
      rmSetAreaMaxBlobs(elevID, 3);
      rmSetAreaMinBlobDistance(elevID, 16.0);
      rmSetAreaMaxBlobDistance(elevID, 20.0);
      rmSetAreaCoherence(elevID, 0.0);
      rmAddAreaConstraint(elevID, avoidBuildings);
      rmAddAreaConstraint(elevID, centerConstraint);
      rmAddAreaConstraint(elevID, shortHillConstraint);
      if(rmBuildArea(elevID)==false)
      {
         failCount++;
         if(failCount==10)
            break;
      }
      else
         failCount=0;
   } 
   rmSetStatusText("",0.60);
   id=rmAddFairLoc("Settlement", false, true,  60, 80, 40, 10);
   rmAddFairLocConstraint(id, centerConstraint);
   id=rmAddFairLoc("Settlement", true, false, 70, 120, 60, 10);
   rmAddFairLocConstraint(id, centerConstraint);
   if(rmPlaceFairLocs())
   {
      id=rmCreateObjectDef("far settlement2");
      rmAddObjectDefItem(id, "Settlement", 1, 0.0);
      for(i=1; <cNumberPlayers)
      {
         for(j=0; <rmGetNumberFairLocs(i))
            rmPlaceObjectDefAtLoc(id, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
      }
   }
   rmPlaceObjectDefPerPlayer(stragglerTreeID, false, rmRandInt(2,6));
   rmPlaceObjectDefPerPlayer(startingGoldID, false);
   rmPlaceObjectDefPerPlayer(closePigsID, true);
   rmPlaceObjectDefPerPlayer(closeChickensID, true);
   rmPlaceObjectDefPerPlayer(closeBoarID, false);
   rmPlaceObjectDefPerPlayer(mediumGoldID, false);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefAtLoc(mediumPigsID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), 2);
   rmPlaceObjectDefPerPlayer(farGoldID, false, 3);
   rmPlaceObjectDefPerPlayer(relicID, false);
   rmPlaceObjectDefPerPlayer(farhawkID, false, 2); 
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefAtLoc(farPigsID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), 3);
   rmPlaceObjectDefAtLoc(bonusHuntableID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
   rmPlaceObjectDefAtLoc(farBerriesID, 0, 0.5, 0.5, cNumberPlayers);
   rmPlaceObjectDefPerPlayer(farPredatorID, false, 1);
   rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);

   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest v forest", rmClassID("forest"), 20.0);
   int forestSettleConstraint=rmCreateClassDistanceConstraint("forest settle", rmClassID("starting settlement"), 20.0);
   int forestCount=10*cNumberNonGaiaPlayers;
   failCount=0;
   for(i=0; <forestCount)
   {
      int forestID=rmCreateArea("forest"+i);
      rmSetAreaSize(forestID, rmAreaTilesToFraction(05), rmAreaTilesToFraction(50));
      rmSetAreaWarnFailure(forestID, false);
      if(rmRandFloat(0.0, 1.0)<0.5)
         rmSetAreaForestType(forestID, "Palm forest");
      else
         rmSetAreaForestType(forestID, "Palm forest");
      rmAddAreaConstraint(forestID, forestSettleConstraint);
      rmAddAreaConstraint(forestID, forestObjConstraint);
      rmAddAreaConstraint(forestID, forestConstraint);
      rmAddAreaConstraint(forestID, avoidImpassableLand);
      rmAddAreaToClass(forestID, classForest);
      
      rmSetAreaMinBlobs(forestID, 1);
      rmSetAreaMaxBlobs(forestID, 5);
      rmSetAreaMinBlobDistance(forestID, 16.0);
      rmSetAreaMaxBlobDistance(forestID, 40.0);
      rmSetAreaCoherence(forestID, 0.0);
      if(rmBuildArea(forestID)==false)
      {
         failCount++;
         if(failCount==3)
            break;
      }
      else
         failCount=0;
   }
   rmSetStatusText("",0.80);

   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int deerID=rmCreateObjectDef("lonely deer");
   if(rmRandFloat(0,1)<0.5)
      rmAddObjectDefItem(deerID, "gazelle", rmRandInt(1,2), 1.0);
   else
      rmAddObjectDefItem(deerID, "gazelle", 1, 0.0);
   rmSetObjectDefMinDistance(deerID, 0.0);
   rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(deerID, avoidAll);
   rmAddObjectDefConstraint(deerID, avoidBuildings);
   rmAddObjectDefConstraint(deerID, avoidImpassableLand);
   rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
   int avoidGrass=rmCreateTypeDistanceConstraint("avoid grass", "grass", 12.0);
   int grassID=rmCreateObjectDef("grass");
   rmAddObjectDefItem(grassID, "grass", 3, 4.0);
   rmSetObjectDefMinDistance(grassID, 0.0);
   rmSetObjectDefMaxDistance(grassID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(grassID, avoidGrass);
   rmAddObjectDefConstraint(grassID, avoidAll);
   rmAddObjectDefConstraint(grassID, avoidImpassableLand);
   rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);
   int rockID=rmCreateObjectDef("rock and grass");
   int avoidRock=rmCreateTypeDistanceConstraint("avoid rock", "rock limestone sprite", 8.0);
   rmAddObjectDefItem(rockID, "rock limestone sprite", 1, 1.0);
   rmAddObjectDefItem(rockID, "grass", 2, 1.0);
   rmSetObjectDefMinDistance(rockID, 0.0);
   rmSetObjectDefMaxDistance(rockID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(rockID, avoidAll);
   rmAddObjectDefConstraint(rockID, avoidImpassableLand);
   rmAddObjectDefConstraint(rockID, avoidRock);
   rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers);
   int rockID2=rmCreateObjectDef("rock group");
   rmAddObjectDefItem(rockID2, "rock limestone sprite", 3, 2.0);
   rmSetObjectDefMinDistance(rockID2, 0.0);
   rmSetObjectDefMaxDistance(rockID2, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(rockID2, avoidAll);
   rmAddObjectDefConstraint(rockID2, avoidImpassableLand);
   rmAddObjectDefConstraint(rockID2, avoidRock);
   rmPlaceObjectDefAtLoc(rockID2, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);
   int nearshore=rmCreateTerrainMaxDistanceConstraint("seaweed near shore", "land", true, 14.0);
   int farshore = rmCreateTerrainDistanceConstraint("seaweed far from shore", "land", true, 10.0);
   int kelpID=rmCreateObjectDef("seaweed");
   rmAddObjectDefItem(kelpID, "seaweed", 12, 6.0);
   rmSetObjectDefMinDistance(kelpID, 0.0);
   rmSetObjectDefMaxDistance(kelpID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(kelpID, avoidAll);
   rmAddObjectDefConstraint(kelpID, nearshore);
   rmAddObjectDefConstraint(kelpID, farshore);
   rmPlaceObjectDefAtLoc(kelpID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
   int kelp2ID=rmCreateObjectDef("seaweed 2");
   rmAddObjectDefItem(kelp2ID, "seaweed", 5, 3.0);
   rmSetObjectDefMinDistance(kelp2ID, 0.0);
   rmSetObjectDefMaxDistance(kelp2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(kelp2ID, avoidAll);
   rmAddObjectDefConstraint(kelp2ID, nearshore);
   rmAddObjectDefConstraint(kelp2ID, farshore);
   rmPlaceObjectDefAtLoc(kelp2ID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);

   rmSetStatusText("",1.0);

}  




