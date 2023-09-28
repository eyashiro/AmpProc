#!/bin/python3

import sys
from skbio import TreeNode

# Last updated: 18.09.2023
# To run: add_midpoint_root.py input.tre > out_rooted.tre
# Author: Erika Yashiro, Ph.D.



with open(sys.argv[1], "r") as file:
   tree = TreeNode.read(file)

newtree = str(tree.root_at_midpoint())
print(newtree)
file.close()
