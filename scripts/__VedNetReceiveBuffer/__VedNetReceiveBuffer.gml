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
                case "create project":
                    var _path = _json[$ "__yyPath"];
                    if (_path == undefined) __VinylError("JSON missing .__yyPath field");
                    __VedCreate(_path, false);
                break;
                
                case "load project":
                    var _path = _json[$ "__yyPath"];
                    if (_path == undefined) __VinylError("JSON missing .__yyPath field");
                    VedLoad(_path, false);
                break;
                
                case "identify project":
                    var _ident = _json[$ "__ident"];
                    if (_ident == undefined) __VinylError("JSON missing .__ident field");
                    __VedModalOpen(__VedClassModalIdentifyProject).__receivedIdent = _ident;
                break;
                
                case "no ident found":
                    __VedModalOpen(__VedClassModalNoIdent);
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