// Feather disable all

function __VinylEditorWindowConfigPatterns(_stateStruct)
{
    var _document = __VinylDocument();
    
    var _contentDict = _document.__patternDict;
    
    var _contentNameArray = variable_struct_get_names(_contentDict);
    array_sort(_contentNameArray, true);
    
    var _tabState = _stateStruct.__tabPatterns;
    var _makePopup = false;
    
    //Use the selection handler for this tab and ensure its binding to the project's sound dictionary
    //This dictionary will be used to track item selection
    var _selectionHandler = _tabState.__selectionHandler;
    _selectionHandler.__Bind(_contentDict, __VinylClassPatternBasic, undefined);
    
    var _filter    = _tabState.__filter;
    var _useFilter = _tabState.__useFilter;
    
    var _func = function(_func, _visibleArray, _contentDict, _uuid, _selectionHandler, _filter, _useFilter)
    {
        var _target = _contentDict[$ _uuid];
        
        //TODO - Cache these values
        var _multiselect   = _selectionHandler.__GetMultiselect();
        var _seeSelected   = _selectionHandler.__GetSeeSelected();
        var _seeUnselected = _selectionHandler.__GetSeeUnselected();
        
        var _selected = _selectionHandler.__IsSelected(_uuid);
        if ((not _multiselect) || (_selected && _seeSelected) || ((not _selected) && _seeUnselected)) //Selected check
        {
            if ((not _useFilter) || __VinylFilterApply(_filter, _target)) //General filter
            {
                var _childArray = _target[$ "__childArray"];
                
                var _flags = ImGuiTreeNodeFlags.OpenOnArrow | ImGuiTreeNodeFlags.DefaultOpen;
                
                if (_selectionHandler.__IsSelected(_uuid))
                {
                    _flags |= ImGuiTreeNodeFlags.Selected;
                }
                
                if ((not is_array(_childArray)) || (array_length(_childArray) <= 0))
                {
                    _flags |= ImGuiTreeNodeFlags.Bullet;
                }
                
                var _open = ImGui.TreeNodeEx(_target.__GetName() + "##Select " + _uuid, _flags);
                if ((not ImGui.IsItemToggledOpen()) && ImGui.IsItemClicked())
                {
                    _selectionHandler.__SelectToggle(_uuid);
                }
                
                if (_open)
                {
                    if (is_array(_childArray))
                    {
                        var _i = 0;
                        repeat(array_length(_childArray))
                        {
                            _func(_func, _visibleArray, _contentDict, _childArray[_i], _selectionHandler, _filter, _useFilter);
                            ++_i;
                        }
                    }
                    
                    ImGui.TreePop();
                }
                
                //Push the name of this visible sound to our array
                array_push(_visibleArray, _uuid);
            }
        }
    }
    
    ImGui.BeginChild("Left Pane", 0.3*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        //General filter checkbox and edit button
        ImGui.Text("Filter");
        ImGui.SameLine();
        _tabState.__useFilter = ImGui.Checkbox("##Filter", _useFilter);
        ImGui.SameLine();
        if (ImGui.Button("Edit..."))
        {
            __VinylEditorWindowSetOpen("__filter", true);
        }
        
        if (ImGui.Button("New Pattern"))
        {
            _document.__NewPattern();
        }
        
        ImGui.BeginChild("Label View", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, true);
            
            //Keep an array of all visible sounds. We use this later for the "select all" button
            var _visibleArray = [];
            
            //Iterate over every sound in the project and show them in the editor
            var _i = 0;
            repeat(array_length(_contentNameArray))
            {
                var _uuid = _contentNameArray[_i];
                var _target = _contentDict[$ _uuid];
                if ((not _target.__IsChild()) && ((not is_instanceof(_target, __VinylClassPatternFallback)) && (not is_instanceof(_target, __VinylClassPatternSound))))
                {
                    _func(_func, _visibleArray, _contentDict, _uuid, _selectionHandler, _filter, _useFilter);
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
        var _selectedCount  = _selectionHandler.__GetSelectedCount();
        var _lastSelected   = _selectionHandler.__lastSelected;
        var _selectedStruct = _contentDict[$ _lastSelected];
        
        //Bit of aesthetic spacing
        ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 20);
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if ((_selectedCount == 0) || (not is_struct(_selectedStruct)))
        {
            //Add some helpful text to guide users if nothing's selected
            ImGui.Text("Please select a pattern from the menu on the left");
        }
        else
        {
            //Change the display text depending on what the user is actually seeing
            ImGui.Text(_selectedStruct.__GetName());
            
            ImGui.SameLine(300);
            
            if (ImGui.Button("Play Once"))
            {
                //TODO
            }
            
            ImGui.SameLine(undefined, 20);
            
            ImGui.BeginDisabled(_selectedCount > 1);
                if (ImGui.Button("Rename"))
                {
                    _makePopup = true;
                    
                    with(_stateStruct.__popupData)
                    {
                        __type     = "Rename";
                        __tempName = _selectedStruct.__name;
                    }
                }
            ImGui.EndDisabled(_selectedCount);
            
            ImGui.SameLine(undefined, 20);
            
            if (ImGui.Button("Delete"))
            {
                _makePopup = true;
                
                with(_stateStruct.__popupData)
                {
                    __type = "Delete";
                }
            }
            
            ImGui.SameLine(undefined, 20);
            
            static _rootPatterns  = [__VinylClassPatternBasic, __VinylClassPatternShuffle, __VinylClassPatternQueue, __VinylClassPatternMulti];
            static _childPatterns = [__VinylClassPatternBasic, __VinylClassPatternShuffle, __VinylClassPatternQueue, __VinylClassPatternMulti, __VinylClassPatternRefNameMatch, __VinylClassPatternRefAssetTag];
            
            ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
            if (ImGui.BeginCombo("##Pattern Type Combobox", __VinylPatternToName(instanceof(_selectedStruct)), ImGuiComboFlags.None))
            {
                var _patternArray = _selectedStruct.__IsChild()? _childPatterns : _rootPatterns;
                var _i = 0;
                repeat(array_length(_patternArray))
                {
                    var _pattern = _patternArray[_i];
                    if (ImGui.Selectable(__VinylPatternToName(_pattern)))
                    {
                        __VinylPatternChange(_selectedStruct, _pattern);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
        }
        
        //Little more aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        //Here's where we jump to a different function to draw the actual properties
        if ((_selectedCount > 0) && is_struct(_selectedStruct))
        {
            ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                _contentDict[$ _lastSelected].__BuildPropertyUI(_selectionHandler);
            ImGui.EndChild();
        }
    ImGui.EndChild();
    
    
    
    //if (_stateStruct.__popupData.__target == _selectedStruct)
    {
        if (_makePopup)
        {
            ImGui.OpenPopup("Popup");
        }
        
        var _windowWidth  = window_get_width();
        var _windowHeight = window_get_height();
        ImGui.SetNextWindowSize(0.3*_windowWidth, 0.15*_windowHeight, ImGuiCond.Appearing);
        ImGui.SetNextWindowPos(0.5*_windowWidth, 0.5*_windowHeight, ImGuiCond.Appearing, 0.5, 0.5);
        
        if (ImGui.BeginPopupModal("Popup", undefined, ImGuiWindowFlags.NoResize))
        {
            var _popupData = _stateStruct.__popupData;
            
            switch(_stateStruct.__popupData.__type)
            {
                case "Rename":
                    ImGui.Text("Please enter a new name for \"" + _selectedStruct.__GetName() + "\"");
                    
                    ImGui.Separator();
                    
                    _popupData.__tempName = ImGui.InputText("##Rename Field", _popupData.__tempName);
                    
                    if (ImGui.Button("Rename"))
                    {
                        _selectionHandler.__Select(_selectedStruct.__uuid, false);
                        _selectedStruct.__Rename(_popupData.__tempName);
                        _selectionHandler.__Select(_selectedStruct.__uuid, true);
                        
                        ImGui.CloseCurrentPopup();
                    }
                    
                    ImGui.SameLine(undefined, 40);
                    if (ImGui.Button("Cancel"))
                    {
                        ImGui.CloseCurrentPopup();
                    }
                    
                    ImGui.EndPopup();	
                break;
                
                case "Delete":
                    if (_selectedCount > 1)
                    {
                        ImGui.Text("Are you sure you want to delete multiple patterns?\n\nThis cannot be undone!");
                    }
                    else
                    {
                        ImGui.Text("Are you sure you want to delete \"" + _selectedStruct.__GetName() + "\"?\n\nThis cannot be undone!");
                    }
                    
                    ImGui.Separator();
                    
                    if (ImGui.Button("Delete"))
                    {
                        _selectionHandler.__ForEachSelected(method({
                            __selectionHandler: _selectionHandler,
                            __patternDict: _contentDict,
                        }, function(_name)
                        {
                            var _selectedStruct = __patternDict[$ _name];
                            if (_selectedStruct != undefined) _selectedStruct.__Discard();
                            
                            __selectionHandler.__Select(_name, false);
                        }));
                        
                        
                        ImGui.CloseCurrentPopup();
                    }
                    
                    ImGui.SameLine(undefined, 40);
                    if (ImGui.Button("Keep"))
                    {
                        ImGui.CloseCurrentPopup();
                    }
                    
                    ImGui.EndPopup();
                break;
            }
        }
    }
}