#include <string>
#include <unordered_map>
#include <utility>
#include <vector>
#include <iterator>

class Trie {
public:
    std::string value;
    int weight;
    std::unordered_map<std::string, Trie*> children;

    // trivial helpers
    inline int get_degree() { return children.size(); }
    Trie(std::string val, int w=-1) : value(val), weight(w) {}
    virtual ~Trie() {}

    // look up a word.
    // If found, return the sub-Trie.
    // else, create and return the sub-Trie
    Trie * find_or_create(std::string value) {
      auto it = children.find(value);
      if (it == children.end()) {
        auto ret = new Trie(value);
        children[value] = ret;
        return ret;
      }
      return children[value];
    }

    // look up a word.
    // If found, return the sub-Trie
    // else, return nullptr
    Trie * find(std::string value) {
      auto it = children.find(value);
      if (it == children.end()) {
        return nullptr;
      }
      return children[value];
    }

    // get my child suffixes, and prepend my value to them
    // if I have a weight, I also represent a suffix, so add my (weight,value) to the return vector
    // Note, this is not as efficient as NOT making these strings and iterating over them in a print method.
    std::vector< std::pair<int, std::string> > get_internal_suffixes() {
      std::vector< std::pair<int, std::string> > ret;
      for (auto it = children.begin(); it != children.end(); ++it) {
        auto suffixes = it->second->get_internal_suffixes();
        for (auto sit = suffixes.begin(); sit != suffixes.end(); ++sit) {
          // I didn't have a good way to prevent root from prefixing a space.
          // This isn't necessary if I always make a non-empty query.
          std::string possible_space = (weight == -2) ? "" : " ";
          ret.push_back(std::make_pair(sit->first, value + possible_space + sit->second));
        }
      }
      if (weight != -1) {
        ret.push_back(std::make_pair(weight, value));
      }
      return ret;
    }

    // the "public" version does not prepend its own value
    std::vector< std::pair<int, std::string> > get_suffixes() {
      std::vector< std::pair<int, std::string> > ret;
      for (auto it = children.begin(); it != children.end(); ++it) {
        auto suffixes = it->second->get_internal_suffixes();
        ret.insert(
            ret.end(),
            std::make_move_iterator(suffixes.begin()),
            std::make_move_iterator(suffixes.end())
        );
      }
      return ret;
    }
};
