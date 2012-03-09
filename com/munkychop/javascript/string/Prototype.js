String.prototype.makeCamelCase = function ()
{
	return this.replace(/(\_[a-z])/g, function($1){return $1.toUpperCase().replace('_','');});
}

String.prototype.capitalizeFirstLetter = function ()
{
	return this.charAt(0).toUpperCase() + this.slice(1);
}