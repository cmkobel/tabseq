#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>





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


// char reverse_mapping(int ascii_letter) {
//     /*
//     Maps letters A T G C to integers 0 1 2 3 
//     */
//     if (ascii_letter == 0) {         // A
//         return 'A'; 
//     } else if (ascii_letter == 1) {  // C
//         return 'C';
//     } else if (ascii_letter == 2) {  // G
//         return 'G';
//     } else if (ascii_letter == 3) {  // T
//         return 'T';
//     } 

//     printf("Error: Letter %d does not exist in reverse_mapping().\n", ascii_letter);
//     return 4;

// }


char reverse_mapping[] = {'A', 'C', 'G', 'T'};




void node(int position, int index, int tail, int *sequence, int *tree) {
    /*
    position in sequence
    index in tree
    tail <= k
    */

    //print(f"{sequence[position]} position {position}, index {bin(index)}, tail {tail}")
    printf(" %d: position %d, index %d, tail %d\n", sequence[position], position, index, tail);

    if (tail == 0) { // Base case
        tree[index] += 1;
        printf(" save\n\n");
        return;
    //} else if (position >= len_sequence -1) { // TODO: rememeber to make sure that node() is not called beyond the end of the sequence.
    //    return;
    } else {         // Recurse
        return node(position + 1, (index << 2) + sequence[position + 1], tail - 1, sequence, tree);

    }


}



int main() {

    // Input parameters, should be read over stdin
    int k = 3;
    char * sequence_raw = "AAGG";
                         //01
    
    // Derived parameters
    int len_sequence = strlen(sequence_raw);
    int * sequence = (int *) malloc(len_sequence * sizeof(int));
    int * tree = (int *) malloc(pow(4, k) * sizeof(int));


    // Make a copy of the sequence_raw with integer coding
    for (int i = 0; i < len_sequence; i++) {
        //printf("%d ", sequence_raw[i]);
        //printf("(%d) \n", mapping(sequence_raw[i]));
        sequence[i] = mapping(sequence_raw[i]);

    }

    printf("Length is %d\n", len_sequence);

    // present coded sequence
    printf("Sequence is coded as ");
    for (int i = 0; i < len_sequence; i++) {
        printf("%d", sequence[i]); 
    }
    printf("\n");




    
    // Call node from every starting point
    for (int i = 0; i <= len_sequence - k ; i++) {
        //printf("%d", i);
        node(i, sequence[i], k - 1, sequence, tree);
    }
    printf("\n");
    



    // Present tree
    printf("Result: ");
    for (int i = 0; i < pow(4, k); i++) {
        printf("%d", tree[i]); 
    }


    // for i in range(4**k):
    // #    print(tree[i]) # works

    //     for j in reversed(range(k)):
    //         print(numbers[(i >> (j*2)) & 0b11], end = '')
    //     value = tree[i]
    //     sum += value
    //     print('\t', value, sep = "")

    // Present tree letters
    int sum = 0;
    for (int i = 0; i < pow(4, k); i++) {
        for (int j = k-1; j >= 0; j--) {
            printf("%c", reverse_mapping[(i >> (j*2)) & 3]);
        }
        int value = tree[i];
        sum += value;
        printf("\t%d\n", value);
    }
    printf("sum\t%d (%d)\n", sum, len_sequence - k+1);







    // printf("%d\n", letters);




    return 0;
}