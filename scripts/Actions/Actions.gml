function Action(method_to_call=undefined, args=[]) constructor{
	fn = method_to_call;
	arguments = args;
	complete = false; //action state
	
	Execute = function(){
		method_call(fn, arguments);
		complete = true;
	}
}