//
//  Statement+CoreDataProperties.h
//  statement
//
//  Created by Alexander Kuhar on 4/28/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "Statement+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Statement (CoreDataProperties)

+ (NSFetchRequest<Statement *> *)fetchRequest;

@property (nonatomic) BOOL completed;
@property (nullable, nonatomic, copy) NSString *statementText;
@property (nullable, nonatomic, copy) NSDate *createdDate;

@end

NS_ASSUME_NONNULL_END
