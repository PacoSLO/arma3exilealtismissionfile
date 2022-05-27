private["_flag", "_result", "_maxHackAttempts", "_hackAttempts", "_concurrentHacks", "_hackerUID"];
_flag = _this;
_result = "";
try 
{
	if (ExilePlayerInSafezone) then
	{
		throw "You are in a safe zone!";
	};
	if !("Exile_Item_Laptop" in (magazines player)) then
	{
		throw "You need a laptop!";
	};
	if ((_flag distance player) > 7) then 
	{
		throw "You are too far away!";
	};
	_maxHackAttempts = getNumber (missionConfigFile >> 'CfgFlagHacking' >> 'maxHackAttempts'); 
	_hackAttempts = _flag getVariable ["ExileHackAttempts", -1];
	if (_hackAttempts > _maxHackAttempts) then
	{
		throw "Max hack attempts reached."
	};
	if (count(allPlayers) < (getNumber(missionConfigFile >> "CfgFlagHacking" >> "minPlayers"))) then 
	{
		throw "There aren't enough players on the server to hack right now";
	};
	_concurrentHacks = {_x getVariable ["ExileIsHacking", false]} count allPlayers;
	if (_concurrentHacks >= (getNumber(missionConfigFile >> "CfgFlagHacking" >> "maxHacks"))) then 
	{
		throw "Max hacks in progress";	
	};
	if(count (_flag getVariable ["ExileTerritoryStoredVehicles", []]) <= 0) then 
	{
		throw "There are no more vehicles in the garage!";
	};
	_hackerUID = _flag getVariable ["ExileHackerUID", ""];
	if (!(_hackerUID isEqualTo "") && {!(_hackerUID isEqualTo (getPlayerUID player))}) then
	{
		throw "This flag is already being hacked";
	};
	player setVariable ["ExileIsHacking", true, true];
	if (_hackerUID isEqualTo "") then 
	{
		["startFlagHackRequest", [netId _this]] call ExileClient_system_network_send;
	};
}
catch 
{
	_result = _exception;
};
_result