private["_minutes", "_duration"];
_minutes = getNumber (missionConfigFile >> 'CfgFlagHacking' >> 'hackDuration');
_duration = _minutes * 60;
_duration