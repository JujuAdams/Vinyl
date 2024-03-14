// Feather disable all

/// @param buffer
/// @param offset
/// @param size

function __VedNetReceiveBuffer(_buffer, _offset, _size)
{
    var _type = buffer_read(_buffer, buffer_string);
    switch(_type)
    {
        case "json":
            var _jsonString = buffer_read(_buffer, buffer_string);
            var _json = json_parse(_jsonString);
            switch(_json[$ "__type"])
            {
                case "load project":
                    var _path = _json[$ "__path"];
                    if (_path == undefined) __VinylError("JSON missing .__path field");
                    VedLoad(_path, false);
                break;
                
                case "rpc":
                    __VedError("JSON type \"", _json[$ "__type"], "\" not supported");
                break;
                
                default:
                    __VedError("Unhandled JSON type \"", _json[$ "__type"], "\"");
                break;
            }
        break;
        
        default:
            __VedError("Unhandled buffer type \"", _type, "\"");
        break;
    }
}