function VinylGuiShowAsset(_asset)
{
    static _globalData = __VinylGlobalData();
    
    dbg_view("Vinyl", true);
    
    var _pattern = __VinylPatternGet(_asset);
    var _guiStruct = {};
    
    _pattern.__GuiExportStruct(_guiStruct);
    
    _globalData.__guiPattern  = _pattern;
    _globalData.__guiCurrent  = _guiStruct;
    _globalData.__guiPrevious = __VinylDeepCopy(_guiStruct)
    
    _pattern.__GuiBuildForStruct(_guiStruct);
}