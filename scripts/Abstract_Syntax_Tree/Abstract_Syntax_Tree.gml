function Parser(input_lexer) constructor{
	lexer = input_lexer;
	errors = [];
	curr_token = new Token();
	peek_token = new Token();
	program = new Program(new Token());
	
	Next_Token = function(){
		curr_token = peek_token;
		peek_token = lexer.Next_Token();
	}
	
	Parse_Program = function(){
		var statement;
		
		while(!Curr_Token_Is(TOKEN.EOF)){
			statement = Parse_Statement();			
			if(!is_undefined(statement)){	
				show_debug_message(statement.name.value);
				array_push(program.statements, statement);	
			}
			Next_Token();
		}
		
	}
	
	Parse_Statement = function(){
		switch(curr_token.type){
			case TOKEN.LET:
				return Parse_Let_Statement();
			default:
				return undefined;				
		}
	}
	
	Parse_Let_Statement = function(){
		var statement = new Let_Statement(curr_token);
		
		if(!Expect_Peek(TOKEN.IDENT)){
			return undefined;	
		}
		
		statement.name = new Identifier(curr_token);
		
		if(!Curr_Token_Is(TOKEN.SEMICOLON)){
			Next_Token();	
		}
		
		return statement;
	}
	
	Curr_Token_Is = function(token_type){		
		return curr_token.type == token_type;
	}
	
	Peek_Token_Is = function(token_type){
		return peek_token.type == token_type;
	}
	
	Expect_Peek = function(token_type){
		if (Peek_Token_Is(token_type)){
			Next_Token();
			return true;
		}
		
		Peek_Error(token_type);		
		return false;
	}
	
	Peek_Error = function(token_tpye){
		var msg = $"expected next token to be {token_tpye}, got {peek_token.type} instead.";
		show_debug_message(msg);
		array_push(errors, msg);
	}
	
	Check_Parser_Errors = function(){
		var num_errors = array_length(errors);
		if (num_errors) return;
		
		show_debug_message($"");
	}
}

function Node(token) constructor{
	tok = token;
	Token_Literal = function(){
		return token.literal;
	}
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
}

#region Statement Nodes
function Statement(token) : Node(token) constructor{
	Statement_Node = function() {}
	name = ""; // identifier
	value = ""
}

function Let_Statement(token) : Statement(token) constructor{
	
}
#endregion


#region Expression Nodes
function Expression(token): Node(token) constructor{
	Expression_Node = function() {}
	value = "";
}

function Identifier(token) : Expression(token) constructor{
	value = token.literal;

}
#endregion