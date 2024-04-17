if(!is_undefined(path_a_star)){
	for(var i=0; i<array_length(path_a_star); i++){
		if!(path_a_star[i][0] == player.coords[0] && path_a_star[i][1] == player.coords[1])
			draw_sprite_ext(spr_Player,0,path_a_star[i][0]*TILE_SIZE, path_a_star[i][1]*TILE_SIZE,1,1,0,c_lime,0.5);	
	}
}

if(!is_undefined(path_breadth_first)){
	for(var i=0; i<array_length(path_breadth_first); i++){
		if!(path_breadth_first[i][0] == player.coords[0] && path_breadth_first[i][1] == player.coords[1])
			draw_sprite_ext(spr_Player,0,path_breadth_first[i][0]*TILE_SIZE, path_breadth_first[i][1]*TILE_SIZE,1,1,0,c_yellow,0.5);	
	}
}

if(!is_undefined(path_depth_first)){
	for(var i=0; i<array_length(path_depth_first); i++){
		if!(path_depth_first[i][0] == player.coords[0] && path_depth_first[i][1] == player.coords[1])
			draw_sprite_ext(spr_Player,0,path_depth_first[i][0]*TILE_SIZE, path_depth_first[i][1]*TILE_SIZE,1,1,0,c_red,0.5);	
	}
}