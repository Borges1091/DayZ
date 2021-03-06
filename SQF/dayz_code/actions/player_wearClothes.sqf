if (dayz_lastClothesChange + 5 > diag_tickTime) exitWith {localize "str_player_actionslimit" call dayz_rollingMessages;};
dayz_lastClothesChange = diag_tickTime;
/*
_item call player_wearClothes;
TODO: female
*/
private ["_item","_onLadder","_hasclothesitem","_config","_text","_isFemale","_myModel","_humanity","_isBandit","_isHero",
"_itemNew","_model","_skinToArray","_finalArray","_skinToModel"];

_item = _this;
call gear_ui_init;
r_action_count = 0; //reset for strange glitch
_onLadder = (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {localize "str_player_21" call dayz_rollingMessages;};

_hasclothesitem = _this in magazines player;
_config = configFile >> "CfgMagazines";
_text = getText (_config >> _item >> "displayName");

if (!_hasclothesitem) exitWith {format[localize "str_player_31",_text,localize "str_player_31_wear"] call dayz_rollingMessages;};

if (vehicle player != player) exitWith {localize "str_player_fail_wear1" call dayz_rollingMessages;};

_isFemale = ((typeOf player == "SurvivorW2_DZ")||(typeOf player == "BanditW1_DZ"));
if (_isFemale) exitWith {localize "str_player_fail_wear2" call dayz_rollingMessages;};

_myModel = (typeOf player);
_humanity = player getVariable ["humanity",0];
_isBandit = _humanity < -2000;
_isHero = _humanity > 5000;
_itemNew = "Skin_" + _myModel;

if ( !(isClass(_config >> _itemNew)) ) then {
	_itemNew = if (!_isFemale) then {"Skin_Survivor2_DZ"} else {"Skin_SurvivorW2_DZ"};
};

_skinToArray = toArray (_item);
_skinToArray set [0,"del"];
_skinToArray set [1,"del"];
_skinToArray set [2,"del"];
_skinToArray set [3,"del"];
_skinToArray set [4,"del"];
_finalArray = _skinToArray - ["del"];
_skinToModel = toString (_finalArray);

_model = _skinToModel;
	
if (_item == "Skin_Survivor2_DZ") then {
	if (_isBandit) then {
		_model = "Bandit1_DZ";
	};
	if (_isHero) then {
		_model = "Survivor3_DZ";
	};
};

if (_model != _myModel) then {
	player removeMagazine _item;
	player addMagazine _itemNew;
	[dayz_playerUID, dayz_characterID, _model] spawn player_humanityMorph;
};