DC Dupe Fix
=============
This is a possible way to prevent players duping their gear through disconnection.
This script basically checks whether a player is connected to the session while he is inside his gear menu.
If the connection is interrupted the server clears possible duped gear out of the storage unit where the selected player lost his connection.

NOTE: This is experimental and can contain some bugs. If you notice any issues report them to me.

##### Installation

1.  Copy the server_preventDupe.sqf to \z\addons\dayz_server\init\
2.  In your server_function.sqf put this line at the top

	[] execVM "\z\addons\dayz_server\init\server_preventDupe.sqf";

3.  Open your init.sqf in your mission file and add this line

	"PlayerCheckDupe" addPublicVariableEventHandler {
		(_this select 1) call {[_this select 0,_this select 1,_this select 2] call Dupe_Check;}
	};
  
right after

	if (!isDedicated) then {
  
4.  Copy your fn_gearMenuChecks.sqf to your mission file and add this line to your custom compiles

	fn_gearMenuChecks = compile preprocessFileLineNumbers ""+YOURPATH+"\fn_gearMenuChecks.sqf";
  
Done
