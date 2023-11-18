// Feather disable all

function __VinylClassPatternSoundRef() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_SOUND_REF;
    
    static __child = true;
    
    __parent = undefined;
    __sound = undefined;
    __soundTempName = "";
    
    static toString = function()
    {
        return "<sound ref " + string(__sound) + " " + audio_get_name(__sound) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        _struct.type = __VINYL_PATTERN_TYPE_SOUND_REF;
        _struct.name = audio_get_name(__sound);
    }
    
    static __Deserialize = function(_struct, _child__UNUSED)
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
            ImGui.Text("Sound");
            ImGui.TableSetColumnIndex(1);
            
            var _textOld       = (__sound == undefined)? __VINYL_ASSET_NULL : audio_get_name(__sound);
            var _textNew       = _textOld;
            var _textInput     = ImGui.InputText("##Sound Text Field", _textOld, ImGuiInputTextFlags.EnterReturnsTrue);
            var _textEdited    = ImGui.IsItemDeactivatedAfterEdit();
            var _textActive    = ImGui.IsItemActive();
            var _textActivated = ImGui.IsItemActivated();
            
            if (_textActivated)
            {
                ImGui.OpenPopup("##Sound Text Pop-up");
            }
            
            ImGui.SetNextWindowPos(ImGui.GetItemRectMinX(), ImGui.GetItemRectMaxY());
            ImGui.SetNextWindowSize(ImGui.GetItemRectMaxX() - ImGui.GetItemRectMinX(), 120);
            if (ImGui.BeginPopup("##Sound Text Pop-up", ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize | ImGuiWindowFlags.ChildWindow))
            {
                var _autocomplete = ["cat", "dog", "rabbits", "turtles"];
                
                var _i = 0;
                repeat(array_length(_autocomplete))
                {
                    if (ImGui.Selectable(_autocomplete[_i]))
                    {
                        _textNew = _autocomplete[_i];
                    }
                    
                    ++_i;
                }
                
                if (_textEdited || ((not _textActive) && (not ImGui.IsWindowFocused())))
                {
                    if (_textEdited) _textNew = _textInput;
                    ImGui.CloseCurrentPopup();
                }
                
                ImGui.EndPopup();
            }
            
            if (_textNew != _textOld)
            {
                var _sound = asset_get_index(_textNew);
                if (audio_exists(_sound)) __sound = _sound;
            }
            
            ImGui.EndTable();
        }
    }
}
