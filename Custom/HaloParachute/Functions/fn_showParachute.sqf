/*  
	Parachute from ExAd.. Modified by [FPS]kuplion
*/

if (vehicle player != player) exitWith {false};

if (backpack player == "B_Parachute") exitWith {false};

_condition = false;

if ((getPos player) select 2 > ExAd_ACTION_PARACHUTE_HEIGHT) then
{
	_states =
	[
		"ladderriflestatic",
		"ladderrifledownloop",
		"ladderrifleuploop",
		"laddercivilstatic",
		"laddercivildownloop",
		"ladderciviluploop"
	];
	_condition = !((animationState player) in _states);
};

_condition