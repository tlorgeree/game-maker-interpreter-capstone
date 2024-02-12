function Parser(input_lexer) constructor{
	lexer = input_lexer;
	errors = [];
	curr_token = new Token();
	peek_token = new Token();
	program = new Program(new Token());
	prefix_parse_fns = ds_map_create(); //token.type : Prefix_Parse_Fn()
	infix_parse_fns = ds_map_create();
	
	Init = function(){
		Register_Prefix(TOKEN.IDENT, Parse_Identifier);
		Register_Prefix(TOKEN.INT, Parse_Integer_Literal);
		Register_Prefix(TOKEN.BANG, Parse_Prefix_Expression);
		Register_Prefix(TOKEN.MINUS, Parse_Prefix_Expression);
	}
	
	Next_Token = function(){
		curr_token = peek_token;
		peek_token = lexer.Next_Token();
	}
	
	Parse_Program = function(){
		var statement;
		
		while(!Curr_Token_Is(TOKEN.EOF)){
			if(Curr_Token_Is(TOKEN.MINUS))show_message("found a minus");
			statement = Parse_Statement();			
			if(!is_undefined(statement)){
				array_push(program.statements, statement);	
			}
			Next_Token();
		}
		
	}
	
	#region Statement Parsing
	Parse_Statement = function(){
		switch(curr_token.type){
			case TOKEN.LET:
				return Parse_Let_Statement();
			case TOKEN.RETURN:
				return Parse_Return_Statement();				
			default:
				return Parse_Expression_Statement();				
		}
	}
	
	Parse_Let_Statement = function(){
		var statement = new Let_Statement(curr_token);
				
		if(!Expect_Peek(TOKEN.IDENT)) return undefined;
		
		statement.name = new Identifier(curr_token);
		
		if(!Expect_Peek(TOKEN.ASSIGN)) return undefined;
		
		Next_Token();
		
		statement.value = Parse_Expression(PRECEDENCE.LOWEST);
		
		if(!Curr_Token_Is(TOKEN.SEMICOLON)){
			Next_Token();	
		}
		
		show_debug_message(statement.String());
		return statement;
	}
	
	Parse_Return_Statement = function(){
		var statement = new Return_Statement(curr_token);
		
		Next_Token();
		
		//TODO: we're skipping expressions until we encounter a semicolon
		
		while(!Curr_Token_Is(TOKEN.SEMICOLON)){
			Next_Token();	
		}
		
		show_debug_message(statement.String());
		return statement;
	}
	
	Parse_Expression_Statement = function(){
		var statement = new Expression_Statement(curr_token);
		
		statement.expresison = Parse_Expression(PRECEDENCE.LOWEST);
		
		if(Peek_Token_Is(TOKEN.SEMICOLON)){
			Next_Token();
		}
		
		show_debug_message(statement.String());
		return statement;	
	}
	
	Parse_Expression = function(precedence){
		var prefix = prefix_parse_fns[? curr_token.type];
		
		if(is_undefined(prefix)){
			No_Prefix_Parser_Error(curr_token.type);
			return undefined;	
		}
		
		var left_exp = prefix();
		
		while(!Peek_Token_Is(TOKEN.SEMICOLON)) && precedence < Peak_Precedence(){
			var infix = infix_parse_fns[? peek_token.type];
			if (is_undefined(infix)){
				return left_exp;	
			}
			
			Next_Token();
			
			left_exp = infix(left_exp);
		}
		
		return left_exp;
	}
	
	Parse_Prefix_Expression = function(){
		var expression = new Prefix_Expression(curr_token);		
		Next_Token();
		
		expression.right = Parse_Expression(PRECEDENCE.PREFIX);
		
		show_debug_message(expression.String());
		return expression;
	}
	
	Parse_Infix_Expression = function(){
		var expression = new Prefix_Expression(curr_token);		
		Next_Token();
		
		expression.right = Parse_Expression(PRECEDENCE.PREFIX);
		
		show_debug_message(expression.String());
		return expression;
	}
	
	Parse_Identifier = function(){
		return new Identifier(curr_token);	
	}
	
	Parse_Integer_Literal = function(){
		var literal = new Integer_Literal(curr_token);
		
		var val = Parse_Int(curr_token.literal);
		
		if(is_undefined(val)){
			array_push(errors, $"Could not parse {curr_token.literal} as integer.");
			return undefined;
		}
		
		literal.value = val;
		
		return literal;		
	}
	#endregion
	
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
	
	Peek_Error = function(token_type){
		var msg = $"expected next token to be {global.token_debug_str[token_type]}, got {global.token_debug_str[peek_token.type]} instead.";
		show_debug_message(msg);
		array_push(errors, msg);
	}
	
	No_Prefix_Parser_Error = function(token_type){
		array_push(errors, $"No prefix parse function for {global.token_debug_str[token_type]} found.");
	}
	
	Check_Parser_Errors = function(){
		var num_errors = array_length(errors);
		if (num_errors) return;
		
		for(var i=0; i< num_errors; i++){
			show_debug_message($"Parser error: {errors[i]}");
		}
	}
	
	Prefix_Parse_Fn = function(){
		
	}
	
	Infix_Parse_Fn = function(){
		
	}
	
	Register_Prefix = function(token_type, prefix_parse_fn){
		prefix_parse_fns[? token_type] = prefix_parse_fn;	
	}
	
	Register_Infix = function(token_type, infix_parse_fn){
		infix_parse_fns[? token_type] = infix_parse_fn;	
	}
	
	Parse_Int = function(str){
		var str_digits = string_digits(str);
		
		return (str == str_digits) ? real(str) : undefined;
	}
	
	
	
	Init();
}

