function __VinylInstanceSourceGet(_index)
{
    if ((_index < 0) || (_index >= array_length(__sources))) return undefined;
    return __sources[_index];
}
    
function __VinylInstanceSourcesCountGet()
{
    return array_length(__sources);
}

function __VinylInstanceSourcesArrayGet()
{
    var _array = array_create(array_length(__sources));
    array_copy(_array, 0, __sources, 0, array_length(__sources));
    return _array;
}

function __VinylInstanceSourceFindIndex(_source)
{
    _source = __VinylPatternizeSource(_source);
    
    var _i = 0;
    repeat(array_length(__sources))
    {
        if (__sources[_i].PatternGet() == _source) return _i;
        ++_i;
    }
    
    return undefined;
}

function __VinylInstanceFindIndex(_instance)
{
    var _i = 0;
    repeat(array_length(__sources))
    {
        if (__sources[_i] == _instance) return _i;
        ++_i;
    }
    
    return undefined;
}

function __VinylInstanceInstantiateAll(_parentInstance, _patternSources)
{
    var _sourcesCount = array_length(_patternSources);
    
    //Patternise and generate the sources
    var _instance_sources = array_create(_sourcesCount);
    var _i = 0;
    repeat(_sourcesCount)
    {
        var _pattern = _patternSources[_i];
        if (_pattern == undefined)
        {
            _instance_sources[@ _i] = undefined;
        }
        else
        {
            var _instance = __VinylPatternInstantiate(_parentInstance, _pattern);
            _instance_sources[@ _i] = _instance;
        }
        
        ++_i;
    }
    
    return _instance_sources;
}