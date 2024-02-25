global.bool_true = new Boolean(true);
global.bool_false = new Boolean(false);
global.null = new Null();

function Eval(node){
	switch(instanceof(node)){
		//statements
		case "Program":
			debug_print("eval program");
			return Eval_Statements(node.statements);
		case "Expression_Statement":
			debug_print("eval expression statement");
			return Eval(node.expression);
			
		//expressions
		case "Integer_Literal":
			debug_print("eval integer literal");
			return new Integer(node.value);
		case "Boolean_Expression":
			debug_print("eval booloean expression");
			return new Boolean(node.value);
		case "Prefix_Expression":
			debug_print("eval prefix expression");
			return Eval_Prefix_Expression(node.operator, Eval(node.right))
		case "Infix_Expression":
			debug_print("eval infix expression");			
			return Eval_Infix_Expression(node.operator, Eval(node.left), Eval(node.right));
		default:
			debug_print("undefined");
			return global.null;
	}
}

function Eval_Statements(statement_arr){
	var result;
	
	for(var i=0; i<array_length(statement_arr); i++){
		result = Eval(statement_arr[i]);	
		debug_print(result);
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
			return global.null;
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
	if(instanceof(right) != "Integer") return global.null;
	
	return new Integer(-right.value)
}

function Eval_Infix_Expression(operator, left, right){
	if ((instanceof(left) == "Integer" && instanceof(right) == "Integer")
		|| (instanceof(left) == "Boolean" && instanceof(right) == "Boolean")){
		return Eval_Integer_Infix_Expression(operator, left, right);
	}
	
	return global.null;
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
			return global.null;
	}
}