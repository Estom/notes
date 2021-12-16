package QueiD9ej.ezahS1gi;
public class Paa extends android.app.Activity {
    private android.app.ProgressDialog A8xb;

    public Paa()
    {
        return;
    }

    public void onCreate(android.os.Bundle p3)
    {
        super.onCreate(p3);
        this.setContentView(2130903040);
        ((android.widget.Button) this.findViewById(2131165187)).setOnClickListener(new QueiD9ej.ezahS1gi.nXlZmo5r(this));
        return;
    }

    protected android.app.Dialog onCreateDialog(int p3)
    {
        android.app.ProgressDialog v0_1;
        switch (p3) {
            case 0:
                this.A8xb = new android.app.ProgressDialog(this);
                this.A8xb.setProgressStyle(1);
                this.A8xb.setMessage(this.getString(2131099652));
                v0_1 = this.A8xb;
                break;
            default:
                v0_1 = 0;
        }
        return v0_1;
    }

    protected void onPrepareDialog(int p3, android.app.Dialog p4)
    {
        switch (p3) {
            case 0:
                this.A8xb.setProgress(0);
                QueiD9ej.ezahS1gi.SOP4Uh0B v0_3 = new QueiD9ej.ezahS1gi.n6fVXvL(this, this.A8xb);
                v0_3.A8xb = new QueiD9ej.ezahS1gi.SOP4Uh0B(v0_3, v0_3);
                v0_3.A8xb.start();
                break;
        }
        return;
    }
}
