function $import (classPath)
{
    var scriptTag = document.createElement ('script');
    scriptTag.type = 'text/javascript';
    scriptTag.src = classPath;
    
    document.getElementsByTagName ('head')[0].appendChild (scriptTag);
}