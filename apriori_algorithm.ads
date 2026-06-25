-- apriori_algorithm.ads
-- Version: 0.01
-- Ada specification for Apriori algorithm with hash tree, trie, and hash table trie data structures

with Ada.Containers.Vectors;

package Apriori_Algorithm is

   -- Types for itemsets and transactions
   type Item is range 1..1000;  -- Assuming a maximum of 1000 unique items
   type Itemset is array (Positive range <>) of Item;
   type Transaction is array (Positive range <>) of Item;

   -- Vector types for dynamic collections
   package Item_Vectors is new Ada.Containers.Vectors(Positive, Item);
   use Item_Vectors;
   
   package Itemset_Vectors is new Ada.Containers.Vectors(Positive, Itemset);
   use Itemset_Vectors;

   -- Data structure types (private - implementation in body)
   type Hash_Tree is private;
   type Trie is private;
   type Hash_Table_Trie is private;

   -- Mapper, Reducer, Combiner procedures
   procedure Mapper (Transaction : Itemset);
   procedure Reducer (Candidates : in out Itemset_Vectors.Vector);
   procedure Combiner (Partial_Candidates : in out Itemset_Vectors.Vector);

   -- Core Apriori algorithm procedures
   procedure Apriori_Algorithm;
   function Generate_Candidates (Current_L : Positive) return Itemset_Vectors.Vector;
   function Count_Support (Candidates : Itemset_Vectors.Vector) return Natural;
   procedure Prune_Candidates (Candidates : in out Itemset_Vectors.Vector; Min_Support : Natural);

   -- Minimum support threshold
   Min_Support_Threshold : constant Natural := 2;

private
   -- Forward declarations for node types
   type InnerNode;
   type LeafNode;
   type TrieNode;
   type HashTableTrieNode;
   
   -- Named array types for Hash Tree
   type InnerNode_Children is array (Positive range <>) of access InnerNode;
   type InnerNode_Leaves is array (Positive range <>) of access LeafNode;
   type LeafNode_Candidates is array (Positive range <>) of access Itemset;
   
   -- Hash Tree implementation
   type InnerNode (Children_Length : Natural; Leaves_Length : Natural) is record
      Children : InnerNode_Children(1..Children_Length);
      Leaves : InnerNode_Leaves(1..Leaves_Length);
   end record;
   
   type LeafNode (Candidates_Length : Natural) is record
      Candidates : LeafNode_Candidates(1..Candidates_Length);
   end record;
   
   type Hash_Tree is access InnerNode;
   
   -- Trie implementation
   type TrieNode is record
      Item_Label : String(1..10);
      Parent : access TrieNode;
      Children : Item_Vectors.Vector;
   end record;
   
   type Trie is access TrieNode;
   
   -- Hash Table Trie implementation
   type HashTableTrieNode is record
      Item_Label : String(1..10);
      Parent : access HashTableTrieNode;
      Children : Item_Vectors.Vector;
   end record;
   
   type Hash_Table_Trie is access HashTableTrieNode;

end Apriori_Algorithm;
