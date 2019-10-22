public class Test {
    public static void main(String[] args) {
	int limit = Integer.parseInt(args[0]) + 1;
	int length = Integer.parseInt(args[1]);
	for (int i = 0; i < length; i++) {
	    System.out.print(" ");
	    System.out.print((int)Math.floor(Math.random() * limit));
	}

    }
}
