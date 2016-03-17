
/* **************** */
/* * MM Variables * */
/* **************** */

/*
	*	mm_hcPos				- The Central Position of the Spawn Points (Default: getMarkerPos "center")
	*	mm_hcDist				- The Distance from which we can Spawn - Preferably Map size (Default: 25000)
	*	mm_hcBuildings			- The Buildings that Zombies spawn around (Default ["house"]) Example: ["house","Garage_Door","BusStop"]
	*	mm_enableZSimulation	- "Talk" to the Server? Turn this off, if you want AI`s being able to shoot at Zombies
	*	mm_enableHardZombies	- Make Zombies die from Headshots only? (Default: false - because you don`t have that script :P)
	*	mm_cfgFile				- The Default config File (If you have custom Loot tables use missionConfigFile - Default: configFile)
	*	mm_hcFSM				- The Headless Client FSM ID (Used for Initialization - Jesus i hope i spelled that right?)
	*	mm_useThreads			- Create Zombies using "spawn" or "call" ? If set to true it will use "spawn"
	*	mm_buildings			- The overall Buildings to spawn Zombies at (Used in: Building Spawn Zombies)
	*	mm_locations			- The overall Locations to spawn Zombies at (Used in: Wild Spawn Zombies)
	*	mm_useCoreCustom		- Create a custom Statement for the Client to run (Works in relation with mm_coreCustomState)
	*	mm_coreCustomState		- Script to be executed when using custom States
	*	mm_coreCustomCondition	- Custom Condition to be furfilled (Example: "count _var <= 0" - With the -> " <- )
	*	mm_zombieWait			- The Wait Timer between Zombie Spawns (Used in: Wild Spawn Zombies)
	*	mm_buildingWait			- The Wait Timer between Zombie Spawns (Used in: Building Spawn Zombies)
	*	mm_animalWait			- The Wait Timer between Animal Spawns (Used in: Animal Spawn)
	*	mm_filePath				- If using custom Path for Scripts set the Path here, otherwise leave blank
	*	mm_splitZ				- Split Wild Spawn and Building Spawn (Use with Ratio!) - I recommend you use Wild, because Wilderness is simply bigger
	*	mm_splitPrior			- The Priority in which the Split System will work (possible values "building" , "wild")
	*	mm_splitRatio			- The Split Ratio (Example: mm_splitZ = true; mm_splitPrior = "building"; mm_splitRatio = 4 --- Will Spawn 4 Times as many Zombies at buildings, then in wilderness)
	*	mm_setPermaLoot			- Set the Variable "permaLoot" on the Weapon Holder (Turn this OFF, if you want to shuffe / randomize / respawn the loot, turn on if you want persistent loot)
*/
mm_hcPos			= getMarkerPos "center";
mm_hcDist			= 25000;
mm_hcBuildings		= ["house"];
mm_enableZSimulation= false;
mm_enableHardZombies= false;
mm_cfgFile			= configFile;
mm_hcFSM			= -1;
mm_useThreads		= true;

mm_buildings		= nearestObjects [mm_hcPos, mm_hcBuildings, mm_hcDist];
mm_locations		= nearestLocations [mm_hcPos, ["RockArea","VegetationFir"], mm_hcDist];
/* TODO: Add more Location Names in to the array */

mm_useCoreCustom	= false;
mm_coreCustomState	= {};
mm_coreCustomCondition = "";

mm_zombieWait		= 30;
mm_buildingWait		= 60;
mm_animalWait		= 180;
mm_lootWait			= 120;

mm_filePath			= "";

mm_splitZ			= true;
mm_splitPrior		= "building";
mm_splitRatio		= 2;

mm_setPermaLoot 	= true;

/* This section should be self- explaining */
mm_useAnimalSpawn	= true;
mm_useWildZSpawn	= true;
mm_useBuildingZSpawn= true;
mm_useLootSpawn		= true;
mm_useAnimals 		= ["Cow01","Cow02","Cow03","Cow04","Cow01_EP1","Goat01_EP1","Goat02_EP1","Goat","Sheep","Sheep02_EP1","Sheep01_EP1","Hen","Cock","DZ_Fin","DZ_Pastor"];

/* I recommend you do not touch these Variables unless you don't want an Initial run */
mm_initialRunZ = false;
mm_initialRunW = false;
mm_initialRunA = false;
mm_initialRunL = false;


/* ***************** */
/* * Max Variables * */
/* ***************** */

/*
	*	dayz_maxGlobalZeds				- The maximum number of overall Zeds (all over the map)
	*	dayz_maxAnimals					- The Maximum Number of Animals spawned all over the Map
	*	dayz_maxWeaponHolders			- The Maximum Number of Loot Piles that can be spawned
*/
dayz_maxGlobalZeds		= 1200;
dayz_maxAnimals			= 75;
dayz_maxWeaponHolders 	= 200;


/* ****************** */
/* * Loot Variables * */
/* ****************** */
dayz_CLChances		= [];
dayz_CLBase			= [];
dayz_CBLChances		= [];
dayz_CBLBase		= [];
dayzE_CBLSChances	= [];
dayzE_CBLSBase		= [];
dayzE_CLSBase		= [];
dayzE_CLSChances	= [];

/* ********************* */
/* * Counter Variables * */
/* ********************* */
dayz_currentGlobalZombies	= 0;
mm_wildSpawnZombies			= 0;
mm_buildingSpawnZombies		= 0;
mm_currentGlobalAnimals		= 0;
dayz_currentWeaponHolders	= 0;
