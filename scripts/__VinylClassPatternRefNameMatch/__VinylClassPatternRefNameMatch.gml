// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternRefNameMatch();

function __VinylClassPatternRefNameMatch() constructor
{
    static __patternType    = __VINYL_PATTERN_TYPE_REF_NAME_MATCH;
    static __usesChildArray = false;
    
    __uuid     = string(ptr(__VinylRandom(0x7FFF_FFFF_FFFF_FFFF)));
    __document = undefined;
    __parent   = undefined;
    __name     = "";
    
    __setSubscription = false;
    
    
    
    __Reset();
    
    static __Reset = function()
    {
        __searchString = "";
        __soundsArray  = [];
        
        __EnsureSubscription();
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__searchString");
        variable_struct_remove(self, "__soundsArray");
        
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
    
    static __Rename = function(_name)
    {
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
    }
    
    static __EnsureSubscription = function()
    {
        if (__setSubscription || (__document == undefined)) return;
        __setSubscription = true;
        
        __document.__Subscribe("project reload", self, __UpdateSounds);
    }
    
    static toString = function()
    {
        return "<name match " + string(__searchString) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        _struct.type         = __patternType;
        _struct.parent       = __parent;
        _struct.searchString = __searchString;
    }
    
    static __Deserialize = function(_struct)
    {
        __searchString = asset_get_index(_struct.searchString);
        
        __UpdateSounds();
    }
    
    
    static __Store = function(_document, _parentUUID)
    {
        __document = _document;
        __parent   = _parentUUID;
        
        _document.__patternDict[$ __uuid] = self;
        
        var _parent = __document.__GetPattern(_parentUUID);
        if (_parent != undefined)
        {
            array_push(_parent.__childArray, __uuid);
        }
        
        __EnsureSubscription();
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
        __soundsArray = variable_clone(__VinylFindMatchingSounds(__searchString, __document.__GetProjectSoundArray()));
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
            ImGui.Text("Reference");
            ImGui.TableSetColumnIndex(1);
            
            var _oldValue = __searchString;
            __searchString = ImGui.InputText("##Sound Ref Name Match Input", __searchString);
            if (_oldValue != __searchString) __UpdateSounds();
            
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