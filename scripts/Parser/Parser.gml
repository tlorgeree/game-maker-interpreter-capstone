enum PRECEDENCE {
	LOWEST,
	EQUALS, // ==
	LESSGREATER, // < or >
	SUM, // +
	PRODUCT, // *
	PREFIX, // -X or !X
	CALL // My_Function(X)
}

function Parser(input_lexer) constructor{
	lexer = input_lexer;
	errors = [];	
	peek_token = new Token();
	curr_token = new Token();
	program = new Program(new Token());
	prefix_parse_fns = ds_map_create(); //token.type : Prefix_Parse_Fn()
	infix_parse_fns = ds_map_create();
	precedences = ds_map_create();
	precedences[? TOKEN.EQ] = PRECEDENCE.EQUALS;
	precedences[? TOKEN.NOT_EQ] = PRECEDENCE.EQUALS;
	precedences[? TOKEN.LT] = PRECEDENCE.LESSGREATER;
	precedences[? TOKEN.GT] = PRECEDENCE.LESSGREATER;
	precedences[? TOKEN.PLUS] = PRECEDENCE.SUM;
	precedences[? TOKEN.MINUS] = PRECEDENCE.SUM;
	precedences[? TOKEN.SLASH] = PRECEDENCE.PRODUCT;
	precedences[? TOKEN.ASTERISK] = PRECEDENCE.PRODUCT;
	precedences[? TOKEN.LPAREN] = PRECEDENCE.CALL;
	
	Init = function(){
		Register_Prefix(TOKEN.IDENT, Parse_Identifier);
		Register_Prefix(TOKEN.INT, Parse_Integer_Literal);
		Register_Prefix(TOKEN.BANG, Parse_Prefix_Expression);
		Register_Prefix(TOKEN.MINUS, Parse_Prefix_Expression);
		Register_Prefix(TOKEN.TRUE, Parse_Boolean);
		Register_Prefix(TOKEN.FALSE, Parse_Boolean);
		Register_Prefix(TOKEN.LPAREN, Parse_Grouped_Expression); 
		Register_Prefix(TOKEN.IF, Parse_If_Expression);
		Register_Prefix(TOKEN.FUNCTION, Parse_Function_Literal);
		
		Register_Infix(TOKEN.PLUS, Parse_Infix_Expression);
		Register_Infix(TOKEN.MINUS, Parse_Infix_Expression);
		Register_Infix(TOKEN.SLASH, Parse_Infix_Expression);
		Register_Infix(TOKEN.ASTERISK, Parse_Infix_Expression);
		Register_Infix(TOKEN.EQ, Parse_Infix_Expression);
		Register_Infix(TOKEN.NOT_EQ, Parse_Infix_Expression);
		Register_Infix(TOKEN.LT, Parse_Infix_Expression);
		Register_Infix(TOKEN.GT, Parse_Infix_Expression);
		Register_Infix(TOKEN.LPAREN, Parse_Call_Expression);
	}
	
	Next_Token = function(){
		curr_token = peek_token;		
		peek_token = lexer.Next_Token();
		debug_print(global.token_debug_str[peek_token.type]);
	}
	
	Parse_Program = function(){
		var statement;
		while(!Curr_Token_Is(TOKEN.EOF)){
			statement = Parse_Statement();
			
			if(!is_undefined(statement)){
				array_push(program.statements, statement);	
			}
			Next_Token();
		}
		
		return program;
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
		
		return statement;
	}
	
	Parse_Return_Statement = function(){
		var statement = new Return_Statement(curr_token);
		
		Next_Token();
		
		statement.return_value = Parse_Expression(PRECEDENCE.LOWEST);
		
		while(!Curr_Token_Is(TOKEN.SEMICOLON)){
			Next_Token();	
		}
		
		return statement;
	}
	
	Parse_Expression_Statement = function(){
		var statement = new Expression_Statement(curr_token);
		
		statement.expression = Parse_Expression(PRECEDENCE.LOWEST);
		if(is_undefined(statement.expression)) return undefined;
		
		if(Peek_Token_Is(TOKEN.SEMICOLON)){
			Next_Token();
		}
		
		return statement;	
	}
	
	Parse_Expression = function(precedence){
		var prefix = prefix_parse_fns[? curr_token.type];
		
		if(is_undefined(prefix)){
			No_Prefix_Parser_Error(curr_token.type);
			return undefined;	
		}
		
		var left_exp = prefix();
		
		while(!Peek_Token_Is(TOKEN.SEMICOLON)) && precedence < Peek_Precedence(){
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
		
		return expression;
	}
	
	Parse_Infix_Expression = function(left_expression){
		var expression = new Infix_Expression(curr_token);
		expression.left = left_expression;
		
		var precedence = Curr_Precedence();
		Next_Token();		
		expression.right = Parse_Expression(precedence);
		
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
	
	Parse_Boolean = function(){
		return new Boolean_Expression(curr_token);
	}
	
	Parse_Grouped_Expression = function(){
		Next_Token();
		
		var expression = Parse_Expression(PRECEDENCE.LOWEST);
		
		if(!Expect_Peek(TOKEN.RPAREN)){
			return undefined;	
		}
		
		return expression;
	}
	
	Parse_If_Expression = function(){
		var expression = new If_Expression(curr_token);	
		
		if(!Expect_Peek(TOKEN.LPAREN)) return undefined;	
				
		Next_Token();
		expression.condition = Parse_Expression(PRECEDENCE.LOWEST);
		
		if(!Expect_Peek(TOKEN.RPAREN)) return undefined;
		if(!Expect_Peek(TOKEN.LBRACE)) return undefined;
		
		expression.consequence = Parse_Block_Statement();
		
		if(Peek_Token_Is(TOKEN.ELSE)){
			Next_Token();
			
			if(!Expect_Peek(TOKEN.LBRACE)) return undefined;
			expression.alternative = Parse_Block_Statement();
		}
		
		return expression;		
	}
	
	Parse_Block_Statement = function(){
		var block = new Block_Statement(curr_token);
		
		Next_Token();
		
		while(!Curr_Token_Is(TOKEN.RBRACE) && !Curr_Token_Is(TOKEN.EOF)){
			var statement = Parse_Statement();
			
			if(!is_undefined(statement)) array_push(block.statements, statement);
			
			Next_Token();
		}
		
		return block;
	}
	
	Parse_Function_Literal = function(){
		var literal = new Function_Literal(curr_token);
		
		if(!Expect_Peek(TOKEN.LPAREN)) return undefined;
		
		literal.parameters = Parse_Function_Parameters();
		
		if(!Expect_Peek(TOKEN.LBRACE)) return undefined;
		
		literal.body = Parse_Block_Statement();
		
		
		return literal;
	}
	
	Parse_Function_Parameters = function(){
		var identifiers = [];
		
		if(Peek_Token_Is(TOKEN.RPAREN)){
			Next_Token();
			return identifiers;
		}
		
		Next_Token();
		
		array_push(identifiers, new Identifier(curr_token));
		
		while(Peek_Token_Is(TOKEN.COMMA)){
			Next_Token();
			Next_Token();
			
			array_push(identifiers, new Identifier(curr_token));
		}
		
		if(!Expect_Peek(TOKEN.RPAREN)) return undefined;
		
		return identifiers;
	}
	
	Parse_Call_Expression = function(fn){
		var expression = new Call_Expression(curr_token);
		expression.fn = fn;
		expression.arguments = Parse_Call_Arguments();
		return expression;
	}
	
	Parse_Call_Arguments = function(){
		var args = []; //expressions
		if(Peek_Token_Is(TOKEN.RPAREN)){
			Next_Token();
			return args;			
		}
		
		Next_Token();
		array_push(args, Parse_Expression(PRECEDENCE.LOWEST));
		
		while(Peek_Token_Is(TOKEN.COMMA)){
			Next_Token();
			Next_Token();
			array_push(args, Parse_Expression(PRECEDENCE.LOWEST));
		}
		
		if(!Expect_Peek(TOKEN.RPAREN)) return undefined;
		
		return args;	
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
		debug_print(msg);
		array_push(errors, msg);
	}
	
	No_Prefix_Parser_Error = function(token_type){
		array_push(errors, $"No prefix parse function for {global.token_debug_str[token_type]} found.");
	}
	
	Check_Parser_Errors = function(){
		var num_errors = array_length(errors);
		if (num_errors) return;
		
		for(var i=0; i< num_errors; i++){
			print($"Parser error: {errors[i]}");
		}
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
	
	Peek_Precedence = function(){
		return precedences[? peek_token.type] ?? PRECEDENCE.LOWEST;		
	}
	
	Curr_Precedence = function(){
		return precedences[? curr_token.type] ?? PRECEDENCE.LOWEST;	
	}
	
	Init();
}