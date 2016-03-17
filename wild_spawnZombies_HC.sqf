/*
 * File: wild_spawnZombies_HC.sqf
 * Author: Martin McCormack
 * Distributors : DayZ
 *
 * Description: Spawn Zombies in Wilderness Areas (Areas can be defined in variablesHC.sqf!)
 *
*/

private ["_unitTypes","_agent","_type","_locations","_position","_exit"];

//If there is to much Zombies around no need to go trough all this again, or?
if (dayz_currentGlobalZombies >= dayz_maxGlobalZeds) exitWith {
	diag_log format ["[%1] - To many Zombies around (%2)",time,dayz_currentGlobalZombies];
};

_exit = false;
scopeName "exit";
if (mm_splitZ && !_exit) then {
	if (isNil "mm_splitPrior") then {diag_log format ["[%1] - ERROR:  Split Priority is not set! (%2)",time,__FILE__];_exit = true;breakTo "exit";};
	if (isNil "mm_splitRatio") then {diag_log format ["[%1] - ERROR: Split Ratio is not set! (%2)",time,__FILE__];_exit = true;breakTo "exit";};
	
	if (mm_splitPrior == "building") then {
		if ((mm_wildSpawnZombies*mm_splitRatio) > mm_buildingSpawnZombies && mm_initialRunZ) then {_exit = true;breakTo "exit";};
	};
	
};
if (_exit) exitWith {};

_unitTypes = getArray (mm_cfgFile >> "CfgBuildingLoot" >> "Default" >> "zombieClass");


/* ************************ */
/* * Generate Zombie Loot * */
/* ************************ */
_zombieGenLoot = {
	private ["_agent","_lootType","_index","_weights","_loot_count"];
	_agent = _this select 0;
	_array = [];
	if ((random 1) < 0.2) then {
		_lootType = configFile >> "CfgVehicles" >> (typeOf _agent) >> "zombieLoot";
		if (isText _lootType) then {
			{
				_array set [count _array, _x select 0]
			} count getArray (configFile >> "cfgLoot" >> getText(_lootType));
			if (count _array > 0) then {
				_index = dayz_CLBase find getText(_lootType);
				_weights = dayz_CLChances select _index;
				_loot = _array select (_weights select (floor(random (count _weights))));
				if(!isNil "_loot") then {
					_loot_count =	getNumber(configFile >> "CfgMagazines" >> _loot >> "count");
					if(_loot_count>1) then {
						_agent addMagazine [_loot, ceil(random _loot_count)];
					} else {
						_agent addMagazine _loot;
					};
				};
			};
		};
	};
};


/* ******************** */
/* * Populate Zombies * */
/* ******************** */
{
	_position = [locationPosition _x,120,mm_hcDist,10,0,0,0] call BIS_fnc_findSafePos;
	_skip = false;
	
	//Validate 
	if (count _position <= 0) then {diag_log format ["[%1] - Skipping Location %2 because not valid (%3)",time,_x,__FILE__];_skip = true;};

	scopeName "skip";
	
	if (!_skip) then {
		
		_agent = createAgent [(_unitTypes call BIS_fnc_selectRandom), _position, [], 40, "NONE"];
		_agent setDir round(random 180);

		dayz_currentGlobalZombies = dayz_currentGlobalZombies + 1;
		mm_wildSpawnZombies = mm_wildSpawnZombies + 1;

		if (random 1 > 0.7) then {
			_agent setUnitPos "Middle";
		};

		_agent setVariable ["myDest",getPosATL _agent];
		_agent setVariable ["newDest",getPosATL _agent];

		//Add some loot
		[_agent] call _zombieGenLoot;

		//Disable simulation
		if (mm_enableZSimulation) then {
			_agent enableSimulation false;
		};

		_agent addRating -1000000;

		if (mm_enableHardZombies) then {
			_agent addEventHandler ["HandleDamage",{_this call mm_hardZombie;}];
		};
		
		//Start behavior
		_id = [_position,_agent] execFSM "headlessclient\fsm\zombie_agent_HC.fsm";
		
	};
	
} count mm_locations;

if (!mm_initialRunW) then {
	mm_initialRunW = true;
};

