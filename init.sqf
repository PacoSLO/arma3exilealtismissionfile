[] execVM "R3F_LOG\init.sqf";
[] execVM "Custom\EnigmaRevive\init.sqf";
[] execVM "Custom\HaloParachute\init.sqf";
[] execVM "MarXet\MarXet_Init.sqf";
[] execVM "GF_Earplugs\GF_Earplugs.sqf";

call compileFinal preprocessFileLineNumbers "takegive_poptab_init.sqf";

if(hasInterface) then{
    call compileFinal preprocessFileLineNumbers "service_point.sqf";
