_player = _this select 0;
_costs = _this select 1;
_money = _player getVariable ["ExileMoney", 0];
_money = _money - _costs;
_player setVariable ["ExileMoney", _money, true];
format["setPlayerMoney:%1:%2", _Money, _player getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
[_player, "purchaseVehicleSkinResponse", [0, str _money]] call ExileServer_system_network_send_to;
true