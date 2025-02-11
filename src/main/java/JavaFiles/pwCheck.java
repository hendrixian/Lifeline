package JavaFiles;

import org.mindrot.jbcrypt.BCrypt;

public class pwCheck {
    public static void main(String[] args) {
        // Example password and hashed password
        String enteredPassword = "1234";  // Replace with the password entered by the user
        String storedHash = "$2a$10$W1vlS2MYf1Yw9BY50Jnlm.wrAauz4y8K9HPCf80PfAsn7EFeh9W4m"; // Replace with the actual hashed password

        // Check if the entered password matches the hashed password
        if (BCrypt.checkpw(enteredPassword, storedHash)) {
            System.out.println("Password matches.");
        } else {
            System.out.println("Password does not match.");
        }
    }
}

