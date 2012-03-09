//--XHR Class extends Object -- requires xmlListObject to be an instance of XMLList Class
//------------------------------------------------------------------------------------------------------------------------------------------
function XHR (url, xmlListObject, nodeID)
{
    var xhr;
    
    if (window.XMLHttpRequest)
    {
	xhr = new XMLHttpRequest ();
    }
    else
    {
	if (window.ActiveXObject)
	{
	    try
	    {
		xhr = new ActiveXObject ("Microsoft.XMLHTTP");
	    }
	    catch (err){}
	}
    }
    
    if (xhr)
    {
	xhr.onreadystatechange = checkStatus;
	xhr.open ("GET", url, true);
	xhr.send (null);
    }
    else
    {
	alert ("there was a problem creating the XMLHttpRequest");
    }
    
    function checkStatus ()
    {
	if (xhr.readyState == 4)
	{
	    if (xhr.status == 200)
	    {
		xmlListObject.setData (xhr.responseXML.getElementsByTagName (nodeID));
	    }
	}
    }
}