library(testthat)

# setwd("~/tabseq/tests/testthat/")

test_that(
    'read_fasta()', {

        expect_equal(
            read_fasta("../testthat/small_genes_2.fasta") |> suppressMessages(),
            dplyr::tribble(
                ~sample,              ~part,                     ~auxiliary,  ~sequence,
                "small_genes_2.fasta", "Genoma_CpI19_Refinada_v2", "record 1", "GTGTCGGAGGCTCCATCGACATGGAACGAGCGGTGGCAAGAAGTTACTAATGAGCTGCTGTCACAGTCTCAGGACCCGGAAAGTGGTATTTCCATTACGCGACAGCAAAGCGCCTACCTG",
                "small_genes_2.fasta", "Genoma_CpI20_Refinada_v3", "record 2", "CAATACGGAGCAACTTCAGCCAATGCTGACTTCCAGAATCAACAAAGCACGATATATCA"
            )
        )

        expect_equal(
            read_fasta("../testthat/small_genes_2.fasta", basename_only = F) |> suppressMessages(),
            dplyr::tribble(
                ~sample,              ~part,                     ~auxiliary,  ~sequence,
                "../testthat/small_genes_2.fasta", "Genoma_CpI19_Refinada_v2", "record 1", "GTGTCGGAGGCTCCATCGACATGGAACGAGCGGTGGCAAGAAGTTACTAATGAGCTGCTGTCACAGTCTCAGGACCCGGAAAGTGGTATTTCCATTACGCGACAGCAAAGCGCCTACCTG",
                "../testthat/small_genes_2.fasta", "Genoma_CpI20_Refinada_v3", "record 2", "CAATACGGAGCAACTTCAGCCAATGCTGACTTCCAGAATCAACAAAGCACGATATATCA"
            )
        )

        expect_equal(
            read_fasta("small_genes_2.fasta", remove_extension = T) |> suppressMessages(),
            dplyr::tribble(
                ~sample,              ~part,                     ~auxiliary,  ~sequence,
                "small_genes_2", "Genoma_CpI19_Refinada_v2", "record 1", "GTGTCGGAGGCTCCATCGACATGGAACGAGCGGTGGCAAGAAGTTACTAATGAGCTGCTGTCACAGTCTCAGGACCCGGAAAGTGGTATTTCCATTACGCGACAGCAAAGCGCCTACCTG",
                "small_genes_2", "Genoma_CpI20_Refinada_v3", "record 2", "CAATACGGAGCAACTTCAGCCAATGCTGACTTCCAGAATCAACAAAGCACGATATATCA"
            )
        )

        expect_equal(
            read_fasta("small_genes_3.fasta", remove_extension = T, skip = 1) |> suppressMessages() |> suppressWarnings(),
            dplyr::tribble(
                ~sample,              ~part,                     ~auxiliary,  ~sequence,
                "small_genes_3", "Genoma_CpI20_Refinada_v3", "record 1", "TAAAAAATACGGAGCAACTTCAGCCAATGCTGACTTCCAGAATCAACAAAGCACGATATATCA"
            )
        )

        expect_warning(
            read_fasta("small_genes_3.fasta", remove_extension = T, skip = 1) |> suppressMessages(),
            "You have skipped not long enough to align with a fasta header\\. The half-read record will be removed. Check whether your skip = \\d+ argument corresponds to the file you're reading\\."
        )




test_that(
    'something else', {
        expect_equal(3, 3)


    }
)








    #read_fasta("small_genes_2.fasta")
    })
