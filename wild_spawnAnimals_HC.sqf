/*
 * File: wild_spawnAnimals_HC.sqf
 * Author: Martin McCormack
 * Distributors : DayZ
 *
 * Description: Spawn Wild Animals all over the Map
 *
*/

private ["_list","_animalssupported","_type","_root","_favouritezones","_randrefpoint","_PosList","_PosSelect","_Pos","_agent","_id"];

//If there is to much Animals around no need to go trough all this again, or?
if (mm_currentGlobalAnimals >= dayz_maxAnimals) exitWith {
	//diag_log format ["[%1] - To many Animals around (%2)",time,mm_currentGlobalAnimals];
};


/* ******************** */
/* * Populate Animals * */
/* ******************** */
{
	_position = [locationPosition _x,120,mm_hcDist,10,0,0,0] call BIS_fnc_findSafePos;
	_skip = false;
	
	//Validate 
	if (count _position <= 0) then {diag_log format ["[%1] - Skipping Location %2 because not valid (%3)",time,_x,__FILE__];_skip = true;};
	if (isNil "mm_useAnimals") then {diag_log format ["[%1] - Skipping Animal Spawn, because Array not valid (%3)",time,_x,__FILE__];_skip = true;};
	if (!isNil "mm_useAnimals") then {
		if (count mm_useAnimals <= 0) then {diag_log format ["[%1] - Skipping Animal Spawn, because Array not valid (%3)",time,_x,__FILE__];_skip = true;};
	};

	if (!_skip) then {

		_type = mm_useAnimals call BIS_fnc_selectRandom;

		if (_type == "DZ_Pastor") then {
			_agent = createAgent [_type, _position, [], 0, "NONE"]; 
		} else {
			_agent = createAgent [_type, _position, [], 0, "FORM"];
		};
		
		mm_currentGlobalAnimals = mm_currentGlobalAnimals + 1;
		
		_agent setpos _position;

		PVDZE_zed_Spawn = [_agent];
		publicVariableServer "PVDZE_zed_Spawn";
			
		_id = [_position,_agent] execFSM "headlessclient\fsm\animal_agent_HC.fsm";
	
	};
	
} count mm_locations;
