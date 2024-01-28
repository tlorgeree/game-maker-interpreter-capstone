function Token(token_type=TOKEN.ILLEGAL, ch="") constructor{
	type = token_type;
	literal = ch;

	#endregion
	
	Lookup_Ident = function(ident){
		if(!is_undefined(global.keywords[? ident])) return global.keywords[? ident];
		
		return TOKEN.IDENT;
	}
}