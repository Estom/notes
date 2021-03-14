#include<iostream>
#include<regex>

using namespace std;

int main(){
    //i 必须在e之前，除非在c之后
    string pattern("[^c]ei");
    pattern ="[a-zA-Z]"+pattern+"[a-zA-Z]";
    regex r(pattern);
    smatch results;

    string test_str="receipt freind theif receive";
    if(regex_search(test_str,results,r))   
        cout<<results.str()<<endl;
    else
        cout<<results.str()<<endl;

    regex r2(pattern, regex::icase);

    sregex_iterator end_it;//string 
    sregex_iterator it(test_str.begin(),test_str.end(),r2);
    for(;it != end_it;++it){
        cout<<it->str()<<endl;
    }


    //第一种存储方式
    //match_results<string::const_iterator> result;
    //第二种存储方式
    smatch result;
 
    //文本数据
    string str="1994 is my birth year 1994";
    //正则表达式
    string regex_str("\\d{4}");
    regex pattern1(regex_str,regex::icase);
 
    //迭代器声明
    string::const_iterator iter = str.begin();
    string::const_iterator iterEnd= str.end();
    string temp;
    //正则查找
    while (std::regex_search(iter,iterEnd,result,pattern1))
    {
        temp=result[0];
        cout<<temp<<endl;
        iter = result[0].second; //更新搜索起始位置
    }
 
    //正则匹配
    string regex_str2("(\\d{4}).*");
    regex pattern2(regex_str2,regex::icase);
 
    if(regex_match(str,result,pattern2)){
        cout<<result[0]<<endl;
        cout<<result[1]<<endl;
    }
     
    //正则替换
    std::regex reg1("\\d{4}");
    string t("1993");
    str = regex_replace(str,reg1,t); //trim_left
    cout<<str<<endl;
  
    return 0;
}


int test_regex_match()
{
    std::string pattern{ "\\d{3}-\\d{8}|\\d{4}-\\d{7}" }; // fixed telephone
    std::regex re(pattern);

    std::vector<std::string> str{ "010-12345678", "0319-9876543", "021-123456789"};

    /* std::regex_match:
        判断一个正则表达式(参数re)是否匹配整个字符序列str,它主要用于验证文本
        注意，这个正则表达式必须匹配被分析串的全部，否则返回false;如果整个序列被成功匹配，返回true
    */

    for (auto tmp : str) {
        bool ret = std::regex_match(tmp, re);
        if (ret) fprintf(stderr, "%s, can match\n", tmp.c_str());
        else fprintf(stderr, "%s, can not match\n", tmp.c_str());
    }

    return 0;
}

int test_regex_search()
{
    std::string pattern{ "http|hppts://\\w*$" }; // url
    std::regex re(pattern);

    std::vector<std::string> str{ "http://blog.csdn.net/fengbingchun", "https://github.com/fengbingchun",
        "abcd://124.456", "abcd https://github.com/fengbingchun 123" };

    /* std::regex_search:
        类似于regex_match,但它不要求整个字符序列完全匹配
        可以用regex_search来查找输入中的一个子序列，该子序列匹配正则表达式re
    */

    for (auto tmp : str) {
        bool ret = std::regex_search(tmp, re);
        if (ret) fprintf(stderr, "%s, can search\n", tmp.c_str());
        else fprintf(stderr, "%s, can not search\n", tmp.c_str());
    }

    return 0;
}

int test_regex_search2()
{
    std::string pattern{ "[a-zA-z]+://[^\\s]*" }; // url
    std::regex re(pattern);

    std::string str{ "my csdn blog addr is: http://blog.csdn.net/fengbingchun , my github addr is: https://github.com/fengbingchun " };
    std::smatch results;
    while (std::regex_search(str, results, re)) {
        for (auto x : results)
            std::cout << x << " ";
        std::cout << std::endl;
        str = results.suffix().str();
    }

    return 0;
}

int test_regex_replace()
{
    std::string pattern{ "\\d{18}|\\d{17}X" }; // id card
    std::regex re(pattern);

    std::vector<std::string> str{ "123456789012345678", "abcd123456789012345678efgh",
        "abcdefbg", "12345678901234567X" };
    std::string fmt{ "********" };

    /* std::regex_replace:
        在整个字符序列中查找正则表达式re的所有匹配
        这个算法每次成功匹配后，就根据参数fmt对匹配字符串进行替换
    */

    for (auto tmp : str) {
        std::string ret = std::regex_replace(tmp, re, fmt);
        fprintf(stderr, "src: %s, dst: %s\n", tmp.c_str(), ret.c_str());
    }

    return 0;
}

int test_regex_replace2()
{
    // reference: http://www.cplusplus.com/reference/regex/regex_replace/
    std::string s("there is a subsequence in the string\n");
    std::regex e("\\b(sub)([^ ]*)");   // matches words beginning by "sub"

    // using string/c-string (3) version:
    std::cout << std::regex_replace(s, e, "sub-$2");

    // using range/c-string (6) version:
    std::string result;
    std::regex_replace(std::back_inserter(result), s.begin(), s.end(), e, "$2");
    std::cout << result;

    // with flags:
    std::cout << std::regex_replace(s, e, "$1 and $2", std::regex_constants::format_no_copy);
    std::cout << std::endl;

    return 0;
}