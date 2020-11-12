library(tidyverse)

VERSION = "0.0.2"

library(magrittr)
#needs: dplyr, string, tidyr


read_tabseq = function(file, from_fasta = T) {
    
    
    if (from_fasta) {
        # Open the file
        cat(paste("reading", file, "as fasta", "\n"))
        file_open = scan(file, what="character", sep=NULL, quiet = T)
        
        
        rv = dplyr::tibble(raw = file_open) %>% 
            
            # detect record headers
            dplyr::mutate(header = ifelse(stringr::str_sub(raw, 1,1) == ">", T, F)) %>% 
            
            # enumerate the record headers and fill the downwards through the sequence lines
            dplyr::mutate(header_num = ifelse(header, seq.int(nrow(.)), NA)) %>% # needs no sorting
            tidyr::fill(header_num, .direction = "down") %>% 
            
            # Collect the lines for each record
            dplyr::group_by(header_num) %>% 
            dplyr::summarize(part = stringr::str_sub(raw[1], 2),
                             sequence = paste(raw[-1], collapse = ""), .groups = "drop") %>% 
            
            dplyr::mutate(comment = paste("record", dplyr::row_number(header_num))) %>%  # reset header nums
            
            dplyr::transmute(sample = file, part, comment, sequence)
        
        print(rv)
        rv
        
    }
    
}

out = read_tabseq(file = "test2.fa")


write_tabseq = function(x, file, record_format = "%part", to_fasta = T) {
    
    if (to_fasta) {
        
        cat(paste("writing to file ", file, "as fasta", "\n"))
        cat(paste("using the following record_format:", record_format, "\n"))
        
        # format as "fasta"
        formatted = x %>%
            mutate(record_format = record_format) %>% 
            transmute(record = str_replace_all(record_format, "%sample", sample) %>% 
                          str_replace_all("%part", part) %>% 
                          str_replace_all("%comment", comment), sequence = sequence)
        
        print(formatted)
    
        
    
        # Interleave
        interleave = as.vector(rbind(paste0(">", formatted$record), formatted$sequence))
        
        
        fileConn<-file(file)
        writeLines(interleave, fileConn)
        close(fileConn)
        
        #cat("\n")
        #cat(paste0(">", formatted$record, "\t", str_sub(formatted$sequence, 1, 10), "...", collapse = "\n"))
    }
    
}

x = out
write_tabseq(x, "output.fasta")




