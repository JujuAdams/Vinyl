// Feather disable all

/// @param queueTemplateName
/// @param [gain=1]
/// @param [emitter]
/// @param [fadeInRate=infinity]

function VinylQueueCreateFromTemplate(_queueTemplateName, _gain = 1, _emitter = undefined, _fadeInRate = infinity)
{
    static _system = __VinylSystem();
    static _queueTemplateDict = _system.__queueTemplateDict;
    
    var _queueTemplate = _queueTemplateDict[$ _queueTemplateName];
    if (_queueTemplate == undefined)
    {
        __VinylError($"Queue template with name \"{_queueTemplateName}\" not found");
    }
    
    return _queueTemplate.__CreateFrom(_gain, _emitter, _fadeInRate);
}