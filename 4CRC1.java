// Computer Network Lab (BCS502) - Error detection code using CRC-CCITT (16-bit)
import java.util.Scanner;

public class CRC1 {
    public static void main(String args[]) {
        Scanner sc = new Scanner(System.in);

        // ================= SENDER SIDE =================
        // 1. Take input message bits and generator polynomial
        System.out.print("Enter message bits: ");
        String message = sc.nextLine();

        System.out.print("Enter generator: ");
        String generator = sc.nextLine();

        // Create data array of size: (message length + generator length - 1)
        // Extra (generator.length() - 1) slots default to 0 in Java (appending n-1 zeros)
        int data[] = new int[message.length() + generator.length() - 1];
        int divisor[] = new int[generator.length()];

        // Copy message bits into the beginning of the data array
        for (int i = 0; i < message.length(); i++) {
            data[i] = Integer.parseInt(message.charAt(i) + "");
        }

        // Copy generator bits into the divisor array
        for (int i = 0; i < generator.length(); i++) {
            divisor[i] = Integer.parseInt(generator.charAt(i) + "");
        }

        // 2. Perform Modulo-2 Binary Division (XOR) to find the CRC remainder
        for (int i = 0; i < message.length(); i++) {
            // Only divide (XOR) if the current leading bit is 1
            if (data[i] == 1) {
                for (int j = 0; j < divisor.length; j++) {
                    data[i + j] ^= divisor[j];
                }
            }
        }
        // After the loop, the last (generator.length() - 1) bits in 'data' hold the CRC remainder

        // 3. Form the final transmitted codeword (Original Message + CRC Remainder)
        System.out.print("The checksum code (transmitted data) is: ");
        for (int i = 0; i < message.length(); i++) {
            // Restore the original message bits at the front (remainder stays at the end)
            data[i] = Integer.parseInt(message.charAt(i) + "");
        }

        for (int i = 0; i < data.length; i++) {
            System.out.print(data[i]);
        }
        System.out.println();

        // ================= RECEIVER SIDE =================
        // 4. Read the received codeword and generator to verify integrity
        System.out.print("Enter received checksum code: ");
        message = sc.nextLine();

        System.out.print("Enter generator: ");
        generator = sc.nextLine();

        data = new int[message.length() + generator.length() - 1];
        divisor = new int[generator.length()];

        for (int i = 0; i < message.length(); i++) {
            data[i] = Integer.parseInt(message.charAt(i) + "");
        }

        for (int i = 0; i < generator.length(); i++) {
            divisor[i] = Integer.parseInt(generator.charAt(i) + "");
        }

        // 5. Divide the received codeword by the same generator using XOR
        for (int i = 0; i < message.length(); i++) {
            if (data[i] == 1) {
                for (int j = 0; j < divisor.length; j++) {
                    data[i + j] ^= divisor[j];
                }
            }
        }

        // 6. Check if the remainder is all zeros
        boolean valid = true;
        for (int i = 0; i < data.length; i++) {
            if (data[i] == 1) {
                valid = false;
                break;
            }
        }

        if (valid) {
            System.out.println("Data stream is valid (No error detected).");
        } else {
            System.out.println("Data stream is invalid. CRC error occurred.");
        }

        sc.close();
    }
}
