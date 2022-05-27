/**
 * ExileClient_action_grindLock_duration
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 * Grinding Rebalance by AeoG - El'Rabito. 
 */
 
private["_door", "_startTime", "_fullTime", "_Wbntg", "_Mbntg", "_Cbntg"];
_door = _this;
_fullTime = "";
_Wbntg = getArray(missionConfigFile >> "CfgGrinding" >> "GrindWoodTypes");
_Mbntg = getArray(missionConfigFile >> "CfgGrinding" >> "GrindMetalTypes");
_Cbntg = getArray(missionConfigFile >> "CfgGrinding" >> "GrindConcreteypes");
_startTime = _door getVariable ["ExileGrindTime", 0];

if ((typeOf _door) in _Wbntg) then
{
	_fullTime = getNumber(missionConfigFile >> "CfgGrinding" >> "grindDurationWood");
};
if ((typeOf _door) in _Mbntg) then
{
	_fullTime = getNumber(missionConfigFile >> "CfgGrinding" >> "grindDurationMetal");
};
if ((typeOf _door) in _Cbntg) then
{
	_fullTime = getNumber(missionConfigFile >> "CfgGrinding" >> "grindDurationConcrete");
};
	
(_fullTime * 60) - _startTime