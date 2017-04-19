//
//  Statement+CoreDataProperties.h
//  statement
//
//  Created by Alexander Kuhar on 4/19/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "Statement+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Statement (CoreDataProperties)

+ (NSFetchRequest<Statement *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *statementText;

@end

NS_ASSUME_NONNULL_END
