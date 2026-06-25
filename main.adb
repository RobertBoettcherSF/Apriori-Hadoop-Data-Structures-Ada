-- main.adb
-- Main program to run the Apriori algorithm
--
-- This is the entry point for the Apriori algorithm implementation.
-- It simply calls the main Apriori_Algorithm procedure from the package.

with Apriori_Algorithm;

procedure Main is
   -- Execute the Apriori algorithm
   -- This will:
   -- 1. Generate candidate itemsets starting from size 1
   -- 2. Count support for each candidate
   -- 3. Prune candidates below minimum support threshold
   -- 4. Iterate until no more frequent itemsets are found
   -- 5. Output the total number of frequent itemsets discovered
begin
   Apriori_Algorithm.Apriori_Algorithm;
end Main;
