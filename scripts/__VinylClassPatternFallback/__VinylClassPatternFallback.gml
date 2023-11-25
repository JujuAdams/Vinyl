// Feather disable all

function __VinylClassPatternFallback() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_FALLBACK;
    static __pool = __VinylGlobalData().__poolSound;
    static __usesChildArray = false;
    
    __Reset();
    
    __name = __VINYL_FALLBACK_NAME;
    __uuid = __VINYL_FALLBACK_NAME;
    
    static toString = function()
    {
        return "<fallback>";
    }
    
    static __GetName = function(_maxCharacters)
    {
        return "<fallback>";
    }
    
    static __Reset = function()
    {
        __ResetShared();
        
        __loopPointsOption = __VINYL_OPTION_UNSET;
        __loopPoints       = [0, 0];
        __bpmOption        = __VINYL_OPTION_UNSET;
        __bpm              = VINYL_DEFAULT_BPM;
    }
    
    static __Unset = function()
    {
        __VinylError("Cannot unset fallback pattern");
    }
    
    static __Serialize = function(_struct)
    {
        __SerializeShared(_struct);
    }
    
    static __Deserialize = function(_struct)
    {
        __DeserializeShared(_struct);
        
        //Force the name
        __name = __VINYL_FALLBACK_NAME;
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, _sound, _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        return __VinylPlaySimple(_sound, _gain*__gain[0], _gain*__gain[1], _pitch*__pitch[0], _pitch*__pitch[1], __labelArray, _effectChainName);
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        __SharedWidgets(_selectionHandler);
    }
    
    static __SharedWidgets = function(_selectionHandler)
    {
        if (ImGui.BeginTable("Pattern Properties", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 260))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
            
            __VinylEditorPropWidgetGain(       "Gain",         self, undefined, 0, 2, 1);
            __VinylEditorPropWidgetPitch(      "Pitch",        self, undefined, 0, 2, 1);
            __VinylEditorPropWidgetLoop(       "Loop",         self, undefined, 0, 2, 1);
            __VinylEditorPropWidgetLoopPoints( "Loop Points",  self, undefined, 0, 2, 1);
            __VinylEditorPropWidgetStack(      "Stack",        self, undefined, 0, 2, 1);
            __VinylEditorPropWidgetEffectChain("Effect Chain", self, undefined, 0, 2, 1);
            __VinylEditorPropWidgetPersistent( "Persistent",   self, undefined, 0, 2, 1);
            __VinylEditorPropWidgetBPM(        "BPM",          self, undefined, 0, 2, 1);
            __VinylEditorPropWidgetTranspose(  "Transpose",    self, undefined, 0, 2, 1);
            
            ImGui.EndTable();
        }
    }
}
