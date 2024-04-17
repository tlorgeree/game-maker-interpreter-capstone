#region Debug Commands
if(global.debug){
	if(keyboard_check_pressed(vk_escape)) game_end();
}

if(keyboard_check_pressed(ord("R")) && keyboard_check(vk_control)){
	player.Reset_Position();
	New_Maze();
	win = false;
}

if(win){
	animate_timer--;
	if(animate_timer <= 0){
		for(var i=0; i<array_length(board_pattern); i++){
			for(var j=0; j<array_length(board_pattern[i]); j++){
				if(board[i][j] != -1) board[i][j].color = colors[(i+j+color_offset) mod 6];
			}
		}
		
		color_offset++;
		if(color_offset > 5) color_offset = 0;
		animate_timer = animate_timer_max;
	}
}
#endregion