global.bool_true = new Boolean(true);
global.bool_false = new Boolean(false);
global.null = new Null();
global.builtins = new Environment();
global.builtins.store = {
	len : new Built_In(function(obj){
		switch(obj.Type()){
			case "ARRAY":
				return new Integer(array_length(obj.elements));
			case "STRING":
				return new Integer(string_length(obj));
			default:
				return global.null;
		}
	}),
	
	array_add : new Built_In(function(obj, index, to_add){
		if(obj.Type() == "ARRAY") array_insert(obj.elements, index.value, to_add);
	}),
	
	array_remove : new Built_In(function(obj, index){
		if(obj.Type() == "ARRAY") array_delete(obj.elements, index.value, 1);
		
	}),
	
	Player : {
		get_x : new Built_In(function(){
			var player = obj_Main.Get_Player();
			if(is_undefined(player)) return undefined;
			return new Integer(player.Get_X());
		}),
		get_y : new Built_In(function(obj){
			var player = obj_Main.Get_Player();
			if(is_undefined(player)) return undefined;
			return new Integer(player.Get_Y());
		}),
		set_path : new Built_In(function(obj){
			if(instanceof(obj) != "Array") return new Error("Cannot set Player path. Input needs to be an array or arrays."
			+"\nFor example: [[x1,y1], [x2,y2], ... [xn, yn]]");
		}),
		move_up : new Built_In(function(){
			var player = obj_Main.Get_Player();
			if(is_undefined(player)){
				return new Error("Player object not instantiated");	
			}
			player.Move_Up();
		}),
		move_down : new Built_In(function(){
			var player = obj_Main.Get_Player();
			if(is_undefined(player)){
				return new Error("Player object not instantiated");	
			}
			player.Move_Down();
			
		}),
		move_left : new Built_In(function(){
			var player = obj_Main.Get_Player();
			if(is_undefined(player)){
				return new Error("Player object not instantiated");	
			}
			player.Move_Left();
		}),
		move_right : new Built_In(function(){
			var player = obj_Main.Get_Player();
			if(is_undefined(player)){
				return new Error("Player object not instantiated");	
			}
			player.Move_Right();
		}),		
		set_path : new Built_In(function(path_arr){
			if(path_arr.Type() != "ARRAY") return new Error("set path needs to be an array of coord arrays");
			var path = array_create(array_length(path_arr.elements), 0);
			for(var i=0; i<array_length(path);i++){
				if(path_arr.elements[i].Type() != "ARRAY") return new Error("set path needs to be an array of coord arrays");
				if(array_length(path_arr.elements[i].elements) != 2) return new Error("set path coords needs to be an array of 2 integers");
				if(path_arr.elements[i].elements[0].Type() != "INTEGER") return new Error("set path needs to be an array of coord arrays");
				if(path_arr.elements[i].elements[1].Type() != "INTEGER") return new Error("set path needs to be an array of coord arrays");
				path[i] = array_create(array_length(path_arr.elements[i]), 0);
				path[i] = [0,0];
				path[i][0] = path_arr.elements[i].elements[0].value;
				path[i][1] = path_arr.elements[i].elements[1].value;
			}
			
			var player = obj_Main.Get_Player();
			if(is_undefined(player)){
				return new Error("Player object not instantiated");	
			}
			player.Set_Path(path);
		}),
		execute : new Built_In(function(){
			var player = obj_Main.Get_Player();
			if(is_undefined(player)){
				return new Error("Player object not instantiated");	
			}
			player.Execute_Path();
		}),
		
	},
	
	Goal : {
		get_x : new Built_In(function(){
			var goal = obj_Main.Get_Goal();
			if(is_undefined(goal)) return undefined;
			return new Integer(goal.Get_X());
		}),
		get_y : new Built_In(function(obj){
			var goal = obj_Main.Get_Goal();
			if(is_undefined(goal)) return undefined;
			return new Integer(goal.Get_Y());
		}),
	},
	
	wall_at_coords : new Built_In(function(coord_arr){
		if(instanceof(coord_arr) != "Array") return new Error("wall_at_coords: Input type needs to be array");
		var at_coords = obj_Main.Coords_Get_Instance(coord_arr.Value());
		if(at_coords != -1) return global.bool_true;
		else return global.bool_false;
	}),
	
	a_star_path : new Built_In(function(start_x, start_y, end_x, end_y){
		if(start_x.Type() != "INTEGER" || start_y.Type() != "INTEGER" || end_x.Type() != "INTEGER" 
			|| end_y.Type() != "INTEGER") return new Error("path coordinate types need to be integers");
		var path = a_star([start_x.value, start_y.value], [end_x.value, end_y.value], obj_Main.board_pattern);
		var array = new Array(array_create(array_length(path), 0));
		
		for(var i=0; i<array_length(path); i++){
			path[i][0] = new Integer(path[i][0]);
			path[i][1] = new Integer(path[i][1]);
			array.elements[i] = new Array(path[i]);
		}
		return array;
	}),
};

function Eval(node, env){
	switch(instanceof(node)){
		//statements
		case "Program":
			debug_print("eval program");
			return Eval_Program(node.statements, env);
		case "Expression_Statement":
			debug_print("eval expression statement");
			return Eval(node.expression, env);
		case "Block_Statement":
			debug_print("eval block statement");
			return Eval_Block_Statement(node.statements, env);
		case "Return_Statement":
			debug_print("eval return statement");
			return new Return_Value(Eval(node.return_value, env));
		case "Let_Statement":
			debug_print("eval let statement");
			var val = Eval(node.value, env);
			if(Is_Error(node.value)) return val;
			env.Set(node.name.value, val);
			return;
		case "Function_Statement":
			debug_print("eval function statement");
			var val = Eval(node.value, env);
			if(Is_Error(node.value)) return val;
			env.Set(node.name.value, val);
			return;
		case "Index_Statement":
			debug_print("eval index statement");
			var left = Eval(node.left, env);
			if(Is_Error(left)) return left;
			var index = Eval(node.index, env);
			if(Is_Error(index)) return index;
			
			var value =(!is_undefined(node.value)) ? Eval(node.value, env) : undefined;
			
			return Eval_Index_Statement(left, index, value);
		//expressions
		case "Integer_Literal":
			debug_print("eval integer literal");
			return new Integer(node.value);
		case "Function_Literal":
			return new Function(node, env);
		case "Array_Literal":
			debug_print("eval array literal");
			var elements = Eval_Expressions(node.elements, env);
			if((array_length(elements) == 1) && Is_Error(elements[0])) return elements[0];
			return new Array(elements);
		case "Boolean_Expression":
			debug_print("eval booloean expression");
			return new Boolean(node.value);
		case "Prefix_Expression":
			debug_print("eval prefix expression");
			return Eval_Prefix_Expression(node.operator, Eval(node.right, env))
		case "Infix_Expression":
			debug_print("eval infix expression");			
			return Eval_Infix_Expression(node.operator, Eval(node.left, env), Eval(node.right, env));
		case "If_Expression":
			debug_print("eval if expression");
			return Eval_If_Expression(node, env);
		case "While_Expression":
			debug_print("eval while expression");
			return Eval_While_Expression(node, env);
		case "For_Expression":
			debug_print("eval for expression");
			return Eval_For_Expression(node, env);
		case "Call_Expression":
			debug_print("eval call expression");
			var fn = Eval(node.fn, env);
			if(Is_Error(fn)) return fn;
			var args = Eval_Expressions(node.arguments, env);
			
			if(array_length(args) == 1 && Is_Error(args[0])) return args[0];
			
			return Apply_Function(fn, args);
		case "Index_Expression":
			debug_print("eval index expression");
			var left = Eval(node.left, env);
			if(Is_Error(left)) return left;
			var index = Eval(node.index, env);
			if(Is_Error(index)) return index;
			
			return Eval_Index_Expression(left, index);
		case "Identifier":
			return Eval_Identifier(node, env);
		default:
			debug_print("undefined");
			return global.null;
	}
}

function Eval_Program(statement_arr, env){
	var result = new Null();
	
	for(var i=0; i<array_length(statement_arr); i++){
		result = Eval(statement_arr[i], env);	
		debug_print(result);
		
		switch(instanceof(result)){
			case "Return_Value":
				return result.value;
			case "Error":
				return result;
			default:
				break;
		}		
	}
	
	return result;
}

function Native_Bool_To_Bool_Object(value){
	if(value) return global.bool_true;	
	else return global.bool_false;	
}

function Eval_Prefix_Expression(operator, right){
	switch(operator){
		case "!":
			return Eval_Bang_Operator_Expression(right);
		case "-":
			return Eval_Minus_Operator_Expression(right);
		default:
			return new Error($"unknown operator: {operator}{right.Inspect()}");
	}
}

function Eval_Bang_Operator_Expression(right){
	switch(instanceof(right)){
		case "Boolean":		
			return (right.value) ? global.bool_false : global.bool_true;
		case "Null":
			return global.bool_true;
		default:
			return global.bool_false;		
	}
}

function Eval_Minus_Operator_Expression(right){
	if(instanceof(right) != "Integer") return new Error($"unknown operator: -{right.Inspect()}");
	
	return new Integer(-right.value)
}

function Eval_Infix_Expression(operator, left, right){
	if ((instanceof(left) == "Integer" || instanceof(left) == "Boolean")
		|| (instanceof(right) == "Integer" || instanceof(right) == "Boolean")){
		return Eval_Integer_Infix_Expression(operator, left, right);
	}
	
	
	return new Error($"unknown operator: {left.Inspect()}{operator}{right.Inspect()}");
}

function Eval_Integer_Infix_Expression(operator, left, right){
	switch(operator){
		case "+":
			return new Integer(left.value + right.value);
		case "-":
			return new Integer(left.value - right.value);
		case "*":
			return new Integer(left.value * right.value);
		case "/":
			return new Integer(left.value / right.value);
		case "<":
			return Native_Bool_To_Bool_Object(left.value < right.value);
		case ">":
			return Native_Bool_To_Bool_Object(left.value > right.value);
		case "==":
			return Native_Bool_To_Bool_Object(left.value == right.value);
		case "!=": 
			return Native_Bool_To_Bool_Object(left.value != right.value);
		default:
			return new Error($"unknown operator: {left.Inspect()}{operator}{right.Inspect()}");
	}
}

function Eval_If_Expression(node, env){
	var condition = Eval(node.condition, env);
	
	if(Is_Truthy(condition)){
		return Eval(node.consequence, env);	
	} else if(node.alternative != undefined){
		return Eval(node.alternative, env);
	} else return undefined;
}

function Eval_While_Expression(node, env){
	var block = undefined;
	while(Is_Truthy(Eval(node.condition, env))){
		block = Eval(node.block, env);	
	}
	return block;
}

function Eval_For_Expression(node, env){
	Eval(node.expression, env);
	
	var block = undefined;
	while(Is_Truthy(Eval(node.condition, env))){
		block = Eval(node.block, env);
		Eval(node.iterator, env);
	}
	return block;
}

function Is_Truthy(obj){
	if(instanceof(obj) == "Null") return false;
	if(instanceof(obj) == "Boolean") return (obj.value == true);	
	return true;
}

function Eval_Block_Statement(statement_arr, env){
	var result;
	
	for(var i=0; i<array_length(statement_arr); i++){
		result = Eval(statement_arr[i], env);	
		debug_print(result);
		
		if(!is_undefined(result) 
			&& (instanceof(result) == "Return_Value" || instanceof(result) == "Error")) return result;
	}
	
	return result;	
}

function Is_Error(obj){
	if(!is_undefined(obj)) return (instanceof(obj) == "Error");
	
	return false;
}

function Eval_Identifier(node, env){
	var val = env.Get(node.value);
	if(!is_undefined(val)) return val;
	
	var built_in = global.builtins.Get(node.value);
	if(!is_undefined(built_in)) return built_in;
	return new Error($"Identifier not found: {node.value}");
}

function Eval_Expressions(args, env){
	var result = [];
	var evaluated;
	for(var i=0; i<array_length(args); i++){
		evaluated = Eval(args[i], env);
		if(Is_Error(evaluated)) return [evaluated];
		
		array_push(result, evaluated);
	}
	
	return result;
}

function Apply_Function(fn, args){
	if(instanceof(fn) == "Function"){
		var extended_env = Extend_Function_Env(fn, args);
		var evaluated = Eval(fn.body, extended_env);
	
		return Unwrap_Return_Value(evaluated);
	}
	else if(instanceof(fn) == "Built_In"){
		return method_call(fn.fn, args);
	}	
	
	return new Error($"not a function: {fn.Type()}");	
}

function Extend_Function_Env(fn, args){
	var env = new Environment(fn.env);
	
	for(var i=0; i<array_length(fn.parameters); i++){
		env.Set(fn.parameters[i].value, args[i]);
	}
	
	return env;
}

function Unwrap_Return_Value(obj){
	if(instanceof(obj) == "Return_Value") return obj.value;
	
	return obj;
}

function Eval_Index_Expression(left, index){
	if!(left.Type() == "ARRAY" && index.Type() == "INTEGER") return new Error($"index operator not supported: {left.Type()}");

	return Eval_Array_Index_Expression(left, index);	
}

function Eval_Index_Statement(left, index, value){
	if!(left.Type() == "ARRAY" && index.Type() == "INTEGER") return new Error($"index operator not supported: {left.Type()}");
	if(value.Type() != "INTEGER") return new Error($"Array assignment value must be an integer: {value.Type()}");
	
	left.elements[index.value] = value;
	
}

function Eval_Array_Index_Expression(array, index){
	var ind = index.value;
	if(ind<0 || ind>(array_length(array.elements)-1)) return global.null;
	return array.elements[ind];
}