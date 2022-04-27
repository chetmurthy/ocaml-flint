#include <cstdlib>
#include <iostream>
#include <string>
#include <tuple>
#include <vector>

#include "flintstubs.h"

namespace flintstubs {

using namespace flint;
using namespace std;

std::string
partition(unsigned long n)
{
  std::string res = number_of_partitions(n).to_string() ;
  std::cout << "res = " << res << std::endl ;
  return res ;
}
} // namespace flintstubs
