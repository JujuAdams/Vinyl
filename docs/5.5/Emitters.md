# Emitters

&nbsp;

Building sonically convincing environments involves a lot of detailed work, not least the considered use of panning and spatial positioning. Emitters are points or regions in space that can play voices. As the player moves towards and away from each emitter, sounds played on that emitter pan and modulate their volume accordingly. GameMaker has its own [emitter system](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Emitters/Audio_Emitters.htm) built around point emitters. Vinyl extends this basic featureset to allow for [region emitters](Emitters) as well as simple [panned audio](Panning).

There are five types of emitter that Vinyl supports natively:

1. Point
2. Rectangle
3. Circle
4. Polyline
5. Polygon

The point-type emitter is auditorily the same as GameMaker's native emitters. The other emitters ensure that whilst the [listener position](Emitter-Functions) is inside the region audio will be played in the centre of the soundstage. For stereo effects this means the left and right channels will be balanced when inside the region. As the listener moves away from the region, the audio will attenuate and pan accordingly. This is really useful for creating zones of music or ambience which is often more convincing than a simple emitter point in 2D games.

Emitters can be created, manipulated, and destroyed using dedicated functions which you can read about [here](Emitter-Functions).