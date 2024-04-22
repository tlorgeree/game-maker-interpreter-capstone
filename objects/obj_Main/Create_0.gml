#region Init
randomize();
display_set_gui_size(960, 540);
global.debug = false;
window_set_fullscreen(0);
win = false;
animate_timer_max = 7; 
animate_timer = 0;
colors = [c_red, c_orange, c_yellow, c_lime, c_aqua, c_fuchsia];
color_offset = 0;
#endregion

#region Managers
global.Window_Manager = new GUI_Window_Manager();
global.Window_Manager.Create_Window(544, 0);

global.output_window = global.Window_Manager.Create_Window(544, room_height-room_height*(1/4), true);
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
global.token_debug_str[TOKEN.VAR] = "VAR";
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
global.keywords[$ "var"] = TOKEN.VAR;
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

#region Get Singleton
player = undefined;
Get_Player = function() { return player; }
goal = undefined;
Get_Goal = function() { return goal; }
#endregion

#region Maze
board_w = 17;
board_h = 16;
board = array_create(board_w, -1);
for(var i=0; i<board_w; i++) board[i] = array_create(board_h, -1);

board_pattern = Create_Maze();

for(var i=0; i<board_w; i++){
	for(var j=0; j<board_h; j++){
		if(board_pattern[i][j] == 1){
			board[i][j] = instance_create_layer(i*TILE_SIZE, j*TILE_SIZE, "Instances", obj_Wall);
		}
	}
}

player = instance_create_layer(TILE_SIZE*1, TILE_SIZE*14, "Instances", obj_Player, {
	coords : [1,14]
});

goal = instance_create_layer(TILE_SIZE*15, TILE_SIZE*1, "Instances", obj_Goal, {
	coords : [15,1]
});

New_Maze = function(int=3){
	board_pattern = Create_Maze(int);
	
	for(var i=0; i<board_w; i++){
		for(var j=0; j<board_h; j++){
			if(board[i][j] != -1){
				instance_destroy(board[i][j]);
				board[i][j] = -1;
			}
			if(board_pattern[i][j] == 1){
				board[i][j] = instance_create_layer(i*TILE_SIZE, j*TILE_SIZE, "Instances", obj_Wall);
			}
		}
	}
	path_a_star = a_star(player.coords, goal.coords, board_pattern);
	path_breadth_first = breadth_first_path(player.coords, goal.coords, board_pattern);
	path_depth_first = depth_first_path(player.coords, goal.coords, board_pattern);

	global.output_window.text = [""];
}

Coords_Within_Bounds = function(coord_arr){
	if(!is_array(coord_arr)) return false;
	return (coord_arr[0] >=0 && coord_arr[0]<board_w && coord_arr[1]>=0 && coord_arr[1]<board_h);
}

Coords_Get_Instance = function(coord_arr){
	if(!Coords_Within_Bounds(coord_arr)) return false;
	return board[coord_arr[0]][coord_arr[1]];
}

show_a_star_ghost = false;
show_bfs_ghost = false;
show_dfs_ghost = false;
path_a_star = dfs(player.coords[0], player.coords[1], goal.coords[0], goal.coords[1], board_pattern);//a_star(player.coords, goal.coords, board_pattern);
path_breadth_first = [];//breadth_first_path(player.coords, goal.coords, board_pattern);
path_depth_first = [];//depth_first_path(player.coords, goal.coords, board_pattern);

#endregion