fun <T> everyNth(L: List<T>, N: Int): List<T> =
L.filterIndexed { i, _ -> i % N == N - 1 }

fun main(args: Array<String>) {
	var l1 = listOf(1, 2, 3, 4, 5, 6, 7)
	var o1 = everyNth(l1, 2)
	println(o1)
	l1 = listOf(2, 4, 6, 8, 10, 12, 14)
	println(o1)
	var o2 = everyNth(l1, 3)
	println(o2)
	val l2 = listOf("z", "y", "x", "w", "v", "u", "t", "s", "r")
	val o3 = everyNth(l2, 3)
	val o4 = everyNth(l2, 9)
	println(o3)
	println(o4)
}
