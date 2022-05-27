/**
 * ExileServer_object_lock_network_setPin
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_sessionID", "_parameters", "_object", "_pincode", "_newPinCode", "_objectPinCode", "_databaseID", "_couldChangePin", "_flag", "_lastAttackedAt", "_constructionBlockDuration"];
_sessionID = _this select 0;
_parameters = _this select 1;
_object = objectFromNetId (_parameters select 0);
_pincode = _parameters select 1;
_newPinCode = _parameters select 2;
_objectPinCode = _object getVariable ["ExileAccessCode", "000000"];
_databaseID = _object getVariable ["ExileDatabaseID",0];
_couldChangePin = true;

_flag = _object call ExileClient_util_world_getTerritoryAtPosition;
if !(isNull _flag) then
{
	_lastAttackedAt = _flag getVariable ["ExileLastAttackAt", false];
	if !(_lastAttackedAt isEqualTo false) then 
	{
		_constructionBlockDuration = getNumber (missionConfigFile >> "CfgTerritories" >> "constructionBlockDuration");
		if (time - _lastAttackedAt < _constructionBlockDuration * 60) then
		{
			_couldChangePin = false;			
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Pin change failed!", format ["Territory has been under attack within the last %1 minutes.!", _constructionBlockDuration]]]] call ExileServer_system_network_send_to;
		};
	};
};

if(_couldChangePin) then 
{

	if(_pincode isEqualTo _objectPinCode)then
	{
		if (_object isKindOf "Exile_Construction_Abstract_Static") then
		{
			format ["addDoorLock:%1:%2",_newPinCode,_databaseID] call ExileServer_system_database_query_fireAndForget;
		}
		else
		{
			[_object,_newPinCode] call ExileServer_object_container_database_setpin;
		};
		
		_object setVariable ["ExileAccessCode",_newPinCode];
		[_sessionID, "setPinResponse", [["SuccessTitleOnly", ["PIN changed successfully!"]], netId _object, _newPinCode]] call ExileServer_system_network_send_to;
	}
	else
	{
		[_sessionID, "setPinResponse", [["ErrorTitleAndText", ["Wrong PIN!", "Please try again."]], "", ""]] call ExileServer_system_network_send_to;
	};
	
};
true
