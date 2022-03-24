package QueiD9ej.ezahS1gi;
final class SOP4Uh0B extends java.lang.Thread {
    int A8xb;
    private synthetic QueiD9ej.ezahS1gi.n6fVXvL A8xb;
    private android.os.Handler A8xb;
    private int UgmlJgeQci;

    SOP4Uh0B(QueiD9ej.ezahS1gi.n6fVXvL p1, android.os.Handler p2)
    {
        this.A8xb = p1;
        this.A8xb = p2;
        return;
    }

    public final void run()
    {
        this.A8xb = 1;
        this.UgmlJgeQci = 0;
        while (this.A8xb == 1) {
            try {
                Thread.sleep(100);
            } catch (int v0) {
            }
            int v0_1 = this.A8xb.obtainMessage();
            v0_1.arg1 = this.UgmlJgeQci;
            this.A8xb.sendMessage(v0_1);
            this.UgmlJgeQci = (this.UgmlJgeQci + 1);
        }
        return;
    }
}
