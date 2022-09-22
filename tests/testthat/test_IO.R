library(testthat)

#setwd("~/tabseq/tests/testthat/")

test_that(
    'read_fasta()', {

    expect_equal(
        read_fasta("small_genes_2.fasta")[2,]$sequence |> suppressMessages(),
        "CAATACGGAGCAACTTCAGCCAATGCTGACTTCCAGAATCAACAAAGCACGATATATCA")







    #read_fasta("small_genes_2.fasta")
    })
