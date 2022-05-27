class CfgRemoteExec
{
	class Functions
	{
		mode = 1;
		jip = 0;
		class fnc_AdminReq { allowedTargets=2; };	// infiSTAR AntiHack
		class fn_xm8apps_server { allowedTargets=2; };	// infiSTAR xm8apps
		class ExileServer_system_network_dispatchIncomingMessage { allowedTargets=2; };	// ExileMod
		class ExAdServer_fnc_clientRequest { allowedTargets=2; }; //ExAD
	};
	class Commands
	{
		mode=0;
		jip=0;
	};
};