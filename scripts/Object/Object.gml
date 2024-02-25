enum OBJECT_TYPE {
	INTEGER,
	BOOLEAN,
	NULL,
}

function Object() constructor{
	Type = function() {}; // string : object type
	Inspect = function() {};
}

function Integer(val=undefined) : Object() constructor{
	value = val; // int
	Type = function() { return global.object_type_str[? OBJECT_TYPE.INTEGER]; }
	Inspect = function(){ return string(value); }
}

function Boolean(val=undefined) : Object() constructor{
	value = val; // bool
	Type = function() { return global.object_type_str[? OBJECT_TYPE.BOOLEAN]; }
	Inspect = function(){ return string(value); }
}

function Null() : Object() constructor{
	Type = function() { return global.object_type_str[? OBJECT_TYPE.NULL]; }
	Inspect = function(){ return "null"; }
}