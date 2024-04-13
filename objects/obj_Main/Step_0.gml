#region Debug Commands
if(global.debug){
	if(keyboard_check_pressed(vk_escape)) game_end();
}

if(keyboard_check_pressed(ord("R")) && keyboard_check(vk_control)){
	debug_print("this fired");
	player.Reset_Position();
	New_Maze();
	win = false;
}
#endregion