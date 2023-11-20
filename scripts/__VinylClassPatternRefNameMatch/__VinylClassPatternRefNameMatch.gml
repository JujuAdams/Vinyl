// Feather disable all

function __VinylClassPatternRefNameMatch() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_SOUND_REF;
    
    static __child = true;
    
    __parent    = undefined;
    
    __reference   = "";
    __soundsArray = [];
    
    __VinylDocument().__Subscribe("project reload", self, __UpdateSounds);
    
    
    
    static toString = function()
    {
        return "<sound ref " + string(__sound) + " " + audio_get_name(__sound) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        _struct.type = __VINYL_PATTERN_TYPE_SOUND_REF;
        _struct.name = audio_get_name(__sound);
    }
    
    static __Deserialize = function(_struct, _parent)
    {
        __sound = asset_get_index(_struct.name);
    }
    
    static __Store = function(_document)
    {
        _document.__patternDict[$ __name] = self;
    }
    
    static __Discard = function(_document)
    {
        if (is_struct(__parent))
        {
            var _index = __VinylArrayFindIndex(__parent.__childArray, self);
            if (_index != undefined)
            {
                array_delete(__parent.__childArray, _index, 1);
            }
        }
        else
        {
            variable_struct_remove(_document.__patternDict, __name);
        }
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        __VinylError("TODO");
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        __VinylError("TODO");
    }
    
    static __UpdateSounds = function()
    {
        __soundsArray = variable_clone(__VinylFindMatchingSounds(__reference, __VinylDocument().__projectSoundArray));
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        //Now do the actual table
        if (ImGui.BeginTable("Vinyl Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",  ImGuiTableColumnFlags.WidthFixed,   100);
            ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthStretch,   1);
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Reference");
            ImGui.TableSetColumnIndex(1);
            
            var _oldValue = __reference;
            __reference = ImGui.InputText("##Sound Ref Name Match Input", __reference);
            if (_oldValue != __reference) __UpdateSounds();
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Sounds");
            ImGui.TableSetColumnIndex(1);
            ImGui.BeginChild();
                if (array_length(__soundsArray) <= 0)
                {
                    ImGui.Text("No sounds found");
                }
                else
                {
                    var _i = 0;
                    repeat(array_length(__soundsArray))
                    {
                        ImGui.Text(__soundsArray[_i]);
                        ++_i;
                    }
                }
            ImGui.EndChild();
            
            ImGui.EndTable();
        }
    }
}
