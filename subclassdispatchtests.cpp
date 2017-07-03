#include <iostream>
#include <chrono>
#include <vector>
#include <memory>

using Clock = std::chrono::high_resolution_clock;
using std::chrono::microseconds;

struct AbstrType{
    virtual int f() = 0;
};

struct ConcrType1: public AbstrType{
    int x;
    ConcrType1(int x): x{x} {}
    virtual int f() { return x; }
};

struct ConcrType2: public AbstrType{
    int x;
    ConcrType2(int x): x{x} {}
    virtual int f() { return x; }
};

int main(int argc, char **argv) {
    int n = 100'000;

    std::vector<ConcrType1> arrconcr;
    for(int i=0; i<n; i++){
        arrconcr.push_back(ConcrType1(i+1));
    }

    std::vector<AbstrType*> arrabstr;
    for(int i=0; i<n; i++){
        // alternate object type to inhibit branch prediction (?)
        if(rand()%2){
            arrabstr.push_back(new ConcrType1(i+1));
        }else{
            arrabstr.push_back(new ConcrType2(i+1));
        }
    }


    int sumconcr = 0;
    auto t0 = Clock::now();
    for(auto& e : arrconcr) { sumconcr += e.f(); }
    auto t1 = Clock::now();

    int sumabstr = 0;
    auto t2 = Clock::now();
    for(auto& p : arrabstr) { sumabstr += p->f(); }
    auto t3 = Clock::now();


    std::cout << std::chrono::duration_cast<microseconds>(t1-t0).count() * 1e-6 << " seconds" << std::endl;
    std::cout << std::chrono::duration_cast<microseconds>(t3-t2).count() * 1e-6 << " seconds" << std::endl;

    if(sumconcr != sumabstr){
        throw std::runtime_error("sumconcr != sumabstr");
    }
    std::cout << "(sum=" << sumabstr << ")" << std::endl;

    for(auto p: arrabstr) { delete p; }

    return 0;
}
