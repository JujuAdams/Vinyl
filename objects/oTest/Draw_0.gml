var _string = "";
_string += "Vinyl " + __VINYL_VERSION + ", " + __VINYL_DATE + "\n";
_string += "Library by @jujuadams, music \"Chicken Nuggets\" by @WangleLine\n";
_string += "\n";
_string += "Press up/down to change track pitch\n";
_string += "Press F to fade out and stop the track\n";

draw_text(10, 10, _string);

VinylEmitterDebugDraw(emitter);