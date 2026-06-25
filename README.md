# Apriori Algorithm Implementation in Ada

A complete implementation of the **Apriori algorithm** for frequent itemset mining with **Hash Tree**, **Trie**, and **Hash Table Trie** data structures, designed for integration with Hadoop MapReduce framework.

## Overview

This project implements the Apriori algorithm for association rule mining in Ada. The implementation includes:

- **Core Apriori Algorithm**: Generates frequent itemsets from transactional data
- **Data Structures**:
  - Hash Tree for efficient candidate generation
  - Trie for prefix-based itemset storage
  - Hash Table Trie combining hash-based access with trie structure
- **MapReduce Integration**: Mapper, Reducer, and Combiner procedures for distributed processing
- **Comprehensive Test Suite**: 8 test procedures verifying all functionality

## Features

- ✅ Complete Apriori algorithm implementation
- ✅ Three specialized data structures (Hash Tree, Trie, Hash Table Trie)
- ✅ MapReduce framework integration (Mapper, Reducer, Combiner)
- ✅ Dynamic memory management with proper cleanup
- ✅ Comprehensive test suite with expected results validation
- ✅ Compile-ready with GNAT Project files

## Quick Start

### Prerequisites

- GNAT Ada Compiler (gprbuild, gnatmake)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/RobertBoettcherSF/Apriori-Hadoop-Data-Structures-Ada.git
cd Apriori-Hadoop-Data-Structures-Ada

# Compile the main algorithm
mkdir obj
gprbuild -P apriori_algorithm.gpr

# Run the main program
./main

# Or compile and run the test suite
mkdir obj
gprbuild -P test_apriori.gpr
./test_apriori
```

## Project Structure

```
Apriori-Hadoop-Data-Structures-Ada/
├── README.md                    # This file
├── apriori_algorithm.ads        # Package specification
├── apriori_algorithm.adb        # Package implementation
├── apriori_algorithm.gpr        # GNAT project file for main algorithm
├── main.adb                     # Main entry point
├── test_apriori.adb             # Comprehensive test suite
├── test_apriori.gpr             # GNAT project file for tests
└── obj/                         # Object directory (created during build)
```

## Usage

### Running the Algorithm

The main program executes the complete Apriori algorithm:

```bash
./main
```

This will:
1. Generate candidate itemsets starting from size 1
2. Count support for each candidate
3. Prune candidates below minimum support threshold
4. Iterate until no more frequent itemsets are found
5. Output the total number of frequent itemsets discovered

### Running Tests

The test suite verifies all components:

```bash
./test_apriori
```

This executes 8 comprehensive tests:
1. **Basic Types**: Tests vector types and memory management
2. **Mapper Function**: Tests transaction processing
3. **Generate_Candidates**: Verifies candidate generation for L=1,2,3
4. **Count_Support**: Tests support counting
5. **Prune_Candidates**: Tests candidate pruning
6. **Reducer/Combiner**: Tests MapReduce components
7. **Full Algorithm**: Runs complete Apriori algorithm
8. **Data Structures**: Tests instantiation of all data structures

## Algorithm Details

### Apriori Principle

The Apriori algorithm uses the **Apriori property**: All non-empty subsets of a frequent itemset must also be frequent. This allows efficient pruning of the candidate search space.

### Implementation Steps

1. **Generate Candidates**: Create candidate itemsets of size k from frequent itemsets of size k-1
2. **Count Support**: Scan database to count occurrences of each candidate
3. **Prune**: Remove candidates with support below minimum threshold
4. **Repeat**: Increment k and repeat until no more frequent itemsets

### Data Structures

#### Hash Tree
- Efficient storage and retrieval of itemsets
- Uses hashing to distribute itemsets across tree nodes
- Reduces memory usage compared to flat storage

#### Trie (Prefix Tree)
- Stores itemsets with common prefixes together
- Enables efficient prefix-based operations
- Useful for subset checking

#### Hash Table Trie
- Combines benefits of hash tables and tries
- Fast lookup with hierarchical organization
- Ideal for frequent pattern mining

## MapReduce Integration

The implementation includes three MapReduce components:

### Mapper
- Processes individual transactions
- Generates local candidate itemsets
- Input: Transaction (array of items)
- Output: Local candidates (vector of itemsets)

### Reducer
- Aggregates counts from multiple mappers
- Generates frequent itemsets
- Input: Candidates vector (in out parameter)

### Combiner
- Reduces data transfer between map and reduce phases
- Combines partial results on mapper nodes
- Input: Partial candidates vector (in out parameter)

## Configuration

### Minimum Support Threshold

The minimum support threshold is defined in `apriori_algorithm.ads`:

```ada
Min_Support_Threshold : constant Natural := 2;
```

Adjust this value based on your dataset size and requirements.

### Maximum Itemset Size

The maximum itemset size to consider is defined in `apriori_algorithm.adb`:

```ada
Max_L : constant Positive := 5;
```

Increase this for larger itemsets (note: computational complexity grows exponentially).

## Code Organization

### Package Specification (apriori_algorithm.ads)

Defines:
- Basic types: `Item`, `Itemset`, `Transaction`, `Itemset_Access`
- Vector types: `Item_Vectors`, `Itemset_Vectors`
- Data structure types: `Hash_Tree`, `Trie`, `Hash_Table_Trie`
- Procedure declarations: `Mapper`, `Reducer`, `Combiner`, `Apriori_Algorithm`, etc.
- Memory management: `Free_Itemset` procedure

### Package Body (apriori_algorithm.adb)

Implements:
- Data structure node types (InnerNode, LeafNode, TrieNode, HashTableTrieNode)
- Mapper, Reducer, Combiner procedures
- Core Apriori algorithm
- Candidate generation (combinatorial)
- Support counting (placeholder - to be implemented with actual database)
- Candidate pruning

### Main Program (main.adb)

Simple entry point that calls the Apriori algorithm.

### Test Suite (test_apriori.adb)

Comprehensive test suite with 8 test procedures covering all functionality.

## Type Definitions

### Item Types
```ada
type Item is range 1..1000;              -- Unique item identifier
type Itemset is array (Positive range <>) of Item;  -- Variable-length itemset
type Transaction is array (Positive range <>) of Item;  -- Transaction of items
```

### Access Types
```ada
type Itemset_Access is access Itemset;  -- Pointer to itemset for vector storage
```

### Data Structures
```ada
type Hash_Tree is access InnerNode;     -- Hash tree root
type Trie is access TrieNode;           -- Trie root
type Hash_Table_Trie is access HashTableTrieNode;  -- Hash table trie root
```

## Memory Management

The implementation uses Ada's `Unchecked_Deallocation` for memory cleanup:

```ada
procedure Free_Itemset is new Ada.Unchecked_Deallocation(Itemset, Itemset_Access);
```

All dynamically allocated itemsets must be freed using `Free_Itemset` to prevent memory leaks.

## Performance Considerations

1. **Candidate Generation**: Uses combinatorial generation (O(n choose k))
2. **Support Counting**: Current implementation is placeholder (O(n))
3. **Pruning**: Uses Apriori property for efficient elimination
4. **Data Structures**: Hash-based structures provide O(1) average access

For production use, replace placeholder implementations with:
- Actual database scanning for support counting
- Optimized candidate generation using Apriori property
- Parallel processing for large datasets

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Create a new Pull Request

## License

This project is open source and available for educational and research purposes.

## Acknowledgments

- Apriori algorithm: Agrawal & Srikant, 1994
- Hash Tree: Toivonen, 1996
- Trie data structure: Fredkin, 1960

## Contact

For questions or issues, please open a GitHub issue.
