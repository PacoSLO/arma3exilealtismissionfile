/*  
	Parachute from ExAd.. Modified by [FPS]kuplion
*/

private ["_parachuteObject"];

waitUntil {sleep 0.1; ({player distance _x < (10 max (sizeOf typeOf _x))} count (player nearEntities ["Air", 20])) == 0};

if (!alive player || vehicle player != player) exitWith {};

if (backpack player == "B_Parachute") then
{
	removeBackpack player;
};

_parachuteObject = createVehicle ["Steerable_Parachute_F", getPosATL player, [], 0, "CAN_COLLIDE"];
_parachuteObject setDir getDir player;

_parachuteObject disableCollisionWith player;

player action ["GetinDriver", _parachuteObject];
player switchmove "";
player switchmove "HaloFreeFall_non"; 
player setVelocity [(sin (getDir player)) * 50, (cos (getDir player)) * 50, -5];
ExileJobParachuteFix = [0.25, ExileClient_object_player_parachuteFix, [], true] call ExileClient_system_thread_addtask;

if (ExAd_HALOPARACHUTE_SAFE_MODE) then
{
	[ExAd_PARACHUTE_SAFE_THREAD] call ExileClient_system_thread_removeTask;
};

if (ExAd_HALOPARACHUTE_USE_KEY_ACTIONS) then
{
	["Alt+Shift+V to Eject from Parachute!"] spawn ExileClient_gui_baguette_show;
};

true