
#include <Rcpp.h>
using namespace Rcpp;
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#include <math.h>




// [[Rcpp::export]]
int mapping(int ascii_letter) { // Really, it does take a char, but we treat it as an int.
    /*
    Maps letters A T G C to integers 0 1 2 3
    */
    if (ascii_letter == 65) {         // A
        return 0;
    } else if (ascii_letter == 67) {  // C
        return 1;
    } else if (ascii_letter == 71) {  // G
        return 2;
    } else if (ascii_letter == 84) {  // T
        return 3;
    }

    printf("Error: Letter %c does not exist in mapping().\n", ascii_letter);
    return 4;

}





char reverse_mapping[] = {'A', 'C', 'G', 'T'};




void node(int position, int index, int tail, int *sequence, int *tree) {
    /*
     position in sequence
     index in tree
     tail <= k
     */

    //print(f"{sequence[position]} position {position}, index {bin(index)}, tail {tail}")
    //printf(" %d: position %d, index %d, tail %d\n", sequence[position], position, index, tail);

    if (tail == 0) { // Base case
        tree[index] += 1;
        //printf(" save\n\n");
        return;
        //} else if (position >= len_sequence -1) { // TODO: rememeber to make sure that node() is not called beyond the end of the sequence.
        //    return;
    } else {         // Recurse
        return node(position + 1, (index << 2) + sequence[position + 1], tail - 1, sequence, tree);

    }


}



//int main() {
// [[Rcpp::export]]
IntegerVector kmer_count(NumericVector k_R, CharacterVector sequence_R) {


    // Convert R inputs to c types
    int k = k_R[0];
    printf("k is %d\n", k);
    const char * sequence_raw = ((String) sequence_R[0]).get_cstring();


    // Derived parameters
    int len_sequence = strlen(sequence_raw);
    int * sequence = (int *) malloc(len_sequence * sizeof(int));
    int * tree = (int *) malloc(pow(4, k) * sizeof(int));

    // Reset tree
    for (int i = 0; i<pow(4, k); i++) {
        tree[i] = 0;
    }

    // Make a copy of the sequence_raw with integer coding
    for (int i = 0; i < len_sequence; i++) {
        //printf("%d ", sequence_raw[i]);
        //printf("(%d) \n", mapping(sequence_raw[i]));
        sequence[i] = mapping(sequence_raw[i]);

    }

    printf("Length is %d\n", len_sequence);

    // present coded sequence
    // printf("Sequence is coded as ");
    // for (int i = 0; i < len_sequence; i++) {
    //     printf("%d", sequence[i]);
    // }
    // printf("\n");





    // Call node from every starting point
    for (int i = 0; i <= len_sequence - k ; i++) {
        //printf("%d", i);
        node(i, sequence[i], k - 1, sequence, tree);
    }
    printf("\n");




    // // Present tree
    // printf("Result: ");
    // for (int i = 0; i < pow(4, k); i++) {
    //     printf("%d", tree[i]);
    // }
    // printf("\n");


    // Present tree letters
    IntegerVector rv (pow(4, k));
    int sum = 0;
    for (int i = 0; i < pow(4, k); i++) {
        //char key[] = ""; // TODO, fix naming of the rv elements.
        for (int j = k-1; j >= 0; j--) {
            printf("%c", reverse_mapping[(i >> (j*2)) & 3]);
            //strcat(key, (char *) reverse_mapping[(i >> (j*2)) & 3]);
        }
        int value = tree[i];
        sum += value;
        //printf("\t%d\n", value);
        rv[i] = value;
    }
    //printf("sum\t%d (%d)\n", sum, len_sequence - k+1);











    //return 0;
    return rv;
}
