/*  
	Parachute from ExAd.. Modified by [FPS]kuplion
*/

if (vehicle player == player) exitWith {false};

_condition = false;
if ((getPos player) select 2 > ExAd_ACTION_EJECT_HEIGHT) then
{
	_role = assignedVehicleRole player;
	_condition = if (count _role > 0) then
	{
		if (_role select 0 == "cargo") then
		{
			false
		}
		else
		{
			true
		};
	}
	else
	{
		true
	};
};

_condition