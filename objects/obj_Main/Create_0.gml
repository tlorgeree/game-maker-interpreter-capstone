#region Init
display_set_gui_size(1920, 1080);
global.debug = true;
window_set_fullscreen(0);
#endregion

#region Managers
global.Window_Manager = new GUI_Window_Manager();
global.Window_Manager.Create_Window(50, 50);
global.Game_Manager = new Game_Manager();
#endregion

#region Token Debug String Map
global.token_debug_str = array_create(TOKEN.RETURN+1, "");
global.token_debug_str[TOKEN.ILLEGAL] = "ILLEGAL";
global.token_debug_str[TOKEN.EOF] = "EOF";
global.token_debug_str[TOKEN.IDENT] = "IDENT";
global.token_debug_str[TOKEN.INT] = "INT";
global.token_debug_str[TOKEN.ASSIGN] = "ASSIGN";
global.token_debug_str[TOKEN.PLUS] = "PLUS";
global.token_debug_str[TOKEN.MINUS] = "MINUS";
global.token_debug_str[TOKEN.BANG] = "BANG";
global.token_debug_str[TOKEN.ASTERISK] = "ASTERISK";
global.token_debug_str[TOKEN.SLASH] = "SLASH";
global.token_debug_str[TOKEN.GT] = "GT";
global.token_debug_str[TOKEN.LT] = "LT";
global.token_debug_str[TOKEN.EQ] = "EQ";
global.token_debug_str[TOKEN.NOT_EQ] = "NOT_EQ";
global.token_debug_str[TOKEN.COMMA] = "COMMA";
global.token_debug_str[TOKEN.SEMICOLON] = "SEMICOLON";
global.token_debug_str[TOKEN.LPAREN] = "LPAREN";
global.token_debug_str[TOKEN.RPAREN] = "RPAREN";
global.token_debug_str[TOKEN.LBRACE] = "LBRACE";
global.token_debug_str[TOKEN.RBRACE] = "RBRACE";
global.token_debug_str[TOKEN.FUNCTION] = "FUNCTION";
global.token_debug_str[TOKEN.LET] = "LET";
global.token_debug_str[TOKEN.TRUE] = "TRUE";
global.token_debug_str[TOKEN.FALSE] = "FALSE";
global.token_debug_str[TOKEN.IF] = "IF";
global.token_debug_str[TOKEN.ELSE] = "ELSE";
global.token_debug_str[TOKEN.RETURN] = "RETURN";
#endregion

#region Keyword Map
global.keywords = ds_map_create();
global.keywords[? "fn"] = TOKEN.FUNCTION;
global.keywords[? "let"] = TOKEN.LET	;
global.keywords[? "true"] = TOKEN.TRUE;
global.keywords[? "false"] = TOKEN.FALSE;
global.keywords[? "if"] = TOKEN.IF;
global.keywords[? "else"] = TOKEN.ELSE;
global.keywords[? "return"] = TOKEN.RETURN;
#endregion

#region Object Type Keywords
global.object_type_str = ds_map_create();
global.object_type_str[? OBJECT_TYPE.INTEGER] = "INTEGER";
global.object_type_str[? OBJECT_TYPE.BOOLEAN] = "BOOLEAN";
global.object_type_str[? OBJECT_TYPE.NULL] = "NULL";
#endregion

let_statement_test = @"
	-5;
	let x = -5;
	let y = 10;
	let foobar = 838383;
	let z = 100 + 100;
	let schoob = 1000 - 5 * 4;
	a + b * c + d / e - f;
	3 + 4; -5 * 5;
	5 < 4 != 3 > 4;
	3 + 4 * 5 == 3 * 1 + 4 * 5;
	let t = true ;
	if(t == true){
		y;
	} else {
		z;
	}
	fn(x, y) { x + y; }
	add(1, add(2, 3)); 
	return;
";

/*
repl = new Repl("5");
repl.Start();*/

lex = new Lexer("5");
p = new Parser(lex);
program = p.Parse_Program();

show_message(Eval(program).value);
