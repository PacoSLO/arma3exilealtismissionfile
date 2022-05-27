waitUntil {!isNull findDisplay 46 && !isNil 'ExileClientLoadedIn' && getPlayerUID player != ''};
uiSleep 45;

_playerUID = getPlayerUID player;
{
	_flag = _x;
	_buildRights = _flag getVariable ["ExileTerritoryBuildRights", []];
	if (_playerUID in _buildRights) then
		{
			
			_territoryName = _flag getVariable ["ExileTerritoryName", ""];
			if ((_flag getVariable ["ExileFlagStolen", 0]) isEqualTo 1) then 
				{
					["ErrorTitleOnly", [format["The flag for <t color='#FF0000'>%1</t> has been stolen!!<br/><t color='#FF0000'>Restore it at the Office Trader.</t>",_territoryName]]] call ExileClient_gui_toaster_addTemplateToast;
				}
				else
				{
					_nextDueDate = _flag getVariable ["ExileTerritoryMaintenanceDue", [0, 0, 0, 0, 0]];

					_dueDate = format
					[
					"%3/%2/%1",
					_nextDueDate select 0,
					_nextDueDate select 1,
					_nextDueDate select 2
					];

					["InfoTitleAndText", ["Territory Information", format ["Payment Due for: <t color='#E48A36'>%2</t><br/>Date: <t color='#E48A36'>%1</t><br/>Pay Protection for your Flag!",_dueDate,_territoryName]]] call ExileClient_gui_toaster_addTemplateToast;
				};

		};
}
forEach (allMissionObjects "Exile_Construction_Flag_Static");
true
