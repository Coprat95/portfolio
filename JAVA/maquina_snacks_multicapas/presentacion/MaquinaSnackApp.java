package maquina_snacks_multicapas.presentacion;

import maquina_snacks_multicapas.dominio.Snack;
import maquina_snacks_multicapas.servicio.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;


public class MaquinaSnackApp {
    Scanner scanner;
    List<Snack> carritoCompra;
    // Usaremos tanto servicioSaldo como servicioInventario para sustituir las clases
    // Saldo e Inventario y así poder separar bien lo lógico de lo funcional (arquitectura por capas).
    //private final IServicioSaldo servicioSaldo;
    private final IServicioSaldo servicioSaldoArchivos;
    // private final IServicioInventario servicioInventarioListas;
    private final IServicioInventario servicioInventarioArchivos;
    private final IEntradaUsuario entradaUsuario;
    // Constructor. Inicia el inventario
    public MaquinaSnackApp() {
        scanner = new Scanner(System.in);
        carritoCompra = new ArrayList<>();
        servicioSaldoArchivos = new ServicioSaldoArchivos();
        //servicioInventarioListas = new ServicioInventarioListas(); // Lo comentamos , estamos trabajando con Archivos ahora
        servicioInventarioArchivos = new ServicioInventarioArchivos();

        entradaUsuario = new EntradaUsuario();

    }
    // Clase que activa la máquina de snacks
    public void iniciar() {
        boolean salir = false;
        while (!salir) {
            servicioInventarioArchivos.mostrarInventario();
            mostrarMenu();
            salir = ejecutarOpciones();  // al ser ejecutarOpciones return boolean , podemos hacer que acabe el bucle

        }
    }
    public void mostrarMenu () {
            System.out.printf("""
                    \n*** Máquina de snacks ***
                    
                    Saldo disponible : %.2f
                    1- Comprar snack
                    2- Ticket de compra
                    3- Añadir nuevo snack
                    4- Añadir saldo
                    5- Salir
                    
                    """,servicioSaldoArchivos.getSaldoDisponible());

        }
        public boolean ejecutarOpciones(){

            var opcion = entradaUsuario.leerEntero("Seleccione una opción: ");
            switch (opcion){
                case 1 -> comprarSnack();
                case 2 -> mostrarTicket();
                case 3 -> agregarSnack();
                case 4 -> servicioSaldoArchivos.agregarSaldo(entradaUsuario.leerDouble("¿Cuanto saldo desea " +
                        " añadir (máximo 50€) ? "));
                case 5 -> {
                    System.out.println("Gracias. Hasta pronto!");
                    return true;
                }
                default -> System.out.println("Opción no válida.");

            }
           return false;
        }
        // metodo comprarSnack de la capa de presentación que llama al de la capa de negocio
        // podría tener otro nombre como invocarComprarSnack()
    public void comprarSnack() {
        int id = entradaUsuario.leerEntero("Introduzca el ID del snack que desea comprar: ");
        double saldo = servicioSaldoArchivos.getSaldoDisponible();

        if (servicioInventarioArchivos.comprarSnack(id,saldo)) {
            Snack snack = servicioInventarioArchivos.buscarPorId(id);
            servicioSaldoArchivos.descontarSaldo(snack.getPrecio());
            carritoCompra.add(snack);
        }


    }

    public void mostrarTicket(){
        double total = 0;
        System.out.println("""
                --- Ticket de compra ---
                """);
        for (Snack s : carritoCompra){
            System.out.printf("\n- %s\t\t=\t%.2f",s.getNombre(),s.getPrecio());
            total += s.getPrecio();
        }
        System.out.printf("""
                \n________________________
                Total de la compra:
                - %.2f
                """,total);
        System.out.printf("\nSaldo restante: %.2f\n",servicioSaldoArchivos.getSaldoDisponible());
        System.out.println("\nGracias por su compra.");
    }

    public void agregarSnack(){
        var nombre = entradaUsuario.leerCadena("Introduzca el nombre del snack: ");
        var precio = entradaUsuario.leerDouble("Introduzca el precio del snack: ");
        var stock = entradaUsuario.leerEntero("Introduzca la cantidad de stock: ");
        servicioInventarioArchivos.agregarSnack(nombre,precio,stock);
        System.out.println("Ha agregado el snack "+ nombre);
    }

        public static void main (String[]args){
            new MaquinaSnackApp().iniciar();

        }
    }

