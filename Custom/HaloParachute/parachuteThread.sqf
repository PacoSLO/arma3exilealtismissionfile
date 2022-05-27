/*  
	Parachute from ExAd.. Modified by [FPS]kuplion
*/

// No need for a parachute if you're not loaded in!!
//waitUntil {!isNil "ExileClientLoadedIn"};
//waitUntil {ExileClientLoadedIn};
//waitUntil {alive player};

// Those living sure do love parachutes!
if (alive player) then
{
	// I can haz actions?
	if (ExAd_HALOPARACHUTE_USE_ACTIONS) then
	{
		if (isNil "ExAd_ACTION_PARACHUTE") then
		{
			ExAd_ACTION_PARACHUTE  = player addAction ["<t color='#E48A36'><img image='\a3\ui_f\data\gui\cfg\CommunicationMenu\supplydrop_ca.paa' /> Open Parachute!</t>", "call ExAd_fnc_pullParachute", [], 6, true, true, "", "call ExAd_fnc_showParachute"];
		};
		
		if (isNil "ExAd_ACTION_EJECT") then
		{
			ExAd_ACTION_EJECT  = player addAction ["<t color='#E48A36'><img image='\a3\ui_f\data\gui\cfg\CommunicationMenu\supplydrop_ca.paa' /> Halo Jump!</t>", "call ExAd_fnc_ejectPlayer", [], 6, false, true, "", "call ExAd_fnc_showEject;"];
		};
	};

	// Mash those keys to eject..
	if (ExAd_HALOPARACHUTE_USE_KEY_ACTIONS) then
	{
		if ((getPos player) select 2 > ExAd_ACTION_EJECT_HEIGHT) then
		{
			ExAd_ACTION_HALOPARACHUTE_USE_KEY_ACTIONS = (findDisplay 46) displayAddEventHandler ["KeyDown",
			{
				if (_this select 1 == 47 && _this select 2 && _this select 4) then
				{
					if (vehicle player != player) then
					{
						call ExAd_fnc_ejectPlayer;
					}
					else
					{
						if (call ExAd_fnc_showParachute) then
						{
							call ExAd_fnc_pullParachute;
						};
					};
				};
			}];
		};
	};
};

// Dead folks probably don't parachute..
if !(alive player) then
{
	if (ExAd_HALOPARACHUTE_USE_ACTIONS) then
	{
		if !(isNil "ExAd_ACTION_PARACHUTE") then
		{
			player removeAction ExAd_ACTION_PARACHUTE;
			ExAd_ACTION_PARACHUTE = nil;
		};
		
		if !(isNil "ExAd_ACTION_EJECT") then
		{
			player removeAction ExAd_ACTION_EJECT;
			ExAd_ACTION_EJECT = nil;
		};
	};

	if (ExAd_HALOPARACHUTE_USE_KEY_ACTIONS) then
	{
		if !(isNil "ExAd_ACTION_HALOPARACHUTE_USE_KEY_ACTIONS") then
		{
			(findDisplay 46) displayRemoveEventHandler ["KeyDown", ExAd_ACTION_HALOPARACHUTE_USE_KEY_ACTIONS];
		};
	};
};