draw_sprite_stretched(sprite_index, image_index, x, y, window_w, window_h);

draw_set_font(fnt_Default);
draw_set_color(c_lime);

for(var i=0; i<array_length(viewable_text);i++){
	if(array_length(highlighted_text_range) == 2){
		if(i == highlighted_text_range[0,1] && i == highlighted_text_range[1,1]){
			var first_text = Get_Text_Before_Coords(highlighted_text_range[0,0],highlighted_text_range[0,1]);
			var middle_text = string_delete(Get_Text_Before_Coords(highlighted_text_range[1,0], highlighted_text_range[1,1]), 
				1, highlighted_text_range[0,0]);
			var end_text = Get_Text_After_Coords(highlighted_text_range[1,0], highlighted_text_range[1,1]);
			draw_text(x + 10, y + 24 + (19*i), first_text);
			var x_start = x + 10 + string_width(first_text);
			var y_start = y + 24 + (19*i);
			draw_set_color(c_white);
			draw_rectangle(x_start, y_start, x_start+string_width(middle_text),y_start + 19, 0);
			draw_set_color(c_blue);
			draw_text(x + 10 + string_width(first_text), y + 24 + (19*i), middle_text);
			draw_set_color(c_lime);
			draw_text(x + 10 + string_width(first_text)+string_width(middle_text), y+24+(19*i), end_text);
		}else if(i == highlighted_text_range[0,1]){
			var first_text = Get_Text_Before_Coords(highlighted_text_range[0,0],highlighted_text_range[0,1]);
			var end_text = Get_Text_After_Coords(highlighted_text_range[0,0], highlighted_text_range[0,1]);
			
			draw_text(x + 10, y + 24 + (19*i), first_text);
			draw_set_color(c_white);
			var x_start = x + 10 + string_width(first_text);
			var y_start = y + 24 + (19*i);
			draw_rectangle(x_start, y_start, x_start+string_width(end_text),y_start + 19, 0);
			draw_set_color(c_blue);
			draw_text(x + 10 + string_width(first_text), y + 24 + (19*i), end_text);
		}else if(i == highlighted_text_range[1,1]){
			var first_text = Get_Text_Before_Coords(highlighted_text_range[1,0],highlighted_text_range[1,1]);
			var end_text = Get_Text_After_Coords(highlighted_text_range[1,0], highlighted_text_range[1,1]);
			
			var x_start = x + 10;
			var y_start = y + 24 + (19*i);
			draw_set_color(c_white);
			draw_rectangle(x_start, y_start, x_start+string_width(first_text),y_start + 19, 0);
			draw_set_color(c_blue);
			draw_text(x + 10, y + 24 + (19*i), first_text);
			draw_set_color(c_lime);
			draw_text(x + 10 + string_width(first_text), y + 24 + (19*i), end_text);
		}else if(i > highlighted_text_range[0,1] && i < highlighted_text_range[1,1]){
			var x_start = x + 10;
			var y_start = y + 24 + (19*i);
			draw_set_color(c_white);
			draw_rectangle(x_start, y_start, x_start+string_width(viewable_text[i]),y_start + 19, 0);
			draw_set_color(c_blue);
			draw_text(x + 10, y + 24 + (19*i), viewable_text[i]);
		}else draw_text(x + 10, y + 24 + (19*i), viewable_text[i]);
		
	}else draw_text(x + 10, y + 24 + (19*i), viewable_text[i]);
}

draw_text(x+5+(9*cursor_coords[0]), y+24+(19*cursor_coords[1]), (!output && cursor_visible) ? "|" : "");
draw_set_color(c_white);