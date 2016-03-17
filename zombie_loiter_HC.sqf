/*
 * File: zombie_loiter_HC.sqf
 * Author: DayZ
 *
 * Description: Make Zombie wander around
 *
*/

private ["_unit","_pos","_chance"];
_unit = 		_this select 0;
_pos = 			getPosATL _unit;

_chance = round(random 12);
if ((_chance % 4) == 0) then {
	_pos = [_pos,30,120,4,0,5,0] call BIS_fnc_findSafePos;
} else {
	_pos = [_pos,10,90,4,0,5,0] call BIS_fnc_findSafePos;
};
	
if(isNull group _unit) then {
	_unit moveTo _pos;
} else {
	_unit domove _pos;		
};	
_unit forceSpeed 2;
_unit setVariable ["myDest",_pos];
