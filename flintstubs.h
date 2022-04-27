#include <iostream>
#include <string>
#include <tuple>
#include <vector>

#include "arithxx.h"
#include "fmpzxx.h"

#ifndef flintstubs_h_included
#define flintstubs_h_included

namespace flintstubs {

std::string
  foo(int n) ;

std::tuple< std::string, int >
  bar(std::string s, int n);

void
buzz(std::string s);

std::string
partition(unsigned long);


} // namespace flintstubs

#endif
