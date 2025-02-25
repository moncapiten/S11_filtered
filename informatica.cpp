

#include <iostream>// comando per iniziare a compilare

#include <vector>
//per dichiarare un vettore di interi si fa 
// vector<int>
// vector come un array, ma support piu operaizoni
// tipo resize h

using namespace std; //dichiara che prendo le funzioni sotto da questo space


int foo(int x = 1){ // se x non specificato prende valore 1
    return x + 4;
}



//int main() {
    
   
   //x = x + 4; // usare x e sovrascrivere il suo valore, x a dx solo scrittura, x a sx solo lettura

//    cout<<"Sum of x+y = " << z << endl;  //endl la l è per andare a capo
//}

//int65_t garantisce che si stnno usando 64 bit, con u davanti leva il segno al numero

//funzioni







//fibonacci

int fib3(int n){
    int x[n];
    
    x[0] = x[1] = 1
    //ciclo for
    for(auto i = 2; i < n; i++) {
        x[i] = x[i-1] + x[i-2];        
    }
    return x[n-1];
}



//ciclo WILD
int fib2(int n){
    int fib0 = 1;
    int fib1 = 1;
    //ciclo WILD
    while(n--){
        auto fib = fib0 + fib1;
        fib0 = fib1;
        fib1 = fib;
    }
    return fib1; //tenere a mente che fib esiste nel blocco più interno, 
    //fare retunr fib qua non avrebbe senso, farlo dentro al suo blocco sì
}

//costrutto IF e ricorsione

int fib(int n){
    if (n <= 1) return 1;     // condizione IF vera
    else return fib(n-1) + fib(n-2);     // condizione IF falsa 
}







int main(){
    auto x = foo();
    x = foo()
    
    int n = 10;
    int y[n]; //dichiarare n = 10 variabili numerate da 0 a n-1: y[o], y[1]....
    
    cout << "valore x è " << x << end;
    cout << "Successione di Fibionacci per x = "<< fib(x) << endl;
}




