function Repl(str) constructor{
	input = str;
	tokens = [];
	literals = [];
	
	Start = function(){
		var lexer = new Lexer(input);
		var parser = new Parser(lexer);
			
		var program = parser.Parse_Program();
		for(var i=0; i<array_length(parser.errors); i++){
			print("\t" + parser.errors[i]);	
		}
		
		var evaluated = Eval(program, new Environment());
		if(!is_undefined(evaluated)){
			print("out: " + evaluated.Inspect());	
		}		
		
		debug_print(program.String());
		
		debug_print(tokens);
		debug_print(literals);
		
		return evaluated.Inspect();
	}
	
	
}