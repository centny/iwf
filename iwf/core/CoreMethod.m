//
//  CoreMethod.m
//  Centny
//
//  Created by Centny on 9/25/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "CoreMethod.h"

NSString *DocumentDirectory()
{
	NSArray		*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString	*documentsDirectory = [paths objectAtIndex:0];

	return documentsDirectory;
}

