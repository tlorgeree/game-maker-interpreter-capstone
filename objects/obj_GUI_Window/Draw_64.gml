draw_sprite_stretched(sprite_index, image_index, x, y, window_w, window_h);
//for button implementation
//if(active) draw_sprite(spr_Clear,0, x + window_w - 32, y + 1);
draw_set_font(fnt_Default);
draw_set_color(c_lime);

for(var i=0; i<array_length(text);i++){
	draw_text(x+10, y+24+(19*i), text[i]);
}

draw_text(x+5+(9*cursor_coords[0]), y+24+(19*cursor_coords[1]), (!output && cursor_visible) ? "|" : "");
draw_set_color(c_white);