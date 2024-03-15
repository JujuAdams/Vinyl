// Feather disable all

/// @param yyPath
/// @param [showEditor=true]

function __VedCreate(_yyPath, _show = true)
{
    static _system = __VedSystem();
    
    VedUnload();
    _system.__project = new __VedClassProject();
    if (not _system.__project.__CreateFromGameMakerProject(_yyPath)) return false;
    
    if (_show) VedShow();
    
    return true;
}