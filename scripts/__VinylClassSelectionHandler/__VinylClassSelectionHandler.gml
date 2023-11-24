// Feather disable all

function __VinylClassSelectionHandler() constructor
{
    __multiselect   = false;
    __seeSelected   = true;
    __seeUnselected = true;
    
    __selectedArray = [];
    __lastSelected = undefined;
    
    static __IsSelected = function(_value)
    {
        return array_contains(__selectedArray, _value);
    }
    
    static __GetSelectedCount = function()
    {
        return array_length(__selectedArray);
    }
    
    static __GetLastSelectedName = function()
    {
        return __lastSelected;
    }
    
    static __GetMultiselect = function()
    {
        return __multiselect;
    }
    
    static __GetSeeSelected = function()
    {
        return __seeSelected;
    }
    
    static __GetSeeUnselected = function()
    {
        return __seeUnselected;
    }
    
    static __SelectToggle = function(_value)
    {
        if (__multiselect)
        {
            __Select(_value, not __IsSelected(_value));
        }
        else
        {
            __Select(_value, true);
        }
    }
    
    static __Select = function(_value, _state)
    {
        if (_state == __IsSelected(_value)) return;
        
        if (not __multiselect)
        {
            __SelectNone();
        }
        
        if (_state)
        {
            if (not array_contains(__selectedArray, _value))
            {
                array_push(__selectedArray, _value);
            }
            
            __lastSelected = _value;
        }
        else
        {
            var _index = __VinylArrayFindIndex(__selectedArray, _value);
            if (_index != undefined) array_delete(__selectedArray, _index, 1);
            if (__lastSelected == _value) __lastSelected = undefined;
        }
    }
    
    static __SelectArray = function(_valueArray)
    {
        var _length = array_length(_valueArray);
        var _i = 0;
        repeat(_length)
        {
            var _value = _valueArray[_i];
            if (not array_contains(__selectedArray, _value))
            {
                array_push(__selectedArray, _value);
            }
            
            ++_i;
        }
        
        //Guarantee __lastSelected
        if ((__lastSelected == undefined) || (not array_contains(__selectedArray, __lastSelected)))
        {
            __lastSelected = (_length > 0)? _valueArray[_length-1] : undefined;
        }
    }
    
    static __SelectNone = function()
    {
        array_resize(__selectedArray, 0);
        __lastSelected = undefined;
    }
    
    static __SelectLast = function()
    {
        if (not __multiselect)
        {
            array_resize(__selectedArray, 0);
        }
        
        if ((__lastSelected != undefined) && ((not is_struct(__lastSelected)) || (not __lastSelected.__destroyed)))
        {
            __Select(__lastSelected, true);
        }
        else
        {
            __lastSelected = undefined;
        }
    }
    
    static __ForEachSelected = function(_method)
    {
        var _i = 0;
        repeat(array_length(__selectedArray))
        {
            var _selected = __selectedArray[_i];
            if (is_struct(_selected))
            {
                if (not _selected.__destroyed) _method(_selected);
            }
            else
            {
                _method(_selected);
            }
            
            ++_i;
        }
    }
    
    static __BuildUI = function(_visibleArray)
    {
        ImGui.Text("Multiselect");
        ImGui.SameLine();
        
        var _newValue = ImGui.Checkbox("##Multiselect", __multiselect);
        if (_newValue != __multiselect)
        {
            __multiselect = _newValue;
            
            if (not __multiselect)
            {
                __SelectLast();
            }
        }
        
        ImGui.BeginDisabled(not __multiselect);
            ImGui.SameLine();
            if (ImGui.Button("All"))
            {
                __SelectArray(_visibleArray);
            }
            
            ImGui.SameLine();
            if (ImGui.Button("None"))
            {
                __SelectNone();
            }
            
            var _newValue = ImGui.Checkbox("See selected", (not __multiselect) || __seeSelected);
            if (__multiselect)
            {
                __seeSelected = _newValue;
            }
            
            ImGui.SameLine(undefined, 20);
            var _newValue = ImGui.Checkbox("See unselected", (not __multiselect) || __seeUnselected);
            if (__multiselect)
            {
                __seeUnselected = _newValue;
            }
        ImGui.EndDisabled();
    }
}