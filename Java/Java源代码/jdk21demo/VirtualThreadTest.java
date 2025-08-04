import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class VirtualThreadTest {
    public static void main(String[] args) {
        // long start = System.currentTimeMillis();
        // try (ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor()) {
        try (ExecutorService executor = Executors.newFixedThreadPool(10)) {
            for (int i = 0; i < 1000; i++) {
                final int index = i;
                executor.submit(() -> {
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    Thread.sleep(1000);
                    System.out.println(Thread.currentThread().getName() + ": " + index + " is running");
                });
            }
        }
        // long end = System.currentTimeMillis();
        // System.out.println("Total time: " + (end - start) + " ms");
    }
}
