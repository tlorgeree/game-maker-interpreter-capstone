function Parser() constructor{

}

function Node(token) constructor{
	tok = token;
	Token_Literal = function(){
		return token.literal;
	}
}

function Program(): Node(token) constructor{
	statements = [];
}

#region Statement Nodes
function Statement() : Node(token) constructor{
	Statement_Node = function() {}
	name = ""; // identifier
	value = ""
}

function Let_Statement() : Statement() constructor{
	
	}
#endregion


#region Expression Nodes
function Expression(): Node(token) constructor{
	Expression_Node = function() {}
	value = "";
}

function Identifier() : Expression() constructor{


}
#endregion