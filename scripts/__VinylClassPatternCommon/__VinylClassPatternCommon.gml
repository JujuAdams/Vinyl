// Feather disable all

/// @param document
/// @param parent

function __VinylClassPatternCommon(_document, _parent)
{
    static __effectChainDict = __VinylGlobalData().__effectChainDict;
    
    __document = _document;
    __parent   = _parent;
    
    __name = undefined;
    
    
    
    static __ResetShared = function()
    {
        __gainOption            = __VINYL_OPTION_UNSET;
        __gain                  = [1, 1];
        __gainKnob              = __VINYL_ASSET_NULL;
        __gainKnobOverride      = false;
        
        __pitchOption           = __VINYL_OPTION_UNSET;
        __pitch                 = [1, 1];
        __pitchKnob             = __VINYL_ASSET_NULL;
        __pitchKnobOverride     = false;
        
        __loopOption            = __VINYL_OPTION_UNSET;
        __loop                  = false;
        
        __labelsOption          = __VINYL_OPTION_UNSET;
        __labelArray            = [];
        
        __stackOption           = __VINYL_OPTION_UNSET;
        __stackName             = __VINYL_ASSET_NULL;
        __stackPriority         = 0;
        
        __effectChainOption     = __VINYL_OPTION_UNSET;
        __effectChainName       = __VINYL_ASSET_NULL;
        
        __persistentOption      = __VINYL_OPTION_UNSET;
        __persistent            = undefined;
        
        __transposeOption       = __VINYL_OPTION_UNSET;
        __transpose             = [0, 0];
        __transposeKnob         = __VINYL_ASSET_NULL;
        __transposeKnobOverride = false;
    }
    
    static __SerializeShared = function(_struct)
    {
        _struct.type                  = __patternType;
        _struct.name                  = __name;
        
        _struct.gainOption            = __gainOption;
        _struct.gainKnob              = __gainKnob;
        _struct.gainKnobOverride      = __gainKnobOverride;
        _struct.gain                  = variable_clone(__gain);
        
        _struct.pitchOption           = __pitchOption;
        _struct.pitchKnob             = __pitchKnob;
        _struct.pitchKnobOverride     = __pitchKnobOverride;
        _struct.pitch                 = variable_clone(__pitch);
        
        _struct.loopOption            = __loopOption;
        _struct.loop                  = __loop;
        
        _struct.labelsOption          = __labelsOption;
        _struct.labels                = variable_clone(__labelArray);
        
        _struct.stackOption           = __stackOption;
        _struct.stack                 = __stackName;
        _struct.stackPriority         = __stackPriority;
        
        _struct.effectChainOption     = __effectChainOption;
        _struct.effectChain           = __effectChainName;
        
        _struct.persistentOption      = __persistentOption;
        _struct.persistent            = __persistent;
        
        _struct.transposeOption       = __transposeOption;
        _struct.transposeKnob         = __transposeKnob;
        _struct.transposeKnobOverride = __transposeKnobOverride;
        _struct.transpose             = variable_clone(__transpose);
    }
    
    static __DeserializeShared = function(_struct, _parent)
    {
        //TODO - Decompress on load
        
        __name                  = _struct.name;
        __parent                = _parent;
        
        __gainOption            = _struct.gainOption;
        __gainKnob              = _struct.gainKnob;
        __gainKnobOverride      = _struct.gainKnobOverride;
        __gain                  = variable_clone(_struct.gain);
        
        __pitchOption           = _struct.pitchOption;
        __pitchKnob             = _struct.pitchKnob;
        __pitchKnobOverride     = _struct.pitchKnobOverride;
        __pitch                 = variable_clone(_struct.pitch);
        
        __loopOption            = _struct.loopOption;
        __loop                  = _struct.loop;
        
        __labelsOption          = _struct.labelsOption;
        __labelArray           = variable_clone(_struct.labels);
        
        __stackOption           = _struct.stackOption;
        __stackName             = _struct.stack;
        __stackPriority         = _struct.stackPriority;
        
        __effectChainOption     = _struct.effectChainOption;
        __effectChainName       = _struct.effectChain;
        
        __persistentOption      = _struct.persistentOption;
        __persistent            = _struct.persistent;
        
        __transposeOption       = _struct.transposeOption;
        __transposeKnob         = _struct.transposeKnob;
        __transposeKnobOverride = _struct.transposeKnobOverride;
        __transpose             = variable_clone(_struct.transpose);
    }
    
    static __CopyTo = function(_new)
    {
        _new.__Reset();
        
        _new.__name                  = __name;
        _new.__parent                = __parent;
        
        _new.__gainOption            = __gainOption;
        _new.__gainKnob              = __gainKnob;
        _new.__gainKnobOverride      = __gainKnobOverride;
        _new.__gain                  = variable_clone(__gain);
        
        _new.__pitchOption           = __pitchOption;
        _new.__pitchKnob             = __pitchKnob;
        _new.__pitchKnobOverride     = __pitchKnobOverride;
        _new.__pitch                 = variable_clone(__pitch);
        
        _new.__loopOption            = __loopOption;
        _new.__loop                  = __loop;
        
        _new.__labelsOption          = __labelsOption;
        _new.__labelArray            = variable_clone(__labelArray);
        
        _new.__stackOption           = __stackOption;
        _new.__stackName             = __stackName;
        _new.__stackPriority         = __stackPriority;
        
        _new.__effectChainOption     = __effectChainOption;
        _new.__effectChainName       = __effectChainName;
        
        _new.__persistentOption      = __persistentOption;
        _new.__persistent            = __persistent;
        
        _new.__transposeOption       = __transposeOption;
        _new.__transposeKnob         = __transposeKnob;
        _new.__transposeKnobOverride = __transposeKnobOverride;
        _new.__transpose             = variable_clone(__transpose);
    }
    
    static __Store = function(_document, _parent)
    {
        __document = _document;
        __parent   = _parent;
        
        _document.__patternDict[$ __name] = self;
        
        if (_parent != undefined)
        {
            array_push(_parent.__childArray, self);
        }
    }
    
    static __Discard = function()
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
            variable_struct_remove(__document.__patternDict, __name);
        }
    }
    
    static __Migrate = function()
    {
        if (__effectChainName == __VINYL_ASSET_NULL)
        {
            var _j = 0;
            repeat(array_length(__labelArray))
            {
                var _labelStruct = __labelArray[_j];
                
                if (_labelStruct.__effectChainName != __VINYL_ASSET_NULL)
                {
                    if (__effectChainName == __VINYL_ASSET_NULL)
                    {
                        __effectChainName = _labelStruct.__effectChainName;
                    }
                    else if (_labelStruct.__effectChainName != __effectChainName)
                    {
                        __VinylTrace("Warning! ", self, " has conflicting effect chains (chosen = \"", __effectChainName, "\", conflict = \"", _labelStruct.__effectChainName, "\" from ", _labelStruct, ")");
                    }
                }
                
                ++_j;
            }
        
            if ((__effectChainName != __VINYL_ASSET_NULL) && !variable_struct_exists(__effectChainDict, __effectChainName))
            {
                __VinylError("Effect chain \"", __effectChainName, "\" for ", self, " doesn't exist");
            }
        }
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
    
    
    
    
    
    static __GainSet = function(_gain)
    {
        __gain[0] = _gain;
        __gain[1] = _gain;
    }
    
    static __PitchSet = function(_pitch)
    {
        __pitch[0] = _pitch;
        __pitch[1] = _pitch;
    }
    
    static __LoopGet = function()
    {
        if (__loop == undefined)
        {
            var _i = 0;
            repeat(array_length(__labelArray))
            {
                var _labelStruct = __labelArray[_i];
                if (_labelStruct.__configLoop == true) return true;
                ++_i;
            }
            
            return undefined;
        }
        
        return __loop;
    }
    
    static __InitializeAssetArray = function(_assetArray, _tagArray)
    {
        __assetArray = _assetArray;
        
        //Convert any basic patterns into audio asset indexes
        var _i = 0;
        repeat(array_length(__assetArray))
        {
            var _asset = __assetArray[_i];
            
            if (is_struct(_asset))
            {
                //Generate an anonymous pattern
                var _patternName = __name + " > " + string(_i);
                __VInylPatternCreate(_patternName, _asset, false, true);
                _assetArray[@ _i] = _patternName;
            }
            else
            {
                if (is_string(_asset))
                {
                    if (asset_get_index(_asset) < 0) __VinylError("Error in ", self, " for \"assets\" property\nAsset \"", _asset, "\" not found in the project");
                    if (asset_get_type(_asset) != asset_sound) __VinylError("Error in ", self, " for \"assets\" property\nAsset \"", _asset, "\" not a sound asset");
                    _asset = asset_get_index(_asset);
                }
                
                if (!is_numeric(_asset)) __VinylError("Error in ", self, " for \"assets\" property\nAssets should be specified as an audio asset index or audio asset name (datatype=", typeof(_asset), ")");
                if (!audio_exists(_asset)) __VinylError("Error in ", self, " for \"assets\" property\nAudio asset with index ", _asset, " not found");
                
                __assetArray[@ _i] = _asset;
            }
            
            ++_i;
        }
        
        //Append any asset we find from tags
        if (_tagArray != undefined)
        {
            if (not is_array(_tagArray))
            {
                if (is_string(_tagArray))
                {
                    _tagArray = [_tagArray];
                }
                else
                {
                    __VinylError("Error in ", self, " for \"assetsWithTag\" property\nDatatype must be an array, string, or undefined, was ", typeof(_tagArray));
                }
            }
            
            var _i = 0;
            repeat(array_length(_tagArray))
            {
                var _tag = _tagArray[_i];
                var _foundAssetArray = tag_get_asset_ids(_tag, asset_sound);
                if (is_array(_foundAssetArray) && (array_length(_foundAssetArray) > 0))
                {
                    var _j = 0;
                    repeat(array_length(_foundAssetArray))
                    {
                        var _assetIndex = _foundAssetArray[_j];
                        if (!array_contains(__assetArray, _assetIndex))
                        {
                            array_push(__assetArray, _assetIndex);
                        }
                        
                        ++_j;
                    }
                }
                else
                {
                    __VinylTrace("Warning! No sound assets found for tag name \"", _tag, "\"");
                }
                
                ++_i;
            }
        }
        
        if (array_length(_assetArray) <= 0) __VinylError("Error in ", self, "\n", __patternType, "-type patterns must have at least one asset");
    }
    
    static __SharedWidgets = function(_selectionHandler)
    {
        if (ImGui.BeginTable("Vinyl Properties", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 260))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
            
            __VinylEditorPropWidgetGain(       "Gain",         self, __parent, 0, 2, 1);
            __VinylEditorPropWidgetPitch(      "Pitch",        self, __parent, 0, 2, 1);
            __VinylEditorPropWidgetLoop(       "Loop",         self, __parent, 0, 2, 1);
            __VinylEditorPropWidgetStack(      "Stack",        self, __parent, 0, 2, 1);
            __VinylEditorPropWidgetEffectChain("Effect Chain", self, __parent, 0, 2, 1);
            __VinylEditorPropWidgetPersistent( "Persistent",   self, __parent, 0, 2, 1);
            __VinylEditorPropWidgetTranspose(  "Transpose",    self, __parent, 0, 2, 1);
            
            ImGui.EndTable();
        }
    }
    
    static __SharedWidgetsChildren = function(_selectionHandler)
    {
        ImGui.NewLine();
        if (ImGui.Button("Add Child"))
        {
            __document.__NewPattern(self);
        }
        
        if (ImGui.BeginTable("Vinyl Properties", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, ImGui.GetContentRegionAvailY()))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Buttons", ImGuiTableColumnFlags.WidthFixed, 44);
            ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("Delete", ImGuiTableColumnFlags.WidthFixed, 50);
            
            var _array = __childArray;
            var _size = array_length(_array);
            var _i = 0;
            repeat(_size)
            {
                var _child = _array[_i];
                var _name = _child.__name;
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                
                ImGui.BeginDisabled(_i >= _size-1);
                    if (ImGui.ArrowButton("Order Down " + _name, ImGuiDir.Down))
                    {
                        var _temp = _array[_i+1];
                        _array[_i+1] = _child;
                        _array[_i] = _temp;
                    }
                ImGui.EndDisabled();
                
                ImGui.SameLine();
                ImGui.BeginDisabled(_i <= 0);
                    if (ImGui.ArrowButton("Order Up " + _name, ImGuiDir.Up))
                    {
                        var _temp = _array[_i-1];
                        _array[_i-1] = _child;
                        _array[_i] = _temp;
                    }
                ImGui.EndDisabled();
                
                ImGui.TableSetColumnIndex(1);
                ImGui.Selectable(_name);
                
                ImGui.TableSetColumnIndex(2);
                if (ImGui.Button("Delete##Delete " + _name))
                {
                    
                }
                
                ++_i;
            }
            
            ImGui.EndTable();
        }
    }
}
