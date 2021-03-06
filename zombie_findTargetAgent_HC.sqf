/*
 * File: zombie_findTargetAgent_HC.sqf
 * Author: DayZ
 * Distributors : Martin McCormack
 *
 * Description: Find a Target for given Zombie 
 *
*/

private ["_agent","_target","_targets","_targetDis","_man","_manDis","_range","_objects","_refobj"];
_agent = _this;
_target = objNull;

_targets = [];
_targetDis = [];
_range = 120;
_manDis = 0;

_targets = _agent getVariable ["targets",[]];

if (isNil "_targets") exitWith {};
//Search for objects
if (count _targets == 0) then
{
	_objects = nearestObjects [_agent,["ThrownObjects","GrenadeHandTimedWest","SmokeShell"],50];
	{
		private["_dis"];
		if (!(_x in _targets)) then
		{
			_targets set [count _targets,_x];
			_targetDis set [count _targetDis,_dis];
		};
	} count _objects;
};

//Find best target
if (count _targets > 0) then
{
	_man = _targets select 0;
	_manDis = _man distance _agent;
	{
		private["_dis"];
		_dis =  _x distance _agent;
		if (_dis < _manDis) then
		{
			_man = _x;
			_manDis = _dis;
		};
		if (_dis > _range) then
		{
			_targets = _targets - [_x];
		};
		if (_x isKindOf "SmokeShell") then
		{
			_man = _x;
			_manDis = _dis;
		};
	} count _targets;

	_target = _man;
};

//Check if too far
if (_manDis > _range) then
{
	_targets = _targets - [_target];
	_target = objNull;
};

_target
