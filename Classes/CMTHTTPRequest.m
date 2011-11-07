//
//  CMTHTTPRequest.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 06/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTHTTPRequest.h"

#ifdef DEBUG
static NSString *kBaseURL = @"http://localhost:3000";
#else
static NSString *kBaseURL = @"http://colormatch.heroku.com";
#endif

@implementation CMTHTTPRequest

+ (CMTHTTPRequest *)requestWithPath:(NSString *)path parameters:(NSString *)parameters format:(NSString *)format {
	NSMutableString *fullPath = [NSMutableString stringWithString:kBaseURL];
	
	if(path)
		[fullPath appendFormat:@"/%@", path];
	
	if(format)
		[fullPath appendFormat:@".%@", format];
	
	if(parameters)
		[fullPath appendFormat:@"?%@", parameters];
    
    CMTHTTPRequest *request = [CMTHTTPRequest requestWithURL:[NSURL URLWithString:fullPath]];
    request.timeOutSeconds = 60;
    
	return request;
}

+ (CMTHTTPRequest *)requestWithPath:(NSString *)path parameters:(NSString *)parameters {
	return [CMTHTTPRequest requestWithPath:path parameters:nil format:@"json"];
}

+ (CMTHTTPRequest *)requestWithPath:(NSString *)path {
	return [CMTHTTPRequest requestWithPath:path parameters:nil format:@"json"];
}

@end
