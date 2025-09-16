package maquina_snacks_multicapas.servicio;

import java.util.Scanner;

public class EntradaUsuario implements IEntradaUsuario {
    private final Scanner scanner = new Scanner(System.in);

    // metodos para leer Entero, Double y Cadena
    public int leerEntero (String mensaje) {
        while (true) {
            System.out.println(mensaje);
            try {
                return Integer.parseInt(scanner.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Error, introduce un número. ");
            }

        }
    }
    public double leerDouble (String mensaje) {
        while (true) {
            System.out.println(mensaje);
            try {
                return Double.parseDouble(scanner.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Error , introduzca un valor decimal. ");
            }
        }
    }
    public String leerCadena (String mensaje) {
        while (true) {
            System.out.println(mensaje);
            try {
                // Para asegurarnos que no envíen un texto vacío.
                String entrada = scanner.nextLine().trim();
                if (!entrada.isEmpty()){
                    return  entrada;
                }
            } catch (Exception e) {
                System.out.println("Error. El texto no puede estar vacío.  ");
            }
        }
    }
}
