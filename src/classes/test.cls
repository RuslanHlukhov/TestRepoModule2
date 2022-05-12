/**
 * Created by Ruslan on 11.05.2022.
 */

public with sharing class test {
    public static List<Account> selectAccount() {
        return [
                SELECT Id, Name
                FROM Account
        ];
    }
    public static List<Contact> selectContact() {
        return [
                SELECT Id, Name
                FROM Contact
        ];

    }
    public static List<Contract> selectContract() {
        return [
                SELECT Id, Name
                FROM Contract
        ];

    }
}