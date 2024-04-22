function Node(token) constructor{
	tok = token;
	Token_Literal = function(){
		return tok.literal;
	}
	String = function(){}
}

function Program(token): Node(token) constructor{
	statements = [];
	
	Token_Literal = function(){
		if(array_length(statements) > 0){
			return statements[0].Token_Literal();	
		} else{
			return "";	
		}
	}
	
	String = function(){
		var str = "";
		for(var i=0; i< array_length(statements); i++){
			debug_print(statements[i].String());
		}
		return str;
	}
}

#region Statement Nodes
function Statement(token) : Node(token) constructor{
	//token from Node
	Statement_Node = function() {}
	name = ""; // identifier
	value = undefined;
	
	//Token Literal from Node
}

function Var_Statement(token) : Statement(token) constructor{
	String = function(){
		return $"{Token_Literal()} {name.String()} = {(!is_undefined(value)) ? (string(value.String()) + " "): ""};";	
	}
}

function Return_Statement(token) : Statement(token) constructor{
	return_value = undefined; // Expression
	String = function(){
		return $"{Token_Literal()} {(!is_undefined(value)) ? (string(value) + " "): ""} {(!is_undefined(return_value) ? return_value.String() : "")};";		
	}
}

function Expression_Statement(token) : Statement(token) constructor{
	//token from Node
	expression = undefined; // expression
	
	//Token Literal from Node
	
	String = function(){
		return (!is_undefined(expression)) ? expression.String() : "";
	}	
}

function Function_Statement(token) : Statement(token) constructor{
	String = function(){
		return $"{Token_Literal()} {name.String()} = {(!is_undefined(value)) ? (string(value.String()) + " "): ""};";	
	}
}

function Block_Statement(token): Statement(token) constructor{
	statements = [];
	
	String = function(){
		var str = "";
		for(var i=0; i< array_length(statements); i++) str+=statements[i].String();
		return str;
	}
}

function Index_Statement(token) : Statement(token) constructor{
	left = undefined; //expression
	index = undefined; //expression
	value = undefined;
	
	String = function(){
		return $"{left.String()}[{index.String()}] = {value.String()};";	
	}
}
#endregion

#region Expression Nodes
function Expression(token): Node(token) constructor{
	Expression_Node = function() {}
	value = "";
}

function Identifier(token) : Expression(token) constructor{
	value = token.literal;
	
	String = function(){
		return value;	
	}
}

function Boolean_Expression(token) : Expression(token) constructor{
	value = (token.type == TOKEN.TRUE);
	
	String = function(){
		return tok.literal;	
	}
}

function Prefix_Expression(token) : Expression(token) constructor{
	// token from Node
	operator = token.literal; // prefix operator
	right = undefined; // expression
	
	String = function(){		
		return $"({(!is_undefined(operator)) ? operator : ""}{(!is_undefined(right)) ? string(right.String()) : ""})";	
	}
}

function Infix_Expression(token) : Expression(token) constructor{
	operator = token.literal; // prefix operator
	left = undefined; //expression
	right = undefined; // expression
	
	String = function(){		
		return $"({(!is_undefined(left)) ? string(left.String()) : ""}{(!is_undefined(operator)) ? operator : ""}{(!is_undefined(right)) ? string(right.String()) : ""})";	
	}
}

function If_Expression(token) : Expression(token) constructor{
	condition = undefined; //expression
	consequence = undefined;
	alternative = undefined;
	
	String = function(){
		return 	$"if {(!is_undefined(condition)) ? condition.String() : ""}" 
		+ $" {(!is_undefined(consequence)) ? consequence.String() : ""} else {(!is_undefined(alternative) ? alternative.String() : "")}";
	}
}

function For_Expression(token) : Expression(token) constructor{
	expression = undefined; //var statement
	condition = undefined; //expression
	iterator = undefined; //expression
	block = undefined; //block
	
	String = function(){
		return 	$"for ({(!is_undefined(expression)) ? expression.String()+";" : ""}" 
		+ $" {(!is_undefined(condition)) ? condition.String()+";" : ""}; {(!is_undefined(iterator) ? iterator.String() : "")})"
		+$"{(!is_undefined(block) ? block.String() : "")}";
	}
}

function While_Expression(token) : Expression(token) constructor{
	condition = undefined; //expression
	block = undefined; //block
	
	String = function(){
		return 	$"while {(!is_undefined(condition)) ? condition.String() : ""}" 
		+ $" {(!is_undefined(block)) ? block.String() : ""}";
	}
}

function Call_Expression(token) : Expression(token) constructor{
	fn = undefined; // function expression 
	arguments = []; // Expressions
	
	String = function(){
		var args = "";
		for(var i=0; i< array_length(arguments); i++){
			args += arguments[i].String();
			if(i<array_length(arguments)-1) args += ", ";
		}
		
		return $"{fn.String()}({args})";
	}
}

function Index_Expression(token) : Expression(token) constructor{
	left = undefined; //expression
	index = undefined; //expression
	
	String = function(){
		return $"{left.String()}[{index.String()}]";	
	}
}
#endregion

#region Literals

function Integer_Literal(token) : Node(token) constructor{
	//token from Node
	value = undefined;
	String = function(){
		return tok.literal;
	}
}

function Function_Literal(token) : Expression(token) constructor{
	parameters = []; // Identifiers
	body = undefined; //block statement
	
	String = function(){
		var params = "";
		
		for(var i=0; i<array_length(parameters); i++){
			params += parameters[i].String();
			if(i<array_length(parameters)-1) params += ", ";
		}
				
		return $"{Token_Literal()} ({params}) {(!is_undefined(body)) ? body.String() : ""}";
	}
}

function Array_Literal(token) : Expression(token) constructor{
	elements = [];
	
	String = function(){
		var elems = "";
		for(var i=0; i<array_length(elements); i++){
			elems+=elements[i].String();
			if(i<array_length(elements)-1) elems += ", ";
		}
		
		return $"{tok.literal}[{elems}]";
	}
}
#endregion