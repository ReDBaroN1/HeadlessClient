/*
 * File: zombie_speak_HC.sqf
 * Author: DayZ
 * Distributors: Martin McCormack
 *
 * Description: Make _x play a sound 
 *
*/

private ["_unit","_type","_chance","_rnd","_sound","_local","_dis","_num","_isWoman"];
_unit = _this select 0;
_type = _this select 1;
_chance = _this select 2;

_num = call {
	if (_type == "cough") exitWith {2};
	if (_type == "chase") exitWith {14};
	if (_type == "spotted") exitWith {13};
	if (_type == "hit") exitWith {6};
	if (_type == "attack") exitWith {13};
	if (_type == "idle") exitWith {35};
	if (_type == "scream") exitWith {4};
	if (_type == "fracture") exitWith {1};
	if (_type == "eat") exitWith {3};
	if (_type == "cook") exitWith {2};
	if (_type == "panic") exitWith {4};
	if (_type == "dog_bark") exitWith {3};
	if (_type == "dog_growl") exitWith {2};
	if (_type == "dog_qq") exitWith {1};
	if (_type == "keypad_tick") exitWith {2};
	if (_type == "flysound") exitWith {1};
	if (_type == "open_backpack") exitWith {4};
	if (_type == "open_inventory") exitWith {4};
	0
};

if (count _this > 4) then {
	_dis = _this select 4;
	_local = ({isPlayer _x} count (_unit nearEntities ["AllVehicles",_dis]) < 2);
} else {
	_local = _this select 3;
	
	if (_type in ["shout","hit","attack","scream","breath","spotted","dog_bark","dog_growl","dog_qq"]) then {
		_dis = 100;
	} else {
		_dis = 40;
	};
};

_isWoman = getText(configFile >> "cfgVehicles" >> (typeOf _unit) >> "TextPlural") == "Women";
if (_isWoman && (_type in ["scream","panic"])) then {
	_type = _type + "_w";
};


if ((round(random _chance) == _chance) || (_chance == 0)) then {
	_rnd =(round(random _num));
	_sound = "z_" + _type + "_" + str(_rnd);
	if (_local) then {
		_unit say [_sound, _dis];
	} else {
		[nil,_unit,rSAY,[_sound, _dis]] call RE;
	};
};