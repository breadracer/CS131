import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSetState implements State {
    private AtomicIntegerArray value;
    private byte maxval;

    GetNSetState(byte[] v) {
	value = byteArrToAtomicIntArr(v);
	maxval = 127;
    }

    GetNSetState(byte[] v, byte m) {
	value = byteArrToAtomicIntArr(v);
	maxval = m;
    }

    public int size() { return value.length(); }

    public byte[] current() { return AtomicIntArrToByteArr(value); }

    public boolean swap(int i, int j) {
	int val_i = value.get(i);
	int val_j = value.get(j);
	if (val_i <= 0 || val_j >= maxval) {
	    return false;
	}
	value.set(i, val_i - 1);
	value.set(j, val_j + 1);
	return true;
    }

    private AtomicIntegerArray byteArrToAtomicIntArr(byte[] byteArr) {
	int length = byteArr.length;
	int[] intArr = new int[length];
	for (int i = 0; i < length; i++)
	    intArr[i] = byteArr[i];
	return new AtomicIntegerArray(intArr);
    }

    private byte[] AtomicIntArrToByteArr(AtomicIntegerArray intArr) {
	int length = intArr.length();
	byte[] byteArr = new byte[length];
	for (int i = 0; i < length; i++)
	    byteArr[i] = (byte)intArr.get(i);
	return byteArr;
    }
}
