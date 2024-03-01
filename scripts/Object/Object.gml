enum OBJECT_TYPE {
	INTEGER,
	BOOLEAN,
	NULL,
	RETURN_VALUE,
	ERROR,
	FUNCTION,
}

function Object() constructor{
	Type = function() {}; // string : object type
	Inspect = function() {};
}

function Integer(val=undefined) : Object() constructor{
	value = val; // int
	Type = function() { return global.object_type_str[$ OBJECT_TYPE.INTEGER]; }
	Inspect = function(){ return string(value); }
}

function Boolean(val=undefined) : Object() constructor{
	value = val; // bool
	Type = function() { return global.object_type_str[$ OBJECT_TYPE.BOOLEAN]; }
	Inspect = function(){ return string(value); }
}

function Null() : Object() constructor{
	value = undefined;
	Type = function() { return global.object_type_str[$ OBJECT_TYPE.NULL]; }
	Inspect = function(){ return "null"; }
}

function Return_Value(val=undefined) : Object() constructor{
	value = val;
	Type = function() { return global.object_type_str[$ OBJECT_TYPE.RETURN_VALUE]; }
	Inspect = function() { return (!is_undefined(value)) ? value.Inspect() : string(undefined);}
}

function Error(str="") : Object() constructor{
	msg = str;
	Type = function() { return global.object_type_str[$ OBJECT_TYPE.ERROR]; }
	Inspect = function() { return "ERROR: " + msg; }	
}

function Environment(outer_env=undefined) : Object() constructor{
	store = {};//obj map
	outer = outer_env;
	Get = function(name){
		var val = store[$ name];
		if(is_undefined(val) && !is_undefined(outer)) return outer.store[$ name];		
		return val;
	}
	
	Set = function(name, val){
		store[$ name] = val;	
	}
}

function Function(node, environment) : Object() constructor{
	parameters = node.parameters;
	body = node.body; //block statement
	env = environment;
	Type = function() { return global.object_type_str[$ OBJECT_TYPE.FUNCTION]; }
	Inspect = function(){
		var params = "";
		for(var i=0; i<array_length(parameters); i++){
			array_push(params, string(parameters[i]));
			if(i<array_length(parameters)-1) array_push(params, ", ");
		}
		return $"function({params}\n{body.String()}\n";	
	}
}