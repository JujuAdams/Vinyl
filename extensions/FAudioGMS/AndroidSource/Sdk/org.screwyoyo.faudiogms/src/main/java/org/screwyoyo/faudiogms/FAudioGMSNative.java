package org.screwyoyo.faudiogms;

import java.lang.String;

public class FAudioGMSNative
{
    public FAudioGMSNative()
    {
        super();
    }

    /* exactly as in FAudioGMS_JNI.c: */
    public native double FAudioGMS_Init(double spatialDistanceScale, double timestep);

    public native double FAudioGMS_StaticSound_LoadWAV(String filePath);
    public native double FAudioGMS_StaticSound_CreateSoundInstance(double staticSoundID);
    public native double FAudioGMS_StaticSound_Destroy(double staticSoundID);

    public native double FAudioGMS_StreamingSound_LoadOGG(String filepath);

    public native double FAudioGMS_SoundInstance_Play(double soundInstanceID);
    public native double FAudioGMS_SoundInstance_Pause(double soundInstanceID);
    public native double FAudioGMS_SoundInstance_Stop(double soundInstanceID);

    public native double FAudioGMS_SoundInstance_SetPlayRegion(double soundInstanceID, double startInMilliseconds, double endInMilliseconds);
    public native double FAudioGMS_SoundInstance_SetLoop(double soundInstanceID, double loop);
    public native double FAudioGMS_SoundInstance_SetPan(double soundInstanceID, double pan);
    public native double FAudioGMS_SoundInstance_SetPitch(double soundInstanceID, double pitch);
    public native double FAudioGMS_SoundInstance_SetVolume(double soundInstanceID, double volume);
    public native double FAudioGMS_SoundInstance_Set3DPosition(double soundInstanceID, double x, double y, double z);
    public native double FAudioGMS_SoundInstance_Set3DVelocity(double soundInstanceID, double xVelocity, double yVelocity, double zVelocity);
    public native double FAudioGMS_SoundInstance_SetTrackPositionInSeconds(double soundInstanceID, double trackPositionInSeconds);
    public native double FAudioGMS_SoundInstance_SetVolumeOverTime(double soundInstanceID, double volume, double milliseconds);
    public native double FAudioGMS_SoundInstance_SetLowPassFilter(double soundInstanceID, double lowPassFilter, double Q);
    public native double FAudioGMS_SoundInstance_SetHighPassFilter(double soundInstanceID, double highPassFilter, double Q);
    public native double FAudioGMS_SoundInstance_SetBandPassFilter(double soundInstanceID, double bandPassFilter, double Q);
    
    public native double FAudioGMS_SoundInstance_QueueSoundInstance(double soundInstanceID, double queueSoundInstanceID);
    
    public native double FAudioGMS_SoundInstance_GetPitch(double soundInstanceID);
    public native double FAudioGMS_SoundInstance_GetVolume(double soundInstanceID);
    public native double FAudioGMS_SoundInstance_GetTrackLengthInSeconds(double soundInstanceID);
    public native double FAudioGMS_SoundInstance_GetTrackPositionInSeconds(double soundInstanceID);

    public native double FAudioGMS_SoundInstance_Destroy(double soundInstanceID);
    public native double FAudioGMS_SoundInstance_DestroyWhenFinished(double soundInstanceID);

    public native double FAudioGMS_EffectChain_Create();
    public native double FAudioGMS_EffectChain_AddDefaultReverb(double effectChainID);
    public native double FAudioGMS_EffectChain_AddReverb(
        double effectChainID,
        double wetDryMix,
        double reflectionsDelay,
        double reverbDelay,
        double earlyDiffusion,
        double lateDiffusion,
        double lowEQGain,
        double lowEQCutoff,
        double highEQGain,
        double highEQCutoff,
        double reflectionsGain,
        double reverbGain,
        double decayTime,
        double density,
        double roomSize
    );
    public native double FAudioGMS_EffectChain_Destroy(double effectChainID);

    /*
     * NOTE: Any changes to the effect chain will NOT apply after this is set!
     * You MUST call SetEffectChain again if you make changes to the effect chain parameters!
     */
    public native double FAudioGMS_SoundInstance_SetEffectChain(double soundInstanceID, double effectChainID, double effectGain);
    public native double FAudioGMS_SoundInstance_SetEffectGain(double soundInstanceID, double effectGain);

    public native double FAudioGMS_SetMasteringEffectChain(double effectChainID, double effectGain);
    public native double FAudioGMS_SetMasteringEffectGain(double effectGain);
    
    public native double FAudioGMS_SetListenerPosition(double x, double y, double z);
    public native double FAudioGMS_SetListenerVelocity(double xVelocity, double yVelocity, double zVelocity);

    public native double FAudioGMS_PauseAll(); /* mobile platforms, man... */
    public native double FAudioGMS_ResumeAll(); /* same thing here */
    public native double FAudioGMS_StopAll();

    public native double FAudioGMS_Update();
    public native double FAudioGMS_Destroy();
}
