/**
 * ExileClient_action_grindLock_condition
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 *
 * Grinding Rebalance by AeoG - El'Rabito. 
 */
 
private["_door", "_result", "_grinderUID", "_requiredamount", "_Wbntg", "_Mbntg", "_Cbntg", "_fppgo"];
_door = _this;
_result = "";
_requiredamount = "";
_Wbntg = getArray(missionConfigFile >> "CfgGrinding" >> "GrindWoodTypes");
_Mbntg = getArray(missionConfigFile >> "CfgGrinding" >> "GrindMetalTypes");
_Cbntg = getArray(missionConfigFile >> "CfgGrinding" >> "GrindConcreteypes");
_fppgo = getNumber(missionConfigFile >> "CfgGrinding" >> "FPGrindingOnly");
try 
{
	switch (locked _door) do 
	{
		case 0:	{ throw "The door is not locked!"; };
		case 1:	{ throw "The door does not have a lock!"; };
	};
	if ((_door animationPhase 'DoorRotation') > 0.5) then 
	{
		throw "Please close the door first.";
	};
	if !("Exile_Item_Grinder" in (magazines player)) then
	{
		throw "You need a grinder!";
	};
	if ((_fppgo == 1) && (cameraView isEqualTo "INTERNAL"))then
	{
		player switchCamera "EXTERNAL";
		["ErrorTitleAndText", ["You can't grind in first person!"]] call ExileClient_gui_toaster_addTemplateToast;
	};
	if !("Exile_Magazine_Battery" in (magazines player)) then
	{
		throw "You need a battery!";
	};
	if ((_door distance player) > 7) then 
	{
		throw "You are too far away!";
	};
	if ((typeOf _door) in _Wbntg) then
	{
		_requiredamount = getNumber(missionConfigFile >> "CfgGrinding" >> "BatteryAmountRequiredWood");
	};
	if ((typeOf _door) in _Mbntg) then
	{
		_requiredamount = getNumber(missionConfigFile >> "CfgGrinding" >> "BatteryAmountRequiredMetal");
	};
	if ((typeOf _door) in _Cbntg) then
	{
		_requiredamount = getNumber(missionConfigFile >> "CfgGrinding" >> "BatteryAmountRequiredConcrete");
	};
	_numberOfBatteries = {"Exile_Magazine_Battery" == _x} count (magazines player);
	if(_numberOfBatteries < _requiredamount) then
	{
		["ErrorTitleAndText",["Grind Info", format ["You need %1 x Battery to grind this!", _requiredamount]]] call ExileClient_gui_toaster_addTemplateToast;
		throw "You don't have enough batteries!";
	};
	_grinderUID = _door getVariable ["ExileGrinderUID", ""];
	if (!(_grinderUID isEqualTo "") && {!(_grinderUID isEqualTo (getPlayerUID player))}) then
	{
		throw "Another grind is in progress.";
	};	
	// Prevent Low Level Raiding
	_saveTheBambis = getNumber (missionConfigFile >> "CfgSaveTheBambis" >> "enabled");
	_protectionMessage = getText (missionConfigFile >> "CfgSaveTheBambis" >> "protectionMessage");
	_noMoreProtectionNow = getNumber (missionConfigFile >> "CfgSaveTheBambis" >> "stopProtectionLevel");
	_territory = _door call ExileClient_util_world_getTerritoryAtPosition;
	if !(isNull _territory) then
	{
		if ((_saveTheBambis > 0) && (_territory getVariable ["ExileTerritoryLevel", 1]) < _noMoreProtectionNow) then
		{
			throw _protectionMessage;
		};
	};
	_door setVariable ["ExileGrindStartTime", diag_tickTime];
	if (_grinderUID isEqualTo "") then 
	{
		["grindNotificationRequest", [netId _this]] call ExileClient_system_network_send;
	};	
}
catch 
{
	_result = _exception;
};
_result