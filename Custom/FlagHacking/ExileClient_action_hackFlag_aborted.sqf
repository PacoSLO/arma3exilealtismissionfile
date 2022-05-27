player setVariable ["ExileIsHacking", false, true];
["updateFlagHackAttemptRequest", [netId _this]] call ExileClient_system_network_send;
["ErrorTitleOnly", ["Hacking aborted!"]] call ExileClient_gui_toaster_addTemplateToast;