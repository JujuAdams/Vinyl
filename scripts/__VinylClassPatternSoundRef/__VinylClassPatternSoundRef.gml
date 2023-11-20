// Feather disable all

function __VinylClassPatternSoundRef() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_SOUND_REF;
    
    static __child = true;
    
    __parent        = undefined;
    __sound         = undefined;
    __reference     = "";
    __refType       = __VINYL_REF_SIMPLE;
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
            ImGui.Text("Ref Type");
            ImGui.TableSetColumnIndex(1);
            
            if (ImGui.BeginCombo("##Reference Type Combobox", __refType, ImGuiComboFlags.None))
            {
                if (ImGui.Selectable(__VINYL_REF_SIMPLE, __refType == __VINYL_REF_SIMPLE))
                {
                    __refType = __VINYL_REF_SIMPLE;
                }
                
                if (ImGui.Selectable(__VINYL_REF_NAME_MATCH, __refType == __VINYL_REF_NAME_MATCH))
                {
                    __refType = __VINYL_REF_NAME_MATCH;
                }
                
                if (ImGui.Selectable(__VINYL_REF_ASSET_TAG, __refType == __VINYL_REF_ASSET_TAG))
                {
                    __refType = __VINYL_REF_ASSET_TAG;
                }
                
                ImGui.EndCombo();
            }
            
            switch(__refType)
            {
                case __VINYL_REF_SIMPLE:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Reference");
                    ImGui.TableSetColumnIndex(1);
                    
                    var _textOld       = (__sound == undefined)? __VINYL_ASSET_NULL : audio_get_name(__sound);
                    var _textNew       = _textOld;
                    var _textInput     = ImGui.InputText("##Sound Text Field", __soundTempName, ImGuiInputTextFlags.EnterReturnsTrue);
                    var _textEdited    = ImGui.IsItemDeactivatedAfterEdit();
                    var _textActive    = ImGui.IsItemActive();
                    var _textActivated = ImGui.IsItemActivated();
                    
                    if (_textActivated)
                    {
                        ImGui.OpenPopup("##Sound Text Pop-up");
                    }
                    
                    ImGui.SetNextWindowPos(ImGui.GetItemRectMinX(), ImGui.GetItemRectMaxY());
                    ImGui.SetNextWindowSize(ImGui.GetItemRectMaxX() - ImGui.GetItemRectMinX(), 186);
                    if (ImGui.BeginPopup("##Sound Text Pop-up", ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize | ImGuiWindowFlags.ChildWindow))
                    {
                        static _levenshtein = undefined;
                        if (_levenshtein == undefined)
                        {
                            _levenshtein = new __VinylClassLevenshtein();
                            _levenshtein.SetLexiconArray(__VinylDocument().__projectSoundArray);
                        }
                        
                        _levenshtein.SetString(_textInput);
                        _levenshtein.Process();
                        var _autocomplete = _levenshtein.GetWordArray();
                        
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
                        if (audio_exists(_sound))
                        {
                            __sound = _sound;
                            __soundTempName = _textNew;
                        }
                    }
                    else
                    {
                        __soundTempName = _textInput;
                    }
                break;
                
                case __VINYL_REF_NAME_MATCH:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Reference");
                    ImGui.TableSetColumnIndex(1);
                    __reference = ImGui.InputText("##Sound Ref Name Match Input", __reference);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Sounds");
                    ImGui.TableSetColumnIndex(1);
                    ImGui.BeginChild();
                    
                    if (__reference == "")
                    {
                        ImGui.Text("No sounds found");
                    }
                    else
                    {
                        var _soundArray = __VinylFindMatchingSounds(__reference, __VinylDocument().__projectSoundArray);
                        var _i = 0;
                        repeat(array_length(_soundArray))
                        {
                            ImGui.Text(_soundArray[_i]);
                            ++_i;
                        }
                    }
                    
                    ImGui.EndChild();
                break;
                
                case __VINYL_REF_ASSET_TAG:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Reference");
                    ImGui.TableSetColumnIndex(1);
            
                    if (ImGui.BeginCombo("##Sound Ref Asset Tag Input", __reference, ImGuiComboFlags.None))
                    {
                        if (ImGui.Selectable("A", __reference == "A"))
                        {
                            __reference = "A";
                        }
                        
                        if (ImGui.Selectable("B", __reference == "B"))
                        {
                            __reference = "B";
                        }
                        
                        if (ImGui.Selectable("C", __reference == "C"))
                        {
                            __reference = "C";
                        }
                        
                        ImGui.EndCombo();
                    }
                break;
            }
            
            ImGui.EndTable();
        }
    }
}
