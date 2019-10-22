#!/bin/bash

byte_array_400=$(java Test 127 400)

echo "8 thread Null 100000000 swaps:"
java UnsafeMemory Null 8 100000000 127$byte_array_400
#java UnsafeMemory Null 8 100000000 127$byte_array_400
#java UnsafeMemory Null 8 100000000 127$byte_array_400
#java UnsafeMemory Null 8 100000000 127$byte_array_400
#java UnsafeMemory Null 8 100000000 127$byte_array_400

echo ""
echo "8 thread Synchronized 100000000 swaps:"
java UnsafeMemory Synchronized 8 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 8 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 8 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 8 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 8 100000000 127$byte_array_400

echo ""
echo "8 thread BetterSafe 100000000 swaps:"
java UnsafeMemory BetterSafe 8 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 8 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 8 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 8 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 8 100000000 127$byte_array_400

echo ""
echo "8 thread Unsynchronized 100000000 swaps:"
java UnsafeMemory Unsynchronized 8 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 8 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 8 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 8 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 8 100000000 127$byte_array_400

echo ""
echo "8 thread GetNSet 100000000 swaps:"
java UnsafeMemory GetNSet 8 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 8 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 8 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 8 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 8 100000000 127$byte_array_400

echo ""
echo "16 thread Null 100000000 swaps:"
java UnsafeMemory Null 16 100000000 127$byte_array_400
#java UnsafeMemory Null 16 100000000 127$byte_array_400
#java UnsafeMemory Null 16 100000000 127$byte_array_400
#java UnsafeMemory Null 16 100000000 127$byte_array_400
#java UnsafeMemory Null 16 100000000 127$byte_array_400

echo ""
echo "16 thread Synchronized 100000000 swaps:"
java UnsafeMemory Synchronized 16 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 16 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 16 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 16 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 16 100000000 127$byte_array_400

echo ""
echo "16 thread BetterSafe 100000000 swaps:"
java UnsafeMemory BetterSafe 16 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 16 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 16 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 16 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 16 100000000 127$byte_array_400

echo ""
echo "16 thread Unsynchronized 100000000 swaps:"
java UnsafeMemory Unsynchronized 16 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 16 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 16 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 16 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 16 100000000 127$byte_array_400

echo ""
echo "16 thread GetNSet 100000000 swaps:"
java UnsafeMemory GetNSet 16 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 16 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 16 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 16 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 16 100000000 127$byte_array_400

echo ""
echo "32 thread Null 100000000 swaps:"
java UnsafeMemory Null 32 100000000 127$byte_array_400
#java UnsafeMemory Null 32 100000000 127$byte_array_400
#java UnsafeMemory Null 32 100000000 127$byte_array_400
#java UnsafeMemory Null 32 100000000 127$byte_array_400
#java UnsafeMemory Null 32 100000000 127$byte_array_400

echo ""
echo "32 thread Synchronized 100000000 swaps:"
java UnsafeMemory Synchronized 32 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 32 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 32 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 32 100000000 127$byte_array_400
#java UnsafeMemory Synchronized 32 100000000 127$byte_array_400

echo ""
echo "32 thread BetterSafe 100000000 swaps:"
java UnsafeMemory BetterSafe 32 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 32 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 32 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 32 100000000 127$byte_array_400
#java UnsafeMemory BetterSafe 32 100000000 127$byte_array_400

echo ""
echo "32 thread Unsynchronized 100000000 swaps:"
java UnsafeMemory Unsynchronized 32 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 32 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 32 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 32 100000000 127$byte_array_400
#java UnsafeMemory Unsynchronized 32 100000000 127$byte_array_400

echo ""
echo "32 thread GetNSet 100000000 swaps:"
java UnsafeMemory GetNSet 32 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 32 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 32 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 32 100000000 127$byte_array_400
#java UnsafeMemory GetNSet 32 100000000 127$byte_array_400

