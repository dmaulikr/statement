//
//  Statement+CoreDataProperties.m
//  statement
//
//  Created by Alexander Kuhar on 6/17/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "Statement+CoreDataProperties.h"

@implementation Statement (CoreDataProperties)

+ (NSFetchRequest<Statement *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
}

@dynamic comments;
@dynamic completed;
@dynamic createdDate;
@dynamic statementText;
@dynamic status;
@dynamic type;

@end
