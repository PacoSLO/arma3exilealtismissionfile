/*  
	Parachute from ExAd.. Modified by [FPS]kuplion
*/

ExAd_HALOPARACHUTE_SAFE_MODE = false;		//BOOLEAN - Force pull parachute when player reaches ExAd_ACTION_PARACHUTE_HEIGHT if they ejected from vehicle
ExAd_HALOPARACHUTE_USE_ACTIONS = true;		//BOOLEAN - Show addActions on the screen
ExAd_HALOPARACHUTE_USE_KEY_ACTIONS = true;	//BOOLEAN - Allows player to eject from all vehicles with a pressed key combination 'Alt+Shift+V'
ExAd_ACTION_PARACHUTE_HEIGHT = 10; 			//SCALAR - What is the minimum altitude a player can pull a parachute. | RECOMMENDED 30 meters when safe_mode activated
ExAd_ACTION_EJECT_HEIGHT = 100; 			//SCALAR - What is the minimum altitude a player can Halo/Eject from a vehicle.

// Compile all the things!!
{
    _code = "";
    _function = _x select 0;
    _file = _x select 1;
    _code = compileFinal (preprocessFileLineNumbers _file);
	missionNamespace setVariable [_function, _code];
} 
forEach
[
	['ExAd_fnc_showEject','Custom\HaloParachute\Functions\fn_showEject.sqf'],
	['ExAd_fnc_ejectPlayer','Custom\HaloParachute\Functions\fn_ejectPlayer.sqf'],
	['ExAd_fnc_parachuteSafeMode','Custom\HaloParachute\Functions\fn_parachuteSafeMode.sqf'],
	['ExAd_fnc_pullParachute','Custom\HaloParachute\Functions\fn_pullParachute.sqf'],
	['ExAd_fnc_showParachute','Custom\HaloParachute\Functions\fn_showParachute.sqf'],
	['ExAd_Parachute_Thread', 'Custom\HaloParachute\parachuteThread.sqf']
];

// Create the Parachute Thread..
[1, ExAd_Parachute_Thread, [], true] call ExileClient_system_thread_addtask;