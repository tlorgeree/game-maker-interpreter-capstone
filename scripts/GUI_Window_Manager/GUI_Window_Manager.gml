function GUI_Window_Manager() constructor{
	windows = [];
	
	Create_Window = function(_x, _y, is_output_window=false){
		var window = instance_create_layer(_x, _y,"Managers",obj_GUI_Window, { output : is_output_window });
		array_push(windows, window);
		return window;
	}
	
	Destroy_Window = function(index){
		instance_destroy(windows[index]);
		array_delete(windows, index, 1);
	}
	
	Clear_Windows = function(){
		for(var i=array_length(windows)-1; i>=0; i--) Destroy_Window(i);
	}
}