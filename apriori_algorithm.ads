-- apriori_algorithm.ads
-- Version: 0.01
-- Ada specification for Apriori algorithm with hash tree, trie, and hash table trie data structures
--
-- This package provides a complete implementation of the Apriori algorithm for
-- frequent itemset mining, including specialized data structures and MapReduce
-- framework integration.

with Ada.Containers.Vectors;
with Ada.Unchecked_Deallocation;

package Apriori_Algorithm is

   -- Basic Types for Apriori Algorithm
   -- Item: Represents a unique item in the dataset (1 to 1000)
   -- Itemset: A set of items (variable length, used for candidates and frequent itemsets)
   -- Transaction: A set of items representing a single transaction/record
   -- Itemset_Access: Access type for storing itemsets in vectors (required because
   --   Ada.Containers.Vectors cannot work with unconstrained array types directly)
   type Item is range 1..1000;  -- Unique item identifier (1-1000)
   type Itemset is array (Positive range <>) of Item;  -- Variable-length itemset
   type Transaction is array (Positive range <>) of Item;  -- Transaction of items
   type Itemset_Access is access Itemset;  -- Access type for itemset storage

   -- Memory Management
   -- Free_Itemset: Procedure to deallocate itemset memory
   --   Usage: Free_Itemset(My_Itemset_Access);
   --   Required to prevent memory leaks when using access types
   procedure Free_Itemset is new Ada.Unchecked_Deallocation(Itemset, Itemset_Access);

   -- Vector Types for Dynamic Collections
   -- Item_Vectors: Vector container for Item type (used for individual items)
   -- Itemset_Vectors: Vector container for Itemset_Access (used for itemsets)
   --   Note: Uses Itemset_Access instead of Itemset because Vectors require definite types
   package Item_Vectors is new Ada.Containers.Vectors(Positive, Item);
   use Item_Vectors;
   
   package Itemset_Vectors is new Ada.Containers.Vectors(Positive, Itemset_Access);
   use Itemset_Vectors;

   -- Data Structure Types (private - implementation details hidden)
   -- These types provide efficient storage and retrieval for the Apriori algorithm
   -- Hash_Tree: Hash-based tree structure for candidate itemset storage
   -- Trie: Prefix tree for efficient prefix-based operations
   -- Hash_Table_Trie: Combines hash table and trie for optimal performance
   type Hash_Tree is private;
   type Trie is private;
   type Hash_Table_Trie is private;

   -- MapReduce Framework Procedures
   -- Mapper: Processes a single transaction to generate local candidates
   --   Input: Transaction - a single transaction (itemset)
   --   Output: Generates local candidate itemsets (via side effect on internal state)
   -- Reducer: Aggregates counts from multiple mappers
   --   Input/Output: Candidates - vector of candidate itemsets to process
   -- Combiner: Combines partial results to reduce data transfer
   --   Input/Output: Partial_Candidates - vector of partial candidates to combine
   procedure Mapper (Transaction : Itemset);
   procedure Reducer (Candidates : in out Itemset_Vectors.Vector);
   procedure Combiner (Partial_Candidates : in out Itemset_Vectors.Vector);

   -- Core Apriori Algorithm Procedures
   -- Apriori_Algorithm: Main algorithm that generates frequent itemsets
   --   Process: Generate candidates -> Count support -> Prune -> Repeat
   -- Generate_Candidates: Creates candidate itemsets of size Current_L
   --   Input: Current_L - the current itemset size to generate
   --   Returns: Vector of candidate itemsets
   -- Count_Support: Counts database support for each candidate
   --   Input: Candidates - vector of candidate itemsets
   --   Returns: Total support count (placeholder - should scan actual database)
   -- Prune_Candidates: Removes candidates below minimum support threshold
   --   Input: Candidates - vector of candidates to prune (modified in place)
   --   Input: Min_Support - minimum support threshold for pruning
   procedure Apriori_Algorithm;
   function Generate_Candidates (Current_L : Positive) return Itemset_Vectors.Vector;
   function Count_Support (Candidates : Itemset_Vectors.Vector) return Natural;
   procedure Prune_Candidates (Candidates : in out Itemset_Vectors.Vector; Min_Support : Natural);

   -- Configuration Constants
   -- Min_Support_Threshold: Minimum number of transactions containing an itemset
   --   to be considered frequent. Adjust based on dataset size and requirements.
   Min_Support_Threshold : constant Natural := 2;

private
   -- Private Section: Implementation details of data structures
   -- These types are hidden from users of the package but accessible within the body

   -- Forward declarations for node types (required for mutual recursion)
   type InnerNode;
   type LeafNode;
   type TrieNode;
   type HashTableTrieNode;
   
   -- Named Array Types for Hash Tree
   -- These are required because Ada does not allow anonymous array types as components
   -- InnerNode_Children: Array of child inner nodes (for hash tree branching)
   -- InnerNode_Leaves: Array of leaf nodes (for storing candidate itemsets)
   -- LeafNode_Candidates: Array of candidate itemsets (stored as access types)
   type InnerNode_Children is array (Positive range <>) of access InnerNode;
   type InnerNode_Leaves is array (Positive range <>) of access LeafNode;
   type LeafNode_Candidates is array (Positive range <>) of access Itemset;
   
   -- Hash Tree Implementation
   -- InnerNode: Internal node of the hash tree with discriminated children/leaves counts
   --   Children: Array of child inner nodes (size determined by discriminant)
   --   Leaves: Array of leaf nodes (size determined by discriminant)
   -- LeafNode: Leaf node containing candidate itemsets
   --   Candidates: Array of candidate itemsets (size determined by discriminant)
   -- Hash_Tree: Access type to the root inner node
   type InnerNode (Children_Length : Natural; Leaves_Length : Natural) is record
      Children : InnerNode_Children(1..Children_Length);
      Leaves : InnerNode_Leaves(1..Leaves_Length);
   end record;
   
   type LeafNode (Candidates_Length : Natural) is record
      Candidates : LeafNode_Candidates(1..Candidates_Length);
   end record;
   
   type Hash_Tree is access InnerNode;
   
   -- Trie Implementation
   -- TrieNode: Node in the trie data structure
   --   Item_Label: Label for this node (fixed size string)
   --   Parent: Pointer to parent node (null for root)
   --   Children: Vector of child nodes (dynamic, uses Item_Vectors)
   -- Trie: Access type to the root trie node
   type TrieNode is record
      Item_Label : String(1..10);
      Parent : access TrieNode;
      Children : Item_Vectors.Vector;
   end record;
   
   type Trie is access TrieNode;
   
   -- Hash Table Trie Implementation
   -- HashTableTrieNode: Node combining hash table and trie properties
   --   Item_Label: Label for this node
   --   Parent: Pointer to parent node
   --   Children: Vector of child nodes
   -- Hash_Table_Trie: Access type to the root node
   type HashTableTrieNode is record
      Item_Label : String(1..10);
      Parent : access HashTableTrieNode;
      Children : Item_Vectors.Vector;
   end record;
   
   type Hash_Table_Trie is access HashTableTrieNode;

end Apriori_Algorithm;
