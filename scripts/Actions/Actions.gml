function Actions() constructor{
	fn = undefined;
	args = [];
	Execute = function(){
		method_call(fn, args);
	}
}