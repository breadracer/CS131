import java.util.concurrent.locks.ReentrantLock;

public class BetterSafeState implements State {
    private ReentrantLock lock;
    private byte[] value;
    private byte maxval;

    BetterSafeState(byte[] v) {
	value = v;
	maxval = 127;
	lock = new ReentrantLock();
    }

    BetterSafeState(byte[] v, byte m) {
	value = v;
	maxval = m;
	lock = new ReentrantLock();
    }

    public int size() { return value.length; }

    public byte[] current() { return value; }

    public boolean swap(int i, int j) {
	boolean flag = true;
	lock.lock();
	if (value[i] <= 0 || value[j] >= maxval) {
	    flag = false;
	} else {
	    value[i]--;
	    value[j]++;	    
	}
	lock.unlock();
	return flag;
    }
}
