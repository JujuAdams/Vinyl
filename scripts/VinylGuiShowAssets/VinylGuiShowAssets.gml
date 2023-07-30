function VinylGuiShowAsset(_asset)
{
    static _globalData = __VinylGlobalData();
    
    var _pattern = __VinylPatternGet(_asset);
    
    dbg_view(_pattern.__GetDisplayName(), true);
    
    var _guiStruct = {};
    
    _pattern.__GuiExportStruct(_guiStruct);
    _pattern.__GuiBuildForStruct(_guiStruct);
    dbg_button("Apply", dbg_ref(global, "testFunc"));
    
    _globalData.__guiPattern  = _pattern;
    _globalData.__guiCurrent  = _guiStruct;
    _globalData.__guiPrevious = __VinylDeepCopy(_guiStruct)
}