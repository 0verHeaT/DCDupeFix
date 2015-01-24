server_checkLoop = {
	private ["_player","_i","_object","_name","_puid","_txt","_currentvar"];
	//diag_log format ["DC DUPE: Start checking if %1 is connected to session!",name _player];
	_player = _this select 0;
	_object = _this select 1;

	_name = (name _player);
	_puid = (getPlayerUID _player);

	_currentvar = "DCheckLoop_" + _puid;

	if (_player getVariable [_currentvar,false]) exitWith {};
	_player setVariable [_currentvar,true,false];

	_i = 0;

	while {_i <= 4} do {
		_check = isPlayer _player;
		if !(_check) exitWith {
			diag_log format ["DC DUPE: %1 (%2) lost the connection to the session! Cleared BackpackCargo!",_name,_puid];
			clearBackpackCargoGlobal _object; // Delete the duped backpacks
			
			_txt = format ["%1  (%2)  lost connection  (DC Dupe)  @%3  %4",_name,_puid,(mapGridPosition _player),typeOf _object];
			{
				if ((getPlayerUID _x) in ["0","0"]) then { // <--- Put here some admin UIDs to receive a message ingame.
					PlayerCheckDupe = [toArray _txt,"sChat",_x];
					(owner _player) publicVariableClient "PlayerCheckDupe";
				};
			} forEach playableUnits;
			
			// If you use infistar AH you can log the dupe attempt
			/*
				_log = format ["%1 (%2) lost connection near %3 @%4",_name,_puid,_object,(mapGridPosition _player)];
				"HackLog" callExtension (format[" %1   |   Custom HackLog",_log]);
				PV_hackerL0og = PV_hackerL0og + [[_log,"","0","1","0","0",[]]];
				publicVariable "PV_hackerL0og";
				
			*/
			
			_player setVariable [_currentvar,false,false];
		};
		uiSleep 1;
		_i = _i + 1;
		if (_i >= 5) exitWith {_player setVariable [_currentvar,false,false];};
	};
};

prevent_dupe = {
	private ["_player","_text","_type","_txt","_txt2"];
	_player = _this select 0;
	_text = _this select 1;
	_type = _this select 2;
	
	switch (_type) do {
		case "dupeCheck": {[_player,_text] spawn server_checkLoop;};
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
