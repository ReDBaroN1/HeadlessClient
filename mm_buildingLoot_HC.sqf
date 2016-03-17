/*
 * File: mm_buildingLoot_HC.sqf
 * Author: R4Z0R49
 * Distributors: [VB]AWOL, Martin McCormack
 *
 * Description: Initialize Loot Spawn for Buildings
 *
*/
/*
        Created exclusively for ArmA2:OA - DayZMod
        Please request permission to use/alter/distribute from project leader (R4Z0R49)
		Modified for DayZ Epoch by [VB]AWOL vbawol@veteranbastards.com.
*/
private ["_skipAll","_skipBig","_skipSmal","_config","_lootChance","_positions","_positionsSmall","_lootSpawnBias","_bias","_rnd","_iPos","_nearBy","_index","_weights","_itemType"];

//If there is to much Loot around no need to go trough all this again, or?
if (dayz_currentWeaponHolders >= dayz_maxWeaponHolders) exitWith {
	//diag_log format ["[%1] - To much Loot around (%2)",time,dayz_currentWeaponHolders];
};

{
	_skipAll = false;
	_skipBig = false;
	_skipSmal = false;

	_config = mm_cfgFile >> "CfgBuildingLoot" >> toLower(typeOf _x);
	
	if (!isClass _config) then {diag_log format ["[%1] Skipping Spawn for %2 because no class was found (%3)",time,_x,__FILE__];_skipAll = true;};
	
	scopeName "skip";
	
	if (!_skipAll) then {

		_lootChance = getNumber (_config >> "lootChance");
		_positions = (getArray (_config >> "lootPos")) call rzr_shuffleArray;
		_positionsSmall = (getArray (_config >> "lootPosSmall")) call rzr_shuffleArray;
		
		//Validate
		if (!finite _lootChance) then {diag_log format ["[%1] Skipping Spawn for %2 because loot Chance invalid (%3)",time,_x,__FILE__];_skipAll = true;breakTo "skip";};
		if (count _positions <= 0) then {diag_log format ["[%1] Not spawning big Loot for %2 because positions invalid (%3)",time,_x,__FILE__];_skipBig = true;};
		if (count _positionsSmall <= 0) then {diag_log format ["[%1] Not spawning smal Loot for %2 because positions invalid (%3)",time,_x,__FILE__];_skipSmal = true;};
		
		_lootSpawnBias = 67;
		_bias = 50 max _lootSpawnBias;
		_bias = 100 min _bias;
		_bias = (_bias + random(100 - _bias)) / 100;
		
		if (!_skipBig) then {
			for "_y" from 0 to (count _positions)-1 step 1 do {
				
				/* The only way this happens is, if somebody messed up the loot config Files ;) */
				if (count (_positions select _y) != 3) exitWith {diag_log format ["[%1] - ERROR: Invalid Position for Building %2, Selection %3 (%4)",time,_x,_positions select _y,__FILE__];};

				_rnd = (random 1) / _bias;
				_iPos = _x modelToWorld (_positions select _y);
				_nearBy = nearestObjects [_iPos, ["ReammoBox"], 2];

				if (_rnd <= _lootChance && count _nearBy == 0) then {
					_index = dayz_CBLBase find (toLower(typeOf _x));
					_weights = dayz_CBLChances select _index;
					_cntWeights = count _weights;
					_index = floor(random _cntWeights);
					_index = _weights select _index;
					_itemType = (getArray (_config >> "lootType")) select _index;
					[_itemType select 0, _itemType select 1 , _iPos, 0.0] call dz_spawn_loot;
					dayz_currentWeaponHolders = dayz_currentWeaponHolders +1;
					_x setVariable ["looted",diag_tickTime];
				};

			}; /* For */

		};  /* SkipBig */

		if (!_skipSmal) then {
			for "_y" from 0 to (count _positionsSmall)-1 step 1 do {
				
				/* The only way this happens is, if somebody messed up the loot config Files ;) */
				if (count (_positionsSmall select _y) != 3) exitWith {diag_log format ["[%1] - ERROR: Invalid Position for Building %2, Selection %3 (%4)",time,_x,_positions select _y,__FILE__];};
				
				_rnd = (random 1) / _bias;
				_iPos = _x modelToWorld (_positionsSmall select _y);
				_nearBy = nearestObjects [_iPos, ["ReammoBox"], 2];
				
				if (_rnd <= _lootChance && count _nearBy == 0) then {
					_index = dayzE_CBLSBase find (toLower(typeOf _x));
					_weights = dayzE_CBLSChances select _index;
					_cntWeights = count _weights;
					_index = floor(random _cntWeights);
					_index = _weights select _index;
					_itemType = (getArray (_config >> "lootTypeSmall")) select _index;
					[_itemType select 0, _itemType select 1, _iPos, 0.0] call dz_spawn_loot_small;
					dayz_currentWeaponHolders = dayz_currentWeaponHolders +1;
					_x setVariable ["looted",diag_tickTime];
				};
			
			}; /* For */
			
		}; /* SkipSmal */
		
	}; /* SkipAll */

} count mm_buildings > 0;
