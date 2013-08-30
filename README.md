red-glint
=========

It contains some scripts designed to handle big matrix. The goal here is generating 2nd-order (smoothed) matrix. 

* Terminology
- e-f-s file: file that holds element-feature (vector) matrix. Here, it refers to a specific file format that holds many line where each line has the format of"element \t feature \t score \n". 

* List of the test scripts: 
- test1.rb: reads e-f-s file and converts it to f-e-s. Not very effective (uses lots of ram.) 
- test2.rb: reads e-f-s file and outputs integer ID based feature-vectors. The format is "feature_id \t\t element_id \t value_for_this \t element_id \t value_of_that \t ... \n". Each line shows one feature vector (one column vector, of full matrix). 
- test3.rb: reads feature vector text file (result of test2.rb), generates a portion of the B matrix. (see memos/2nd_order_sketch.org to check what is so-called B-matrix). 
- test4.rb: (multi-thread expansion of test3.rb?) 


* The main scripts: 
(will package some of the test scripts into this, when finished. ... when?) 


* Things to consider? 
- using BinData 
- 