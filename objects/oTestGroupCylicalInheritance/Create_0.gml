VinylGroupCreate("a");
VinylGroupCreate("b");
VinylGroupCreate("c");
VinylGroupCreate("d");
VinylGroupCreate("e");

VinylGroupGet("a").GroupInherit("b", "c");
VinylGroupGet("b").GroupInherit("c");
VinylGroupGet("c").GroupInherit("d", "e");
//VinylGroupGet("d").GroupInherit("e");
VinylGroupGet("e").GroupInherit("a");