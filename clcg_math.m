//
//  clcg_math.m
//  Goodreads
//
//  Created by Ettore Pasquini on 2/2/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#include <math.h>

#import "clcg_math.h"


double clcg_floor(double n, unsigned decimals)
{
  double mul = pow(10, decimals);
  return floor(n * mul) / mul;
}


double clcg_ceil(double n, unsigned decimals)
{
  double mul = pow(10, decimals);
  return ceil(n * mul) / mul;
}
