//////////////////////////////////////////////
//                                          //
// Architect Mod                            //
// By benjamin foo                          //
//                                          //
// Contains project related constants       //
//                                          //
////////////////////////////////////////////// 

// a simple version string
const string Architect_Version = "Architect v0.4.0";

// 
// These constants are gathered from the fabulos GFA project of mud_freak.
// * Gothic Free Aim (GFA) v1.2.0 - Free aiming for the video games Gothic 1 and Gothic 2 by Piranha Bytes
// * Copyright (C) 2016-2019  mud-freak (@szapp)
// *
// * This file is part of Gothic Free Aim.
// * <http://github.com/szapp/GothicFreeAim>
// See: https://github.com/szapp/GothicFreeAim
// See: https://github.com/szapp/GothicFreeAim/blob/master/_work/data/Scripts/Content/GFA/_intern/const.d
// 
const int zTraceRay_vob_ignore_no_cd_dyn             = 1<<0;  // Ignore vobs without collision
const int zTraceRay_vob_bbox                         = 1<<2;  // Intersect bounding boxes (important to detect NPCs)
const int zTraceRay_poly_normal                      = 1<<7;  // Report normal vector of intersection
const int zTraceRay_poly_ignore_transp               = 1<<8;  // Ignore alpha polys (without this, trace ray is bugged)
const int zTraceRay_poly_test_water                  = 1<<9;  // Intersect water
const int zTraceRay_vob_ignore_projectiles           = 1<<14; // Ignore projectiles
// Trafo matrix as zMAT4 is divided column wise
const int zMAT4_rightVec                             = 0; // Right vector
const int zMAT4_upVec                                = 1; // Up vector
const int zMAT4_outVec                               = 2; // Out vector/at vector (facing direction)
const int zMAT4_position                             = 3; // Position vector
const int oCNpc__player                              = 11216516; //0xAB2684
const int sizeof_zVEC3                               = 12;  //0x000C
const int zCWorld__TraceRayNearestHit_Vob            =  6430624; //0x621FA0


// 
// Mouse-Wheel
// 

// G1 Cursor Pointer
// const int Cursor_Ptr = 8834220; //0x86CCAC

// G2 Cursor Pointer
const int Cursor_Ptr = 9246300; //0x8D165C
const int CUR_WheelUp    = 3;
const int CUR_WheelDown  = 4;


// 
// Sounds
// These sounds are used throughout the mod in order to notify the user.
// 

const string TOGGLE_TRANSLATION_BLIP = "M_FALL_SMALL";
const string TOGGLE_ROTATION_BLIP = "M_FALL_SMALL";
const string TOGGLE_COLLISION_BLIP = "M_FALL_SMALL";
const string NOTIFY_DELETE_CONSTRUCTION = "Scroll_Unfold";
const string NOTIFY_CONSTRUCTION_BUILT = "PickOre";
const string NOTIFY_DISABLE_EDITING = "M_FALL_SMALL";
const string NOTIFY_VOB_GRAB = "Hammer_A2";


// 
// Keys
// These keys are used throughout the mod in order to allow user input.
// 

// TODO
