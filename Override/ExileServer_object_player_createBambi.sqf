/**
 * ExileServer_object_player_createBambi
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_sessionID","_requestingPlayer","_spawnLocationMarkerName","_thugToCheck","_HaloSpawnCheck","_bambiPlayer","_accountData","_direction","_position","_spawnAreaPosition","_spawnAreaRadius","_clanID","_clanData","_clanGroup","_player","_devFriendlyMode","_devs","_parachuteNetID","_spawnType","_parachuteObject"];
_sessionID = _this select 0;
_requestingPlayer = _this select 1;
_spawnLocationMarkerName = _this select 2;
_bambiPlayer = _this select 3;
_accountData = _this select 4;
_direction = random 360;
_Respect = (_accountData select 0);
if ((count ExileSpawnZoneMarkerPositions) isEqualTo 0) then 
{
    _position = call ExileClient_util_world_findCoastPosition;
    if ((toLower worldName) isEqualTo "namalsk") then 
    {
        while {(_position distance2D [76.4239, 107.141, 0]) < 100} do 
        {
            _position = call ExileClient_util_world_findCoastPosition;
        };
    };
}
else 
{
    _spawnAreaPosition = getMarkerPos _spawnLocationMarkerName;
    _spawnAreaRadius = getNumber(configFile >> "CfgSettings" >> "BambiSettings" >> "spawnZoneRadius");
    _position = [_spawnAreaPosition, _spawnAreaRadius] call ExileClient_util_math_getRandomPositionInCircle;
    while {surfaceIsWater _position} do 
    {
        _position = [_spawnAreaPosition, _spawnAreaRadius] call ExileClient_util_math_getRandomPositionInCircle;
    };
};

_name = name _requestingPlayer;
_clanID = (_accountData select 3);
if !((typeName _clanID) isEqualTo "SCALAR") then
{
    _clanID = -1;
    _clanData = [];
}
else
{
    _clanData = missionNamespace getVariable [format ["ExileServer_clan_%1",_clanID],[]];
    if(isNull (_clanData select 5))then
    {
        _clanGroup = createGroup independent;
        _clanData set [5,_clanGroup];
        _clanGroup setGroupIdGlobal [_clanData select 0];
        missionNameSpace setVariable [format ["ExileServer_clan_%1",_clanID],_clanData];
    }
    else
    {
        _clanGroup = (_clanData select 5);
    };
    [_player] joinSilent _clanGroup;
};
_bambiPlayer setPosATL [_position select 0,_position select 1,0];
_bambiPlayer disableAI "FSM";
_bambiPlayer disableAI "MOVE";
_bambiPlayer disableAI "AUTOTARGET";
_bambiPlayer disableAI "TARGET";
_bambiPlayer disableAI "CHECKVISIBLE";
_bambiPlayer setDir _direction;
_bambiPlayer setName _name;
_bambiPlayer setVariable ["ExileMoney", 0, true]; 
_bambiPlayer setVariable ["ExileScore", (_accountData select 0)];
_bambiPlayer setVariable ["ExileKills", (_accountData select 1)];
_bambiPlayer setVariable ["ExileDeaths", (_accountData select 2)];
_bambiPlayer setVariable ["ExileClanID", _clanID];
_bambiPlayer setVariable ["ExileClanData", _clanData];
_bambiPlayer setVariable ["ExileHunger", 100];
_bambiPlayer setVariable ["ExileThirst", 100];
_bambiPlayer setVariable ["ExileTemperature", 37];
_bambiPlayer setVariable ["ExileWetness", 0];
_bambiPlayer setVariable ["ExileAlcohol", 0]; 
_bambiPlayer setVariable ["ExileName", _name]; 
_bambiPlayer setVariable ["ExileOwnerUID", getPlayerUID _requestingPlayer]; 
_bambiPlayer setVariable ["ExileIsBambi", true];
_bambiPlayer setVariable ["ExileXM8IsOnline", false, true];
_bambiPlayer setVariable ["ExileLocker", (_accountData select 4), true];
_devFriendlyMode = getNumber (configFile >> "CfgSettings" >> "ServerSettings" >> "devFriendyMode");
if (_devFriendlyMode isEqualTo 1) then 
{
    _devs = getArray (configFile >> "CfgSettings" >> "ServerSettings" >> "devs");
    {
        if ((getPlayerUID _requestingPlayer) isEqualTo (_x select 0))exitWith 
        {
            if((name _requestingPlayer) isEqualTo (_x select 1))then
            {
                _bambiPlayer setVariable ["ExileMoney", 500000, true];
                _bambiPlayer setVariable ["ExileScore", 100000];
            };
        };
    }
    forEach _devs;
};
_parachuteNetID = "";

_thugToCheck = _sessionID call ExileServer_system_session_getPlayerObject;
_HaloSpawnCheck = _thugToCheck getVariable ["playerWantsHaloSpawn", 0];

if (_HaloSpawnCheck isEqualTo 1) then
{
    _position set [2, getNumber(configFile >> "CfgSettings" >> "BambiSettings" >> "parachuteDropHeight")]; 
    if ((getNumber(configFile >> "CfgSettings" >> "BambiSettings" >> "haloJump")) isEqualTo 1) then
    {
        _bambiPlayer addBackpackGlobal "B_Parachute";
        _bambiPlayer setPosATL _position;
        _spawnType = 2;
    }
    else 
    {
        _parachuteObject = createVehicle ["Steerable_Parachute_F", _position, [], 0, "CAN_COLLIDE"];
        _parachuteObject setDir _direction;
        _parachuteObject setPosATL _position;
        _parachuteObject enableSimulationGlobal true;
        _parachuteNetID = netId _parachuteObject;
        _spawnType = 1;
    };
}
else
{
    _spawnType = 0;
};

//Weapon Tier, Suppressor tier and optics is to randomize what weapon and its attachments the player spawns in with.
//If a weapon that does not support an attachment is added to the tiers it is ok the attachment will be ignored.
//if using the weapon tiers code found in the respect based loadouts below do not define ammo because it is automatically coded to give the ammo specific to the random gun players end up with.
private _Tier1PrimaryWeapons = selectRandom
											[		//LOW Pistols
												"hgun_Pistol_heavy_01_snds_F",				
												"hgun_Rook40_F",
												"hgun_ACPC2_F"										
											];	
											
private _Tier1Suppressors = selectRandom
											[
												""
											];
				
	
private _Tier2PrimaryWeapons = selectRandom
											[		//LOW SMG
												"SMG_01_F",				
												"SMG_02_F",
												"hgun_PDW2000_F"	
											];
											
private _Tier2Suppressors = selectRandom	
											[
												""
											];
											
											
private _Tier3PrimaryWeapons = selectRandom
											[		//5.56mm
												"arifle_Mk20_plain_F",				
												"arifle_TRG20_F",
												"arifle_SDAR_F",				
												"Exile_Weapon_M16A4",
												"Exile_Weapon_M4"	
											];

private _Tier3Suppressors = selectRandom	
											[
												""
											];


private _Tier4PrimaryWeapons = selectRandom
											[		//6.5mm
												"arifle_Katiba_F",
												"arifle_MXC_Black_F",
												"srifle_DMR_07_blk_F",
												"arifle_ARX_blk_F"										
											];
											
private _Tier4Suppressors = selectRandom	
											[
												""
											];

private _RndmOptic = selectRandom 
											[
												"optic_Aco",
												"optic_Holosight",
												"optic_Yorris",
												"optic_ACO_grn"
											];

switch (true) do 
{

//Loadouts by UID place the player UID in "PlacePlayerUIDHere" inside the quotations.

//UID Loadout 1												//Wullf
        if ((getPlayerUID _requestingPlayer) isEqualTo (PlacePlayerUIDHere))exitWith 
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "U_B_Protagonist_VR"; // adds uniforms
			_bambiPlayer addVest "V_PlateCarrierGL_blk";
			_bambiPlayer addBackpack "B_ViperHarness_blk_F";
			_bambiPlayer addHeadgear "H_HelmetO_ViperSP_ghex_F";
			[_bambiPlayer,"srifle_DMR_05_blk_F",5] call bis_fnc_addWeapon;
			_bambiPlayer addPrimaryWeaponItem "muzzle_snds_93mmg";
			_bambiPlayer addPrimaryWeaponItem "bipod_01_F_blk";
			_bambiPlayer addPrimaryWeaponItem "optic_LRPS";
			[_bambiPlayer,"hgun_ACPC2_F",2] call bis_fnc_addWeapon;
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "ItemGPS";
			_bambiPlayer addItemToUniform "Exile_Item_PlasticBottleCoffee";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_BeefParts";
			_bambiPlayer addItemToUniform "Exile_Item_BeefParts";
			_bambiPlayer addItemToVest "Exile_Item_Defibrillator";
			_bambiPlayer addItemToVest "Exile_Item_InstaDoc";
			_bambiPlayer addItemToVest "Exile_Item_InstaDoc";
			_bambiPlayer addItemToVest "Exile_Item_Wrench";
			_bambiPlayer addItemToVest "Exile_Item_ExtensionCord";
		};	

//UID Loadout 2												//Kooter
        if ((getPlayerUID _requestingPlayer) isEqualTo ("PlacePlayerUIDHere"))exitWith
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "U_B_CombatUniform_mcam"; // adds uniforms
			_bambiPlayer addVest "rhsusf_spc_teamleader";
			_bambiPlayer addBackpack "B_Carryall_khk";
			_bambiPlayer addHeadgear "H_HelmetO_ViperSP_ghex_F";
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "ItemGPS";
			_bambiPlayer addWeapon "Rangefinder";
			_bambiPlayer addWeapon "rhs_weap_m4a1_m203s_d";
			_bambiPlayer addPrimaryWeaponItem "rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red";
			_bambiPlayer addPrimaryWeaponItem "rhsusf_acc_ACOG_d";
			_bambiPlayer addPrimaryWeaponItem "rhsusf_acc_anpeq16a";
			_bambiPlayer addPrimaryWeaponItem "rhsusf_acc_nt4_tan";
			_bambiPlayer addWeapon "rhsusf_weap_glock17g4";
			_bambiPlayer addHandgunItem "rhsusf_mag_17Rnd_9x19_FMJ";
			_bambiPlayer addHandgunItem "acc_flashlight_pistol";
			_bambiPlayer addHandgunItem "rhsusf_acc_omega9k";
			_bambiPlayer addItemToUniform "rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red";
			_bambiPlayer addItemToUniform "rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red";
			_bambiPlayer addItemToUniform "rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red";
			_bambiPlayer addItemToUniform "rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red";
			_bambiPlayer addItemToVest "20Rnd_762x51_Mag";
			_bambiPlayer addItemToVest "20Rnd_762x51_Mag";
			_bambiPlayer addItemToVest "20Rnd_762x51_Mag";
			_bambiPlayer addItemToVest "20Rnd_762x51_Mag";
			_bambiPlayer addItemToVest "20Rnd_762x51_Mag";
			_bambiPlayer addItemToVest "rhsusf_mag_17Rnd_9x19_FMJ";
			_bambiPlayer addItemToVest "rhsusf_mag_17Rnd_9x19_FMJ";
			_bambiPlayer addItemToVest "rhs_mag_m67";
			_bambiPlayer addItemToVest "rhs_mag_m67";
			_bambiPlayer addItemToVest "rhs_mag_m67";
			_bambiPlayer addItemToVest "rhs_mag_m67";
			_bambiPlayer addItemToVest "rhs_mag_M397_HET";
			_bambiPlayer addItemToVest "rhs_mag_M397_HET";
			_bambiPlayer addItemToVest "rhs_mag_M397_HET";
			_bambiPlayer addItemToVest "rhs_mag_M397_HET";
			_bambiPlayer addItemToVest "150Rnd_556x45_Drum_Sand_Mag_Tracer_F";
			_bambiPlayer addItemToBackpack "rhs_weap_m72a7";
			_bambiPlayer addItemToBackpack "MineDetector";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_Defibrillator";
			_bambiPlayer addItemToBackpack "Exile_Item_SheepSteak_Cooked";
			_bambiPlayer addItemToBackpack "Exile_Item_SheepSteak_Cooked";
			_bambiPlayer addItemToBackpack "Exile_Item_PlasticBottleCoffee";
			_bambiPlayer addItemToBackpack "Exile_Item_PlasticBottleCoffee";
			_bambiPlayer addItemToBackpack "Exile_Item_ExtensionCord";
			_bambiPlayer addItemToBackpack "Exile_Item_Wrench";
        };	
		
//UID Loadout 3												//Mattidg
        if ((getPlayerUID _requestingPlayer) isEqualTo ("PlacePlayerUIDHere"))exitWith 
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "U_B_Protagonist_VR"; // adds uniforms
			_bambiPlayer addVest "V_PlateCarrierGL_blk";
			_bambiPlayer addBackpack "EBM_Backpack_dev";
			_bambiPlayer addHeadgear "H_HelmetO_ViperSP_ghex_F";
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "I_UavTerminal";
			_bambiPlayer addWeapon "Laserdesignator";
			_bambiPlayer addWeapon "arifle_ARX_blk_F";
			_bambiPlayer addPrimaryWeaponItem "30Rnd_65x39_caseless_green";
			_bambiPlayer addPrimaryWeaponItem "10Rnd_50BW_Mag_F";
			_bambiPlayer addPrimaryWeaponItem "muzzle_snds_H";
			_bambiPlayer addPrimaryWeaponItem "bipod_02_F_blk";
			_bambiPlayer addPrimaryWeaponItem "acc_pointer_IR";
			_bambiPlayer addPrimaryWeaponItem "optic_ERCO_blk_F";
			_bambiPlayer addWeapon "launch_O_Titan_short_F";
			_bambiPlayer addSecondaryWeaponItem "acc_pointer_IR";
			_bambiPlayer addSecondaryWeaponItem "Titan_AT";
			_bambiPlayer addWeapon "hgun_Pistol_heavy_01_F";
			_bambiPlayer addHandgunItem "11Rnd_45ACP_Mag";
			_bambiPlayer addHandgunItem "muzzle_snds_acp";
			_bambiPlayer addHandgunItem "acc_flashlight_pistol";
			_bambiPlayer addHandgunItem "optic_MRD";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_InstaDoc";
			_bambiPlayer addItemToUniform "Exile_Item_InstaDoc";
			_bambiPlayer addItemToUniform "Exile_Item_InstaDoc";
			_bambiPlayer addItemToUniform "Exile_Item_InstaDoc";
			_bambiPlayer addItemToUniform "Exile_Item_InstaDoc";
			_bambiPlayer addItemToUniform "Exile_Item_ExtensionCord";
			_bambiPlayer addItemToUniform "Exile_Item_ExtensionCord";
			_bambiPlayer addItemToUniform "Exile_Item_ExtensionCord";
			_bambiPlayer addItemToUniform "Exile_Item_ExtensionCord";
			_bambiPlayer addItemToUniform "Exile_Item_ExtensionCord";
			_bambiPlayer addItemToVest "30Rnd_65x39_caseless_green";
			_bambiPlayer addItemToVest "30Rnd_65x39_caseless_green";
			_bambiPlayer addItemToVest "30Rnd_65x39_caseless_green";
			_bambiPlayer addItemToVest "30Rnd_65x39_caseless_green";
			_bambiPlayer addItemToVest "30Rnd_65x39_caseless_green";
			_bambiPlayer addItemToVest "30Rnd_65x39_caseless_green";
			_bambiPlayer addItemToVest "30Rnd_65x39_caseless_green";
			_bambiPlayer addItemToVest "10Rnd_50BW_Mag_F";
			_bambiPlayer addItemToVest "10Rnd_50BW_Mag_F";
			_bambiPlayer addItemToVest "10Rnd_50BW_Mag_F";
			_bambiPlayer addItemToVest "10Rnd_50BW_Mag_F";
			_bambiPlayer addItemToVest "10Rnd_50BW_Mag_F";
			_bambiPlayer addItemToBackpack "MineDetector";
			_bambiPlayer addItemToBackpack "optic_tws";
			_bambiPlayer addItemToBackpack "11Rnd_45ACP_Mag";
			_bambiPlayer addItemToBackpack "11Rnd_45ACP_Mag";
			_bambiPlayer addItemToBackpack "Exile_Item_Defibrillator";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "rhs_mag_an_m14_th3";
			_bambiPlayer addItemToBackpack "Titan_AT";
			_bambiPlayer addItemToBackpack "Titan_AT";
			_bambiPlayer addItemToBackpack "B_IR_Grenade";
			_bambiPlayer addItemToBackpack "B_IR_Grenade";
			_bambiPlayer addItemToBackpack "Chemlight_blue";
			_bambiPlayer addItemToBackpack "Chemlight_blue";
			_bambiPlayer addItemToBackpack "Exile_Item_SafeKit";
			_bambiPlayer addItemToBackpack "APERSMineDispenser_Mag";
			_bambiPlayer addItemToBackpack "APERSMineDispenser_Mag";
			_bambiPlayer addItemToBackpack "APERSMineDispenser_Mag";
			_bambiPlayer addItemToBackpack "APERSMineDispenser_Mag";
			_bambiPlayer addItemToBackpack "APERSMineDispenser_Mag";
			_bambiPlayer addItemToBackpack "Exile_Item_Wrench";
        };	

//UID Loadout 4											//Barnacle Bill
        if ((getPlayerUID _requestingPlayer) isEqualTo ("PlacePlayerUIDHere"))exitWith 
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "rhs_uniform_emr_patchless"; // adds uniforms
			_bambiPlayer addVest "V_PlateCarrier1_rgr";
			_bambiPlayer addBackpack "EBM_Backpack_dev";
			_bambiPlayer addHeadgear "rhs_6b7_1m_bala2_emr";
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "ItemGPS";
			_bambiPlayer addWeapon "Rangefinder";
			_bambiPlayer addItem "NVGogglesB_blk_F";
			_bambiPlayer assignItem "NVGogglesB_blk_F";	 
			_bambiPlayer addWeapon "rhs_weap_pkp";
			_bambiPlayer addPrimaryWeaponItem "rhs_100Rnd_762x54mmR";
			_bambiPlayer addWeapon "rhs_weap_rpg7";
			_bambiPlayer addSecondaryWeaponItem "rhs_rpg7_PG7VL_mag";
			_bambiPlayer addWeapon "rhs_weap_pp2000_folded";
			_bambiPlayer addHandgunItem "rhs_mag_9x19mm_7n21_20";
			_bambiPlayer addItemToUniform "Exile_Item_PowerDrink";
			_bambiPlayer addItemToUniform "Exile_Item_EMRE";
			_bambiPlayer addItemToUniform "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_Defibrillator";
			_bambiPlayer addItemToBackpack "Exile_Item_Wrench";
			_bambiPlayer addItemToBackpack "MineDetector";
			_bambiPlayer addItemToBackpack "Exile_Item_ExtensionCord";
        };	

//UID Loadout 5												//Titan
        if ((getPlayerUID _requestingPlayer) isEqualTo ("PlacePlayerUIDHere"))exitWith 
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "U_O_R_Gorka_01_black_F"; // adds uniforms
			_bambiPlayer addVest "rhsusf_spcs_ocp_rifleman";
			_bambiPlayer addBackpack "EBM_Backpack_dev";
			_bambiPlayer addHeadgear "rhsusf_opscore_mc_cover_pelt_cam";
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "ItemGPS";
			_bambiPlayer addWeapon "rhs_balaclava";
			_bambiPlayer addWeapon "Laserdesignator";
			_bambiPlayer addItem "rhsusf_ANPVS_15";
			_bambiPlayer assignItem "rhsusf_ANPVS_15";	 
			_bambiPlayer addWeapon "rhs_weap_mk17_CQC";
			_bambiPlayer addPrimaryWeaponItem "rhs_mag_20Rnd_SCAR_762x51_m61_ap";
			_bambiPlayer addPrimaryWeaponItem "rhsusf_acc_grip3_tan";
			_bambiPlayer addPrimaryWeaponItem "rhsusf_acc_anpeq15_light";
			_bambiPlayer addPrimaryWeaponItem "rhsusf_acc_su230a_mrds_c";
			_bambiPlayer addPrimaryWeaponItem "acc_pointer_IR";
			_bambiPlayer addPrimaryWeaponItem "optic_ERCO_blk_F";
			_bambiPlayer addWeapon "Exile_Melee_SledgeHammer";
			_bambiPlayer addItemToUniform "rhsusf_acc_rotex5_tan";
			_bambiPlayer addItemToUniform "rhs_acc_perst3_top";
			_bambiPlayer addItemToUniform "rhs_mag_20Rnd_SCAR_762x51_m61_ap";
			_bambiPlayer addItemToVest "Exile_Item_Defibrillator";
			_bambiPlayer addItemToVest "rhs_mag_20Rnd_SCAR_762x51_m61_ap";
			_bambiPlayer addItemToVest "rhs_mag_20Rnd_SCAR_762x51_m61_ap";
			_bambiPlayer addItemToVest "rhs_mag_20Rnd_SCAR_762x51_m61_ap";
			_bambiPlayer addItemToVest "rhs_mag_20Rnd_SCAR_762x51_m61_ap";
			_bambiPlayer addItemToVest "rhs_mag_20Rnd_SCAR_762x51_m61_ap";
			_bambiPlayer addItemToVest "rhs_mag_20Rnd_SCAR_762x51_m61_ap";
			_bambiPlayer addItemToBackpack "Exile_Item_ExtensionCord";
        };	
		
//UID Loadout 6												//jason
        if ((getPlayerUID _requestingPlayer) isEqualTo ("PlacePlayerUIDHere"))exitWith 
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "rhs_uniform_g3_tan"; // adds uniforms
			_bambiPlayer addVest "rhsusf_spc_teamleader";
			_bambiPlayer addBackpack "rhsusf_assault_eagleaiii_coy";
			_bambiPlayer addHeadgear "rhsusf_opscore_paint_pelt_nsw_cam";
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "I_UavTerminal";
			_bambiPlayer addWeapon "Rangefinder";
			_bambiPlayer addItem "NVGoggles";
			_bambiPlayer assignItem "NVGoggles";	 
			_bambiPlayer addWeapon "rhs_weap_ak103_zenitco01_b33";
			_bambiPlayer addPrimaryWeaponItem "rhs_30Rnd_762x39mm_polymer";
			_bambiPlayer addPrimaryWeaponItem "rhs_acc_dtk4screws";
			_bambiPlayer addPrimaryWeaponItem "rhsusf_acc_compm4";
			_bambiPlayer addPrimaryWeaponItem "rhsusf_acc_grip3";
			_bambiPlayer addPrimaryWeaponItem "rhs_acc_perst3_top_h";
			_bambiPlayer addWeapon "exile_weapon_cz550";
			_bambiPlayer addSecondaryWeaponItem "optic_Nightstalker";
			_bambiPlayer addSecondaryWeaponItem "Exile_Magazine_5Rnd_22LR";
			_bambiPlayer addWeapon "rhsusf_weap_glock17g4";
			_bambiPlayer addHandgunItem "rhsusf_mag_17Rnd_9x19_FMJ";
			_bambiPlayer addItemToUniform "Exile_Item_PlasticBottleCoffee";
			_bambiPlayer addItemToUniform "Exile_Item_PlasticBottleCoffee";
			_bambiPlayer addItemToUniform "rhsusf_mag_17Rnd_9x19_FMJ";
			_bambiPlayer addItemToUniform "Exile_Magazine_5Rnd_22LR";
			_bambiPlayer addItemToUniform "Exile_Magazine_5Rnd_22LR";
			_bambiPlayer addItemToVest "Exile_Item_InstaDoc";
			_bambiPlayer addItemToVest "Exile_Item_InstaDoc";
			_bambiPlayer addItemToVest "Exile_Item_EMRE";
			_bambiPlayer addItemToVest "Exile_Item_Knife";
			_bambiPlayer addItemToVest "Exile_Magazine_5Rnd_22LR";
			_bambiPlayer addItemToVest "Exile_Magazine_5Rnd_22LR";
			_bambiPlayer addItemToVest "Exile_Magazine_5Rnd_22LR";
			_bambiPlayer addItemToVest "Exile_Magazine_5Rnd_22LR";
			_bambiPlayer addItemToVest "rhs_30Rnd_762x39mm_polymer";
			_bambiPlayer addItemToVest "rhs_30Rnd_762x39mm_polymer";
			_bambiPlayer addItemToVest "rhs_30Rnd_762x39mm_polymer";
			_bambiPlayer addItemToVest "rhs_30Rnd_762x39mm_polymer";
			_bambiPlayer addItemToVest "rhs_30Rnd_762x39mm_polymer";
			_bambiPlayer addItemToBackpack "MineDetector";
			_bambiPlayer addItemToBackpack "optic_tws_mg";
			_bambiPlayer addItemToBackpack "Exile_Item_Defibrillator";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_Wrench";
			_bambiPlayer addItemToBackpack "Exile_Item_ExtensionCord";
        };	
		
//UID Loadout 7												//Orient
        if ((getPlayerUID _requestingPlayer) isEqualTo ("PlacePlayerUIDHere"))exitWith 
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "rhs_uniform_gorka_1_a"; // adds uniforms
			_bambiPlayer addVest "rhsgref_6b23_khaki_officer";
			_bambiPlayer addBackpack "EBM_Backpack_dev";
			_bambiPlayer addHeadgear "rhs_tsh4";
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "ItemGPS";
			_bambiPlayer addWeapon "G_Respirator_blue_F";
			_bambiPlayer addItem "O_NVGoggles_ghex_F";
			_bambiPlayer assignItem "O_NVGoggles_ghex_F";	 
			_bambiPlayer addWeapon "rhs_weap_akm_zenitco01_b33_grip1";
			_bambiPlayer addPrimaryWeaponItem "rhs_30Rnd_762x39mm_bakelite_tracer";
			_bambiPlayer addPrimaryWeaponItem "rhs_acc_dtk1l";
			_bambiPlayer addPrimaryWeaponItem "rhs_acc_perst3_2dp_h";
			_bambiPlayer addPrimaryWeaponItem "rhs_acc_grip_rk6";
			_bambiPlayer addPrimaryWeaponItem "optic_Hamr";
			_bambiPlayer addWeapon "rhs_weap_rpg7";
			_bambiPlayer addSecondaryWeaponItem "rhs_rpg7_PG7VR_mag";
			_bambiPlayer addWeapon "rhs_weap_makarov_pm";
			_bambiPlayer addHandgunItem "rhs_mag_9x18_8_57N181S";
			_bambiPlayer addItemToUniform "Exile_Item_InstaDoc";
			_bambiPlayer addItemToUniform "Exile_Item_Wrench";
			_bambiPlayer addItemToUniform "Exile_Item_ExtensionCord";
			_bambiPlayer addItemToVest "rhs_30Rnd_762x39mm_bakelite_tracer";
			_bambiPlayer addItemToVest "rhs_30Rnd_762x39mm_bakelite_tracer";
			_bambiPlayer addItemToVest "rhs_mag_9x18_8_57N181S";
			_bambiPlayer addItemToVest "rhs_mag_9x18_8_57N181S";
			_bambiPlayer addItemToVest "HandGrenade";
			_bambiPlayer addItemToVest "HandGrenade";
			_bambiPlayer addItemToBackpack "H_HelmetO_ViperSP_ghex_F";
			_bambiPlayer addItemToBackpack "Exile_Item_Defibrillator";
			_bambiPlayer addItemToBackpack "rhs_rpg7_PG7VR_mag";
			_bambiPlayer addItemToBackpack "Exile_Item_EMRE";
			_bambiPlayer addItemToBackpack "Exile_Item_EMRE";
			_bambiPlayer addItemToBackpack "Exile_Item_PlasticBottleCoffee";
			_bambiPlayer addItemToBackpack "Exile_Item_PlasticBottleCoffee";
			_bambiPlayer addItemToBackpack "Exile_Item_BeefParts";
			_bambiPlayer addItemToBackpack "Exile_Item_BeefParts";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
        };	

//UID Loadout 8												//joshu
        if ((getPlayerUID _requestingPlayer) isEqualTo ("PlacePlayerUIDHere"))exitWith 
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "U_B_FullGhillie_ard"; // adds uniforms
			_bambiPlayer addVest "V_PlateCarrierGL_rgr";
			_bambiPlayer addBackpack "EBM_Backpack_dev";
			_bambiPlayer addHeadgear "H_HelmetO_ViperSP_hex_F";
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "I_UavTerminal";
			_bambiPlayer addWeapon "Rangefinder";
			_bambiPlayer addWeapon "srifle_GM6_F";
			_bambiPlayer addPrimaryWeaponItem "5Rnd_127x108_APDS_Mag";
			_bambiPlayer addPrimaryWeaponItem "optic_LRPS";
			_bambiPlayer addItemToUniform "Exile_Item_Wrench";
			_bambiPlayer addItemToUniform "Exile_Item_ExtensionCord";
			_bambiPlayer addItemToUniform "Exile_Item_Defibrillator";
			_bambiPlayer addItemToUniform "Exile_Item_PlasticBottleFreshWater";
			_bambiPlayer addItemToUniform "Exile_Item_PlasticBottleFreshWater";
			_bambiPlayer addItemToUniform "Exile_Item_PlasticBottleFreshWater";
			_bambiPlayer addItemToVest "MineDetector";
			_bambiPlayer addItemToVest "5Rnd_127x108_APDS_Mag";
			_bambiPlayer addItemToBackpack "5Rnd_127x108_APDS_Mag";
			_bambiPlayer addItemToBackpack "5Rnd_127x108_APDS_Mag";
			_bambiPlayer addItemToBackpack "5Rnd_127x108_APDS_Mag";
			_bambiPlayer addItemToBackpack "5Rnd_127x108_APDS_Mag";
			_bambiPlayer addItemToBackpack "Exile_Item_EMRE";
			_bambiPlayer addItemToBackpack "Exile_Item_EMRE";
			_bambiPlayer addItemToBackpack "Exile_Item_EMRE";
			_bambiPlayer addItemToBackpack "Exile_Item_EMRE";
			_bambiPlayer addItemToBackpack "Exile_Item_EMRE";
			_bambiPlayer addItemToBackpack "Exile_Item_EMRE";
			_bambiPlayer addItemToBackpack "Exile_Item_PlasticBottleFreshWater";
			_bambiPlayer addItemToBackpack "Exile_Item_PlasticBottleFreshWater";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
			_bambiPlayer addItemToBackpack "Exile_Item_InstaDoc";
        };	

//UID Loadout 9												//fecker
        if ((getPlayerUID _requestingPlayer) isEqualTo ("PlacePlayerUIDHere"))exitWith 
        {
			clearWeaponCargo _bambiPlayer; 
			clearMagazineCargo _bambiPlayer;
			_bambiPlayer forceAddUniform "U_C_Uniform_Farmer_01_F"; // adds uniforms
			_bambiPlayer addVest "V_LegStrapBag_black_F";
			_bambiPlayer addBackpack "I_UGV_02_Demining_backpack_F";
			_bambiPlayer addHeadgear "H_Hat_Tinfoil_F";
			_bambiPlayer addWeapon "Exile_Item_XM8";
			_bambiPlayer addWeapon "ItemCompass";
			_bambiPlayer addWeapon "ItemMap";
			_bambiPlayer addWeapon "I_UavTerminal";
			_bambiPlayer addItem "NVGogglesB_blk_F";
			_bambiPlayer assignItem "NVGogglesB_blk_F";	 
			_bambiPlayer addWeapon "rhs_tr8_periscope";
			_bambiPlayer addWeapon "G_Blindfold_01_black_F";
			_bambiPlayer addWeapon "sgun_HunterShotgun_01_F";
			_bambiPlayer addPrimaryWeaponItem "2Rnd_12Gauge_Pellets";
			_bambiPlayer addWeapon "hgun_esd_01_F";
			_bambiPlayer addItemToUniform "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToUniform "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToUniform "2Rnd_12Gauge_Slug";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Pellets";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Slug";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Slug";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Slug";
			_bambiPlayer addItemToVest "2Rnd_12Gauge_Slug";
			_bambiPlayer addItem "Exile_Item_ExtensionCord";
        };	

//If players are not given a loadout by UID number they will automatically be given loadouts below this line based on how much respect they have.	
   case (_Respect > 0 && _Respect < 4999):
   //Bambi
    {
	clearWeaponCargo _bambiPlayer; 
	clearMagazineCargo _bambiPlayer;
     _bambiPlayer forceAddUniform "U_IG_Guerilla2_3";
	 _bambiplayer addVest "V_Rangemaster_belt";
	 _bambiPlayer addBackpack "B_FieldPack_ocamo";
	 [_bambiPlayer,_Tier1PrimaryWeapons,3] call bis_fnc_addWeapon; 	//3 defines how many magazines the player will spawn with. _Tier1PrimaryWeapons point to weapon tier 1 above.
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
   
   case (_Respect > 5000 && _Respect < 9999):
   //Bambi Plus
    {
	clearWeaponCargo _bambiPlayer; 
	clearMagazineCargo _bambiPlayer;
     _bambiPlayer forceAddUniform "U_IG_Guerilla2_1";
	 _bambiplayer addVest "V_BandollierB_blk";
	 _bambiPlayer addBackpack "B_FieldPack_ocamo";
	 [_bambiPlayer,_Tier1PrimaryWeapons,3] call bis_fnc_addWeapon;	 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
 
    case (_Respect > 10000 && _Respect < 14999):
    //Super Bambi
    {
	clearWeaponCargo _bambiPlayer; 
	clearMagazineCargo _bambiPlayer;
     _bambiPlayer forceAddUniform "U_I_G_resistanceLeader_F";
	 _bambiplayer addVest "V_BandollierB_blk";
	 _bambiPlayer addBackpack "B_FieldPack_blk";
	 [_bambiPlayer,_Tier1PrimaryWeapons,3] call bis_fnc_addWeapon; 
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic;
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
 
    case (_Respect > 15000 && _Respect < 19999):
    //Definetly Not a Bambi
    {
	clearWeaponCargo _bambiPlayer; 
	clearMagazineCargo _bambiPlayer;
     _bambiPlayer forceAddUniform "U_IG_Guerilla1_1";
	 _bambiplayer addVest "V_BandollierB_blk";
	 _bambiPlayer addBackpack "B_FieldPack_blk";
	 [_bambiPlayer,_Tier1PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic;
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
 
    case (_Respect > 20000 && _Respect < 24999):
    //Woodman
    {
	clearWeaponCargo _bambiPlayer; 
	clearMagazineCargo _bambiPlayer;
     _bambiPlayer forceAddUniform "U_C_HunterBody_grn";
	 _bambiplayer addVest "V_BandollierB_blk";
	 _bambiPlayer addBackpack "B_FieldPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetB_plain_blk";
	 [_bambiPlayer,_Tier1PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic;	 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 25000 && _Respect < 29999):
    //Robber
    {
	clearWeaponCargo _bambiPlayer; 
	clearMagazineCargo _bambiPlayer;
     _bambiPlayer forceAddUniform "Exile_Uniform_Woodland";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_FieldPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetB_plain_blk";
	 [_bambiPlayer,_Tier2PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 30000 && _Respect < 34999):
    //Hunter
    {
     _bambiPlayer forceAddUniform "Exile_Uniform_Woodland";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_FieldPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetB_plain_blk";
	 [_bambiPlayer,_Tier2PrimaryWeapons,3] call bis_fnc_addWeapon; 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 35000 && _Respect < 39999):
    //Worker
    {
     _bambiPlayer forceAddUniform "Exile_Uniform_Woodland";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_FieldPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetB_plain_blk";
	 [_bambiPlayer,_Tier2PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic;	 	 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 40000 && _Respect < 44999):
    //Murderer
    {
     _bambiPlayer forceAddUniform "Exile_Uniform_Woodland";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_FieldPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetCrew_B";
	 [_bambiPlayer,_Tier2PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic;		 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 45000 && _Respect < 49999):
    //Prisoner
    {
     _bambiPlayer forceAddUniform "Exile_Uniform_Woodland";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_AssaultPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetCrew_B";
	 [_bambiPlayer,_Tier2PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic;	 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 50000 && _Respect < 59999):
    //Prisoner
    {
     _bambiPlayer forceAddUniform "U_I_GhillieSuit";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_AssaultPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetCrew_B";
	 [_bambiPlayer,_Tier3PrimaryWeapons,3] call bis_fnc_addWeapon; 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 60000 && _Respect < 69999):
    //KUT AK
    //Prisoner
    {
     _bambiPlayer forceAddUniform "U_I_GhillieSuit";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_AssaultPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetCrew_B";
	 [_bambiPlayer,_Tier3PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 70000 && _Respect < 79999):
    //Prisoner
    {
     _bambiPlayer forceAddUniform "U_I_Wetsuit";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_AssaultPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetCrew_B";
	 [_bambiPlayer,_Tier3PrimaryWeapons,3] call bis_fnc_addWeapon;	 
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic;	 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 80000 && _Respect < 89999):
    //Prisoner
    {
     _bambiPlayer forceAddUniform "U_I_Wetsuit";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_AssaultPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetCrew_B";
	 [_bambiPlayer,_Tier4PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 90000 && _Respect < 99999):
    //Prisoner
    {
     _bambiPlayer forceAddUniform "U_B_FullGhillie_ard";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_AssaultPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetSpecB";
	 [_bambiPlayer,_Tier4PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic; 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
    case (_Respect > 100000 && _Respect < 9999999999):
    //Prisoner
    {
     _bambiPlayer forceAddUniform "U_B_FullGhillie_ard";
	 _bambiplayer addVest "V_HarnessO_gry";
	 _bambiPlayer addBackpack "B_AssaultPack_blk";
	 _bambiPlayer addHeadgear "H_HelmetSpecB";
	 [_bambiPlayer,_Tier4PrimaryWeapons,3] call bis_fnc_addWeapon;
	 _bambiPlayer addPrimaryWeaponItem _RndmOptic;	 
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
    };
	
   default
    {  
	clearWeaponCargo _bambiPlayer; 
	clearMagazineCargo _bambiPlayer;
     _bambiPlayer forceAddUniform "U_IG_Guerilla2_3";
	 _bambiplayer addVest "V_Rangemaster_belt";
	 _bambiPlayer addBackpack "B_FieldPack_ocamo";
	 [_bambiPlayer,_Tier1PrimaryWeapons,3] call bis_fnc_addWeapon; 	//3 defines how many magazines the player will spawn with. _Tier1PrimaryWeapons point to weapon tier 1 above.
	 _bambiPlayer addWeapon "Exile_Item_XM8";
	 _bambiPlayer addWeapon "ItemCompass";
	 _bambiPlayer addWeapon "ItemMap";
	 _bambiPlayer addWeapon "ItemGPS";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
	 _bambiplayer addItem "Exile_Item_InstaDoc";
     _bambiplayer addItem "Exile_Item_PlasticBottleCoffee";
	 _bambiplayer addItem "Exile_Item_EMRE";
     _bambiplayer addItem "Exile_Item_ExtensionCord";
	 _bambiplayer addItem "Exile_Item_ExtensionCord";
     };
};

if((canTriggerDynamicSimulation _bambiPlayer) isEqualTo false) then 
{
    _bambiPlayer triggerDynamicSimulation true; 
};
_bambiPlayer addMPEventHandler ["MPKilled", {_this call ExileServer_object_player_event_onMpKilled}];
_bambiPlayer call ExileServer_object_player_database_insert;
_bambiPlayer call ExileServer_object_player_database_update;
[
    _sessionID, 
    "createPlayerResponse", 
    [
        _bambiPlayer, 
        _parachuteNetID, 
        str (_accountData select 0),
        (_accountData select 1),
        (_accountData select 2),
        100,
        100,
        0,
        (getNumber (configFile >> "CfgSettings" >> "BambiSettings" >> "protectionDuration")) * 60, 
        _clanData,
        _spawnType
    ]
] 
call ExileServer_system_network_send_to;
[_sessionID, _bambiPlayer] call ExileServer_system_session_update;
true