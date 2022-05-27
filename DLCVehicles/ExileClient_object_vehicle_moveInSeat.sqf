/**
 * ExileClient_object_vehicle_moveInSeat
 *
 * FriendlyPlayerShooting
 * www.friendlyplayershooting.com
 * © 2019 FriendlyPlayerShooting Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */

private["_seatToGetIn", "_vehicle"];
_seatToGetIn = _this select 0;
_vehicle = ExileClientInteractionObject;

switch (_seatToGetIn) do 
{
	case "Driver":
	{
		player assignAsDriver _vehicle;
		player moveInDriver _vehicle;
	};
	case "Gunner":
	{
		player assignAsGunner _vehicle;
		player moveInGunner _vehicle;
	};
	case "Commander":
	{
		player assignAsCommander _vehicle;
		player moveInCommander _vehicle;
	};
	default
	{
		player assignAsDriver _vehicle;
		player moveInDriver _vehicle;
	};
};