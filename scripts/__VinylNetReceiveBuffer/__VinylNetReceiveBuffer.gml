// Feather disable all

/// @param buffer
/// @param offset
/// @param size

function __VinylNetReceiveBuffer(_buffer, _offset, _size)
{
    static _rpcDict = __VinylSystem().__rpcDict;
    if (not VINYL_LIVE_EDIT) return;
    
    var _type = buffer_read(_buffer, buffer_string);
    switch(_type)
    {
        case "json":
            var _jsonString = buffer_read(_buffer, buffer_string);
            var _json = json_parse(_jsonString);
            switch(_json[$ "__type"])
            {
                case "rpc":
                    var _name      = _json[$ "__name"];
                    var _arguments = _json[$ "__arguments"];
                    
                    if (_name      == undefined) __VinylError("JSON missing .__name field");
                    if (_arguments == undefined) __VinylError("JSON missing .__arguments field");
                    
                    var _function = _rpcDict[$ _name];
                    if (_function == undefined) __VinylError("RPC \"", _name, "\" not recognised");
                    script_execute_ext(_function, _arguments);
                break;
                
                case "create project":
                case "load project":
                case "identify project":
                case "no ident found":
                    __VinylError("JSON type \"", _json[$ "__type"], "\" not supported");
                break;
                
                default:
                    __VinylError("Unhandled JSON type \"", _json[$ "__type"], "\"");
                break;
            }
        break;
        
        default:
            __VinylError("Unhandled buffer type \"", _type, "\"");
        break;
    }
}