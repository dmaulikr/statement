//
//  Statement+CoreDataProperties.m
//  statement
//
//  Created by Alexander Kuhar on 4/19/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "Statement+CoreDataProperties.h"

@implementation Statement (CoreDataProperties)

+ (NSFetchRequest<Statement *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
}

@dynamic statementText;

@end
