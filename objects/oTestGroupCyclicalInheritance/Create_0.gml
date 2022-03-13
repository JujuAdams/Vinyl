VinylGroupCreate("a");
VinylGroupCreate("b");
VinylGroupCreate("c");
VinylGroupCreate("d");
VinylGroupCreate("e");

VinylGroup("a").GroupInherit("b", "c");
VinylGroup("b").GroupInherit("c");
VinylGroup("c").GroupInherit("d", "e");
VinylGroup("d").GroupInherit("e");
VinylGroup("e").GroupInherit("a");