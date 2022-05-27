/**
 * ExileClient_object_vehicle_checkForDLCAndSeat
 *
 * FriendlyPlayerShooting
 * www.friendlyplayershooting.com
 * © 2019 FriendlyPlayerShooting Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */

private["_seatToGetIn", "_vehicle", "_ownedDLCs", "_vehicleDLC", "_canGetIn"];
_seatToGetIn = _this select 0;
_vehicle = ExileClientInteractionObject;
_ownedDLCs = getDLCs 1;
_vehicleDLC = getObjectDLC _vehicle;
_canGetIn = true;

try
{
	if !(alive _vehicle) throw false;
	if (isNil "_vehicleDLC") throw false;
	if (_vehicleDLC in _ownedDLCs) throw false;
	
	switch (_seatToGetIn) do 
	{
		case "Driver":
		{
			if !(isNull Driver _vehicle) throw false;
			if !(_vehicle emptyPositions "Driver" > 0) throw false;
		};
		case "Gunner":
		{
			if !(isNull Gunner _vehicle) throw false;
			if !(_vehicle emptyPositions "Gunner" > 0) throw false;
		};
		case "Commander":
		{
			if !(isNull Commander _vehicle) throw false;
			if !(_vehicle emptyPositions "Commander" > 0) throw false;
		};
		default
		{
			if !(isNull Driver _vehicle) throw false;
			if !(_vehicle emptyPositions "Driver" > 0) throw false;
		};
	};
}
catch
{
	_canGetIn = _exception;
};
_canGetIn