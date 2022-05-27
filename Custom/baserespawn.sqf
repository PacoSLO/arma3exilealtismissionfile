private["_display","_spawnButton","_listBox","_listItemIndex","_numberOfSpawnPoints","_randNum","_randData","_randomSpawnIndex"];

if(isNil "spawnRegistry") then 
{
	spawnRegistry = [];
};

fn_checkRespawnDelay = {
	_markerName = _this select 0;
	if(isNil "_markerName") exitWith { diag_log "checkRespawn: invalid parameter 1"; true; };
	
	diag_log format["checkRespawn: Checking flag %1...", _markerName];
	
	_counter = 0;
	{

		
		_name = _x select 0;
		_time = _x select 1;
		
		if(isNil "_name") exitWith { true; };
		if(isNil "_time") exitWith { true; };
		
		diag_log format["checkRespawn: checking flag %1, with reg %2", _markerName, _name];
		if(_name isEqualTo _markerName) then 
		{
			if(_time > time-300) then 
			{
				_counter = _counter + 1;
			};
		};
	} forEach spawnRegistry;
	diag_log format["checkRespawn: counter for flag %1 = %2",_markerName, _counter];
	
	if(_counter >= 1) exitWith
	{
		diag_log format["checkRespawn: returned false"];
		false;
	};
	
	diag_log format["checkRespawn: returned true"];
	true;
};

disableSerialization;
diag_log "Selecting spawn location...";
ExileClientSpawnLocationSelectionDone = false;
ExileClientSelectedSpawnLocationMarkerName = "";
createDialog "RscExileSelectSpawnLocationDialog";
waitUntil {_display = findDisplay 24002;!isNull _display};
_display displayAddEventHandler ["KeyDown", "_this call ExileClient_gui_loadingScreen_event_onKeyDown"];
_listBox = _display displayCtrl 24002;
lbClear _listBox;
{
	if (getMarkerType _x == "ExileSpawnZone") then
	{
		_name = markerText _x;
//		if(! ( [_name] call fn_checkRespawnDelay) ) exitWith { diag_log format["checkRespawn returned false for spawn zone: %1, respawn disabled",_name]; };
		
		diag_log format["Adding spawn zone: %1",markerText _x];
		
		_listItemIndex = _listBox lbAdd (markerText _x);
		_listBox lbSetData [_listItemIndex, _x];
		
	};
} forEach allMapMarkers;
// _numberOfSpawnPoints = {getMarkerType _x == "ExileSpawnZone"} count allMapMarkers;
// if(_numberOfSpawnPoints > 0)then 
// {
	// _randNum = floor(random _numberOfSpawnPoints);
	// _randData = lbData [24002,_randNum];
	// _randomSpawnIndex = _listBox lbAdd "Random";
	// _listBox lbSetData [_randomSpawnIndex, _randData];
// };

defaultLBsize = lbSize _listBox;
myUID = getPlayerUID player;
myFlags = [];
{
	_flag = _x;
	_owner = _flag getVariable ["ExileOwnerUID", ""];
    _arrBuildRights = _x getVariable["ExileTerritoryBuildRights",[]]; // by Nerexis
	
	if(myUID isEqualTo _owner OR ( !(isNil "_arrBuildRights") AND (count _arrBuildRights>0) AND (myUID in _arrBuildRights) ) )then
	{
		
		
		_name = _flag getVariable ["ExileTerritoryName", ""];
		
		if(! ( [_name] call fn_checkRespawnDelay) ) exitWith { diag_log format["checkRespawn returned false for flag: %1, respawn disabled",_name]; };
		
		_lbid = _listBox lbAdd (_flag getVariable ["ExileTerritoryName", ""]);
		_listBox lbSetColor [_lbid, [0,0.68,1,1]];
		_listBox lbSetData [_lbid,str(count myFlags)];
		myFlags pushBack _flag;
		
		// localmarkerName = format['LOCALFLAG_%1',myUID];
		// deleteMarkerLocal localmarkerName;
		// _marker = createMarkerLocal [localmarkerName,getPosATL _flag];
		// _marker setMarkerShapeLocal "ICON";
		// _marker setMarkerTypeLocal "loc_Bunker";
		// _marker setMarkerColorLocal "ColorGreen";
		// _marker setMarkerSize [3, 3];
		// _marker setMarkerTextLocal (_flag getVariable ["ExileTerritoryName", ""]);
	};
} forEach (allMissionObjects "Exile_Construction_Flag_Static");


fnc_LBSelChanged_24002 = {
	disableSerialization;
	_ctrl = _this select 0;
	_curSel = lbCurSel _ctrl;
	if(_curSel < defaultLBsize)then
	{
		_this call ExileClient_gui_selectSpawnLocation_event_onListBoxSelectionChanged;
	}
	else
	{
		_data = _ctrl lbData _curSel;
		_num = parseNumber _data;
		_flag = myFlags select _num;
		
		
		markerName = format['FLAG_%1',myUID];
		deleteMarker markerName;
		createMarker [markerName,getPosATL _flag];
		ExileClientSelectedSpawnLocationMarkerName = markerName;
		
		// localmarkerName = format['LOCALFLAG_%1',myUID];
		// deleteMarkerLocal localmarkerName;
		// _marker = createMarkerLocal [localmarkerName,getPosATL _flag];
		// _marker setMarkerShapeLocal "ICON";
		// _marker setMarkerTypeLocal "loc_Bunker";
		// _marker setMarkerColorLocal "ColorGreen";
		// _marker setMarkerSize [3, 3];
		// _marker setMarkerTextLocal (_flag getVariable ["ExileTerritoryName", ""]);
		
		_mapControl = (findDisplay 24002) displayCtrl 24001;
		_mapControl ctrlMapAnimAdd [1, 0.1, getMarkerPos ExileClientSelectedSpawnLocationMarkerName]; 
		ctrlMapAnimCommit _mapControl;
	};
};
_listBox ctrlRemoveAllEventHandlers "LBSelChanged";
_listBox ctrlAddEventHandler ["LBSelChanged", "_this call fnc_LBSelChanged_24002;"];

fnc_ButtonClick_24003 = {
	disableSerialization;
	
	_display = nil;
	waitUntil {_display = findDisplay 24002;!isNull _display};
	_lB = _display displayCtrl 24002;
	_curSel = lbCurSel _lB;
	_data = _lB lbData _curSel;
	_num = parseNumber _data;
	_flag = myFlags select _num;
	_name = lbText [24002, _curSel]; //_flag getVariable ["ExileTerritoryName", ""];
	//spawnRegistry pushBack [_name, time];	
	spawnRegistry pushBack [_name, time];
	
	//diag_log format["Plr selected spawn %1", lbText [24002, _curSel]];
	diag_log format["Plr respawning at flag %1 - time: %2",_name, _time];
	
	[] call ExileClient_gui_selectSpawnLocation_event_onSpawnButtonClick;
	
	
	
	// if(!isNil 'markerName')then
	// {
		// [] spawn {
			// waitUntil {!isNil 'ExileClientLoadedIn'};
			// uiSleep 3;
			// deleteMarker markerName;
			// deleteMarkerLocal localmarkerName;
		// };
	// };
};
_spawnButton = _display displayCtrl 24003;
_spawnButton ctrlRemoveAllEventHandlers "ButtonClick";
_spawnButton ctrlSetEventHandler["ButtonClick","call fnc_ButtonClick_24003"];
_spawnButton ctrlSetText "Spawn!";
_spawnButton ctrlEnable true;
_spawnButton ctrlCommit 0;

true