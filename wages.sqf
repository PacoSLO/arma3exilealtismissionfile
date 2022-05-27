if((player call ExileClient_util_world_isInOwnTerritory) or (ExilePlayerInSafezone)) then
{
    _paycheck = 0;
    ["ErrorTitleAndText",["BB WAGE", format ["You do not earn Poptabs reward in Safezones and your Base!"]]] call ExileClient_gui_toaster_addTemplateToast;
}
else
{
    _paycheck = 750;
    _pay = (player getVariable ["ExileMoney", 0]);
    _pay = _pay + _paycheck;
    ["SuccessTitleAndText", ["BB WAGE", format ["You received +%1 <img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/><br/>You have now %2 <img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _paycheck, _pay]]] call ExileClient_gui_toaster_addTemplateToast;
    player setVariable ["ExileMoney",_pay,true];
    call ExileClient_object_player_stats_update;
};
