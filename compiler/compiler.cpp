#include <fstream>
#include <sstream>
#include <unordered_map>
#include <string>
#include <vector>
#include <bitset>
using namespace std;
#define BINSTR(str, len) (bitset<len>(stoi(str, nullptr, 0)).to_string())

string complier(string str);

int main() {
	ifstream fin("test.asm");
	ofstream fout("input.txt");
	string str;
	while (getline(fin, str)) {
		str = complier(str);
		for (int i = 0; i < str.size(); ++i) {
			fout << str[i];
			if (i % 8 == 7) {
				fout << ' ';
			}
		}
		fout << '\n';
	}
	return 0;
}

string complier(string str) {
	static unordered_map<string, string> mp{
		{"add", "000000"},
		{"sub", "000001"},
		{"addiu", "000010"},
		{"and", "010000"},
		{"andi", "010001"},
		{"ori", "010010"},
		{"xori", "010011"},
		{"sll", "011000"},
		{"slti", "100110"},
		{"slt", "100111"},
		{"sw", "110000"},
		{"lw", "110001"},
		{"beq", "110100"},
		{"bne", "110101"},
		{"bltz", "110110"},
		{"j", "111000"},
		{"jr", "111001"},
		{"jal", "111010"},
		{"halt", "111111"}
	};
	for (auto & c : str) {
		if (c == '$' || c == '(' || c == ')' || c == ',') {
			c = ' ';
		}
	}
	vector<string> vec_str;
	istringstream iss(str);
	while (iss >> str) {
		vec_str.push_back(str);
	}
	switch (vec_str.size())
	{
	case 0:
		return "";
		break;
	case 1:
		str = mp[vec_str[0]] + string(26, '0');
		break;
	case 2:
		str = mp[vec_str[0]];
		if (vec_str[0] == "jr") {
			str += BINSTR(vec_str[1], 5) + string(21, '0');
		}
		else {
			str += bitset<26>(stoi(vec_str[1], nullptr, 0) >> 2).to_string();
		}
		break;
	case 3:
		str = mp[vec_str[0]] + BINSTR(vec_str[1], 5) + string(5, '0') + BINSTR(vec_str[2], 16);
		break;
	case 4:
		str = mp[vec_str[0]];
		if (vec_str[0] == "sw" || vec_str[0] == "lw") {
			str += BINSTR(vec_str[3], 5) + BINSTR(vec_str[1], 5) + BINSTR(vec_str[2], 16);
		}
		else if (vec_str[0] == "sll") {
			str += string(5, '0') + BINSTR(vec_str[2], 5) + BINSTR(vec_str[1], 5) + BINSTR(vec_str[3], 5) + string(6, '0');
		}
		else if (vec_str[0] == "beq" || vec_str[0] == "bne") {
			str += BINSTR(vec_str[1], 5) + BINSTR(vec_str[2], 5) + BINSTR(vec_str[3], 16);
		}
		else if (vec_str[0].find('i') != vec_str[0].npos) {
			str += BINSTR(vec_str[2], 5) + BINSTR(vec_str[1], 5) + BINSTR(vec_str[3], 16);
		}
		else {
			str += BINSTR(vec_str[2], 5) + BINSTR(vec_str[3], 5) + BINSTR(vec_str[1], 5) + string(11, '0');
		}
	default:
		break;
	}
	return str;
}


