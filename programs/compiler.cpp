#include "bits/stdc++.h"

using namespace std;
int line = 0;

// r[Rs] を 000 ~ 111 に変換
string s_to_b(string s)
{
    if (s[2] == '0')
        return "000";
    else if (s[2] == '1')
        return "001";
    else if (s[2] == '2')
        return "010";
    else if (s[2] == '3')
        return "011";
    else if (s[2] == '4')
        return "100";
    else if (s[2] == '5')
        return "101";
    else if (s[2] == '6')
        return "110";
    else if (s[2] == '7')
        return "111";
    else
    {
        cout << "s to b parsing failed"
             << "(in line: " << line << ")" << endl;
        cout << "exit code : 0" << endl;
        return 0;
    }
}

int main()
{
    string inst;
    while (cin >> inst)
    {
        if (inst[0] == '#')
            continue;
        line++;
        string sub2 = "**", sub3 = "***", sub4 = "****";
        string res = "";
        if (inst.length() == 2)
            sub2 = inst.substr(0, 2);
        else if (inst.length() == 3)
        {
            sub3 = inst.substr(0, 3);
        }
        else if (inst.length() == 4)
        {
            sub4 = inst.substr(0, 4);
        }
        else
        {
            cout << "first parsing failed"
                 << "(in line: " << line << ")" << endl;
            cout << "exit code : 1" << endl;
            return 0;
        }

        if (sub3 == "ADD" || sub3 == "SUB" || sub3 == "AND" || sub2 == "OR" ||
            sub3 == "XOR" || sub3 == "CMP" || sub3 == "MOV")
        {
            res += "11";
            string rd, rs;
            cin >> rs >> rd; // changed

            res += s_to_b(rs);
            res += s_to_b(rd);

            if (sub3 == "ADD")
                res += "0000";
            else if (sub3 == "SUB")
                res += "0001";
            else if (sub3 == "AND")
                res += "0010";
            else if (sub2 == "OR")
                res += "0011";
            else if (sub3 == "XOR")
                res += "0100";
            else if (sub3 == "CMP")
                res += "0101";
            else if (sub3 == "MOV")
                res += "0110";
            else
            {
                cout << "second parsing failed"
                     << "(in line: " << line << ")" << endl;
                return 0;
            }

            res += "0000";
        }
        else if (sub3 == "SLL" || sub3 == "SLR" || sub3 == "SRL" || sub3 == "SRA")
        {
            res += "11";
            string rd, d;
            cin >> rd >> d;

            res += "000";
            res += s_to_b(rd);

            if (sub3 == "SLL")
                res += "1000";
            else if (sub3 == "SLR")
                res += "1001";
            else if (sub3 == "SRL")
                res += "1010";
            else if (sub3 == "SRA")
                res += "1011";
            else
            {
                cout << "third parsing failed"
                     << "(in line: " << line << ")" << endl;
                cout << "exit code : 2" << endl;
                return 0;
            }

            res += d;
        }
        else if (sub2 == "IN")
        {
            res += "11";
            string rd, d;
            cin >> rd >> d;

            res += "000";
            res += s_to_b(rd);
            res += "1100";
            res += d;
        }
        else if (sub3 == "OUT")
        {
            res += "11";
            string rs;
            cin >> rs;

            res += s_to_b(rs);
            res += s_to_b(rs);
            res += "1101";
            res += "0000";
        }
        else if (sub3 == "HLT")
        {
            res += "11";
            res += "000";
            res += "000";
            res += "1111";
            res += "0000";
        }
        else if (sub2 == "LD")
        {
            string ra, rb, d;
            cin >> ra >> rb >> d;

            res += "00";
            res += s_to_b(ra);
            res += s_to_b(rb);
            res += d;
        }
        else if (sub2 == "ST")
        {
            string ra, rb, d;
            cin >> ra >> rb >> d;

            res += "01";
            res += s_to_b(ra);
            res += s_to_b(rb);
            res += d;
        }
        else if (sub2 == "LI")
        {
            string rb, d;
            cin >> rb >> d;

            res += "10";
            res += "000";
            res += s_to_b(rb);
            res += d;
        }
        else if (sub2 == "BR")
        {
            string rb, d;
            cin >> rb >> d;

            res += "10";
            res += "100";
            res += s_to_b(rb);
            // res += "000";
            res += d;
        }
        else if (sub4 == "ADDI")
        {
            string rb, d;
            cin >> rb >> d;

            res += "10";
            res += "001";
            res += s_to_b(rb);
            res += d;
        }
        else if (sub4 == "SUBI")
        {
            string rb, d;
            cin >> rb >> d;

            res += "10";
            res += "010";
            res += s_to_b(rb);
            res += d;
        }
        else if (sub4 == "CMPI")
        {
            string rb, d;
            cin >> rb >> d;

            res += "10";
            res += "011";
            res += s_to_b(rb);
            res += d;
        }
        else if (sub2 == "BE" || sub3 == "BLT" || sub3 == "BLE" || sub3 == "BNE")
        {
            string d;
            cin >> d;

            res += "10";
            res += "111";

            if (sub2 == "BE")
                res += "000";
            else if (sub3 == "BLT")
                res += "001";
            else if (sub3 == "BLE")
                res += "010";
            else if (sub3 == "BNE")
                res += "011";
            else
            {
                cout << "fourth parsing failed"
                     << "(in line: " << line << ")" << endl;
                cout << "exit code : 4" << endl;
                return 0;
            }

            res += d;
        }
        else
        {
            cout << "fifth parsing failed"
                 << "(in line: " << line << ")" << endl;
            cout << "exit code : 5" << endl;
            cout << inst << " " << sub2 << " " << sub3 << endl;
            return 0;
        }
        cout << res << endl;
    }
}