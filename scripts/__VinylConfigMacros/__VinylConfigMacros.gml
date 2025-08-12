// Feather disable all

//Maximum final gain for audio voices. Must be greater than or equal to zero. Setting this value
//higher will allow for higher gain values throughout Vinyl but may lead to degraded audio quality.
#macro VINYL_MAX_VOICE_GAIN  2

//Boost to global master gain. This is helpful to tame audio levels if they're too loud or to
//increase audio levels if they're too quiet.
#macro VINYL_MASTER_GAIN_BOOST  1

//Whether to set a more helpful listener orientation at the start of the game. This improves on the
//frankly bizarre default listener orientation that GameMaker uses. If this macro is set to `true`
//the following code will be executed when the game starts:
//
//  `audio_listener_set_orientation(0,   0, 0, 1,   0, -1, 0);`
// 
#macro VINYL_SET_LISTENER_ORIENTATION  true

//Falloff model to set on boot. See GameMaker documentation for `audio_falloff_set_model()` more
//information. Set this macro to `undefined` to not set a falloff model on boot (at the time of
//writing, GameMaker's default model is `audio_falloff_none` which isn't very helpful).
#macro VINYL_AUDIO_FALLOFF_MODEL  audio_falloff_linear_distance_clamped

//Default values to use for `VinylPlayAt()`. See GameMaker documentation for `audio_play_sound_at()`
//more information.
#macro VINYL_DEFAULT_FALLOFF_DIST      0
#macro VINYL_DEFAULT_FALLOFF_MAX_DIST  100
#macro VINYL_DEFAULT_FALLOFF_FACTOR    1

//The name to use to indicate no mix. This should be a unique string and cannot be used for the
//name of mixes when calling VinylSetupMix() or VinylSetupImportJSON().
#macro VINYL_NO_MIX  "no mix"

//The default mix to use for all sounds and patterns unless otherwise specified. If you set this
//macro to <VINYL_NO_MIX> then no mix will be set by default.
#macro VINYL_DEFAULT_MIX  VINYL_NO_MIX

//The default rate for VinylPlayFadeIn(), VinylFadeOut(), and VinylMixVoicesFadeOut() operations.
//These two macros are measured in "gain units per second".
#macro VINYL_DEFAULT_FADE_IN_RATE   1
#macro VINYL_DEFAULT_FADE_OUT_RATE  1

//Whether to rigorously check imported JSON when calling VinylSetupImportJSON(). This is useful to
//catch errors in JSON but carries a performance penality. You may want to consider setting this
//macro to <false> for production builds after your JSON import has been thoroughly tested.
#macro VINYL_SAFE_JSON_IMPORT  true

//Whether live editing is enabled.
#macro VINYL_LIVE_EDIT  true

//Length of moment-to-moment gain adjustments, in milliseconds
//Choose lower values for tigher, quicker gain adjustment
//Choose higher values for smooth, less glitchy gain adjustment
#macro VINYL_STEP_DURATION  50

//How far from the end of an audio asset to determine the audio as finishing. This is used for
//audio scheduling for queue voices
#macro VINYL_WILL_STOP_TOLERANCE  20