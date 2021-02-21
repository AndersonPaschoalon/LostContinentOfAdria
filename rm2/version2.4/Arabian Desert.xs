/**
 * @file
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
 * A gigantic map with gold and abundant relics, but randomly scattered 
 * across the map. However, bandit camps are also randomly scattered. 
 * Very little wood available, mostly concentrated in Oasis Central, 
 * which may own some fish.
 * @TODO
 * - put some paphyrus on the central lake
 */

void main(void)
{
   // Text
   rmSetStatusText("Creating map...",0.01);
   // Set size.
   float xLoc = 0.0;
   float zLoc = 0.0;
   int numTries = 0;
   int playerTiles=7500;
   if(cMapSize == 1)
   {
      playerTiles = 9750;
      rmEchoInfo("Large map");
   }
   else if (cMapSize == 2)
   {
      playerTiles = 19750;
      rmEchoInfo("Giant map");      
   }
   //int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles/0.9);
   int size=2.0*sqrt(3.0*cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Set up default water.
   rmSetSeaLevel(0.0);

   // Init map.
   rmTerrainInitialize("SandC");

   // Define some classes.
   int classPlayer=rmDefineClass("player");
   int classPlayerCore=rmDefineClass("player core");
   int classForest=rmDefineClass("forest");
   int classElev=rmDefineClass("elevation");
   rmDefineClass("center");
   rmDefineClass("starting settlement");

   rmSetStatusText("Defining constraints...",0.10);
   // -------------Define constraints

   // Create a edge of map constraint.
   int edgeConstraint=rmCreateBoxConstraint("edge of map", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0-rmXTilesToFraction(8), 1.0-rmZTilesToFraction(8));

   // Center constraint.
   int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 8.0);
   int playerCenterConstraint=rmCreateClassDistanceConstraint("player areas from center", rmClassID("center"), 12.0);
   int wideCenterConstraint=rmCreateClassDistanceConstraint("wide avoid center", rmClassID("center"), 25.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest v forest", rmClassID("forest"), 25.0);

   // Settlement constraints
   int shortAvoidSettlement=rmCreateTypeDistanceConstraint("objects avoid TC by short distance", "AbstractSettlement", 20.0);
   int farAvoidSettlement=rmCreateTypeDistanceConstraint("TCs avoid TCs by long distance", "AbstractSettlement", 50.0);
   int farStartingSettleConstraint=rmCreateClassDistanceConstraint("objects avoid player TCs", rmClassID("starting settlement"), 50.0);
       
   // Tower constraint.
   int avoidTower=rmCreateTypeDistanceConstraint("towers avoid towers", "tower", 4.0);
   int avoidTower2=rmCreateTypeDistanceConstraint("objects avoid towers", "tower", 4.0);

   // Gold
   int avoidGold=rmCreateTypeDistanceConstraint("avoid gold", "gold", 30.0);
   int shortAvoidGold=rmCreateTypeDistanceConstraint("short avoid gold", "gold", 10.0);

   // Food
   int avoidHerdable=rmCreateTypeDistanceConstraint("avoid herdable", "herdable", 30.0);
   int avoidPredator=rmCreateTypeDistanceConstraint("avoid predator", "animalPredator", 20.0);
   int avoidFood=rmCreateTypeDistanceConstraint("avoid other food sources", "food", 6.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "land", false, 10.0);
   int avoidBuildings=rmCreateTypeDistanceConstraint("avoid buildings", "Building", 20.0);
   int shortAvoidBuildings=rmCreateTypeDistanceConstraint("short avoid buildings", "Building", 10.0);
   int elevConstraint=rmCreateClassDistanceConstraint("elev avoid elev", rmClassID("elevation"), 10.0);

   rmSetStatusText("Defining objects...",0.15);
   // -------------Define objects
   // Close Objects

   int startingSettlementID=rmCreateObjectDef("starting settlement");
   rmAddObjectDefItem(startingSettlementID, "Settlement Level 1", 1, 0.0);
   rmAddObjectDefToClass(startingSettlementID, rmClassID("starting settlement"));
   rmSetObjectDefMinDistance(startingSettlementID, 0.0);
   rmSetObjectDefMaxDistance(startingSettlementID, 0.0);

   // towers avoid other towers
   int startingTowerID=rmCreateObjectDef("Starting tower");
   rmAddObjectDefItem(startingTowerID, "tower", 1, 0.0);
   rmSetObjectDefMinDistance(startingTowerID, 20.0);
   rmSetObjectDefMaxDistance(startingTowerID, 20.0);
   rmAddObjectDefConstraint(startingTowerID, avoidTower);
   rmAddObjectDefConstraint(startingTowerID, centerConstraint);

   // goats
   int closeGoatsID=rmCreateObjectDef("close goats");
   rmAddObjectDefItem(closeGoatsID, "goat", 2, 2.0);
   rmSetObjectDefMinDistance(closeGoatsID, 25.0);
   rmSetObjectDefMaxDistance(closeGoatsID, 30.0);
   rmAddObjectDefConstraint(closeGoatsID, avoidFood);

   int closeChickensID=rmCreateObjectDef("close Chickens");
   if(rmRandFloat(0,1)<0.5)
      rmAddObjectDefItem(closeChickensID, "chicken", rmRandInt(5,8), 5.0);
   else
      rmAddObjectDefItem(closeChickensID, "berry bush", rmRandInt(6,8), 4.0);
   rmSetObjectDefMinDistance(closeChickensID, 20.0);
   rmSetObjectDefMaxDistance(closeChickensID, 25.0);
   rmAddObjectDefConstraint(closeChickensID, avoidFood); 

   int closeBoarID=rmCreateObjectDef("close gazelle");
   float boarNumber=rmRandFloat(0, 1);
   rmAddObjectDefItem(closeBoarID, "gazelle", rmRandInt(2,5), 2.0);
   rmSetObjectDefMinDistance(closeBoarID, 30.0);
   rmSetObjectDefMaxDistance(closeBoarID, 60.0);
   rmAddObjectDefConstraint(closeBoarID, shortAvoidBuildings);

   int stragglerTreeID=rmCreateObjectDef("straggler tree");
   rmAddObjectDefItem(stragglerTreeID, "palm", 1, 0.0);
   rmSetObjectDefMinDistance(stragglerTreeID, 12.0);
   rmSetObjectDefMaxDistance(stragglerTreeID, 15.0);

   int mediumGoatsID=rmCreateObjectDef("medium Goats");
   rmAddObjectDefItem(mediumGoatsID, "goat", rmRandInt(0,3), 4.0);
   rmSetObjectDefMinDistance(mediumGoatsID, 50.0);
   rmSetObjectDefMaxDistance(mediumGoatsID, 70.0);
   rmAddObjectDefConstraint(mediumGoatsID, avoidHerdable);

   // Goats avoid TCs and other herds, since this map places a lot of Goats
   int farGoatsID=rmCreateObjectDef("far Goats");
   rmAddObjectDefItem(farGoatsID, "goat", 2, 4.0);
   rmSetObjectDefMinDistance(farGoatsID, 80.0);
   rmSetObjectDefMaxDistance(farGoatsID, 150.0);
   rmAddObjectDefConstraint(farGoatsID, avoidHerdable);

   // pick lions or bears as predators
   // avoid TCs
   int farPredatorID=rmCreateObjectDef("far predator");
   rmAddObjectDefItem(farPredatorID, "lion", 2, 4.0);
   rmSetObjectDefMinDistance(farPredatorID, 80.0);
   rmSetObjectDefMaxDistance(farPredatorID, 80.0);
   rmAddObjectDefConstraint(farPredatorID, farStartingSettleConstraint);

   int farPredator2ID=rmCreateObjectDef("far predator2");
   rmAddObjectDefItem(farPredator2ID, "hyena", 3, 8.0);
   rmSetObjectDefMinDistance(farPredator2ID, 80.0);
   rmSetObjectDefMaxDistance(farPredator2ID, 80.0);
   rmAddObjectDefConstraint(farPredator2ID, farStartingSettleConstraint);

   // Berries avoid TCs  
   int farBerriesID=rmCreateObjectDef("far berries");
   rmAddObjectDefItem(farBerriesID, "berry bush", rmRandInt(4,10), 4.0);
   rmSetObjectDefMinDistance(farBerriesID, 0.0);
   rmSetObjectDefMaxDistance(farBerriesID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);

   // This map will either use boar or deer as the extra huntable food.
   int classBonusHuntable=rmDefineClass("bonus huntable");
   int avoidBonusHuntable=rmCreateClassDistanceConstraint("avoid bonus huntable", classBonusHuntable, 40.0);
   int avoidHuntable=rmCreateTypeDistanceConstraint("avoid huntable", "huntable", 40.0);

   // hunted avoids hunted and TCs
   int bonusHuntableID=rmCreateObjectDef("bonus huntable");
   rmAddObjectDefItem(bonusHuntableID, "gazelle", rmRandInt(0,4), 3.0);
   rmSetObjectDefMinDistance(bonusHuntableID, 0.0);
   rmSetObjectDefMaxDistance(bonusHuntableID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(bonusHuntableID, avoidBonusHuntable);
   rmAddObjectDefConstraint(bonusHuntableID, avoidHuntable);
   rmAddObjectDefToClass(bonusHuntableID, classBonusHuntable);

   int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, "palm", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(15.5));
   rmAddObjectDefConstraint(randomTreeID, rmCreateTypeDistanceConstraint("random tree", "all", 4.0));

   int randomTreeID2=rmCreateObjectDef("random tree 2");
   rmAddObjectDefItem(randomTreeID2, "savannah tree", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID2, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID2, rmXFractionToMeters(15.5));
   rmAddObjectDefConstraint(randomTreeID2, rmCreateTypeDistanceConstraint("random tree 2", "all", 4.0));

    // Birds
   int farhawkID=rmCreateObjectDef("far hawks");
   rmAddObjectDefItem(farhawkID, "vulture", 1, 0.0);
   rmSetObjectDefMinDistance(farhawkID, 0.0);
   rmSetObjectDefMaxDistance(farhawkID, rmXFractionToMeters(0.5));

   int randomRelicID=rmCreateObjectDef("random relic");
   rmAddObjectDefItem(randomRelicID, "relic", 1, 4.0);
   //rmAddObjectDefConstraint(randomRelicID, farStartingSettleConstraint);   

   int randomGoldID=rmCreateObjectDef("random gold");
   rmAddObjectDefItem(randomGoldID, "Gold mine", 1, 4.0);
   //rmAddObjectDefConstraint(randomGoldID, farStartingSettleConstraint);    

   // -------------Done defining objects

   rmSetStatusText("Creating player area...",0.20);
   // Cheesy "circular" placement of players.

   rmPlacePlayersSquare(0.4, 0.05, 0.05);

   // Text
   rmSetStatusText("",0.20);

   // Dumb thing to just block out player areas since placement sucks right now.
   // This area doesn't paint down anything, it just exists for blocking out the center sea.
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player core"+i);
      // Set the size.
      rmSetAreaSize(id, rmAreaTilesToFraction(110), rmAreaTilesToFraction(110));
      rmAddAreaToClass(id, classPlayerCore);
      rmSetAreaCoherence(id, 1.0);
      // Set the location.
      rmSetAreaLocPlayer(id, i);
   }

   rmSetStatusText("Creating player area...",0.25);
   int forestOneID = 0;
   int forestTwoID = 0;
   int forestThreeID = 0;
   int forestFourID = 0;
   int coreOneID = 0;
   int coreTwoID = 0;
   int coreThreeID = 0;
   int coreFourID = 0;
   int forestNumber =0;

   forestOneID=rmCreateArea("forest one");
   rmSetAreaSize(forestOneID, 0.007, 0.007);
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
   rmSetAreaSize(coreOneID, 0.006, 0.006);
   rmSetAreaLocation(coreOneID, 0.5, 0.5);
   rmSetAreaWaterType(coreOneID, "Egyptian Nile");
   rmAddAreaToClass(coreOneID, rmClassID("center"));
   rmSetAreaBaseHeight(coreOneID, 0.0);
   rmSetAreaMinBlobs(coreOneID, 1);
   rmSetAreaMaxBlobs(coreOneID, 1);
   rmSetAreaSmoothDistance(coreOneID, 50);
   rmSetAreaCoherence(coreOneID, 0.25);
   rmBuildArea(coreOneID);

   // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(3000);
   for(i=1; <cNumberPlayers)
   {
      id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, 0.9*playerFraction, 1.1*playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 5);
      rmSetAreaMinBlobDistance(id, 16.0);
      rmSetAreaMaxBlobDistance(id, 40.0);
      rmSetAreaCoherence(id, 0.0);
      rmAddAreaConstraint(id, playerCenterConstraint);
      rmSetAreaLocPlayer(id, i);
      rmSetAreaTerrainType(id, "SandDirt50"); 
      rmAddAreaTerrainLayer(id, "SandA", 1, 2); 
      rmAddAreaTerrainLayer(id, "SandB", 0, 1); 
   }

   rmSetStatusText("Building areas...",0.30);
   // Build the areas.
   rmBuildAllAreas();

   for(i=1; <cNumberPlayers*5)
   {
      // Beautification sub area.
      int id2=rmCreateArea("patch A"+i);
      rmSetAreaSize(id2, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
      rmSetAreaTerrainType(id2, "SandD");
      rmSetAreaMinBlobs(id2, 1);
      rmSetAreaMaxBlobs(id2, 5);
      rmSetAreaMinBlobDistance(id2, 16.0);
      rmSetAreaMaxBlobDistance(id2, 40.0);
      rmSetAreaCoherence(id2, 0.0);
      rmAddAreaConstraint(id2, centerConstraint);
      rmAddAreaConstraint(id2, avoidBuildings);
      rmBuildArea(id2);
   }

   // Text
   rmSetStatusText("Map elevation...",0.40);

   // Elev.
   numTries=10*cNumberNonGaiaPlayers;
   int failCount=0;
   for(i=0; <numTries)
   {
      int elevID=rmCreateArea("elev"+i);
      rmSetAreaSize(elevID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
      rmSetAreaWarnFailure(elevID, false);
      rmAddAreaConstraint(elevID, avoidImpassableLand);
      if(rmRandFloat(0.0, 1.0)<0.5)
         rmSetAreaTerrainType(elevID, "SandD");
      rmSetAreaBaseHeight(elevID, rmRandFloat(3.0, 6.0));
      rmSetAreaHeightBlend(elevID, 2);
      rmAddAreaToClass(id, classElev);
      rmSetAreaMinBlobs(elevID, 1);
      rmSetAreaMaxBlobs(elevID, 5);
      rmSetAreaMinBlobDistance(elevID, 16.0);
      rmSetAreaMaxBlobDistance(elevID, 40.0);
      rmSetAreaCoherence(elevID, 0.0);
      if(rmBuildArea(elevID)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==6)
            break;
      }
      else
         failCount=0;
   }

   rmSetStatusText("Map elevation...",0.50);
   numTries=20*cNumberNonGaiaPlayers;
   failCount=0;
   for(i=0; <numTries)
   {
      elevID=rmCreateArea("wrinkle"+i);
      rmSetAreaSize(elevID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(120));
      rmSetAreaWarnFailure(elevID, false);
      rmSetAreaBaseHeight(elevID, rmRandFloat(2.0, 3.0));
      rmSetAreaMinBlobs(elevID, 1);
      rmSetAreaMaxBlobs(elevID, 3);
      if(rmRandFloat(0.0, 1.0)<0.5)
         rmSetAreaTerrainType(elevID, "SandD");
      rmSetAreaMinBlobDistance(elevID, 16.0);
      rmSetAreaMaxBlobDistance(elevID, 20.0);
      rmSetAreaCoherence(elevID, 0.0);
      rmAddAreaConstraint(elevID, avoidImpassableLand);
      rmAddAreaToClass(elevID, classElev);
      rmAddAreaConstraint(elevID, elevConstraint);

      if(rmBuildArea(elevID)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==10)
            break;
      }
      else
         failCount=0;
   }

   rmSetStatusText("Place starting settlements...",0.60);
   // Place starting settlements.
   // Close things....
   // TC
   rmPlaceObjectDefPerPlayer(startingSettlementID, true);

   // Settlements.
   id=rmAddFairLoc("Settlement", false, true, 60, 80, 50, 16); /* forward inside */
   rmAddFairLocConstraint(id, wideCenterConstraint);

   if(rmRandFloat(0,1)<0.75)
      id=rmAddFairLoc("Settlement", true, false, 70, 120, 50, 16);
   else
      id=rmAddFairLoc("Settlement", false, true,  60, 100, 40, 16);

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

   // Towers.
   rmPlaceObjectDefPerPlayer(startingTowerID, true, 9);

   // Straggler trees.
   rmPlaceObjectDefPerPlayer(stragglerTreeID, false, 3);

   // Gold
   //rmPlaceObjectDefPerPlayer(startingGoldID, false, 2);

   // Goats
   rmPlaceObjectDefPerPlayer(closeGoatsID, true);

   // Chickens or berries.

   rmPlaceObjectDefPerPlayer(closeChickensID, true, 3);

   // Boar.
   rmPlaceObjectDefPerPlayer(closeBoarID, false, 1);

   // Random Items
   int randomTries=6*sqrt(2*cNumberNonGaiaPlayers);
   xLoc = 0.0;
   zLoc = 0.0;
   for(i=0; <randomTries)
   {
      xLoc = rmRandFloat(0,1);
      zLoc = rmRandFloat(0,1);
      rmPlaceObjectDefAtLoc(randomRelicID, 0, xLoc, zLoc, 2);
      xLoc = rmRandFloat(0,1);
      zLoc = rmRandFloat(0,1);
      rmPlaceObjectDefAtLoc(randomGoldID, 0, xLoc, zLoc, 2);
   }

   // Some cliffy areas
   rmSetStatusText("Some cliffy areas...",0.70);
   numTries=30*cNumberNonGaiaPlayers;
   failCount=0;
   for(i=0; <numTries)
   {
      int rockyID=rmCreateArea("rocky terrain"+i);
      rmSetAreaSize(rockyID, rmAreaTilesToFraction(300), rmAreaTilesToFraction(600));      
      rmSetAreaWarnFailure(rockyID, false);
      rmSetAreaMinBlobs(rockyID, 1);
      rmSetAreaMaxBlobs(rockyID, 1);
      rmSetAreaTerrainType(rockyID, "SandA");      
      rmAddAreaTerrainLayer(rockyID, "SandA", 0, 2);
      rmSetAreaBaseHeight(rockyID, 5.0);
      rmSetAreaMinBlobDistance(rockyID, 16.0);
      rmSetAreaMaxBlobDistance(rockyID, 20.0);
      rmSetAreaCoherence(rockyID, 1.0); 
      rmSetAreaSmoothDistance(rockyID, 10);
      rmAddAreaConstraint(rockyID, avoidImpassableLand);
      rmAddAreaConstraint(rockyID, elevConstraint); 

      if(rmBuildArea(rockyID)==false)
      {
         failCount++;
         if(failCount==10)
            break;
      }
      else
         failCount=0;
   }

   rmSetStatusText("Placing map objects...",0.75);
   // Gold
   //rmPlaceObjectDefPerPlayer(mediumGoldID, false);

   // Goats
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefAtLoc(mediumGoatsID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), 2);

    // Hawks
   rmPlaceObjectDefPerPlayer(farhawkID, false, 2);

   // Goats
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefAtLoc(farGoatsID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), 3);

   // Bonus huntable.
   rmPlaceObjectDefAtLoc(bonusHuntableID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

   // Berries.
   rmPlaceObjectDefAtLoc(farBerriesID, 0, 0.5, 0.5, cNumberPlayers);

   // Predators
   rmPlaceObjectDefPerPlayer(farPredatorID, false, 1);

   // Predators2
   rmPlaceObjectDefPerPlayer(farPredator2ID, false, 1);   

   // Text
   rmSetStatusText("Placing trees...",0.80);

   // Random trees.
   rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
   rmPlaceObjectDefAtLoc(randomTreeID2, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

   // Oasis Forest.
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestSettleConstraint=rmCreateClassDistanceConstraint("forest settle", rmClassID("starting settlement"), 20.0);
   int forestID=rmCreateArea("forest"+i);
   rmSetAreaSize(forestID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(100));
   rmSetAreaWarnFailure(forestID, false);
   rmSetAreaForestType(forestID, "palm forest");
   rmAddAreaConstraint(forestID, forestSettleConstraint);
   rmAddAreaConstraint(forestID, forestObjConstraint);
   rmAddAreaConstraint(forestID, forestConstraint);
   rmAddAreaConstraint(forestID, centerConstraint);
   rmAddAreaToClass(forestID, classForest);
   rmSetAreaMinBlobs(forestID, 1);
   rmSetAreaMaxBlobs(forestID, 1);
   rmSetAreaMinBlobDistance(forestID, 1.0);
   rmSetAreaMaxBlobDistance(forestID, 1.0);
   rmSetAreaCoherence(forestID, 0.0);

   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int deerID=rmCreateObjectDef("lonely deer");
   rmAddObjectDefItem(deerID, "gazelle", rmRandInt(1,3), 2.0);
   rmSetObjectDefMinDistance(deerID, 0.0);
   rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(deerID, avoidAll);
   rmAddObjectDefConstraint(deerID, avoidBuildings);
   rmAddObjectDefConstraint(deerID, avoidImpassableLand);
   rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

   //rocks
   int rockID=rmCreateObjectDef("rock");
   rmAddObjectDefItem(rockID, "rock sandstone sprite", 1, 0.0);
   rmSetObjectDefMinDistance(rockID, 0.0);
   rmSetObjectDefMaxDistance(rockID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(rockID, avoidAll);
   rmAddObjectDefConstraint(rockID, avoidImpassableLand);
   rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);

   // Bushes
   int bushID=rmCreateObjectDef("big bush patch");
   rmAddObjectDefItem(bushID, "bush", 4, 3.0);
   rmSetObjectDefMinDistance(bushID, 0.0);
   rmSetObjectDefMaxDistance(bushID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(bushID, avoidAll);
   rmPlaceObjectDefAtLoc(bushID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

   int bush2ID=rmCreateObjectDef("small bush patch");
   rmAddObjectDefItem(bush2ID, "bush", 3, 2.0);
   rmAddObjectDefItem(bush2ID, "rock sandstone sprite", 1, 2.0);
   rmSetObjectDefMinDistance(bush2ID, 0.0);
   rmSetObjectDefMaxDistance(bush2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(bush2ID, avoidAll);
   rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

   int grassID=rmCreateObjectDef("grass");
   rmAddObjectDefItem(grassID, "grass", 1, 0.0);
   rmSetObjectDefMinDistance(grassID, 0.0);
   rmSetObjectDefMaxDistance(grassID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(grassID, avoidAll);
   rmAddObjectDefConstraint(grassID, centerConstraint);
   rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);

   int driftVsDrift=rmCreateTypeDistanceConstraint("drift vs drift", "sand drift dune", 25.0);
   int sandDrift=rmCreateObjectDef("blowing sand");
   rmAddObjectDefItem(sandDrift, "sand drift patch", 1, 0.0);
   rmSetObjectDefMinDistance(sandDrift, 0.0);
   rmSetObjectDefMaxDistance(sandDrift, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(sandDrift, avoidAll);
   rmAddObjectDefConstraint(sandDrift, edgeConstraint);
   rmAddObjectDefConstraint(sandDrift, driftVsDrift);
   rmAddObjectDefConstraint(sandDrift, avoidBuildings);
   rmPlaceObjectDefAtLoc(sandDrift, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);


   // Oasis Fishes
   rmSetStatusText("Placing oasis...",0.85);
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 1.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 1.0);
   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "fish - perch", 3, 1.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, 600);
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers); 
   //papyrus - posso tentar colocar papiro no lado central depois.
   /*
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int papyrusID=rmCreateObjectDef("lone papyrus");
   int nearshore=rmCreateTerrainMaxDistanceConstraint("papyrus near shore", "land", true, 4.0);
   rmAddObjectDefItem(papyrusID, "papyrus", 3, 2.0);
   rmSetObjectDefMinDistance(papyrusID, 0.0);
   rmSetObjectDefMaxDistance(papyrusID, 600);
   rmAddObjectDefConstraint(papyrusID, avoidAll);
   rmAddObjectDefConstraint(papyrusID, nearshore);
   rmPlaceObjectDefAtLoc(papyrusID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
   */
   // Text

   // Bandit Camps
   rmSetStatusText("Placing bandit camps...",0.90);
   int banditCampId=rmCreateObjectDef("Bandit Camp");
   rmAddObjectDefItem(banditCampId, "Longhouse", 1, 0.0);
   int banditId=rmCreateObjectDef("far bandits");
   rmAddObjectDefItem(banditId, "Spearman", rmRandInt(4,15), 10.0);
   numTries=6*cNumberNonGaiaPlayers;
   xLoc = 0.0;
   zLoc = 0.0;
   for(i=0; <numTries)
   {
      xLoc = rmRandFloat(0,1);
      zLoc = rmRandFloat(0,1);
      rmPlaceObjectDefAtLoc(banditCampId, 0, xLoc, zLoc, 1);
      rmPlaceObjectDefAtLoc(banditId, 0, xLoc, zLoc, 1);
   }
   rmSetStatusText("Finishing map...",1.0);

}  




