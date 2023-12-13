// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternRefAssetTag();

function __VinylClassPatternRefAssetTag() constructor
{
    static __patternType    = __VINYL_PATTERN_TYPE_REF_ASSET_TAG;
    static __usesChildArray = false;
    
    __uuid     = __VinylGenerateUUID();
    __document = undefined;
    __parent   = undefined;
    __name     = "";
    
    
    
    __Reset();
    
    static __Reset = function()
    {
        __setSubscription = false;
        
        __assetTag    = "";
        __soundsArray = [];
        
        __EnsureSubscription();
    }
    
    static __GetName = function(_maxCharacters)
    {
        if (__name != "")
        {
            return string(__name);
        }
        
        return "Tag \"" + __assetTag + "\"";
    }
    
    static __Unset = function()
    {
        if (__document != undefined)
        {
            __document.__Unsubscribe("project reload", self);
        }
        
        variable_struct_remove(self, "__assetTag");
        variable_struct_remove(self, "__soundsArray");
        variable_struct_remove(self, "__setSubscription");
    }
    
    static __IsChild = function()
    {
        return (__parent != undefined);
    }
    
    static __Rename = function(_name)
    {
        if (_name == __name) return;
        
        if (__uuid == __name)
        {
            var _patternDict = __document.__patternDict;
            if (variable_struct_exists(_patternDict, _name))
            {
                __VinylTrace("Warning! Cannot rename Vinyl pattern with UUID \"", __uuid, "\", new name \"", _name, "\" conflicts with existing pattern");
                return;
            }
            else
            {
                variable_struct_remove(_patternDict, __uuid);
                __uuid = _name;
                _patternDict[$ __uuid] = self;
            }
        }
        
        __name = _name;
        __document.__Save();
    }
    
    static __EnsureSubscription = function()
    {
        if (__setSubscription || (__document == undefined)) return;
        __setSubscription = true;
        
        __document.__Subscribe("project reload", self, __UpdateSounds);
    }
    
    static toString = function()
    {
        return "<asset tag " + string(__assetTag) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        _struct.type     = __patternType;
        _struct.parent   = __parent;
        _struct.uuid     = __uuid;
        _struct.assetTag = __assetTag;
    }
    
    static __Deserialize = function(_struct)
    {
        __uuid     = _struct.uuid;
        __parent   = _struct.parent;
        __assetTag = _struct.assetTag;
        
        __UpdateSounds();
    }
    
    static __Store = function(_document)
    {
        __document = _document;
        
        _document.__patternDict[$ __uuid] = self;
        
        __EnsureSubscription();
        __UpdateSounds();
    }
    
    static __ChangeParent = function(_parentUUID)
    {
        var _parent = __document.__GetPattern(__parent);
        if (_parent != undefined)
        {
            var _index = __VinylArrayFindIndex(_parent.__childArray, self);
            if (_index != undefined) array_delete(_parent.__childArray, _index, 1);
        }
        
        __parent = _parentUUID;
        
        var _parent = __document.__GetPattern(__parent);
        if (_parent != undefined)
        {
            array_push(_parent.__childArray, __uuid);
        }
    }
    
    static __Discard = function()
    {
        var _parent = __document.__GetPattern(__parent);
        if (is_struct(_parent))
        {
            var _index = __VinylArrayFindIndex(_parent.__childArray, __uuid);
            if (_index != undefined) array_delete(_parent.__childArray, _index, 1);
        }
        
        variable_struct_remove(__document.__patternDict, __uuid);
        __document.__Save();
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
        if (__document == undefined)
        {
            __soundsArray = [];
            return;
        }
        
        var _soundArray = __document.__GetProjectAssetTagDict()[$ __assetTag];
        if (not is_array(_soundArray))
        {
            __soundsArray = [];
        }
        else
        {
            __soundsArray = _soundArray;
        }
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        //Now do the actual table
        if (ImGui.BeginTable("Vinyl Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY, undefined, 280))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",  ImGuiTableColumnFlags.WidthFixed,   100);
            ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthStretch,   1);
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Asset Tag");
            ImGui.TableSetColumnIndex(1);
            
            if (ImGui.BeginCombo("##Sound Ref Asset Tag Input", __assetTag, ImGuiComboFlags.None))
            {
                var _assetTagArray = __VinylDocument().__GetProjectAssetTagArray();
                var _i = 0;
                repeat(array_length(_assetTagArray))
                {
                    var _assetTag = _assetTagArray[_i];
                    if (ImGui.Selectable(_assetTag + "##Asset Tag Checkbox", (__assetTag == _assetTag)))
                    {
                        if (__assetTag != _assetTag)
                        {
                            __document.__Write(self, "__assetTag", _assetTag);
                            __UpdateSounds();
                        }
                    }
                        
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
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
