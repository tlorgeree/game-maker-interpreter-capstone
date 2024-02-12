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
			str += statements[i].String();	
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

function Let_Statement(token) : Statement(token) constructor{
	String = function(){
		return $"{Token_Literal()} {name.String()} = {(!is_undefined(value)) ? (string(value.String()) + " "): ""};";	
	}
}

function Return_Statement(token) : Statement(token) constructor{
	String = function(){
		return $"{Token_Literal()} {(!is_undefined(value)) ? (string(value) + " "): ""};";		
	}
}

function Expression_Statement(token) : Statement(token) constructor{
	//token from Node
	expression = undefined; // expression
	
	//Token Literal from Node
	
	String = function(){
		return (!is_undefined(expression)) ? expresison.String() : "";
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

function Prefix_Expression(token) : Expression(token) constructor{
	// token from Node
	operator = token.literal; // prefix operator
	right = undefined; // expression
	
	String = function(){		
		return $"({(!is_undefined(operator)) ? operator : ""}{(!is_undefined(right)) ? string(right.value) : ""})";	
	}
}
#endregion

#region Lierals

function Integer_Literal(token) : Node(token) constructor{
	//token from Node
	value = undefined;
}
#endregion