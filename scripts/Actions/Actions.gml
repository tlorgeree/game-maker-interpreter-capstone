function Action(method_to_call=undefined, args=[]) constructor{
	fn = method_to_call;
	arguments = args;
	complete = false; //action state
	
	Execute = function(){
		var result = method_call(fn, arguments);
		complete = true;
		array_delete(obj_Main.Get_Player().path, 0, 1);
		debug_print(result);
		return result;
	}
}