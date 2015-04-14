//
//  GBDateManipulator.m
//  gobbeasy
//
//  Created by Matteo Gobbi on 12/10/12.
//  Copyright (c) 2012 Matteo Gobbi. All rights reserved.
//

#import "DateManipulator.h"

@implementation DateManipulator

/* Get a localized date and time from NSDate */
+ (NSString *) getStringToLocaleDate:(NSDate *) date
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"dd/MM/yyyy-HH:mm:ss"];
    
    NSString *dateString = [dateFormatter stringFromDate: date];
    
    return dateString;
}


/* Return a feedback string that rappresent a differece from 2 date */
+ (NSString *)differenceFeedbackFromDate:(NSDate *)date1 andDate:(NSDate *)date2 {
    
    double ti = [date1 timeIntervalSinceDate:date2];
    ti = ti * -1;
    
    if (ti < 60) {
        
        return [NSString stringWithFormat:@"%ds", (int)ti];
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        
        return [NSString stringWithFormat:@"%dm", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);

        return [NSString stringWithFormat:@"%dh", diff];
    } else {
        int diff = round(ti / 60 / 60 / 24);
        
        //return format like Yesterday
        if(diff==2){
            return @"Yesterday";
        }else{
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date2];
            NSString *dayStr = components.day<10?[NSString stringWithFormat:@"0%ld",(long)components.day]:[NSString stringWithFormat:@"%ld",(long)components.day];
            NSString *monthStr = components.month<10?[NSString stringWithFormat:@"0%ld",(long)components.month]:[NSString stringWithFormat:@"%ld",(long)components.month];
            NSString *yearStr = components.year<10?[NSString stringWithFormat:@"0%ld",(long)components.year]:[NSString stringWithFormat:@"%ld",(long)components.year];
            
            return [NSString stringWithFormat:@"%@,%@ %@",monthStr,dayStr,yearStr];
        }
        
        //Return years
        if(diff >= 365) {
            int y = round(diff/365.0);
            if(y > 100)return [NSString stringWithFormat:@"+%dy", y];
            return [NSString stringWithFormat:@"%dy", y];
        }
        
        return [NSString stringWithFormat:@"%dd", diff];
    }
}


/* Get actual timestamp (int) */
+ (int)getActualTimestamp {
    return [[NSDate date] timeIntervalSince1970];
}

@end
