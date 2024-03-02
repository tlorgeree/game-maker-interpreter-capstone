#region Init
display_set_gui_size(1920, 1080);
global.debug = true;
window_set_fullscreen(0);
#endregion

#region Managers
global.Window_Manager = new GUI_Window_Manager();
global.Window_Manager.Create_Window(50, 50);
global.Game_Manager = new Game_Manager();

global.output_window = global.Window_Manager.Create_Window(700, 50);
global.output_window.active = false;
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
global.token_debug_str[TOKEN.LBRACKET] = "LBRACE";
global.token_debug_str[TOKEN.RBRACKET] = "RBRACE";
global.token_debug_str[TOKEN.LBRACE] = "LBRACE";
global.token_debug_str[TOKEN.RBRACE] = "RBRACE";
global.token_debug_str[TOKEN.FUNCTION] = "FUNCTION";
global.token_debug_str[TOKEN.LET] = "LET";
global.token_debug_str[TOKEN.TRUE] = "TRUE";
global.token_debug_str[TOKEN.FALSE] = "FALSE";
global.token_debug_str[TOKEN.IF] = "IF";
global.token_debug_str[TOKEN.ELSE] = "ELSE";
global.token_debug_str[TOKEN.RETURN] = "RETURN";
global.token_debug_str[TOKEN.WHILE] = "WHILE";
global.token_debug_str[TOKEN.FOR] = "FOR";
#endregion

#region Keyword Map
global.keywords = {}
global.keywords[$ "function"] = TOKEN.FUNCTION;
global.keywords[$ "let"] = TOKEN.LET;
global.keywords[$ "true"] = TOKEN.TRUE;
global.keywords[$ "false"] = TOKEN.FALSE;
global.keywords[$ "if"] = TOKEN.IF;
global.keywords[$ "else"] = TOKEN.ELSE;
global.keywords[$ "return"] = TOKEN.RETURN;
global.keywords[$ "while"] = TOKEN.WHILE;
global.keywords[$ "for"] = TOKEN.FOR;
#endregion

#region Object Type Keywords
global.object_type_str = {}
global.object_type_str[$ OBJECT_TYPE.INTEGER] = "INTEGER";
global.object_type_str[$ OBJECT_TYPE.BOOLEAN] = "BOOLEAN";
global.object_type_str[$ OBJECT_TYPE.NULL] = "NULL";
global.object_type_str[$ OBJECT_TYPE.RETURN_VALUE] = "RETURN_VALUE";
global.object_type_str[$ OBJECT_TYPE.ERROR] = "ERROR";
global.object_type_str[$ OBJECT_TYPE.FUNCTION] = "FUNCTION";
global.object_type_str[$ OBJECT_TYPE.ARRAY] = "ARRAY";
#endregion

let_statement_test = @"
	let add = function(x,y) { x+y;}
	
	let z = 1;
	z=2;
	for(let i = 1; i<10; i = i+1;){
		z = add(z, 1);
	}
	return z;
";

ifstmt = @"

let z = [[1,2],[3,4]];
return z[1][0];

";
repl = new Repl(ifstmt);
repl.Start();