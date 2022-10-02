// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// mapping
int mapping(int ascii_letter);
RcppExport SEXP _tabseq_mapping(SEXP ascii_letterSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< int >::type ascii_letter(ascii_letterSEXP);
    rcpp_result_gen = Rcpp::wrap(mapping(ascii_letter));
    return rcpp_result_gen;
END_RCPP
}
// kmer_count
int kmer_count(CharacterVector sequence_R);
RcppExport SEXP _tabseq_kmer_count(SEXP sequence_RSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< CharacterVector >::type sequence_R(sequence_RSEXP);
    rcpp_result_gen = Rcpp::wrap(kmer_count(sequence_R));
    return rcpp_result_gen;
END_RCPP
}
// rcpp_hello_world
List rcpp_hello_world();
RcppExport SEXP _tabseq_rcpp_hello_world() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(rcpp_hello_world());
    return rcpp_result_gen;
END_RCPP
}
// special_test
int special_test();
RcppExport SEXP _tabseq_special_test() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(special_test());
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_tabseq_mapping", (DL_FUNC) &_tabseq_mapping, 1},
    {"_tabseq_kmer_count", (DL_FUNC) &_tabseq_kmer_count, 1},
    {"_tabseq_rcpp_hello_world", (DL_FUNC) &_tabseq_rcpp_hello_world, 0},
    {"_tabseq_special_test", (DL_FUNC) &_tabseq_special_test, 0},
    {NULL, NULL, 0}
};

RcppExport void R_init_tabseq(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
