library(testthat)

# setwd("~/tabseq/tests/testthat/")

test_that(
    'read_fasta()', {

        expect_equal(
            read_fasta("../testthat/small_genes_2.fasta") |> suppressMessages(),
            dplyr::tribble(
                ~sample,              ~part,                     ~comment,  ~sequence,
                "small_genes_2.fasta", "Genoma_CpI19_Refinada_v2", "record 1", "GTGTCGGAGGCTCCATCGACATGGAACGAGCGGTGGCAAGAAGTTACTAATGAGCTGCTGTCACAGTCTCAGGACCCGGAAAGTGGTATTTCCATTACGCGACAGCAAAGCGCCTACCTG",
                "small_genes_2.fasta", "Genoma_CpI20_Refinada_v3", "record 2", "CAATACGGAGCAACTTCAGCCAATGCTGACTTCCAGAATCAACAAAGCACGATATATCA"
            )
        )

        expect_equal(
            read_fasta("../testthat/small_genes_2.fasta", basename_only = F) |> suppressMessages(),
            dplyr::tribble(
                ~sample,              ~part,                     ~comment,  ~sequence,
                "../testthat/small_genes_2.fasta", "Genoma_CpI19_Refinada_v2", "record 1", "GTGTCGGAGGCTCCATCGACATGGAACGAGCGGTGGCAAGAAGTTACTAATGAGCTGCTGTCACAGTCTCAGGACCCGGAAAGTGGTATTTCCATTACGCGACAGCAAAGCGCCTACCTG",
                "../testthat/small_genes_2.fasta", "Genoma_CpI20_Refinada_v3", "record 2", "CAATACGGAGCAACTTCAGCCAATGCTGACTTCCAGAATCAACAAAGCACGATATATCA"
            )
        )

        expect_equal(
            read_fasta("small_genes_2.fasta", remove_extension = T) |> suppressMessages(),
            dplyr::tribble(
                ~sample,              ~part,                     ~comment,  ~sequence,
                "small_genes_2", "Genoma_CpI19_Refinada_v2", "record 1", "GTGTCGGAGGCTCCATCGACATGGAACGAGCGGTGGCAAGAAGTTACTAATGAGCTGCTGTCACAGTCTCAGGACCCGGAAAGTGGTATTTCCATTACGCGACAGCAAAGCGCCTACCTG",
                "small_genes_2", "Genoma_CpI20_Refinada_v3", "record 2", "CAATACGGAGCAACTTCAGCCAATGCTGACTTCCAGAATCAACAAAGCACGATATATCA"
            )
        )









    #read_fasta("small_genes_2.fasta")
    })
