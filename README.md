red-glint
=========

It contains some scripts designed to handle big matrix. The goal here is generating 2nd-order (smoothed) matrix. 

* Terminology
- e-f-s file: file that holds element-feature (vector) matrix. Here, it refers to a specific file format that holds many line where each line has the format of"element \t feature \t score \n". 

* List of the test scripts: 
- test1.rb: (NOUSE) reads e-f-s file and converts it to f-e-s. Not very effective (uses lots of ram.) Output on STDOUT, with log on STDERR. 
- test2.rb: reads e-f-s file and outputs integer ID based feature-vectors. The format is "feature_id \t\t element_id \t value_for_this \t element_id \t value_of_that \t ... \n". Each line shows one feature vector (one column vector, of full matrix). Output on STDOUT, with log on STDERR. Additionally, it creates "features.txt" and "elements.txt" file that maps feature/element value (string) to their index value. 
- test3.rb: reads feature vector text file (result of test2.rb), generates a portion of the B matrix. (see memos/2nd_order_sketch.org to check what is so-called B-matrix). Output on STDOUT, with log on STDERR 
- test3b.rb: same to test3.rb, but uses slightly different format of output, that uses gap, instead of "absolute" value of column index. Output on STDOUT, with log on STDERR 
- test3c.rb: same to test3b; but uses "Filewrite with row index". Output on predefined file + row-from row-to numbers (see constant in the script), with log on STDERR 
- test4.rb: (multi-thread expansion of test3. closer to real work horse) Note thta multi-thread actually works only on JRuby. 
- test5.rb: a short scirpt that shows how to recover "relative" row index to actual "absolute" row index. 

* List of utility class
- File_with_row_index.rb: this script holds several classes related to writing file with row indexes. By row, it means one line that ends with newline. Index, keeps position of each lines within the (text) file. Filewrite_with_row_index generates a file with one additional index file (.index); that records offset (File.pos) of each row. Class Fileread_with_row_index can access such rows very fast based on those indexes. Finally Simple_merger class gets a list of row-indexed files into one row-indexed (bigger) file. Useful for distributed running and merging. 

* The main scripts: 
- calc_B_st.rb: calculate B matrix, single thread. (evolved from test3c)  
- 


* Things to consider? 
- using BinData 
- 