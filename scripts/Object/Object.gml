enum OBJECT_TYPE {
	INTEGER,
	BOOLEAN,
	NULL,
	RETURN_VALUE,
	ERROR,
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
	value = undefined;
	Type = function() { return global.object_type_str[? OBJECT_TYPE.NULL]; }
	Inspect = function(){ return "null"; }
}

function Return_Value(val=undefined) : Object() constructor{
	value = val;
	Type = function() { return global.object_type_str[? OBJECT_TYPE.RETURN_VALUE]; }
	Inspect = function() { return (!is_undefined(value)) ? value.Inspect() : string(undefined);}
}

function Error(str="") : Object() constructor{
	msg = str;
	Type = function() { return global.object_type_str[? OBJECT_TYPE.ERROR]; }
	Inspect = function() { return "ERROR: " + msg; }	
}

function Environment() : Object() constructor{
	store = ds_map_create();//obj map
	
	Get = function(name){
		return store[? name];
	}
	
	Set = function(name, val){
		store[? name] = val;	
	}
}