#include "trie.hpp"
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>

int main(int argc, char* argv[]) {
  // Initialize trie up here
  Trie root("", -2);
  Trie *max=nullptr;
  int max_degree=0;

  // parse input lines until I find newline
  for(std::string line; std::getline(std::cin, line) && line.compare(""); ) {
    std::stringstream ss(line);
    std::string string_weight;
    ss >> string_weight;
    int weight = std::stoi(string_weight);

    // iterate over the sentence, and build the trie
    auto next = &root;
    for(std::string word; ss >> word;) {
      // there's a little awkardness due to checking max degree as we build
      auto next_next = next->find_or_create(word);
      if (next->get_degree() > max_degree && next != &root) {
        max=next;
        max_degree=next->get_degree();
      }
      next = next_next;
    }

    // reached the end of the sentence, tack on the weight
    next->weight = weight;
  }
  // parse query line
  std::string query;
  std::getline(std::cin, query);
  std::stringstream query_stream(query);

  // iterate over the query
  auto next = &root;
  for(std::string word; query_stream >> word;) {
    next = next->find(word);
    if (next == nullptr) break;
  }

  if ( next != nullptr ) {
    std::vector< std::pair< int, std::string > > suffixes = next->get_suffixes();
    std::sort(suffixes.rbegin(), suffixes.rend());
    for (auto it=suffixes.begin(); it != suffixes.end(); ++it) {
      std::cout << it->second << std::endl;
    }
  } else {
    std::cout << "No valid completion" << std::endl;
  }
  // Now we output some stuff... probably not this
  std::cout << max->value << " " << max_degree << std::endl;

  return 0;
}
