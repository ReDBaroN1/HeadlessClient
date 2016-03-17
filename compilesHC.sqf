
/* ******************* */
/* * Zombie Compiles * */
/* ******************* */
building_spawnZombies	= compile preprocessFileLineNumbers "headlessclient\building_spawnZombies_HC.sqf";
mm_hardZombie			= compile preprocessFileLineNumbers "custom\scripts\zombies\mm_hardZombie.sqf";
zombie_findTargetAgent	= compile preprocessFileLineNumbers "headlessclient\zombie_findTargetAgent_HC.sqf";
zombie_loiter			= compile preprocessFileLineNumbers "headlessclient\zombie_loiter_HC.sqf";
zombie_generate			= compile preprocessFileLineNumbers "headlessclient\zombie_generate_HC.sqf";
wild_spawnZombies		= compile preprocessFileLineNumbers "headlessclient\wild_spawnZombies_HC.sqf";
dayz_zombiespeak		= compile preprocessFileLineNumbers "headlessclient\zombie_speak_HC.sqf";


/* ***************** */
/* * Loot Compiles * */
/* ***************** */
mm_buildingLoot			= compile preprocessFileLineNumbers "headlessclient\mm_buildingLoot_HC.sqf";
dz_spawn_loot			= compile preprocessFileLineNumbers "headlessclient\spawn_loot_HC.sqf";
dz_spawn_loot_small		= compile preprocessFileLineNumbers "headlessclient\spawn_loot_small_HC.sqf";
dz_loot_init			= compile preprocessFileLineNumbers "headlessclient\loot_init_HC.sqf";


/* ******************* */
/* * Animal Compiles * */
/* ******************* */
wild_spawnAnimals		= compile preprocessFileLineNumbers "headlessclient\wild_spawnAnimals_HC.sqf";


/* ******************* */
/* * System Compiles * */
/* ******************* */
BIS_fnc_findSafePos			= compile preprocessFileLineNumbers "ca\modules\functions\misc\fn_findSafePos.sqf";
BIS_fnc_selectRandom		= compile preprocessFileLineNumbers "ca\modules\functions\arrays\fn_selectRandom.sqf";
BIS_fnc_returnParents		= compile preprocessFileLineNumbers "ca\modules\functions\configs\fn_returnParents.sqf";
BIS_fnc_selectRandomWeighted= compile preprocessFileLineNumbers "ca\modules\functions\arrays\fn_selectRandomWeighted.sqf";


/* ****************** */
/* * Other Compiles * */
/* ****************** */
dayz_losChance = {
	private["_agent","_maxDis","_dis","_val","_maxExp","_myExp"];
	_agent = 	_this select 0;
	_dis =		_this select 1;
	_maxDis = 	_this select 2;
	// diag_log ("VAL:  " + str(_this));
	_val = 		(_maxDis - _dis) max 0;
	_maxExp = 	((exp 2) * _maxDis);
	_myExp = 	((exp 2) * (_val)) / _maxExp;
	_myExp = _myExp * 0.7;
	_myExp
};

[] call dz_loot_init;

rzr_shuffleArray = {
	private ["_ar","_rand_array","_rand"];
	_ar = _this;
	_rand_array = [];
	while {count _ar > 0} do {
		_rand = floor (random (count _ar));
		_rand_array set [count _rand_array, _ar select _rand];
		_ar set [_rand, "randarray_del"];
		_ar = _ar - ["randarray_del"];
	};
	_rand_array
};

dayz_losCheck = {
	private["_target","_agent","_cantSee"];
	_target = _this select 0; // PUT THE PLAYER IN FIRST ARGUMENT!!!!
	_agent = _this select 1;
	_cantSee = true;
	if (!isNull _target) then {
	
		_tPos = visiblePositionASL _target;
		_zPos = visiblePositionASL _agent;

		_tPos set [2,(_tPos select 2)+1];
		_zPos set [2,(_zPos select 2)+1];

		if ((count _tPos > 0) && (count _zPos > 0)) then {
			_cantSee = terrainIntersectASL [_tPos, _zPos];
			if (!_cantSee) then {
				_cantSee = lineIntersects [_tPos, _zPos, _agent, vehicle _target];
			};
		};
	};
	_cantSee
};

mm_hcFSM = [] execFSM "headlessclient\fsm\core.fsm";

if (!isNil "mm_hcFSM") then {
	if (finite mm_hcFSM) then {
		diag_log format ["Successfully initialized HC Monitor"];
	} else {
		diag_log format ["Failed to Initialize HC Monitor"];
	};
} else {
	diag_log format ["Failed to Initialize HC Monitor"];
};
