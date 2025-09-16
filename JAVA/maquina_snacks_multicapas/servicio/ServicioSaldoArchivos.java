package maquina_snacks_multicapas.servicio;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;
import java.util.Scanner;

public class ServicioSaldoArchivos implements IServicioSaldo{
    private final String ARCHIVO_SALDO = "saldo.txt";
    private double saldoDisponible;

    public ServicioSaldoArchivos(){
        cargarSaldo();
    }

    @Override
    public void agregarSaldo(double cantidad) {
        if (cantidad <= 50) {
            saldoDisponible += cantidad;
            guardarSaldo();
        } else {
            System.out.println("No se ha podido agregar el saldo. La cantidad excede de 50€.");
        }

    }

    @Override
    public boolean descontarSaldo(double cantidad) {
        if (saldoDisponible > cantidad) {
            saldoDisponible -= cantidad;
            guardarSaldo();
            return true;
        }
        return false;
    }

    private void guardarSaldo(){
        try (PrintWriter salida = new PrintWriter(new FileWriter(ARCHIVO_SALDO))){
        salida.printf(Locale.US,"%.2f%n",saldoDisponible);
        } catch (IOException e){
            System.out.println("Error al guardar el saldo: "+ e.getMessage());
        } catch (Exception e) {
            System.out.println("Error inesperado al guardar el saldo." + e.getMessage());
        }
    }

    private void cargarSaldo (){
       File archivo = new File(ARCHIVO_SALDO);
       if (archivo.exists()) {
           try (Scanner scanner = new Scanner(archivo)) {
               if (scanner.hasNextLine()) {
                   String linea = scanner.nextLine().trim();
                   try{
                       saldoDisponible = Double.parseDouble(linea);
                   } catch (NumberFormatException e){
                       System.out.println("Formato de saldo inválido en el archivo." + e.getMessage());
                       saldoDisponible = 0.0;
                   }
               }
           } catch (IOException e) {
               System.out.println("Error al inicializar el saldo. " + e.getMessage());
           }
       } else {
           saldoDisponible = 0.0;
           guardarSaldo();
               }

    }


    @Override
    public double getSaldoDisponible() {
        return saldoDisponible;
    }
}
