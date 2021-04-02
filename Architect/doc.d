//////////////////////////////////////////////
//                                          //
// Architect Mod                            //
// By benjamin foo                          //
//                                          //
// Useful information gathered from         //
// various sources.                         //
//                                          //
////////////////////////////////////////////// 

// https://forum.worldofplayers.de/forum/threads/1408430-Skriptpaket-LeGo-3/page9?p=24747762&viewfull=1#post24747762

/*

// How To: Transformationsmatrix
Hier muss man wissen wie die Transformationsmatrix aufgebaut ist:

Sie besteht aus drei Vektoren, die x, y und z Richtung
des lokalen Koordinatensystem des Kameravobs
in Weltkoordinaten angeben (dabei müsste z die
Blickrichtung sein). Ich habe diese Vektoren hier
mit v1, v2, v3 Bezeichnet.
Zusätzlich gibt es in der 4. Spalte die Translation,
das heißt die Position der Kamera.

v1_x    v2_x    v3_x    x
v1_y    v2_y    v3_y    y
v1_z    v3_z    v3_z    z
0       0       0       0

Die Matrix ist Zeilenweise im Speicher abgelegt.
Da wir uns für die letzte Spalte interessieren sind die Indizes
im trafoWorld Array 3, 7 und 11, die wir brauchen.

// Vob Flags!
const int zCVob_bitfield0_showVisual                = ((1 << 1) - 1) <<  0;
const int zCVob_bitfield0_drawBBox3D                = ((1 << 1) - 1) <<  1;
const int zCVob_bitfield0_visualAlphaEnabled        = ((1 << 1) - 1) <<  2;
const int zCVob_bitfield0_physicsEnabled            = ((1 << 1) - 1) <<  3;
const int zCVob_bitfield0_staticVob                 = ((1 << 1) - 1) <<  4;
const int zCVob_bitfield0_ignoredByTraceRay         = ((1 << 1) - 1) <<  5;
const int zCVob_bitfield0_collDetectionStatic       = ((1 << 1) - 1) <<  6;
const int zCVob_bitfield0_collDetectionDynamic      = ((1 << 1) - 1) <<  7;
const int zCVob_bitfield0_castDynShadow             = ((1 << 2) - 1) <<  8;
const int zCVob_bitfield0_lightColorStatDirty       = ((1 << 1) - 1) << 10;
const int zCVob_bitfield0_lightColorDynDirty        = ((1 << 1) - 1) << 11;
const int zCVob_bitfield1_isInMovementMode          = ((1 << 2) - 1) <<  0;
const int zCVob_bitfield2_sleepingMode              = ((1 << 2) - 1) <<  0;
const int zCVob_bitfield2_mbHintTrafoLocalConst     = ((1 << 1) - 1) <<  2;
const int zCVob_bitfield2_mbInsideEndMovementMethod = ((1 << 1) - 1) <<  3;
const int zCVob_bitfield3_visualCamAlign            = ((1 << 2) - 1) <<  0;
const int zCVob_bitfield4_collButNoMove             = ((1 << 8) - 1) <<  0;
const int zCVob_bitfield4_dontWriteIntoArchive      = ((1 << 1) - 1) <<  8;

*/
