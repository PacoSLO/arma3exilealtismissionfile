/*  
	Parachute from ExAd.. Modified by [FPS]kuplion
*/

private ["_vehicleObj", "_push", "_vecDir"];

_vehicleObj = vehicle player;
if (_vehicleObj == player) exitWith {false};

moveOut player;

_push = if (_vehicleObj isKindOf "Plane") then
{
	player setDir getDir _vehicleObj;
	((vectorUp _vehicleObj) vectorMultiply 40)
}
else
{
	_vecDir = (getPosASL player) vectorDiff (getPosASL _vehicleObj);
	(_vecDir vectorMultiply (5 / vectorMagnitude _vecDir))
};

player setVelocity ((velocity player) vectorAdd _push);

if (ExAd_HALOPARACHUTE_SAFE_MODE) then
{
	ExAd_PARACHUTE_SAFE_THREAD = [0.1, ExAd_fnc_parachuteSafeMode, [], true] call ExileClient_system_thread_addtask;
};

true