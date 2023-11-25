// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternRefAssetTag();

function __VinylClassPatternRefAssetTag() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_REF_ASSET_TAG;
    
    __uuid     = string(ptr(__VinylRandom(0x7FFF_FFFF_FFFF_FFFF)));
    __document = undefined;
    __parent   = undefined;
    __name     = "";
    
    __setSubscription = false;
    
    
    
    __Reset();
    
    static __Reset = function()
    {
        __assetTag    = "";
        __soundsArray = [];
        
        __EnsureSubscription();
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__assetTag");
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
        _struct.assetTag = __assetTag;
    }
    
    static __Deserialize = function(_struct, _parent)
    {
        __assetTag = _struct.assetTag;
        
        __UpdateSounds();
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
        var _soundArray = variable_struct_exists(__document.__GetProjectAssetTagDict(), __assetTag);
        if (not is_array(_soundArray))
        {
            __Reset();
        }
        else
        {
            __soundsArray = _soundArray;
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
            
            if (ImGui.BeginCombo("##Sound Ref Asset Tag Input", __assetTag, ImGuiComboFlags.None))
            {
                if (ImGui.Selectable("A", __assetTag == "A"))
                {
                    __assetTag = "A";
                }
                
                if (ImGui.Selectable("B", __assetTag == "B"))
                {
                    __assetTag = "B";
                }
                
                if (ImGui.Selectable("C", __assetTag == "C"))
                {
                    __assetTag = "C";
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.EndTable();
        }
    }
}
