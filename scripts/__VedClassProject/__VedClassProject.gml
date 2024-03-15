// Feather disable all

function __VedClassProject() constructor
{
    __projectPath = undefined;
    
    __ident = undefined;
    
    
    
    static __Update = function()
    {
        
    }
    
    static __Serialize = function()
    {
        return {
            ident: __ident,
        };
    }
    
    static __Deserialize = function(_input)
    {
        __ident = ident;
    }
    
    
    
    static __Load = function(_projectPath)
    {
        __VedTrace("Loading \"", _projectPath, "\"");
        __projectPath = _projectPath;
        
        if (not file_exists(__projectPath))
        {
            __VedWarning("Vinyl project doesn't exist");
            __VedModalOpen(__VedClassModalLoadFailed).__path = __projectPath;
            return;
        }
        
        var _buffer = buffer_load(__projectPath);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = undefined;
        try
        {
            _json = json_stringify(_string);
        }
        catch(_error)
        {
            show_debug_message(_error);
        }
        
        if (_json == undefined)
        {
            __VedWarning("Failed to parse Vinyl project");
            __VedModalOpen(__VedClassModalLoadFailed).__path = __projectPath;
            return;
        }
        
        try
        {
            __Deserialize(_json);
            __VedModalOpen(__VedClassModalLoadSuccess).__path = __projectPath;
        }
        catch(_error)
        {
            show_debug_message(_error);
            __VedWarning("Failed to deserialize Vinyl project");
            __VedModalOpen(__VedClassModalLoadFailed).__path = __projectPath;
        }
    }
    
    static __Unload = function()
    {
        __VedTrace("Unloading \"", __projectPath, "\"");
    }
    
    static __Save = function()
    {
        var _output = __Serialize();
        var _string = json_stringify(_output, true);
        
        var _buffer = buffer_create(string_byte_length(_string), buffer_text, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, __projectPath);
        buffer_delete(_buffer);
    }
}