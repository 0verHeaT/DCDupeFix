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
	private ["_transportMax","_obj"];
	_obj = _this select 0;
	if !(canbuild) exitWith {};
	if ((player distance _obj) > 10) exitWith {};
	if (vehicle player != player || isPlayer _obj) exitWith {};

	_transportMax = (getNumber (configFile >> "CfgVehicles" >> (typeof _obj) >> "transportMaxWeapons") + getNumber (configFile >> "CfgVehicles" >> (typeof _obj) >> "transportMaxMagazines") + getNumber (configFile >> "CfgVehicles" >> (typeof _obj) >> "transportMaxBackpacks"));
	if (_transportMax < 1 || (typeOf _obj) == "WeaponHolder") exitWith {};

	if (isNil "GearDisplay") then {GearDisplay = false;};
	if (isNil "DupeObject") then {DupeObject = objNull;};
	
	if (GearDisplay/* && _obj == DupeObject*/) exitWith {
		waitUntil {str(FindDisplay 106) == "Display #106"};
		(FindDisplay 106) closeDisplay 0;
		cutText["\n\nPlease wait a moment to open your gear!","PLAIN DOWN"];
	};
	
	waitUntil {str(FindDisplay 106) == "Display #106"};
	
	GearDisplay = true;
	DupeObject = _obj;
	PlayervarName = "DupeVar_" + (getPlayerUID player);
	if (DupeObject getVariable [PlayervarName,false]) then {
		PVDZE_dupe = [player,DupeObject,"dcdupe"];
		publicVariableServer "PVDZE_dupe";
	};
	uiSleep 0.2;
	DupeObject setVariable [PlayervarName,true,true];

	waitUntil {str(FindDisplay 106) == "No Display"};

	uiSleep 0.2;
	PVDZE_dupe = [player,DupeObject,"dupeCheck"];
	publicVariableServer "PVDZE_dupe";
	uiSleep 1.2;
	PVDZE_dupe = [player,"","val"];
	publicVariableServer "PVDZE_dupe";
	uiSleep 0.4;
	// This would not work on populated servers
	//uiSleep 1.4;
	//if (DupeObject getVariable [PlayervarName,true]) then {(findDisplay 46) closeDisplay 0;};
	GearDisplay = false;
	DupeObject = objNull;
};
