// Vihacle salwage
SV_fnc_SalvageVehicle = compileFinal preprocessFileLineNumbers "Custom\SalvageVehicle\SalvageVehicle.sqf";
//BASE RANSOM NOTIFICATION
execVM "announcepay.sqf";
///////////////////////////////////////////////////////////////////////////////
// Static Objects
///////////////////////////////////////////////////////////////////////////////

// Taken away for now
//#include "initServer.sqf"

if (!hasInterface || isServer) exitWith {};

//LOADOUTS
ExileClientPlayerLoadoutServerName = getText(missionConfigFile >> "CfgLoadout" >> "Settings" >> "ServerName");
ExileClientPlayerLoadoutMax = getNumber(missionConfigFile >> "CfgLoadout" >> "Settings" >> "MaxLoadouts");
ExileClientPlayerLoadoutNumber = 1;

private ['_code', '_function', '_file'];
{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;
    _code = compileFinal (preprocessFileLineNumbers _file);
    missionNamespace setVariable [_function, _code];
}
forEach
[
	//Loadouts
	['ExileClient_gui_loadoutDialog_calculateLoadoutPrice', 'Custom\loadouts\ExileClient_gui_loadoutDialog_calculateLoadoutPrice.sqf'],
	['ExileClient_gui_loadoutDialog_canAddLoadoutItem', 'Custom\loadouts\ExileClient_gui_loadoutDialog_canAddLoadoutItem.sqf'],
	['ExileClient_gui_loadoutDialog_containerCargo_list', 'Custom\loadouts\ExileClient_gui_loadoutDialog_containerCargo_list.sqf'],
	['ExileClient_gui_loadoutDialog_event_checkLoadout', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_checkLoadout.sqf'],
	['ExileClient_gui_loadoutDialog_event_onAddLoadoutButtonClick', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onAddLoadoutButtonClick.sqf'],
	['ExileClient_gui_loadoutDialog_event_onApplyLoadoutButtonClick', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onApplyLoadoutButtonClick.sqf'],
	['ExileClient_gui_loadoutDialog_event_onBuyLoadoutButtonClick', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onBuyLoadoutButtonClick.sqf'],
	['ExileClient_gui_loadoutDialog_event_onClearLoadoutButtonClick', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onClearLoadoutButtonClick.sqf'],
	['ExileClient_gui_loadoutDialog_event_onInventoryListBoxSelectionChanged', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onInventoryListBoxSelectionChanged.sqf'],
	['ExileClient_gui_loadoutDialog_event_onPlayerInventoryDropDownSelectionChanged', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onPlayerInventoryDropDownSelectionChanged.sqf'],
	['ExileClient_gui_loadoutDialog_event_onLoudoutDropDownSelectionChanged', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onLoudoutDropDownSelectionChanged.sqf'],
	['ExileClient_gui_loadoutDialog_event_onUnload', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onUnload.sqf'],
	['ExileClient_gui_loadoutDialog_event_onWarningCheckboxStateChanged', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_onWarningCheckboxStateChanged.sqf'],
	['ExileClient_gui_loadoutDialog_event_save', 'Custom\loadouts\ExileClient_gui_loadoutDialog_event_save.sqf'],
	['ExileClient_gui_loadoutDialog_getItemCapacity', 'Custom\loadouts\ExileClient_gui_loadoutDialog_getItemCapacity.sqf'],
	['ExileClient_gui_loadoutDialog_getItemMass', 'Custom\loadouts\ExileClient_gui_loadoutDialog_getItemMass.sqf'],
	['ExileClient_gui_loadoutDialog_removeLoadoutItem', 'Custom\loadouts\ExileClient_gui_loadoutDialog_removeLoadoutItem.sqf'],
	['ExileClient_gui_loadoutDialog_removeLoadoutListboxItem', 'Custom\loadouts\ExileClient_gui_loadoutDialog_removeLoadoutListboxItem.sqf'],
	['ExileClient_gui_loadoutDialog_show', 'Custom\loadouts\ExileClient_gui_loadoutDialog_show.sqf'],
	['ExileClient_gui_loadoutDialog_updateInventoryDropdown', 'Custom\loadouts\ExileClient_gui_loadoutDialog_updateInventoryDropdown.sqf'],
	['ExileClient_gui_loadoutDialog_updateInventoryListBox', 'Custom\loadouts\ExileClient_gui_loadoutDialog_updateInventoryListBox.sqf'],
	['ExileClient_gui_loadoutDialog_updateLoadoutDropdown', 'Custom\loadouts\ExileClient_gui_loadoutDialog_updateLoadoutDropdown.sqf'],
	['ExileClient_gui_loadoutDialog_updateLoadoutInterface', 'Custom\loadouts\ExileClient_gui_loadoutDialog_updateLoadoutInterface.sqf'],
	['ExileClient_gui_loadoutDialog_updateLoadoutListBox', 'Custom\loadouts\ExileClient_gui_loadoutDialog_updateLoadoutListBox.sqf'],
	['ExileClient_gui_loadoutDialog_updatePriceInterface', 'Custom\loadouts\ExileClient_gui_loadoutDialog_updatePriceInterface.sqf'],
	['ExileClient_system_trading_network_purchaseLoadoutResponse', 'Custom\loadouts\ExileClient_system_trading_network_purchaseLoadoutResponse.sqf'],
	['ExileClient_util_addCommas', 'Custom\loadouts\ExileClient_util_addCommas.sqf']
];

//No peaking
client_lowKneelAnimations = "getText(_x >> 'actions') in ['RifleAdjustBKneelActions', 'PistolAdjustBKneelActions'] && getNumber(_x >> 'looped') == 1" configClasses (configFile >> "CfgMovesMaleSdr" >> "States") apply {toLower configName _x};
client_toLowKneelAnimations = [];
{_anim = _x; client_toLowKneelAnimations append ("_anim in (getArray(_x >> 'connectTo') select {_x isEqualType ''} apply {toLower _x})" configClasses (configFile >> "CfgMovesMaleSdr" >> "States") apply {toLower configName _x})} forEach client_lowKneelAnimations;
client_inLowKneel = false;

//FLAG HACKING

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _code = compileFinal (preprocessFileLineNumbers _file);

    missionNamespace setVariable [_function, _code];
}
forEach
[
	['ExileClient_action_hackFlag_aborted','Custom\FlagHacking\ExileClient_action_hackFlag_aborted.sqf'],
	['ExileClient_action_hackFlag_completed','Custom\FlagHacking\ExileClient_action_hackFlag_completed.sqf'],
	['ExileClient_action_hackFlag_condition','Custom\FlagHacking\ExileClient_action_hackFlag_condition.sqf'],
	['ExileClient_action_hackFlag_duration','Custom\FlagHacking\ExileClient_action_hackFlag_duration.sqf'],
	['ExileClient_action_hackFlag_failChance','Custom\FlagHacking\ExileClient_action_hackFlag_failChance.sqf'],
	['ExileClient_action_hackFlag_failed','Custom\FlagHacking\ExileClient_action_hackFlag_failed.sqf']
];

//CLAIM WORLD VEHICLES
private ['_code', '_function', '_file'];
{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _code = compileFinal (preprocessFileLineNumbers _file);

    missionNamespace setVariable [_function, _code];
}
forEach
[
    ['ExileClient_ClaimVehicles_network_claimRequestSend','ClaimVehicles_Client\functions\ExileClient_ClaimVehicles_network_claimRequestSend.sqf']
];

//XM8 ALLWAY ON
missionNamespace setVariable ["ExileClientXM8IsPowerOn",true];
player setVariable ["ExileXM8IsOnline",true];
profileNamespace setVariable ["ExileEnable8GNetwork",true];

// Compile all the things NO DLC VEHICLES
{
    _code = "";
    _function = _x select 0;
    _file = _x select 1;
    _code = compileFinal (preprocessFileLineNumbers _file);
	missionNamespace setVariable [_function, _code];
}
forEach
[
    // Get In DLC Vehicles
	["ExileClient_object_vehicle_getInteractionName", "DLCVehicles\ExileClient_object_vehicle_getInteractionName.sqf"],
	["ExileClient_object_vehicle_moveInSeat", "DLCVehicles\ExileClient_object_vehicle_moveInSeat.sqf"],
	["ExileClient_object_vehicle_checkForDLCAndSeat", "DLCVehicles\ExileClient_object_vehicle_checkForDLCAndSeat.sqf"]
];

///////////////////////////////////////////////////////////////////////////
// Hardware Trader
///////////////////////////////////////////////////////////////////////////
_workBench = "Land_Workbench_01_F" createVehicleLocal [0,0,0];
_workBench setDir 45.4546;
_workBench setPosATL [14587.8, 16758.7, 0.0938587];

_trader = 
[
    "Exile_Trader_Hardware",
    "Exile_Trader_Hardware",
    "WhiteHead_17",
    ["InBaseMoves_sitHighUp1"],
    [0, 0, -0.5],
    170,
    _workBench
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Fast Food Trader
///////////////////////////////////////////////////////////////////////////
_cashDesk = "Land_CashDesk_F" createVehicleLocal [0,0,0];
_cashDesk setDir 131.818;
_cashDesk setPosATL [14589.8, 16778.2, -0.0701294];

_microwave = "Land_Microwave_01_F" createVehicleLocal [0,0,0];
_cashDesk disableCollisionWith _microwave;         
_microwave disableCollisionWith _cashDesk; 
_microwave attachTo [_cashDesk, [-0.6, 0.2, 1.1]];

_ketchup = "Land_Ketchup_01_F" createVehicleLocal [0,0,0];
_cashDesk disableCollisionWith _ketchup;         
_ketchup disableCollisionWith _cashDesk; 
_ketchup attachTo [_cashDesk, [-0.6, 0, 1.1]];

_mustard = "Land_Mustard_01_F" createVehicleLocal [0,0,0];
_cashDesk disableCollisionWith _mustard;         
_mustard disableCollisionWith _cashDesk; 
_mustard attachTo [_cashDesk, [-0.5, -0.05, 1.1]];

_trader = 
[
    "Exile_Trader_Food",
    "Exile_Trader_Food",
    "GreekHead_A3_01",
    ["InBaseMoves_table1"],
    [0.1, 0.5, 0.2],
    170,
    _cashDesk
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Armory Trader
///////////////////////////////////////////////////////////////////////////
_chair = "Land_CampingChair_V2_F" createVehicleLocal [0,0,0];
_chair setDir 208.182;    
_chair setPosATL [14568.1, 16764.3, 0.084837];

_trader = 
[
    "Exile_Trader_Armory",
    "Exile_Trader_Armory",
    "PersianHead_A3_02",
    ["InBaseMoves_SittingRifle1"],
    [0, -0.15, -0.45],
    180,
    _chair
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Equipment Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_Equipment",
    "Exile_Trader_Equipment",
    "WhiteHead_19",
    ["InBaseMoves_Lean1"],
    [14571.5, 16759.1, 0.126438],
    0
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Specops Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_SpecialOperations",
    "Exile_Trader_SpecialOperations",
    "AfricanHead_02",
    ["HubStanding_idle1", "HubStanding_idle2", "HubStanding_idle3"],
    [14566.3, 16773.2, 0.126438],
    140
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Office Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_Office",
    "Exile_Trader_Office",
    "GreekHead_A3_04",
    ["HubBriefing_scratch", "HubBriefing_stretch", "HubBriefing_think", "HubBriefing_lookAround1", "HubBriefing_lookAround2"],
    [14599.6, 16774.6, 5.12644],
    220
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Waste Dump Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_WasteDump",
    "Exile_Trader_WasteDump",
    "GreekHead_A3_01",
    ["HubStandingUA_move1", "HubStandingUA_move2", "HubStandingUA_idle1", "HubStandingUA_idle2", "HubStandingUA_idle3"],
    [14608.4, 16901.3, 0],
    270
]
call ExileClient_object_trader_create;


///////////////////////////////////////////////////////////////////////////
// Aircraft Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_Aircraft",
    "Exile_Trader_Aircraft",
    "WhiteHead_17",
    ["LHD_krajPaluby"],
    [14596.5, 16752.9, 0.12644],
    133
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Aircraft Customs Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_AircraftCustoms",
    "Exile_Trader_AircraftCustoms",
    "GreekHead_A3_07",
    ["HubStandingUC_idle1", "HubStandingUC_idle2", "HubStandingUC_idle3", "HubStandingUC_move1", "HubStandingUC_move2"],
    [14635, 16790.3, 0],
    156.294
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Vehicle Trader
///////////////////////////////////////////////////////////////////////////

_trader = 
[
    "Exile_Trader_Vehicle",
    "Exile_Trader_Vehicle",
    "WhiteHead_11",
    ["InBaseMoves_repairVehicleKnl", "InBaseMoves_repairVehiclePne"],
    [14603.7, 16877.3, 0.00143433],
    90
]
call ExileClient_object_trader_create;

_carWreck = "Land_Wreck_CarDismantled_F" createVehicleLocal [0,0,0];
_carWreck setDir 355.455;
_carWreck setPosATL [14605.6, 16877.3, 0.0208359];

///////////////////////////////////////////////////////////////////////////
// Vehicle Customs Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_VehicleCustoms",
    "Exile_Trader_VehicleCustoms",
    "WhiteHead_11",
    ["AidlPercMstpSnonWnonDnon_G01", "AidlPercMstpSnonWnonDnon_G02", "AidlPercMstpSnonWnonDnon_G03", "AidlPercMstpSnonWnonDnon_G04", "AidlPercMstpSnonWnonDnon_G05", "AidlPercMstpSnonWnonDnon_G06"],
    [14617.2, 16888.4, 0],
    269.96
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Guard 01
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Guard_01",
    "",
    "WhiteHead_17",
    ["InBaseMoves_patrolling1"],
    [14564.9,16923.4,0.00146294],
    323.53
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Guard 02
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Guard_02",
    "",
    "WhiteHead_03",
    ["InBaseMoves_patrolling2"],
    [14626.3,16834.6,4.72644],
    326.455
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Guard 03
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Guard_03",
    "",
    "AfricanHead_03",
    ["InBaseMoves_patrolling1"],
    [14577.1,16793.1,3.75118],
    313.349
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Western Guard 01
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Guard_02",
    "",
    "WhiteHead_03",
    ["InBaseMoves_patrolling2"],
    [2950.52,18195.3,4.93399],
    179.092
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Western Boat Trader
///////////////////////////////////////////////////////////////////////////

_trader = 
[
    "Exile_Trader_Boat",
    "Exile_Trader_Boat",
    "WhiteHead_17",
    ["AidlPercMstpSnonWnonDnon_G01", "AidlPercMstpSnonWnonDnon_G02", "AidlPercMstpSnonWnonDnon_G03", "AidlPercMstpSnonWnonDnon_G04", "AidlPercMstpSnonWnonDnon_G05", "AidlPercMstpSnonWnonDnon_G06"],
    [2914.35,18192.9,8.51858],
    88.3346
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Western Vehicle Trader
///////////////////////////////////////////////////////////////////////////

_trader = 
[
    "Exile_Trader_Vehicle",
    "Exile_Trader_Vehicle",
    "WhiteHead_11",
    ["InBaseMoves_repairVehicleKnl", "InBaseMoves_repairVehiclePne"],
    [2980.19,18146.2,1.06391],
    222.352
]
call ExileClient_object_trader_create;

_carWreck = "Land_Wreck_CarDismantled_F" createVehicleLocal [0,0,0];
_carWreck setDir 130.966;    
_carWreck setPosATL [2978.76,18144.5,1.13293];

///////////////////////////////////////////////////////////////////////////
// Western Waste Dump Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_WasteDump",
    "Exile_Trader_WasteDump",
    "GreekHead_A3_01",
    ["HubStandingUA_move1", "HubStandingUA_move2", "HubStandingUA_idle1", "HubStandingUA_idle2", "HubStandingUA_idle3"],
    [2984.05,18133.4,0.00107765],
    29.3856
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Western Fast Food Trader
///////////////////////////////////////////////////////////////////////////

_trader = 
[
    "Exile_Trader_Food",
    "Exile_Trader_Food",
    "GreekHead_A3_01",
    ["AidlPercMstpSnonWnonDnon_G01", "AidlPercMstpSnonWnonDnon_G02", "AidlPercMstpSnonWnonDnon_G03", "AidlPercMstpSnonWnonDnon_G04", "AidlPercMstpSnonWnonDnon_G05", "AidlPercMstpSnonWnonDnon_G06"],
    [2979.87,18184.9,2.55185],
    89.2952
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Western Equipment Trader
///////////////////////////////////////////////////////////////////////////

_trader = 
[
    "Exile_Trader_Equipment",
    "Exile_Trader_Equipment",
    "WhiteHead_19",
    ["HubStanding_idle1", "HubStanding_idle2", "HubStanding_idle3"],
    [2980.7,18192.9,2.49853],
    130.535
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Western Armory Trader
///////////////////////////////////////////////////////////////////////////

_trader = 
[
    "Exile_Trader_Armory",
    "Exile_Trader_Armory",
    "PersianHead_A3_02",
    ["HubStanding_idle1", "HubStanding_idle2", "HubStanding_idle3"],
    [2986.43,18178.5,1.66267],
    296.855
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Western Guard 02
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Guard_03",
    "",
    "AfricanHead_03",
    ["InBaseMoves_patrolling1"],
    [2993.2,18167,0.353821],
    109.888
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Eastern Fast Food Trader
///////////////////////////////////////////////////////////////////////////
_cashDesk = "Land_CashDesk_F" createVehicleLocal [0,0,0];
_cashDesk setDir 222.727;
_cashDesk setPosATL [23353.1, 24168, 0.16585];

_microwave = "Land_Microwave_01_F" createVehicleLocal [0,0,0];
_cashDesk disableCollisionWith _microwave;         
_microwave disableCollisionWith _cashDesk; 
_microwave attachTo [_cashDesk, [-0.6, 0.2, 1.1]];

_ketchup = "Land_Ketchup_01_F" createVehicleLocal [0,0,0];
_cashDesk disableCollisionWith _ketchup;         
_ketchup disableCollisionWith _cashDesk; 
_ketchup attachTo [_cashDesk, [-0.6, 0, 1.1]];

_mustard = "Land_Mustard_01_F" createVehicleLocal [0,0,0];
_cashDesk disableCollisionWith _mustard;         
_mustard disableCollisionWith _cashDesk; 
_mustard attachTo [_cashDesk, [-0.5, -0.05, 1.1]];

_trader = 
[
    "Exile_Trader_Food",
    "Exile_Trader_Food",
    "GreekHead_A3_01",
    ["InBaseMoves_table1"],
    [0.1, 0.5, 0.2],
    170,
    _cashDesk
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Eastern Boat Trader
///////////////////////////////////////////////////////////////////////////

_trader = 
[
    "Exile_Trader_Boat",
    "Exile_Trader_Boat",
    "WhiteHead_17",
    ["AidlPercMstpSnonWnonDnon_G01", "AidlPercMstpSnonWnonDnon_G02", "AidlPercMstpSnonWnonDnon_G03", "AidlPercMstpSnonWnonDnon_G04", "AidlPercMstpSnonWnonDnon_G05", "AidlPercMstpSnonWnonDnon_G06"],
    [23296.6,24189.8,5.61213],
    96
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Eastern Vehicle Trader
///////////////////////////////////////////////////////////////////////////

_trader = 
[
    "Exile_Trader_Vehicle",
    "Exile_Trader_Vehicle",
    "WhiteHead_11",
    ["InBaseMoves_repairVehicleKnl", "InBaseMoves_repairVehiclePne"],
    [23385.6,24191.6,0.00136566],
    123
]
call ExileClient_object_trader_create;

_carWreck = "Land_Wreck_CarDismantled_F" createVehicleLocal [0,0,0];
_carWreck setDir 47.2728;    
_carWreck setPosATL [23387.3, 24190.3, 0.05];

///////////////////////////////////////////////////////////////////////////
// Eastern Hardware Trader
///////////////////////////////////////////////////////////////////////////
_workBench = "Land_Workbench_01_F" createVehicleLocal [0,0,0];
_workBench setDir 279.545;
_workBench setPosATL [23371.6, 24188, 0.89873];

_trader = 
[
    "Exile_Trader_Hardware",
    "Exile_Trader_Hardware",
    "WhiteHead_17",
    ["InBaseMoves_sitHighUp1"],
    [0, 0, -0.5],
    170,
    _workBench
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Eastern Equipment Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_Equipment",
    "Exile_Trader_Equipment",
    "WhiteHead_19",
    ["HubStanding_idle1", "HubStanding_idle2", "HubStanding_idle3"],
    [23379.9, 24169.3, 0.199955],
    206
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Eastern Armory Trader
///////////////////////////////////////////////////////////////////////////
_chair = "Land_CampingChair_V2_F" createVehicleLocal [0,0,0];
_chair setDir 12.7272;
_chair setPosATL [23379.6, 24169.3, 4.56662];

_trader = 
[
    "Exile_Trader_Armory",
    "Exile_Trader_Armory",
    "PersianHead_A3_02",
    ["InBaseMoves_SittingRifle1"],
    [0, -0.15, -0.45],
    180,
    _chair
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Eastern Waste Dump Trader
///////////////////////////////////////////////////////////////////////////
_trader = 
[
    "Exile_Trader_WasteDump",
    "Exile_Trader_WasteDump",
    "GreekHead_A3_01",
    ["HubStandingUA_move1", "HubStandingUA_move2", "HubStandingUA_idle1", "HubStandingUA_idle2", "HubStandingUA_idle3"],
    [23336.6,24214.4,0.00115061],
    346
]
call ExileClient_object_trader_create;

///////////////////////////////////////////////////////////////////////////
// Russian Roulette
///////////////////////////////////////////////////////////////////////////
[
    "Exile_Trader_RussianRoulette",
    "",
    "GreekHead_A3_01",
    ["HubStandingUA_move1", "HubStandingUA_move2", "HubStandingUA_idle1", "HubStandingUA_idle2", "HubStandingUA_idle3"],
    [14622.6, 16820.1, 0.126],
    187.428
]
call ExileClient_object_trader_create;
///////////START OF FUCK YOU///
// 15 NPCs
private _npcs = [
["Exile_Trader_Boat", ["HubStandingUA_idle1"], "Exile_Trader_Boat", "WhiteHead_11", [[],[],[],["U_OrestesBody",[]],[],[],"H_Cap_surfer","",[],["","","","","",""]], [18367.5, 8035.01, 1.86994], [0.801099, -0.598532, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["HubStandingUA_idle1"], "Exile_Trader_WasteDump", "WhiteHead_06", [[],[],[],["U_I_G_Story_Protagonist_F",[]],["V_Rangemaster_belt",[]],[],"H_MilCap_gry","G_Combat",[],["","","","","",""]], [18424.2, 8114.72, 2.95554], [-0.979937, 0.199309, 0], [0, 0, 1]],
["Exile_Trader_Food", ["HubStandingUA_idle1"], "Exile_Trader_Food", "AfricanHead_01", [[],[],[],["U_C_Poloshirt_blue",[]],[],[],"H_Cap_tan","",[],["","","","","",""]], [18406, 8181.98, 2.62372], [-0.90107, -0.433675, 0], [0, 0, 1]],
["Exile_Trader_Equipment", ["HubStandingUA_idle1"], "Exile_Trader_Equipment", "WhiteHead_13", [["arifle_MX_GL_Black_F","","","",[],[],""],[],[],["U_BG_Guerrilla_6_1",[]],["V_I_G_resistanceLeader_F",[]],[],"H_Watchcap_khk","",[],["","","","","",""]], [18412.5, 8171.51, 2.20665], [-0.896326, -0.443395, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["HubStandingUA_idle1"], "Exile_Trader_Vehicle", "WhiteHead_18", [[],[],[],["U_B_CTRG_1",[]],[],[],"","G_Aviator",[],["","","","","",""]], [18414.2, 8143.67, 2.26797], [-0.998671, -0.0515299, 0], [0, 0, 1]],
["Exile_Trader_Armory", ["HubStandingUA_idle1"], "Exile_Trader_Armory", "WhiteHead_08", [["srifle_DMR_06_olive_F","","","",[],[],""],[],[],["U_Rangemaster",[]],["V_Rangemaster_belt",[]],[],"H_Cap_headphones","G_Shades_Black",[],["","","","","",""]], [18411.3, 8174.97, 2.35416], [-0.940105, -0.340885, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["HubStandingUA_idle1"], "Exile_Trader_Aircraft", "AfricanHead_03", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","",[],["","","","","",""]], [18425.1, 8083.33, 2.54338], [-0.932945, 0.360018, 0], [0, 0, 1]],
["Exile_Trader_CommunityCustoms", ["HubStandingUA_idle1"], "Exile_Trader_CommunityCustoms", "WhiteHead_05", [[],[],[],["U_NikosAgedBody",[]],[],[],"","H_Hat_tan",[],["","","","","",""]], [13808.2, 6386.19, 61.2493], [-0.0945463, 0.99552, 0], [0, 0, 1]],
["Exile_Trader_CommunityCustoms2", ["HubStandingUA_idle1"], "Exile_Trader_CommunityCustoms2", "WhiteHead_09", [[],[],[],["U_NikosAgedBody",[]],[],[],"","H_Hat_tan",[],["","","","","",""]], [2285.58, 22180.8, 93.6659], [0.761791, -0.647822, 0], [0, 0, 1]],
["Exile_Trader_CommunityCustoms3", ["HubStandingUA_idle1"], "Exile_Trader_CommunityCustoms3", "WhiteHead_05", [[],[],[],["U_NikosAgedBody",[]],[],[],"","H_Hat_tan",[],["","","","","",""]], [27629.4, 23147.8, 9.35275], [-0.874648, 0.484759, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["HubStandingUA_idle1"], "Exile_Trader_Aircraft", "WhiteHead_19", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","",[],["","","","","",""]], [23354.9, 24199.9, 4.54535], [0.726692, -0.686964, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["HubStandingUA_idle1"], "Exile_Trader_Aircraft", "WhiteHead_04", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Tactical_Black",[],["","","","","",""]], [3037.22, 18150.8, 3.70143], [-0.185148, -0.982711, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["HubStandingUA_idle1"], "Exile_Trader_Aircraft", "WhiteHead_19", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","",[],["","","","","",""]], [23354.9, 24199.9, 4.54535], [0.726692, -0.686964, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["HubStandingUA_idle1"], "Exile_Trader_Aircraft", "WhiteHead_04", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Tactical_Black",[],["","","","","",""]], [3037.22, 18150.8, 3.70143], [-0.185149, -0.982711, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["HubStandingUA_idle1"], "Exile_Trader_Aircraft", "WhiteHead_12", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Tactical_Clear",[],["","","","","",""]], [13806.2, 6387.48, 61.2493], [0.979339, 0.202227, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["HubStandingUA_idle1"], "Exile_Trader_Vehicle", "WhiteHead_08", [[],[],[],["Exile_Uniform_ExileCustoms",[]],[],[],"H_RacingHelmet_4_F","G_Tactical_Clear",[],["","","","","",""]], [13809.2, 6390.63, 61.2493], [-0.662094, -0.749421, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["HubStandingUA_idle1"], "Exile_Trader_Aircraft", "GreekHead_A3_09", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","",[],["","","","","",""]], [27625.6, 23148.7, 9.66032], [0.843414, 0.537264, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["HubStandingUA_idle1"], "Exile_Trader_Vehicle", "WhiteHead_08", [[],[],[],["Exile_Uniform_ExileCustoms",[]],[],[],"H_RacingHelmet_4_F","G_Combat",[],["","","","","",""]], [27624.2, 23151.6, 9.74338], [0.959145, -0.282914, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["HubStandingUA_idle1"], "Exile_Trader_Vehicle", "WhiteHead_01", [[],[],[],["Exile_Uniform_ExileCustoms",[]],[],[],"H_RacingHelmet_4_F","",[],["","","","","",""]], [2288.41, 22179.2, 93.4977], [-0.998758, -0.0498208, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["HubStandingUA_idle1"], "Exile_Trader_Aircraft", "Sturrock", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Tactical_Clear",[],["","","","","",""]], [2285.39, 22179.5, 93.7406], [0.979339, 0.202227, 0], [0, 0, 1]]
];

{
    private _logic = "Logic" createVehicleLocal [0, 0, 0];
    private _trader = (_x select 0) createVehicleLocal [0, 0, 0];
    private _animations = _x select 1;
    
    _logic setPosWorld (_x select 5);
    _logic setVectorDirAndUp [_x select 6, _x select 7];
    
    _trader setVariable ["BIS_enableRandomization", false];
    _trader setVariable ["BIS_fnc_animalBehaviour_disable", true];
    _trader setVariable ["ExileAnimations", _animations];
    _trader setVariable ["ExileTraderType", _x select 2];
    _trader disableAI "ANIM";
    _trader disableAI "MOVE";
    _trader disableAI "FSM";
    _trader disableAI "AUTOTARGET";
    _trader disableAI "TARGET";
    _trader disableAI "CHECKVISIBLE";
    _trader allowDamage false;
    _trader setFace (_x select 3);
    _trader setUnitLoadOut (_x select 4);
    _trader setPosWorld (_x select 5);
    _trader setVectorDirAndUp [_x select 6, _x select 7];
    _trader reveal _logic;
    _trader attachTo [_logic, [0, 0, 0]];
    _trader switchMove (_animations select 0);
    _trader addEventHandler ["AnimDone", {_this call ExileClient_object_trader_event_onAnimationDone}];
}
forEach _npcs;
////END OF FUCK YOU///
//servermsg
execVM "messages.sqf";
//wages
_wages = compileFinal preprocessFileLineNumbers "wages.sqf";
[1800, _wages, [], true] call ExileClient_system_thread_addtask;

//ANTI FLOAT
waitUntil {!isNil"ExileClientLoadedIn"};
[
    1,
    {
        _fs = ["afalpercmstpsraswrfldnon","afalpercmstpsnonwnondnon","afalpercmstpsraswpstdnon","afalpknlmstpsraswrfldnon","afalpknlmstpsnonwnondnon"];  
		if ((animationState player) in _fs) then
		{
			_f = (getPos player select 2);
			if (_f < 0.1) then 
			{
				player setvelocity [0,0,0];
			};
			
		};
		
    },
    [],
    true,
    true
] call ExileClient_system_thread_addtask;