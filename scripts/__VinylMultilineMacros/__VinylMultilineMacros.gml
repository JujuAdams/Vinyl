// Feather disable all

#macro __VINYL_HANDLE_GAINS  if (_gain == undefined)\
                             {\
                                 var _gainMin = 1;\
                                 var _gainMax = 1;\
                             }\
                             else if (is_array(_gain))\
                             {\
                                 if (array_length(_gain) == 2)\
                                 {\
                                     var _gainMin = _gain[0];\
                                     var _gainMax = _gain[1];\
                                 }\
                                 else\
                                 {\
                                     __VinylError("Array length for gain argument must be 2 (found ", array_length(_gain), ")");\
                                 }\
                             }\
                             else\
                             {\
                                 var _gainMin = _gain;\
                                 var _gainMax = _gain;\
                             }
    
#macro __VINYL_HANDLE_PITCHES  if (_pitch == undefined)\
                               {\
                                   var _pitchMin = 1;\
                                   var _pitchMax = 1;\
                               }\
                               else if (is_array(_pitch))\
                               {\
                                   if (array_length(_pitch) == 2)\
                                   {\
                                       var _pitchMin = _pitch[0];\
                                       var _pitchMax = _pitch[1];\
                                   }\
                                   else\
                                   {\
                                       __VinylError("Array length for pitch argument must be 2 (found ", array_length(_pitch), ")");\
                                   }\
                               }\
                               else\
                               {\
                                   var _pitchMin = _pitch;\
                                   var _pitchMax = _pitch;\
                               }