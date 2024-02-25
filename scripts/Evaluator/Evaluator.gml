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
			debug_print("eval booloean");
			return new Boolean(node.value);
		default:
			debug_print("undefined");
			return undefined;
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