// Feather disable all

function __VedClassLibrary() constructor
{
    __byName    = {};
    __orderName = [];
    
    static __Clear = function()
    {
        __byName    = {};
        __orderName = [];
    }
    
    static __Add = function(_name, _data)
    {
        if (variable_struct_exists(__byName, _name))
        {
            __VedLog("Member called \"", _name, "\" already exists in library");
            return;
        }
        
        __byName[$ _name] = _data;
        array_push(__orderName, _name);
    }
    
    static __RemoveByName = function(_name)
    {
        variable_struct_remove(__byName, _name);
        
        var _orderName = __orderName;
        var _i = 0;
        repeat(array_length(_orderName))
        {
            if (_orderName[_i] == _name)
            {
                array_delete(_orderName, _i, 1);
                break;
            }
            
            ++_i;
        }
    }
    
    static __RemoveByIndex = function(_index)
    {
        var _name = __orderName[_index];
        variable_struct_remove(__byName, _name);
        array_delete(__orderName, _index, 1);
    }
    
    static __ImportArray = function(_array)
    {
        var _i = 0;
        repeat(array_length(_array))
        {
            var _data = _array[_i];
            var _name = _data.__name;
            
            if (not variable_struct_exists(__byName, _name))
            {
                __byName[$ _name] = _data;
                array_push(__orderName, _name);
            }
            
            ++_i;
        }
    }
    
    static __SortNames = function(_ascending)
    {
        array_sort(__orderName, _ascending);
    }
    
    static __GetByName = function(_name)
    {
        return __byName[$ _name];
    }
    
    static __Exists = function(_name)
    {
        return variable_struct_exists(__byName, _name);
    }
    
    static __GetCount = function()
    {
        return array_length(__orderName);
    }
    
    static __GetNameArray = function()
    {
        return __orderName;
    }
    
    static __GetDictionary = function()
    {
        return __byName;
    }
    
    static __GetDataByIndex = function(_index)
    {
        return __byName[$ __orderName[_index]];
    }
    
    static __GetNameByIndex = function(_index)
    {
        return __orderName[_index];
    }
    
    static __ForEach = function(_function, _metadata)
    {
        var _byName = __byName;
        var _orderName = __orderName;
        var _i = 0;
        repeat(array_length(_orderName))
        {
            var _name = _orderName[_i];
            _function(_i, _name, _byName[$ _name], _metadata);
            ++_i;
        }
    }
}