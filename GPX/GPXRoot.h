//
//  GPXRoot.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"

@class GPXMetadata;
@class GPXWaypoint;
@class GPXRoute;
@class GPXTrack;
@class GPXExtensions;


/** GPX is the root element in the XML file.
    GPX documents contain a metadata header, followed by waypoints, routes, and tracks. 
    You can add your own elements to the extensions section of the GPX document.
 */
@interface GPXRoot : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** The namespace for external XML schemas. */
@property (strong, nonatomic, readonly) NSString * _Nonnull schema;

/** You must include the version number in your GPX document. */
@property (strong, nonatomic) NSString * _Nullable version;

/** You must include the name or URL of the software that created your GPX document. 
    This allows others to inform the creator of a GPX instance document that fails to validate. */
@property (strong, nonatomic) NSString * _Nullable creator;

/** Metadata about the file. */
@property (strong, nonatomic) GPXMetadata * _Nullable metadata;

/** A list of waypoints. */
@property (strong, nonatomic, readonly) NSArray<GPXWaypoint *> * _Nullable waypoints;

/** A list of routes. */
@property (strong, nonatomic, readonly) NSArray<GPXRoute *> * _Nullable routes;

/** A list of tracks. */
@property (strong, nonatomic, readonly) NSArray<GPXTrack *> * _Nullable tracks;

/** You can add extend GPX by adding your own elements from another schema here. */
@property (strong, nonatomic) GPXExtensions * _Nullable extensions;


/// ---------------------------------
/// @name Create Root Element
/// ---------------------------------

/** Creates and returns a new root element.
 @param creator The name or URL of the software.
 @return A newly created root element.
 */
+ (GPXRoot * _Nonnull)rootWithCreator:(NSString * _Nonnull)creator;


/// ---------------------------------
/// @name Creating Waypoint
/// ---------------------------------

/** Creates and returns a new waypoint element.
 @param latitude The latitude of the point.
 @param longitude The longitude of the point.
 @return A newly created waypoint element.
 */
- (GPXWaypoint * _Nonnull)newWaypointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;


/// ---------------------------------
/// @name Adding Waypoint
/// ---------------------------------

/** Inserts a given GPXWaypoint object at the end of the waypoint array.
 @param waypoint The GPXWaypoint to add to the end of the waypoint array.
 */
- (void)addWaypoint:(GPXWaypoint * _Nonnull)waypoint;

/** Adds the GPXWaypoint objects contained in another given array to the end of the waypoint array.
 @param array An array of GPXWaypoint objects to add to the end of the waypoint array.
 */
- (void)addWaypoints:(NSArray<GPXWaypoint *> * _Nonnull)array;


/// ---------------------------------
/// @name Removing Waypoint
/// ---------------------------------

/** Removes all occurrences in the waypoint array of a given GPXWaypoint object.
 @param waypoint The GPXWaypoint object to remove from the waypoint array.
 */
- (void)removeWaypoint:(GPXWaypoint * _Nonnull)waypoint;


/// ---------------------------------
/// @name Creating Route
/// ---------------------------------

/** Creates and returns a new route element.
 @return A newly created route element.
 */
- (GPXRoute * _Nonnull)newRoute;


/// ---------------------------------
/// @name Adding Route
/// ---------------------------------

/** Inserts a given GPXRoute object at the end of the route array.
 @param route The GPXRoute to add to the end of the route array.
 */
- (void)addRoute:(GPXRoute * _Nonnull)route;

/** Adds the GPXRoute objects contained in another given array to the end of the route array.
 @param array An array of GPXRoute objects to add to the end of the route array.
 */
- (void)addRoutes:(NSArray<GPXRoute *> * _Nonnull)array;


/// ---------------------------------
/// @name Removing Route
/// ---------------------------------

/** Removes all occurrences in the route array of a given GPXRoute object.
 @param route The GPXRoute object to remove from the route array.
 */
- (void)removeRoute:(GPXRoute * _Nonnull)route;


/// ---------------------------------
/// @name Creating Track
/// ---------------------------------

/** Creates and returns a new track element.
 @return A newly created track element.
 */
- (GPXTrack * _Nonnull)newTrack;


/// ---------------------------------
/// @name Adding Track
/// ---------------------------------

/** Inserts a given GPXTrack object at the end of the track array.
 @param track The GPXTrack to add to the end of the track array.
 */
- (void)addTrack:(GPXTrack * _Nonnull)track;

/** Adds the GPXTrack objects contained in another given array to the end of the track array.
 @param array An array of GPXTrack objects to add to the end of the track array.
 */
- (void)addTracks:(NSArray<GPXTrack *> * _Nonnull)array;


/// ---------------------------------
/// @name Removing Track
/// ---------------------------------

/** Removes all occurrences in the track array of a given GPXTrack object.
 @param track The GPXTrack object to remove from the track array.
 */
- (void)removeTrack:(GPXTrack * _Nonnull)track;

@end
