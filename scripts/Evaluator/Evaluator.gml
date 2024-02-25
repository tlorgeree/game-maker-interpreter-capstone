function Eval(node){
	switch(instanceof(node)){
		//statements
		case "Program":
			show_debug_message("eval program");
			return Eval_Statements(node.statements);
		case "Expression_Statement":
			show_debug_message("eval expression statement");
			return Eval(node.expression);
			
		//expressions
		case "Integer_Literal":
			show_debug_message("eval integer literal");
			return new Integer(node.value);
		default:
			show_debug_message("undefined");
			return undefined;
	}
}

function Eval_Statements(statement_arr){
	var result;
	
	for(var i=0; i<array_length(statement_arr); i++){
		result = Eval(statement_arr[i]);	
		show_debug_message(result);
	}
	
	return result;
}