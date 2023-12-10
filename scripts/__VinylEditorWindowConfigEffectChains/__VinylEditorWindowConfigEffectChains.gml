// Feather disable all

function __VinylEditorWindowConfigEffectChains(_stateStruct)
{
    var _document = __VinylDocument();
    
    var _contentDict = _document.__effectChainDict;
    
    var _contentNameArray = variable_struct_get_names(_contentDict);
    array_sort(_contentNameArray, true);
    
    var _tabState = _stateStruct.__tabEffectChains;
    
    //Use the selection handler for this tab and ensure its binding to the project's sound dictionary
    //This dictionary will be used to track item selection
    var _selectionHandler = _tabState.__selectionHandler;
    _selectionHandler.__Bind(_contentDict, __VinylClassEffectChain, undefined);
    
    var _multiselect   = _selectionHandler.__GetMultiselect();
    var _seeSelected   = _selectionHandler.__GetSeeSelected();
    var _seeUnselected = _selectionHandler.__GetSeeUnselected();
    var _filter        = _tabState.__filter;
    var _useFilter     = _tabState.__useFilter;
    
    ImGui.BeginChild("Left Pane", 0.3*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        if (ImGui.Button("New Effect Chain"))
        {
            _document.__NewEffectChain();
        }
        
        ImGui.BeginChild("Effect Chain View", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, true);
            
            //Keep an array of all visible sounds. We use this later for the "select all" button
            var _visibleArray = [];
            
            //Iterate over every sound in the project and show them in the editor
            var _i = 0;
            repeat(array_length(_contentNameArray))
            {
                var _target = _contentDict[$ _contentNameArray[_i]];
                
                var _name = _target.__name;
                
                var _selected = _selectionHandler.__IsSelected(_name);
                
                if ((not _multiselect) || (_selected && _seeSelected) || ((not _selected) && _seeUnselected)) //Selected check
                {
                    if ((not _useFilter) || __VinylFilterApply(_filter, _target)) //General filter
                    {
                        var _flags = ImGuiTreeNodeFlags.OpenOnArrow;
                        
                        if (_selectionHandler.__IsSelected(_name))
                        {
                            _flags |= ImGuiTreeNodeFlags.Selected;
                        }
                        
                        var _open = ImGui.TreeNodeEx(_name + "##Select " + _name, _flags);
                        if ((not ImGui.IsItemToggledOpen()) && ImGui.IsItemClicked())
                        {
                            _selectionHandler.__SelectToggle(_name);
                        }
                        
                        if (_open)
                        {
                            var _effectChainStruct = _contentDict[$ _name];
                            var _childArray = _effectChainStruct.__bus.effects;
                            
                            var _childCount = 0;
                            var _j = 0;
                            repeat(__VINYL_EFFECT_BUS_SIZE)
                            {
                                var _childEffectStruct = _childArray[_j];
                                if (is_struct(_childEffectStruct))
                                {
                                    ++_childCount;
                                    
                                    var _childName = __VinylEffectToName(_childEffectStruct.type);
                                    
                                    if (ImGui.TreeNodeEx(_childName + "##Effect " + string(_i) + " Child " + string(_j), ImGuiTreeNodeFlags.Bullet))
                                    {
                                        ImGui.TreePop();
                                    }
                                }
                                
                                ++_j;
                            }
                            
                            if (_childCount <= 0)
                            {
                                ImGui.Text("No effects set up");
                            }
                            
                            ImGui.TreePop();
                        }
                        
                        //Push the name of this visible sound to our array
                        array_push(_visibleArray, _name);
                    }
                }
        
                ++_i;
            }
            
        ImGui.EndChild();
        
        //Build the selection handler UI at the bottom of the list of sounds
        _selectionHandler.__BuildUI(_visibleArray);
        
    ImGui.EndChild();
    
    
    
    //Ok! Now we do the right-hand properties pane
    
    
    
    ImGui.SameLine();
    ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        //Collect some basic facts about the current selection(s)
        var _selectedCount = _selectionHandler.__GetSelectedCount();
        var _lastSelected  = _selectionHandler.__lastSelected;
        
        //Bit of aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if (_selectedCount == 0)
        {
            //Add some helpful text to guide users if nothing's selected
            ImGui.Text("Please select an effect chain from the menu on the left");
        }
        else
        {
            //Change the display text depending on what the user is actually seeing
            ImGui.Text(_selectionHandler.__GetLastSelectedName());
            
            ImGui.SameLine(200);
            
            if (ImGui.Button("Rename"))
            {
                //TODO
            }
            
            ImGui.SameLine(undefined, 20);
            
            if (ImGui.Button("Delete"))
            {
                _contentDict[$ _lastSelected].__Discard(_document);
                _selectionHandler.__Select(_lastSelected, false);
            }
        }
        
        //Little more aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        //Here's where we jump to a different function to draw the actual properties
        if (_selectionHandler.__GetSelectedCount() > 0)
        {
            ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                _contentDict[$ _lastSelected].__BuildPropertyUI();
            ImGui.EndChild();
        }
    ImGui.EndChild();
}