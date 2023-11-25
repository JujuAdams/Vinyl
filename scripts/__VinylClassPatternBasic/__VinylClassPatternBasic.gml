// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternBasic();

function __VinylClassPatternBasic() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_BASIC;
    static __pool = __VinylGlobalData().__poolBasic;
    static __usesChildArray = false;
    
    __Reset();
    
    static toString = function()
    {
        return (__sound == undefined)? "<basic ???>" : "<basic " + audio_get_name(__sound) + ">";
    }
    
    static __GetName = function(_maxCharacters)
    {
        if (__name != "")
        {
            return string(__name);
        }
        
        return audio_get_name(__sound);
    }
    
    static __Reset = function()
    {
        __ResetShared();
        
        __sound = VinylFallbackSound;
        __soundTempName = "";
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__sound");
    }
    
    static __Serialize = function(_struct)
    {
        __SerializeShared(_struct);
        
        _struct.sound = audio_get_name(__sound);
    }
    
    static __Deserialize = function(_struct)
    {
        __DeserializeShared(_struct);
        
        __sound = asset_get_index(_struct.sound);
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
    
    static __CheckSoundExists = function()
    {
        if (not variable_struct_exists(__document.__GetProjectSoundDictionary(), audio_get_name(__sound)))
        {
            __sound = VinylFallbackSound;
        }
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        ImGui.NewLine();
        if (ImGui.BeginTable("Vinyl Properties", 2, ImGuiTableFlags.None, undefined, 24))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",  ImGuiTableColumnFlags.WidthFixed,   100);
            ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthStretch,   1);
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Sound");
            ImGui.TableSetColumnIndex(1);
            
            var _textOld       = audio_get_name(__sound);
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
                    _levenshtein.SetLexiconArray(__document.__GetProjectSoundArray());
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
                __sound = asset_get_index(_textNew);
                __soundTempName = _textNew;
                __CheckSoundExists();
            }
            else
            {
                __soundTempName = _textInput;
                __CheckSoundExists();
            }
            
            ImGui.EndTable();
        }
        
        ImGui.NewLine();
        __SharedWidgets(_selectionHandler);
    }
}
