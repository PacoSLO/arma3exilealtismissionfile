/**
 * ExileServer_object_tree_network_chopTreeRequest
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_sessionId","_parameters","_treeNetId","_tree","_isTree","_player","_treeHeight","_newDamage","_treePosition","_spawnRadius","_weaponHolders","_weaponHolder","_weaponHolderPosition"];
_sessionId = _this select 0;
_parameters = _this select 1;
_treeNetId = _parameters select 0;
	
///////////////////////////////////
//////Chop Trees Into Vehicles/////
///////////////////////////////////
_woodText = "Wood dropped in your Area!";
_woodVehicleText = "Wood was put inside your Vehicle!";
_woodVehicleFullText = "Wood dropped in your Area! Vehicle is Full!";
///////////////////////////////////

try 
{
	_tree = objectFromNetId _treeNetId;
	if (isNull _tree) then 
	{
		throw format ["Cannot chop unknown tree! %1", _treeNetId];
	};
	if !(alive _tree) then 
	{
		throw "Cannot chop already chopped tree!";
	};
	_isTree = [_tree, "WoodSource"] call ExileClient_util_model_isInteraction;
	if !(_isTree) then 
	{
		throw "Can only chop down trees!";
	};
	_player = _sessionId call ExileServer_system_session_getPlayerObject;
	if (isNull _player) then 
	{
		throw "Unknown players cannot chop trees!";
	};
	if !(alive _player) then 
	{
		throw "The dead cannot chop down trees!";
	};
	if ((_player distance _tree) > 30) then 
	{
		throw "No long distance tree chopping! Nope!";
	};
	_treeHeight = _tree call ExileClient_util_model_getHeight;
	_treeHeight = _treeHeight max 1; 
	_newDamage = ((damage _tree) + (1 / (floor _treeHeight) )) min 1;
	_tree setDamage _newDamage; 
	if (_newDamage isEqualTo 1) then
	{
		_tree setDamage 999; 
	};
	
///////////////////////////////////
//////Chop Trees Into Vehicles/////
///////////////////////////////////
            _nearestTruck = (getPosATL _tree) nearEntities[[
			
						"Exile_Car_BRDM2_HQ",

						"Exile_Car_BTR40_MG_Green","Exile_Car_BTR40_MG_Camo","Exile_Car_BTR40_Green","Exile_Car_BTR40_Camo",

						"Exile_Car_Golf_Red","Exile_Car_Golf_Black",

						"Exile_Car_Hatchback_Beige","Exile_Car_Hatchback_Green","Exile_Car_Hatchback_Blue","Exile_Car_Hatchback_BlueCustom",
						"Exile_Car_Hatchback_BeigeCustom","Exile_Car_Hatchback_Yellow","Exile_Car_Hatchback_Grey","Exile_Car_Hatchback_Black",
						"Exile_Car_Hatchback_Dark","Exile_Car_Hatchback_Rusty1","Exile_Car_Hatchback_Rusty2","Exile_Car_Hatchback_Rusty3",

						"Exile_Car_Hatchback_Sport_Red","Exile_Car_Hatchback_Sport_Blue","Exile_Car_Hatchback_Sport_Orange","Exile_Car_Hatchback_Sport_White",
						"Exile_Car_Hatchback_Sport_Beige","Exile_Car_Hatchback_Sport_Green","Exile_Car_Hatchback_Sport_Admin",

						"Exile_Car_HEMMT","HMMWV_M134","Exile_Car_HMMWV_M134_Green","Exile_Car_HMMWV_M134_Desert","HMMWV_M2","Exile_Car_HMMWV_M2_Green",
						"Exile_Car_HMMWV_M2_Desert","HMMWV_MEV","Exile_Car_HMMWV_MEV_Green","Exile_Car_HMMWV_MEV_Desert","HMMWV_UNA",
						"Exile_Car_HMMWV_UNA_Green","Exile_Car_HMMWV_UNA_Desert",

						"Exile_Car_Hunter",
						"Exile_Car_Ifrit",

						"Exile_Car_Ikarus_Blue","Exile_Car_Ikarus_Red","Exile_Car_Ikarus_Party",

						"Exile_Car_Lada_Green","Exile_Car_Lada_Taxi","Exile_Car_Lada_Red","Exile_Car_Lada_White","Exile_Car_Lada_Hipster",

						"Exile_Car_LandRover_Red","Exile_Car_LandRover_Urban","Exile_Car_LandRover_Green","Exile_Car_LandRover_Sand","Exile_Car_LandRover_Desert",
						"Exile_Car_LandRover_Ambulance_Green","Exile_Car_LandRover_Ambulance_Desert","Exile_Car_LandRover_Ambulance_Sand",

						"Exile_Car_Octavius_White","Exile_Car_Octavius_Black",

						"Exile_Car_Offroad_Red","Exile_Car_Offroad_Beige","Exile_Car_Offroad_White","Exile_Car_Offroad_Blue","Exile_Car_Offroad_DarkRed",
						"Exile_Car_Offroad_BlueCustom","Exile_Car_Offroad_Guerilla01","Exile_Car_Offroad_Guerilla02","Exile_Car_Offroad_Guerilla03",
						"Exile_Car_Offroad_Guerilla04","Exile_Car_Offroad_Guerilla05","Exile_Car_Offroad_Guerilla06","Exile_Car_Offroad_Guerilla07",
						"Exile_Car_Offroad_Guerilla08","Exile_Car_Offroad_Guerilla09","Exile_Car_Offroad_Guerilla10","Exile_Car_Offroad_Guerilla11",
						"Exile_Car_Offroad_Guerilla12","Exile_Car_Offroad_Rusty1","Exile_Car_Offroad_Rusty2","Exile_Car_Offroad_Rusty3",

						"Exile_Car_Offroad_Armed_Guerilla01","Exile_Car_Offroad_Armed_Guerilla02","Exile_Car_Offroad_Armed_Guerilla03","Exile_Car_Offroad_Armed_Guerilla04",
						"Exile_Car_Offroad_Armed_Guerilla05","Exile_Car_Offroad_Armed_Guerilla06","Exile_Car_Offroad_Armed_Guerilla07","Exile_Car_Offroad_Armed_Guerilla08",
						"Exile_Car_Offroad_Armed_Guerilla09","Exile_Car_Offroad_Armed_Guerilla10","Exile_Car_Offroad_Armed_Guerilla11","Exile_Car_Offroad_Armed_Guerilla12",

						"Exile_Car_Offroad_Repair_Civillian","Exile_Car_Offroad_Repair_Red","Exile_Car_Offroad_Repair_Beige","Exile_Car_Offroad_Repair_White",
						"Exile_Car_Offroad_Repair_Blue","Exile_Car_Offroad_Repair_DarkRed","Exile_Car_Offroad_Repair_BlueCustom","Exile_Car_Offroad_Repair_Guerilla01",
						"Exile_Car_Offroad_Repair_Guerilla02","Exile_Car_Offroad_Repair_Guerilla03","Exile_Car_Offroad_Repair_Guerilla04","Exile_Car_Offroad_Repair_Guerilla05",
						"Exile_Car_Offroad_Repair_Guerilla06","Exile_Car_Offroad_Repair_Guerilla07","Exile_Car_Offroad_Repair_Guerilla08","Exile_Car_Offroad_Repair_Guerilla09",
						"Exile_Car_Offroad_Repair_Guerilla10","Exile_Car_Offroad_Repair_Guerilla11","Exile_Car_Offroad_Repair_Guerilla12",

						"Exile_Car_OldTractor_Red",
						"Exile_Car_Strider",

						"Exile_Car_SUV_Red","Exile_Car_SUV_Black","Exile_Car_SUV_Grey","Exile_Car_SUV_Orange","Exile_Car_SUV_Rusty1","Exile_Car_SUV_Rusty2",
						"Exile_Car_SUV_Rusty3","SUV_Base",

						"Exile_Car_SUVXL_Black","Exile_Car_SUV_Armed_Black",

						"Exile_Car_Tempest",

						"Exile_Car_TowTractor_White",

						"Exile_Car_Tractor_Red",
						"Exile_Car_UAZ_Green","Exile_Car_UAZ_Open_Green",

						"Exile_Car_Ural_Covered_Blue","Exile_Car_Ural_Covered_Yellow","Exile_Car_Ural_Covered_Worker","Exile_Car_Ural_Covered_Military","Exile_Car_Ural_Open_Blue",
						"Exile_Car_Ural_Open_Yellow","Exile_Car_Ural_Open_Worker","Exile_Car_Ural_Open_Military",

						"Exile_Car_V3S_Covered","Exile_Car_V3S_Open",

						"Exile_Car_Van_Black","Exile_Car_Van_White","Exile_Car_Van_Red","Exile_Car_Van_Guerilla01","Exile_Car_Van_Guerilla02",
						"Exile_Car_Van_Guerilla03","Exile_Car_Van_Guerilla04","Exile_Car_Van_Guerilla05","Exile_Car_Van_Guerilla06","Exile_Car_Van_Guerilla07",
						"Exile_Car_Van_Guerilla08",

						"Exile_Car_Van_Box_Black","Exile_Car_Van_Box_White","Exile_Car_Van_Box_Red","Exile_Car_Van_Box_Guerilla01","Exile_Car_Van_Box_Guerilla02",
						"Exile_Car_Van_Box_Guerilla03","Exile_Car_Van_Box_Guerilla04","Exile_Car_Van_Box_Guerilla05","Exile_Car_Van_Box_Guerilla06","Exile_Car_Van_Box_Guerilla07",
						"Exile_Car_Van_Box_Guerilla08",

						"Exile_Car_Van_Fuel_Black","Exile_Car_Van_Fuel_White","Exile_Car_Van_Fuel_Red","Exile_Car_Van_Fuel_Guerilla01","Exile_Car_Van_Fuel_Guerilla02","Exile_Car_Van_Fuel_Guerilla03",

						"Exile_Car_Volha_Blue","Exile_Car_Volha_White","Exile_Car_Volha_Black",

						"Exile_Car_Zamak",

						"Exile_Bike_QuadBike_Black","Exile_Bike_QuadBike_Blue","Exile_Bike_QuadBike_Red","Exile_Bike_QuadBike_White","Exile_Bike_QuadBike_Nato","Exile_Bike_QuadBike_Csat","Exile_Bike_QuadBike_Fia",
						"Exile_Bike_QuadBike_Guerilla01","Exile_Bike_QuadBike_Guerilla02",

						"Exile_Chopper_Hellcat_Green","Exile_Chopper_Hellcat_FIA",

						"Exile_Chopper_Huey_Green","Exile_Chopper_Huey_Desert","Exile_Chopper_Huey_Armed_Green","Exile_Chopper_Huey_Armed_Desert",

						"Exile_Chopper_Hummingbird_Green","Exile_Chopper_Hummingbird_Civillian_Blue","Exile_Chopper_Hummingbird_Civillian_Red","Exile_Chopper_Hummingbird_Civillian_ION",
						"Exile_Chopper_Hummingbird_Civillian_BlueLine","Exile_Chopper_Hummingbird_Civillian_Digital","Exile_Chopper_Hummingbird_Civillian_Elliptical",
						"Exile_Chopper_Hummingbird_Civillian_Furious","Exile_Chopper_Hummingbird_Civillian_GrayWatcher","Exile_Chopper_Hummingbird_Civillian_Jeans",
						"Exile_Chopper_Hummingbird_Civillian_Light","Exile_Chopper_Hummingbird_Civillian_Shadow","Exile_Chopper_Hummingbird_Civillian_Sheriff",
						"Exile_Chopper_Hummingbird_Civillian_Speedy","Exile_Chopper_Hummingbird_Civillian_Sunset","Exile_Chopper_Hummingbird_Civillian_Vrana",
						"Exile_Chopper_Hummingbird_Civillian_Wasp","Exile_Chopper_Hummingbird_Civillian_Wave",

						"Exile_Chopper_Huron_Black","Exile_Chopper_Huron_Green",

						"Exile_Chopper_Mohawk_FIA",

						"Exile_Chopper_Orca_CSAT","Exile_Chopper_Orca_Black","Exile_Chopper_Orca_BlackCustom",

						"Exile_Chopper_Taru_CSAT","Exile_Chopper_Taru_Black","Exile_Chopper_Taru_Covered_CSAT","Exile_Chopper_Taru_Covered_Black","Exile_Chopper_Taru_Transport_CSAT","Exile_Chopper_Taru_Transport_Black",
						
						"Exile_Plane_Ceasar","Exile_Plane_BlackfishInfantry","Exile_Plane_BlackfishVehicle",
						"Exile_Car_ProwlerLight","Exile_Car_ProwlerUnarmed",
						"Exile_Car_QilinUnarmed",
						"Exile_Car_MB4WD",
						"Exile_Car_MB4WDOpen",
						
						"C_Offroad_02_unarmed_F",
						"B_T_LSV_01_armed_F", "B_T_LSV_01_unarmed_F", "O_T_LSV_02_armed_F","O_T_LSV_02_unarmed_F","B_T_UAV_03_F","C_Plane_Civil_01_F","O_T_UAV_04_CAS_F","B_T_VTOL_01_armed_F",
						"B_T_VTOL_01_infantry_F","B_T_VTOL_01_vehicle_F","O_T_VTOL_02_infantry_F","O_T_VTOL_02_vehicle_F","I_C_Boat_Transport_02_F","C_Scoooter_Transport_01_F"
						
						], 50];
						
            _weaponHolder = objNull;
            if ((count _nearestTruck > 0)) then
            {
                _truck = _nearestTruck select 0;
                if (_truck canAdd "Exile_Item_WoodLog") then
                    {
                    _truck addMagazineCargoGlobal ["Exile_Item_WoodLog", 1];
						[_sessionID, "toastRequest", ["SuccessTitleOnly", [_woodVehicleText]]] call ExileServer_system_network_send_to;
                    }
                    else
                    {
                        _treePosition = getPosATL _tree;
                        _treePosition set[2, 0];
                        _spawnRadius = 3;
                        _weaponHolders = nearestObjects[_treePosition, ["GroundWeaponHolder"], _spawnRadius];
                        _weaponHolder = objNull;
                        if (_weaponHolders isEqualTo []) then
                        {
                            _weaponHolderPosition = [_treePosition, _spawnRadius] call ExileClient_util_math_getRandomPositionInCircle;
                            _weaponHolderPosition set [2, 0];
                            _weaponHolder = createVehicle ["GroundWeaponHolder", _weaponHolderPosition, [], 0, "CAN_COLLIDE"];
                            _weaponHolder setPosATL _weaponHolderPosition;
                        }
                        else
                        {
                            _weaponHolder = _weaponHolders select 0;
                        };
                        _weaponHolder addMagazineCargoGlobal ["Exile_Item_WoodLog", 1];
						[_sessionID, "toastRequest", ["SuccessTitleOnly", [_woodVehicleFullText]]] call ExileServer_system_network_send_to;
                    };
            }
            else
            {
			

	_treePosition = getPosATL _tree;
	_treePosition set[2, 0];
	_spawnRadius = 3;
	_weaponHolders = nearestObjects[_treePosition, ["GroundWeaponHolder"], _spawnRadius];
	_weaponHolder = objNull;
	if (_weaponHolders isEqualTo []) then
	{
		_weaponHolderPosition = getPosATL _player;
		_weaponHolder = createVehicle ["GroundWeaponHolder", _weaponHolderPosition, [], 0, "CAN_COLLIDE"];
		_weaponHolder setPosATL _weaponHolderPosition;
	}
	else 
	{
		_weaponHolder = _weaponHolders select 0;
	};
	_weaponHolder addMagazineCargoGlobal ["Exile_Item_WoodLog", 1];
	

			[_sessionID, "toastRequest", ["SuccessTitleOnly", [_woodText]]] call ExileServer_system_network_send_to;
			};			

}
catch 
{
	_exception call ExileServer_util_log;
};
true