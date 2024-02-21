function Repl(str) constructor{
	input = str;
	tokens = [];
	literals = [];
	
	Start = function(){
			
		var lexer = new Lexer(input);
		var parser = new Parser(lexer);
			
		var program = parser.Parse_Program();
		for(var i=0; i<array_length(parser.errors); i++){
			show_debug_message("\t" + parser.errors[i]);	
		}
			
		for(var tok = lexer.Next_Token(); tok.type != TOKEN.EOF; tok = lexer.Next_Token()){
			array_push(tokens, global.token_debug_str[tok.type]);
			array_push(literals, tok.literal);
		}
			
		ds_map_destroy(parser.prefix_parse_fns);
		ds_map_destroy(parser.infix_parse_fns);
		
		show_debug_message(program.String());
		show_debug_message(tokens);
		show_debug_message(literals);
	}
	
	
}