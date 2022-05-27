if(isServer)then{
	takegive_poptab = compileFinal preprocessFileLineNumbers "takegive_poptab.sqf";
	"takegive_poptab" addPublicVariableEventHandler {(_this select 1) call takegive_poptab};
};
if(hasInterface)then{
	isTradeEnabled = true;
};