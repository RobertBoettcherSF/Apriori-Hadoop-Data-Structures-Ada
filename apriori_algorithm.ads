-- apriori_algorithm.ads
-- Version: 0.01
-- Ada specification for Apriori algorithm with hash tree, trie, and hash table trie data structures

package Apriori_Algorithm is

   -- Types for itemsets and transactions
   type Item is range 1..1000;  -- Assuming a maximum of 1000 unique items
   type Itemset is array (Positive range <>) of Item;
   type Transaction is array (Positive range <>) of Item;

   -- Data structure types
   type Hash_Tree;
   type Trie;
   type Hash_Table_Trie;

   -- MapReduce framework types
   type Mapper;
   type Reducer;
   type Combiner;

   -- Core Apriori algorithm procedures
   procedure Apriori_Algorithm;
   function Generate_Candidates return Itemset;
   function Count_Support return Natural;
   procedure Prune_Candidates;

end Apriori_Algorithm;
