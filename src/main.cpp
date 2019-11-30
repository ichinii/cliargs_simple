#include <iostream>
#include <regex>
#include <variant>
#include <string>
#include <cassert>
#include <experimental/filesystem>
#include "parser.hpp"

namespace fs = std::experimental::filesystem;

std::ostream& operator<< (std::ostream& os, const SingleValueList& values)
{
	for (const SingleValue& value : values)
		std::visit([&] (auto&& v) { os << "[" << v << "]"; }, value);
	return os;
}

Arg args_conf[] = {
	Arg{"a", true},
	Arg{"b", false},
};

int main(int argc, char* argv[])
{
	std::cout << std::boolalpha;

	auto args = parse_args(argc, argv);

	for (const auto& arg : args) {
		std::visit([&arg] (auto&& v) { std::cout << (arg.name == "" ? "?" : arg.name) << " " << v << std::endl; }, arg.value);
	}

	return 0;
}
