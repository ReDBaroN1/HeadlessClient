/*
 * File: zombie_loiter_HC.sqf
 * Author: Martin McCormack
 * Distributors : DayZ
 *
 * Description: Spawn Zombie at given Position
 *
*/

private ["_position","_doLoiter","_unitTypes","_pNear","_loot","_array","_agent","_type","_radius","_method","_favStance","_index","_weights","_loot_count"];

_position = _this select 0;
_doLoiter = _this select 1;
_unitTypes = _this select 2;

_pNear = 	false;
_loot = 	"";
_array = 	[];
_agent = 	objNull;

//Validate
if (count _unitTypes == 0) then {
	_unitTypes = getArray (mm_cfgFile >> "CfgBuildingLoot" >> "Default" >> "zombieClass");
};

if (count _this < 3) exitWith {diag_log format ["[%1] - Exiting Zombie Generate because no valid parameters (%2)",time,_this];};
if (count _position <= 0) exitWith {diag_log format ["[%1] - Exiting Zombie Generate because no valid parameters (%2)",time,_this];};
if (_pNear) exitWith {/* SPÄHÄM A LOHOT ! diag_log format ["[%1] - Exiting Zombie Generate because player was near (%2)",time,_this];*/};
if (surfaceIsWater _position) exitwith {diag_log format ["[%1] - Exiting Zombie Generate because zombies simply don`t swim! (%2)",time,_this];};
if (count _unitTypes == 0) exitWith {diag_log format ["[%1] - Exiting Zombie Generate because no valid parameters (%2)",time,_this];};

if (dayz_currentGlobalZombies < dayz_maxGlobalZeds) then {

	// lets create an agent
	_type = _unitTypes call BIS_fnc_selectRandom;
	_radius = 5;
	_method = "NONE";
	if (_doLoiter) then {
		_radius = 40;
		_method = "CAN_COLLIDE";
	};

	_agent = createAgent [_type, _position, [], _radius, _method];
	
	//add to global counter
	dayz_currentGlobalZombies = dayz_currentGlobalZombies + 1;
	mm_buildingSpawnZombies = mm_buildingSpawnZombies + 1;

	//Add some loot
	_rnd = random 1;
	if (_rnd < 0.2) then {
		_lootType = mm_cfgFile >> "CfgVehicles" >> _type >> "zombieLoot";
		if (isText _lootType) then {
			{
				_array set [count _array, _x select 0]
			} count getArray (mm_cfgFile >> "cfgLoot" >> getText(_lootType));
			if (count _array > 0) then {
				_index = dayz_CLBase find getText(_lootType);
				_weights = dayz_CLChances select _index;
				_loot = _array select (_weights select (floor(random (count _weights))));
				if(!isNil "_loot") then {
					_loot_count =	getNumber(mm_cfgFile >> "CfgMagazines" >> _loot >> "count");
					if(_loot_count>1) then {
						_agent addMagazine [_loot, ceil(random _loot_count)];
					} else {
						_agent addMagazine _loot;
					};
				};
			};
		};
	};

	_agent setVariable["agentObject",_agent];

	if (!isNull _agent) then {

		_agent setDir random 360;

		_position = getPosATL _agent;

		_favStance = (
			switch ceil(random(3^0.5)^2) do {
				//case 3: {"DOWN"}; // prone
				case 2: {"Middle"}; // Kneel
				default {"UP"} // stand-up
			}
		);
		_agent setUnitPos _favStance;

		_agent setVariable ["stance", _favStance];
		_agent setVariable ["BaseLocation", _position];
		_agent setVariable ["doLoiter", _doLoiter];
		_agent setVariable ["myDest", _position];
		_agent setVariable ["newDest", _position];

	};

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