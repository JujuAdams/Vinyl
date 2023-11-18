// Feather disable all

function __VinylClassPatternBasic() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_BASIC;
    static __pool = __VinylGlobalData().__poolBasic;
    
    //Specific variables for basic patterns
    __sound = undefined;
    
    static toString = function()
    {
        return (__sound == undefined)? "<basic ???>" : "<basic " + audio_get_name(__sound) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        __SerializeShared(_struct);
        
        _struct.sound = audio_get_name(__sound);
    }
    
    static __Deserialize = function(_struct, _child)
    {
        __DeserializeShared(_struct, _child);
        
        __sound = asset_get_index(_struct.__sound);
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, __sound, _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound_UNUSED, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        return __VinylPatternGet(__sound).__PlaySimple(__sound, _gain*0.5*(__gain[0] + __gain[1]), _pitch*0.5*(__pitch[0] + __pitch[1]), _effectChainName); //TODO - Inherit properly
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        //For easier reading, all the widgets are handled by parsing this array!
        static _displayWidgetArray = [
            { __name: "Gain",         __function: __VinylEditorPropWidgetGain,        },
            { __name: "Pitch",        __function: __VinylEditorPropWidgetPitch,       },
            { __name: "Loop",         __function: __VinylEditorPropWidgetLoop,        },
            { __name: "Stack",        __function: __VinylEditorPropWidgetStack,       },
            { __name: "Effect Chain", __function: __VinylEditorPropWidgetEffectChain, },
            { __name: "Persistent",   __function: __VinylEditorPropWidgetPersistent,  },
            { __name: "Transpose",    __function: __VinylEditorPropWidgetTranspose,   },
        ];
        
        //Now do the actual table
        if (ImGui.BeginTable("Vinyl Properties", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
            
            //Make aaaall the widgets
            var _i = 0;
            repeat(array_length(_displayWidgetArray))
            {
                var _displayWidget = _displayWidgetArray[_i];
                _displayWidget.__function(__name, self, __parent, 0, 2, 1);
                ++_i;
            }
            
            ImGui.EndTable();
        }
    }
}
