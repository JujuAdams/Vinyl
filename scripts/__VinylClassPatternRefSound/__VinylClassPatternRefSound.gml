// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternRefSound();

function __VinylClassPatternRefSound() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_REF_SOUND;
    
    __uuid     = string(ptr(__VinylRandom(0x7FFF_FFFF_FFFF_FFFF)));
    __document = undefined;
    __parent   = undefined;
    __name     = "";
    
    __setSubscription = false;
    
    
    
    __Reset();
    
    static __Reset = function()
    {
        __soundName     = "";
        __soundTempName = "";
        
        __EnsureSubscription();
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__soundName");
        variable_struct_remove(self, "__soundTempName");
        
        if (__document != undefined)
        {
            __document.__Unsubscribe("project reload", self);
        }
    }
    
    static __IsChild = function()
    {
        return (__parent != undefined);
    }
    
    static __GetName = function()
    {
        if (__name != "")
        {
            return string(__name);
        }
        
        return string(self);
    }
    
    static __EnsureSubscription = function()
    {
        if (__setSubscription || (__document == undefined)) return;
        __setSubscription = true;
        
        __document.__Subscribe("project reload", self, __CheckSoundExists);
    }
    
    static toString = function()
    {
        return "<sound ref " + string(__soundName) + ">";
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        __VinylError("TODO");
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        __VinylError("TODO");
    }
    
    static __Store = function(_document, _parent)
    {
        __document = _document;
        __parent   = _parent;
        
        _document.__patternDict[$ __uuid] = self;
        
        if (_parent != undefined)
        {
            array_push(_parent.__childArray, __uuid);
        }
        
        __EnsureSubscription();
    }
    
    static __Discard = function()
    {
        var _index = __VinylArrayFindIndex(__parent.__childArray, __uuid);
        if (_index != undefined) array_delete(__parent.__childArray, _index, 1);
    }
    
    static __Serialize = function(_struct)
    {
        _struct.type  = __patternType;
        _struct.sound = __soundName;
        
        __CheckSoundExists();
    }
    
    static __Deserialize = function(_struct, _parent)
    {
        __soundName = asset_get_index(_struct.sound);
    }
    
    static __CheckSoundExists = function()
    {
        if (not variable_struct_exists(__document.__GetProjectSoundDictionary(), __soundName))
        {
            __soundName = audio_get_name(VinylFallbackSound);
        }
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
            
            var _textOld       = __soundName;
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
                __soundName     = _textNew;
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
    }
}
