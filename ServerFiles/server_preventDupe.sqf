prevent_dupe = {
	private ["_player","_text","_type","_txt","_txt2"];
	_player = _this select 0;
	_text = _this select 1;
	_type = _this select 2;
	
	switch (_type) do {
		case "dupeCheck": {
			diag_log format ["DC DUPE: Start checking if %1 is connected to session!",name _player];
			[_player,_text] spawn {
				private ["_player","_i","_object","_name","_puid","_txt","_check"];
				_player = _this select 0;
				_object = _this select 1;
				_i = 0;
				_name = (name _player);
				_puid = (getPlayerUID _player);
				// 5 connection attempts, approx. 5secs
				while {_i <= 4} do {
					_check = isPlayer _player;
					if !(_check) exitWith { // If someone lost connection after the gear menu, we found our duper!
						diag_log format ["DC DUPE: %1 (%2) lost the connection to the session! Cleared BackpackCargo!",_name,_puid]; //Print to log
						clearBackpackCargoGlobal _object; // Delete the duped backpacks (You can edit here some extra stuff, eg. deleting the storage unit)
						_txt = format ["%1  (%2)  lost connection  (DC Dupe)  @%3  %4",(name _player),(getPlayerUID _player),(mapGridPosition _player),typeOf _object];
						
						{
							if ((getPlayerUID _x) in ["0","0"]) then { // <--- Put here some admin UIDs to receive a message ingame.
								PlayerCheckDupe = [toArray _txt,"sChat",_x];
								(owner _player) publicVariableClient "PlayerCheckDupe";
							};
						} forEach playableUnits;
					};
					uiSleep 1;
					_i = _i + 1;
					if (_i >= 5) exitWith {
						diag_log format ["DC DUPE: %1 is still connected to the session!",name _player];
					};
				};
			};
		};
		case "dcdupe": {
			// if a player join the server after he tried to dupe, this part will be executed
			_debug = format ["DC DUPE ATTEMPT: %1 (%2) attempted to dupe @%3 | Storage Unit:  %4",(name _player),(getPlayerUID _player),(mapGridPosition _player),typeOf _text];
			_txt = format ["%1  (%2)  DC Dupe Attempt @%3  %4",(name _player),(getPlayerUID _player),(mapGridPosition _player),typeOf _text];
			{
				if ((getPlayerUID _x) in ["0","0"]) then { // <--- Put here some admin UIDs to receive a message ingame.
					PlayerCheckDupe = [toArray _txt,"sChat",_x];
					(owner _player) publicVariableClient "PlayerCheckDupe";
				};
			} forEach playableUnits;
			
			_txt2 = format ["%1, Duping is a non-excusable offence! Stop it or you will be banned!",(name _player)]; // Send the duper a nice message!
			PlayerCheckDupe = [toArray _txt2,"sChat",_player];
			(owner _player) publicVariableClient "PlayerCheckDupe";
		};
		case "val": {
			// resetting the variable
			PlayerCheckDupe = [toArray ("DupeObject setVariable [PlayervarName,false,true];"),"set",_player];
			(owner _player) publicVariableClient "PlayerCheckDupe";
		};
	};
};
"PVDZE_dupe" addPublicVariableEventHandler {(_this select 1) call prevent_dupe;};

Dupe_Check = {
	private ["_code","_type","_player"];
	_code = _this select 0;
	_type = _this select 1;
	_player = _this select 2;
	if (_player != player) exitWith {};
	switch (_type) do {
		case "sChat": {systemChat (toString _code);};
		case "set": {call compile (toString _code);};
	};
};
publicVariable "Dupe_Check";
