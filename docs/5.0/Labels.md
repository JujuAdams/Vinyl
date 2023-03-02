# Labels

Labels are an evolution of GameMaker's native audio groups, expanded to allow you to control the properties of many [assets and patterns](Terminology) in bulk, both when configuring audio and at runtime. Labels can further be used as a way to execute commands on p[voices](Terminology) without worrying about whether a voice actually exists for you to act upon.

&nbsp;

## Configuration Properties

The following properties can be set for a label in the [configuration file](Configuration-Syntax).

|Property         |Config Name     |Purpose                         |
|-----------------|----------------|--------------------------------|
|Gain             |`gain`          |                                |
|Pitch            |`pitch`         |                                |
|Transpose        |`transpose`     |                                |
|Loop             |`loop`          |                                |
|Effect chain     |`effect chain`  |                                |
|Stack            |`stack`         |                                |
|Stack priority   |`stack priority`|                                |
|GM asset tag link|`tag`           |                                |
|Child labels     |`children`      |                                |

&nbsp;

## Runtime State

Labels themselves do not hold much in the way of runtime state.

|State            |Purpose                                                                                                             |
|-----------------|--------------------------------------------------------------------------------------------------------------------|
|Gain             |A gain factor for all voices assigned to the label. [Applied multiplicatively with other voice gain values](Gain)   |
|Gain target      |Target gain for the label                                                                                           |
|Gain change rate |Rate to approach the target gain                                                                                    |
|Pitch            |A pitch factor for all voices assigned to the label. [Applied multiplicatively with other voice pitch values](Pitch)|
|Pitch target     |Target pitch for the label                                                                                          |
|Pitch change rate|Rate to approach the target pitch                                                                                   |

Because labels (by design) hold such little state at runtime, this means that many functions that can optionally target labels instead of voices (such as `InputPersistentSet()`) will in fact execute code for each voice **currently** assigned to that label. Any additional voices that are assigned to the same label *after* the function has been executed will not be affected. Whether or not a function executes per voice assigned to the label or affects the label itself is highlighted in the function documentation.

This has an interesting side effect too: if you want to control behaviour of a voice but you either 1. don't want to keep a reference to that voice tucked away in a variable somewhere, 2. you don't want to keep having to check if a voice exists, then you can use a label to affect that voice indirectly. So long as that voice is assigned to a particular label, you can control the voice without using an explicit reference.