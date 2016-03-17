/*
 * File: building_spawnZombies_HC.sqf
 * Author: Martin McCormack
 * Distributors : DayZ
 *
 * Description: Spawn Zombies around the Buildings on Map
 *
*/

private ["_buildings","_config","_skip","_zChance","_zClass","_zPos","_spawnPos","_nearBy","_min","_max","_num","_exit"];

//_buildings = nearestObjects [mm_hcPos, mm_hcBuildings, mm_hcDist];
_skip = false;

//If there is to much Zombies around no need to go trough all this again, or?
if (dayz_currentGlobalZombies >= dayz_maxGlobalZeds) exitWith {
	diag_log format ["[%1] - To many Zombies around (%2)",time,dayz_currentGlobalZombies];
};

_exit = false;
scopeName "exit";
if (mm_splitZ && !_exit) then {
	if (isNil "mm_splitPrior") then {diag_log format ["[%1] - ERROR:  Split Priority is not set! (%2)",time,__FILE__];_exit = true;breakTo "exit";};
	if (isNil "mm_splitRatio") then {diag_log format ["[%1] - ERROR: Split Ratio is not set! (%2)",time,__FILE__];_exit = true;breakTo "exit";};
	
	if (mm_splitPrior == "wild") then {
		if ((mm_buildingSpawnZombies*mm_splitRatio) > mm_wildSpawnZombies && mm_initialRunW) then {_exit = true;breakTo "exit";};
	};
	
};
if (_exit) exitWith {};

{
	//Validate Parameters
	_config = mm_cfgFile >> "CfgBuildingLoot" >> (typeOf _x);
	
	if !(isClass _config) then {
	
		_skip = true;
	
		//Let`s give it a second chance, before we skip
		_parents = [(configFile >> "CfgVehicles" >> (typeOf _x)),true] call BIS_fnc_returnParents;
		
		// See : https://community.bistudio.com/wiki/Code_Optimisation#Loops
		for "_y" from 0 to (count _parents)-1 step 1 do {
			_config = mm_cfgFile >> "CfgBuildingLoot" >> (_parents select _y);
			if (isClass _config) exitWith {_skip = false;};
		};
		
	};
	
	scopeName "skip";
	
	if (!_skip) then {

		_zChance= getNumber (_config >> "zombieChance");
		_zClass	= getArray (_config >> "zombieClass");
		_zPos	= getArray (_config >> "lootPosZombie");
		_min	= getNumber (_config >> "minRoaming");
		_max	= getNumber (_config >> "maxRoaming");
		
		//Validate 
		if !(finite _zChance) then {diag_log format ["[%1] - Skipping Object %2  because no zChance (%3)",time,_x,__FILE__];_skip = true; breakTo "skip";};
		if !(finite _min) then {diag_log format ["[%1] - Skipping Object %2 because no min Value (%3)",time,_x,__FILE__];_skip = true; breakTo "skip";};
		if !(finite _max) then {diag_log format ["[%1] - Skipping Object %2 because no max Value (%3)",time,_x,__FILE__];_skip = true; breakTo "skip";};
		if !(count _zClass > 0) then {diag_log format ["[%1] - Skipping Object %2 because no zClass (%3)",time,_x,__FILE__];_skip = true; breakTo "skip";};
		
		_num = (round(random _max)) max _min;
		
		if (count _zPos > 0) then {
		
			// See : https://community.bistudio.com/wiki/Code_Optimisation#Loops
			for "_y" from 0 to (count _zPos)-1 step 1 do {
				if (random 1 < _zChance) then {
					_spawnPos = _x modelToWorld (_zPos select _y);
					if !(count (_spawnPos nearEntities ["zZombie_Base",1]) > 0) then {
						[_spawnPos,true,_zClass] call zombie_generate;
					};
				};
			};
			
		} else {
			
			// See : https://community.bistudio.com/wiki/Code_Optimisation#Loops
			for "_y" from 0 to _num step 1 do {
				if (random 1 < _zChance) then {
					[(getPosATL _x),true,_zClass] call zombie_generate;
				};
			};
			
		};
		
	};
	
} count mm_buildings > 0;

if (!mm_initialRunZ) then {
	mm_initialRunZ = true;
};
