/**
 * ExileClient_object_lock_toggle
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_condition", "_object", "_known", "_pincode"];
_condition = _this;
_object = ExileClientInteractionObject;
if(ExileLockIsShown)exitWith{};
ExileLockIsShown = true;
_known = _object getVariable ["ExileAlreadyKnownCode",""];
private _playerUID = getPlayerUID player;
private _flag = player call ExileClient_util_world_getTerritoryAtPosition;
private _territoryModerators = _flag getVariable ["ExileTerritoryModerators", []];
if ((_playerUID in _territoryModerators) && {!ExileClientPlayerIsInCombat} && {_object isKindOf "Exile_Construction_Abstract_Static" || {_object isKindOf "Exile_Container_Abstract"}}) then
{
	["lockToggle", [netId _object, "Moderator", _condition]] call ExileClient_system_network_send;
}
else
{
	if ((_known isEqualTo "") || ExileClientPlayerIsInCombat) then
	{
		_pincode = 4 call ExileClient_gui_keypadDialog_show;
	}
	else
	{
		_pincode = _known;
	};
	if !(_pincode isEqualTo "") then
	{
		["lockToggle", [netId _object, _pincode, _condition]] call ExileClient_system_network_send;
	};
};
call ExileClient_gui_interactionMenu_unhook;
ExileLockIsShown = false;
true
