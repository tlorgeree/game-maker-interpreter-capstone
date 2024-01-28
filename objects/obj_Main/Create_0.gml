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

#region Interpreter
#region Token Keywords
enum TOKEN {
	ILLEGAL,
	EOF,
	IDENT,
	INT,
	
	// Operators
	ASSIGN,
	PLUS,
	MINUS,
	BANG,
	ASTERISK,
	SLASH,
	GT,
	LT,
	EQ,
	NOT_EQ,
	
	// Delimeters
	COMMA,
	SEMICOLON,
	LPAREN,
	RPAREN,
	LBRACE,
	RBRACE,
	
	// Keywords
	FUNCTION,
	LET,
	TRUE,
	FALSE,
	IF,
	ELSE,
	RETURN,
}

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
#endregion


test_string =[
	@"let five = 5; 
	let ten = 10;
	let add = fn(x, y) {
	x + y;
	};
	let result = add(five, ten);
	!-/*5;
	5 < 10 > 5;
	if (5 < 10) {
	return true;
	} else {
	return false;
	}
	10 == 10;
	10 != 9;
"
];

repl = new Repl(test_string);