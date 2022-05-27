private["_display", "_killDeathRatio", "_killDeathRatioControl", "_popTabsValue", "_popTabs", "_respectValue", "_respect", "_popTabsAmount"];
disableSerialization;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
if (ExileClientPlayerDeaths < 1) then 
{
	_killDeathRatio = ExileClientPlayerKills;
}
else 
{
	_killDeathRatio = [ExileClientPlayerKills / ExileClientPlayerDeaths, 2] call ExileClient_util_math_round;
};
_killDeathRatioControl = _display displayCtrl 4057;
_killDeathRatioControl ctrlSetTooltip format ["%1 Kills / %2 Deaths", ExileClientPlayerKills, ExileClientPlayerDeaths];
_killDeathRatioControl ctrlSetStructuredText parseText (format ["<t color='#00b2cd' font='OrbitronLight' size='1.4' valign='middle' align='center' shadow='2'><br/><br/><br/><t font='OrbitronMedium' size='3' color='#ffffff'>%1</t><br/>K/D</t>", _killDeathRatio]);
_popTabsAmount = (player getVariable ["ExileLocker", 0]);
_popTabsValue = _popTabsAmount;
if (_popTabsAmount > 999) then
{
	_popTabsValue = format ["%1k", floor (_popTabsAmount / 1000)];
};
if (_popTabsAmount > 999999) then
{
	_popTabsValue = format ["%1m", floor (_popTabsAmount / 1000000)];
};
_popTabs = _display displayCtrl 4058;
_popTabs ctrlSetTooltip format["You have %1 Pop Tabs in your locker", _popTabsValue];
_popTabs ctrlSetStructuredText parseText (format ["<t color='#00b2cd' font='OrbitronLight' size='1.4' valign='middle' align='center' shadow='2'><br/><br/><br/><t font='OrbitronMedium' size='3' color='#ffffff'>%1</t><br/>POP TABS</t>", _popTabsValue]);
_respect = ExileClientPlayerScore;
_respectValue = _respect;
if (_respect > 999) then
{
	_respectValue = format ["%1k", floor (_respect / 1000)];
};
if (_respect > 999999) then
{
	_respectValue = format ["%1m", floor (_respect / 1000000)];
};
_respect = _display displayCtrl 4059;
_respect ctrlSetTooltip format["You have %1 respect", _respectValue];
_respect ctrlSetStructuredText parseText (format ["<t color='#00b2cd' font='OrbitronLight' size='1.4' valign='middle' align='center' shadow='2'><br/><br/><br/><t font='OrbitronMedium' size='3' color='#ffffff'>%1</t><br/>RESPECT</t>", _respectValue]);