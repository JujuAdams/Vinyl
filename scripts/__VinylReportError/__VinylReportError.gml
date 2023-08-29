function __VinylReportError(_errorStruct, _path, _firstTime)
{
    show_debug_message("");
    __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    __VinylTrace(_errorStruct.longMessage);
    __VinylTrace(_errorStruct.stacktrace);
    __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    show_debug_message("");
    
    var _trimmedMessage = string_replace(_errorStruct.message, "Vinyl:\n", "");
    _trimmedMessage = string_copy(_trimmedMessage, 1, string_length(_trimmedMessage)-1);
    
    if (_firstTime)
    {
        __VinylError("There was an error whilst reading \"", _path, "\"\n \n", _trimmedMessage);
    }
    else
    {
        _trimmedMessage = string_replace_all(_trimmedMessage, "\n", "\n       ");
        __VinylTrace("There was an error whilst reading \"", _path, "\"");
        __VinylTrace(_trimmedMessage);
    }
}