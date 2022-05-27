/**
 * ExileClient_object_vehicle_getInteractionName
 *
 * FriendlyPlayerShooting
 * www.friendlyplayershooting.com
 * © 2019 FriendlyPlayerShooting Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */

private["_seatToGetIn", "_vehicle", "_type", "_config", "_displayVehicle", "_displayMessage"];
_seatToGetIn = _this select 0;
_vehicle = ExileClientInteractionObject;
_type = (typeOf (vehicle _vehicle));
_config  = (configFile >>  "CfgVehicles" >>  _type);
_displayVehicle = if (isText(_config >> "displayName")) then {getText(_config >> "displayName")};
_displayMessage = format["Get in %1 as %2", _displayVehicle, _seatToGetIn];
_displayMessage