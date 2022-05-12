/**
 * Created by Ruslan on 12.05.2022.
 */

public with sharing class checkRecursive {
    private static Boolean run = true;

    public static Boolean runOnce() {
        if (run) {
            run = false;
            return true;
        } else {
            return run;
        }
    }
}