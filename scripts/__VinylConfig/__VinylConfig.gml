// Default audio falloff parameters. Used for emitters as well as `VinylPlayAt()`.
#macro VINYL_FALLOFF_MODEL     audio_falloff_linear_distance_clamped
#macro VINYL_FALLOFF_REF_DIST  10
#macro VINYL_FALLOFF_MAX_DIST  1000
#macro VINYL_FALLOFF_FACTOR    1

#macro VINYL_STEP_DURATION  50 //milliseconds

// How far from the end of an audio asset to determine the audio as finishing. This is used in the
// `VinylVoiceGetWillStop()` function.
#macro VINYL_WILL_STOP_TOLERANCE  20 //milliseconds