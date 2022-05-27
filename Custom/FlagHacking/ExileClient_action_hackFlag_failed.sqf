if ((random 1) < (getNumber(missionConfigFile >> "CfgFlagHacking" >> "removeChance") / 100)) then 
{
	[player, "Exile_Item_Laptop"] call ExileClient_util_playerCargo_remove;
};
player setVariable ["ExileIsHacking", false, true];
["updateFlagHackAttemptRequest", [netId _this]] call ExileClient_system_network_send;
["ErrorTitleOnly", ["Hacking failed!"]] call ExileClient_gui_toaster_addTemplateToast;