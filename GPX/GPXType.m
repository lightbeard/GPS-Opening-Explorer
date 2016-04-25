//
//  GPXType.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXType.h"

@implementation GPXType

+ (CLLocationDegrees)latitude:(NSString *)value
{
    CLLocationDegrees f = [value doubleValue];
    return f;
}

+ (NSString *)valueForLatitude:(CLLocationDegrees)latitude
{
    if (-90.f <= latitude && latitude <= 90.f) {
        return [NSString stringWithFormat:@"%f", latitude];
    }
    
    return @"0";
}

+ (CLLocationDegrees)longitude:(NSString *)value
{
    CLLocationDegrees f = [value doubleValue];
    return f;
}

+ (NSString *)valueForLongitude:(CLLocationDegrees)longitude
{
    if (-180.f <= longitude && longitude <= 180.f) {
        return [NSString stringWithFormat:@"%f", longitude];
    }
    
    return @"0";
}

+ (CLLocationDegrees)degress:(NSString *)value
{
    CLLocationDegrees f = [value doubleValue];
    return f;
}

+ (NSString *)valueForDegress:(CLLocationDegrees)degress
{
    if (0.0f <= degress && degress <= 360.f) {
        return [NSString stringWithFormat:@"%f", degress];
    }
    
    return @"0";
}

+ (GPXFix)fix:(NSString *)value
{
    if (value) {
        if ([value isEqualToString:@"2d"]) {
            return GPXFix2D;
        }
        if ([value isEqualToString:@"3d"]) {
            return GPXFix3D;
        }
        if ([value isEqualToString:@"dgps"]) {
            return GPXFixDgps;
        }
        if ([value isEqualToString:@"pps"]) {
            return GPXFixPps;
        }
    }
    
    return GPXFixNone;
}

+ (NSString *)valueForFix:(GPXFix)fix
{
    switch (fix) {
        case GPXFixNone:
            return @"none";
        case GPXFix2D:
            return @"2d";
        case GPXFix3D:
            return @"3d";
        case GPXFixDgps:
            return @"dgps";
        case GPXFixPps:
            return @"pps";
    }
}

+ (NSInteger)dgpsStation:(NSString *)value
{
    NSInteger i = [value integerValue];
    if (0 <= i && i <= 1023) {
        return i;
    }
    return 0;
}

+ (NSString *)valueForDgpsStation:(NSInteger)dgpsStation
{
    if (0 <= dgpsStation && dgpsStation <= 1023) {
        return [NSString stringWithFormat:@"%ld", (long)dgpsStation];
    }
    
    return @"0";
}

+ (double)decimal:(NSString *)value
{
    double f = [value doubleValue];
    return f;
}

+ (NSString *)valueForDecimal:(double)decimal
{
    return [NSString stringWithFormat:@"%f", decimal];
    
}

+ (NSDateFormatter *)newDateFormatterWithFormat:(NSString *)format {
    if (!format) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];
    NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setLocale:en_US_POSIX];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}
+ (NSDate *)dateTime:(NSString *)value
{
    NSDate *date;
    
    static NSDateFormatter *dateFormatter_ssZ = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        dateFormatter_ssZ =  [self newDateFormatterWithFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    });
    
   
    // dateTime（YYYY-MM-DDThh:mm:ssZ）
    date = [dateFormatter_ssZ dateFromString:value];
    if (date) {
        return date;
    }
    
    static NSDateFormatter *dateFormatter_ss_SSSZ = nil;
    static dispatch_once_t pred_ss_SSSZ;
    
    dispatch_once(&pred_ss_SSSZ, ^{
        dateFormatter_ss_SSSZ =  [self newDateFormatterWithFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    });
    
    // dateTime（YYYY-MM-DDThh:mm:ss.SSSZ）
    date = [dateFormatter_ss_SSSZ dateFromString:value];
    if (date) {
        return date;
    }
    

    // dateTime（YYYY-MM-DDThh:mm:sszzzzzz）
    if (value.length >= 22) {
        static NSDateFormatter *dateFormatter_sszzzz = nil;
        static dispatch_once_t pred_sszzzz;
        
        dispatch_once(&pred_sszzzz, ^{
            dateFormatter_sszzzz =  [self newDateFormatterWithFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'sszzzz"];
        });
        
        
        NSString *v = [value stringByReplacingOccurrencesOfString:@":" withString:@"" options:0 range:NSMakeRange(22, 1)];
        date = [dateFormatter_sszzzz dateFromString:v];
        if (date) {
            return date;
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    // date
    formatter.dateFormat = @"yyyy'-'MM'-'dd'";
    date = [formatter dateFromString:value];
    if (date) {
        return date;
    }
    
    // gYearMonth
    formatter.dateFormat = @"yyyy'-'MM'";
    date = [formatter dateFromString:value];
    if (date) {
        return date;
    }
    
    // gYear
    formatter.dateFormat = @"yyyy'";
    date = [formatter dateFromString:value];
    if (date) {
        return date;
    }
    
    return nil;
}

+ (NSString *)valueForDateTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    // dateTime（YYYY-MM-DDThh:mm:ssZ）
    formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    
    return [formatter stringFromDate:date];
}

+ (NSInteger)nonNegativeInteger:(NSString *)value
{
    NSInteger i = [value integerValue];
    if (i > 0) {
        return i;
    }
    
    return 0;
}

+ (NSString *)valueForNonNegativeInteger:(NSInteger)integer
{
    if (integer > 0) {
        return [NSString stringWithFormat:@"%ld", (long)integer];
    }
    return @"0";
}

@end
