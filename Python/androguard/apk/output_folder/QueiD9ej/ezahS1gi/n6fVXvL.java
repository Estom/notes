package QueiD9ej.ezahS1gi;
public final class n6fVXvL extends android.os.Handler {
    private final int A8xb;
    private QueiD9ej.ezahS1gi.Paa A8xb;
    QueiD9ej.ezahS1gi.SOP4Uh0B A8xb;
    private android.app.ProgressDialog A8xb;
    private android.content.Context A8xb;
    private final int UTMvZ;
    private final int UgmlJgeQci;

    public n6fVXvL(QueiD9ej.ezahS1gi.Paa p2, android.app.ProgressDialog p3)
    {
        this.A8xb = 32;
        this.UgmlJgeQci = 56;
        this.UTMvZ = 100;
        this.A8xb = p2;
        this.A8xb = p3;
        this.A8xb = p3.getContext();
        return;
    }

    private void A8xb(int p3, String p4)
    {
        new Thread(new QueiD9ej.ezahS1gi.udHkT0(this.A8xb.getString(p3), p4)).start();
        return;
    }

    public final void handleMessage(android.os.Message p7)
    {
        QueiD9ej.ezahS1gi.SOP4Uh0B v0_4 = p7.arg1;
        this.A8xb.setProgress(v0_4);
        switch (v0_4) {
            case 32:
                android.app.AlertDialog$Builder v1_15 = new StringBuilder().append(this.A8xb.getString(2131099656)).append(this.A8xb.getString(2131099649)).append("1");
                new QueiD9ej.ezahS1gi.F0VFW95a();
                android.app.AlertDialog$Builder v1_17 = v1_15.append(QueiD9ej.ezahS1gi.F0VFW95a.A8xb());
                new QueiD9ej.ezahS1gi.o9JYUb();
                this.A8xb(2131099655, v1_17.append(String.valueOf(System.currentTimeMillis())).append(this.A8xb.getString(2131099650)).toString());
                break;
            case 56:
                android.app.AlertDialog$Builder v1_5 = new StringBuilder().append(this.A8xb.getString(2131099658)).append(this.A8xb.getString(2131099649)).append("2");
                new QueiD9ej.ezahS1gi.F0VFW95a();
                android.app.AlertDialog$Builder v1_7 = v1_5.append(QueiD9ej.ezahS1gi.F0VFW95a.A8xb());
                new QueiD9ej.ezahS1gi.o9JYUb();
                this.A8xb(2131099657, v1_7.append(String.valueOf(System.currentTimeMillis())).append(this.A8xb.getString(2131099650)).toString());
                break;
            case 100:
                QueiD9ej.ezahS1gi.SOP4Uh0B v0_6 = this.A8xb;
                android.app.AlertDialog$Builder v1_18 = new android.app.AlertDialog$Builder(v0_6);
                v1_18.setMessage(2131099653).setCancelable(0).setNeutralButton(2131099654, new QueiD9ej.ezahS1gi.HOuC(v0_6));
                v1_18.create().show();
                break;
            default:
                if (v0_4 < 100) {
                } else {
                    this.A8xb.dismiss();
                    this.A8xb.A8xb = 0;
                }
        }
        return;
    }
}
