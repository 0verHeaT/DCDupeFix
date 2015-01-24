private ["_cTarget","_isOk","_display","_inVehicle"];
disableSerialization;
_display = (_this select 0);
_inVehicle = (vehicle player) != player;
_cTarget = cursorTarget;
if(_inVehicle) then {
	_cTarget = (vehicle player);
};

_isOk = false;
{
	if(!_isOk) then {
		_isOk = _cTarget isKindOf _x;
	};
} forEach ["LandVehicle","Air", "Ship"];

if((locked _cTarget) && _isOk && (((vehicle player) distance _cTarget) < 12)) then {
	cutText [(localize "str_epoch_player_7") , "PLAIN DOWN"];
	_display closeDisplay 1;
};

[_cTarget] spawn {
	private ["_transportMax","_obj","_maxdis"];
	_obj = _this select 0;
	if !(canbuild) exitWith {};
	if (_obj isKindOf "AllVehicles") then {_maxdis = 10;} else {_maxdis = 5;};
	if ((player distance _obj) > _maxdis) exitWith {};
	if (vehicle player != player || isPlayer _obj) exitWith {};

	_transportMax = (getNumber (configFile >> "CfgVehicles" >> (typeof _obj) >> "transportMaxWeapons") + getNumber (configFile >> "CfgVehicles" >> (typeof _obj) >> "transportMaxMagazines") + getNumber (configFile >> "CfgVehicles" >> (typeof _obj) >> "transportMaxBackpacks"));
	if (_transportMax < 1 || (typeOf _obj) == "WeaponHolder") exitWith {};

	if (isNil "GearDisplay") then {GearDisplay = false;};
	if (isNil "DupeObject") then {DupeObject = objNull;};
	
	if (GearDisplay/* && _obj == DupeObject*/) exitWith {
		waitUntil {str(FindDisplay 106) == "Display #106"};
		(FindDisplay 106) closeDisplay 0;
		cutText["\n\nDupe Protection: Please wait a second to access gear!","PLAIN DOWN"];
	};
	
	waitUntil {str(FindDisplay 106) == "Display #106"};
	uiSleep 0.5;
	if (str(FindDisplay 106) == "No Display") exitWith {};
	
	if (GearDisplay) exitWith {};
	GearDisplay = true;
	DupeObject = _obj;
	PlayervarName = "DupeVar_" + (getPlayerUID player);
	uiSleep 0.5;
	if (DupeObject getVariable [PlayervarName,false]) then {
		PVDZE_dupe = [player,DupeObject,"dcdupe"];
		publicVariableServer "PVDZE_dupe";
		//systemChat format ["<OCG - REMOTE>: %1, Duping is a non-excusable offence! Stop it or you will be banned!",(name _player)];
	};
	uiSleep 0.2;
	DupeObject setVariable [PlayervarName,true,true];

	waitUntil {str(FindDisplay 106) == "No Display"};

	PVDZE_dupe = [player,DupeObject,"dupeCheck"];
	publicVariableServer "PVDZE_dupe";
	uiSleep 1;
	PVDZE_dupe = [player,"","val"];
	publicVariableServer "PVDZE_dupe";
	uiSleep 2;
	//uiSleep 1.4;
	//if (DupeObject getVariable [PlayervarName,true]) then {(findDisplay 46) closeDisplay 0;};
	GearDisplay = false;
	DupeObject = objNull;
};
