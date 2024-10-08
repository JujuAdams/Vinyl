// Feather disable all
/// @return GML string that encodes the struct
/// 
/// @param buffer
/// @param struct                The struct to be encoded. Can contain structs, arrays, strings, and numbers (but the root must be a struct).   N.B. Will not encode ds_list, ds_map etc.
/// @param [alphabetizeStructs]  (bool) Sorts struct variable names is ascending alphabetical order as per ds_list_sort(). Defaults to <false>
/// @param [indent=""]
/// 
/// @jujuadams 2022-10-30

//Prefix to use for Vinyl macros relating to patterns, as generated by __VinylSetupExportGMLMacros().
#macro __VINYL_PATTERN_MACRO_PREFIX  "vin"

//Prefix to use for Vinyl macros relating to mixes, as generated by __VinylSetupExportGMLMacros().
#macro __VINYL_MIX_MACRO_PREFIX  "vinMix"

//Prefix to use for Vinyl macros relating to queue templates, as generated by __VinylSetupExportGMLMacros().
#macro __VINYL_QUEUE_TEMPLATE_MACRO_PREFIX  "vinQT"

function __VinylBufferWriteGML(_buffer, _struct, _alphabetise = false, _indent = "")
{
    ____VinylBufferWriteGMLInner(_buffer, _struct, _alphabetise, 1, _indent);
}

function ____VinylBufferWriteGMLInner(_buffer, _value, _alphabetise, _depth, _indent)
{
    if (is_method(_value)) //Implicitly also a struct so we have to check this first
    {
        buffer_write(_buffer, buffer_text, "\"");
        buffer_write(_buffer, buffer_text, string(_value));
        buffer_write(_buffer, buffer_text, "\"");
    }
    else if (is_struct(_value))
    {
        var _struct = _value;
        var _names = variable_struct_get_names(_struct);
        var _count = array_length(_names);
        var _i = 0;
        
        if (_alphabetise) array_sort(_names, true);
        
        if (_count > 0)
        {
            if (_depth != 0)
            {
                buffer_write(_buffer, buffer_text, "{\n");
                var _preIndent = _indent;
                _indent += "    ";
            }
            
            var _i = 0;
            repeat(_count)
            {
                var _name = _names[_i];
                if (is_struct(_name) || is_array(_name))
                {
                    show_error("SNAP:\nKey type \"" + typeof(_name) + "\" not supported\n ", false);
                    _name = string(ptr(_name));
                }
                
                if (_depth == 0)
                {
                    buffer_write(_buffer, buffer_text, _indent);
                    buffer_write(_buffer, buffer_text, string(_name));
                    buffer_write(_buffer, buffer_text, " = ");
                    ____VinylBufferWriteGMLInner(_buffer, _struct[$ _name], _alphabetise, _depth+1, _indent);
                    buffer_write(_buffer, buffer_text, ";\n");
                }
                else
                {
                    buffer_write(_buffer, buffer_text, _indent);
                    buffer_write(_buffer, buffer_text, string(_name));
                    buffer_write(_buffer, buffer_text, ": ");
                    ____VinylBufferWriteGMLInner(_buffer, _struct[$ _name], _alphabetise, _depth+1, _indent);
                    buffer_write(_buffer, buffer_text, ",\n");
                }
                
                ++_i;
            }
            
            if (_depth != 0)
            {
                _indent = _preIndent;
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "}");
            }
        }
        else
        {
            buffer_write(_buffer, buffer_text, "{}");
        }
    }
    else if (is_array(_value))
    {
        var _array = _value;
        var _count = array_length(_array);
        if (_count > 0)
        {
            var _preIndent = _indent;
            _indent += "    ";
            
            buffer_write(_buffer, buffer_text, "[\n");
            
            var _i = 0;
            repeat(_count)
            {
                buffer_write(_buffer, buffer_text, _indent);
                ____VinylBufferWriteGMLInner(_buffer, _array[_i], _alphabetise, _depth+1, _indent);
                buffer_write(_buffer, buffer_text, ",\n");
                ++_i;
            }
            
            _indent = _preIndent;
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "]");
        }
        else
        {
            buffer_write(_buffer, buffer_text, "[]");
        }
    }
    else if (is_string(_value))
    {
        //Sanitise strings
        _value = string_replace_all(_value, "\\", "\\\\");
        _value = string_replace_all(_value, "\n", "\\n");
        _value = string_replace_all(_value, "\r", "\\r");
        _value = string_replace_all(_value, "\t", "\\t");
        _value = string_replace_all(_value, "\"", "\\\"");
        
        buffer_write(_buffer, buffer_text, "\"");
        buffer_write(_buffer, buffer_text, _value);
        buffer_write(_buffer, buffer_text, "\"");
    }
    else if (is_undefined(_value))
    {
        buffer_write(_buffer, buffer_text, "undefined");
    }
    else if (is_bool(_value))
    {
        buffer_write(_buffer, buffer_text, _value? "true" : "false");
    }
    else if (is_real(_value))
    {
        buffer_write(_buffer, buffer_text, __VinylNumberToString(_value, true));
    }
    else if (is_ptr(_value))
    {
        buffer_write(_buffer, buffer_text, "ptr(0x");
        buffer_write(_buffer, buffer_text, string(_value));
        buffer_write(_buffer, buffer_text, ")");
    }
    else if (is_int32(_value) || is_int64(_value))
    {
        buffer_write(_buffer, buffer_text, "0x");
        buffer_write(_buffer, buffer_text, string(ptr(_value))); //Cheeky hack to quickly convert to a hex string
    }
    else if (is_handle(_value))
    {
        switch(asset_get_type(_value))
        {
            case asset_object:   buffer_write(_buffer, buffer_text, object_get_name(  _value)); break;
            case asset_sprite:   buffer_write(_buffer, buffer_text, sprite_get_name(  _value)); break;
            case asset_sound:    buffer_write(_buffer, buffer_text, audio_get_name(   _value)); break;
            case asset_room:     buffer_write(_buffer, buffer_text, room_get_name(    _value)); break;
            case asset_tiles:    buffer_write(_buffer, buffer_text, tileset_get_name( _value)); break;
            case asset_path:     buffer_write(_buffer, buffer_text, path_get_name(    _value)); break;
            case asset_script:   buffer_write(_buffer, buffer_text, script_get_name(  _value)); break;
            case asset_font:     buffer_write(_buffer, buffer_text, font_get_name(    _value)); break;
            case asset_timeline: buffer_write(_buffer, buffer_text, timeline_get_name(_value)); break;
            case asset_shader:   buffer_write(_buffer, buffer_text, shader_get_name(  _value)); break;
            
            default:
                buffer_write(_buffer, buffer_text, string(_value));
            break;
        }
    }
    else
    {
        //Some other thing
        buffer_write(_buffer, buffer_text, string(_value));
    }
}
