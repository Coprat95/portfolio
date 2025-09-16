package maquina_snacks_multicapas.servicio;

import maquina_snacks_multicapas.dominio.Snack;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Scanner;

public class ServicioInventarioArchivos implements IServicioInventario {
private final String NOMBRE_ARCHIVO = "inventario.txt";
// Creamos la lista de snacks
    private final  List<Snack> inventario ;

    public ServicioInventarioArchivos () {
        inventario = new ArrayList<>();
        // creamos el archivo si no existe
        try {
            File archivo = new File(NOMBRE_ARCHIVO);
            if ( archivo.exists()) {
                obtenerInventario();
            } else {
                PrintWriter salida = new PrintWriter(new FileWriter(archivo));
                salida.close();

                // Si no existe, cargamos algunos snacks iniciales
                Snack.reiniciarContador();
                cargarSnacksIniciales();
                guardarInventarioCompleto();
                System.out.println("Se ha creado el archivo.");
            }
        } catch (IOException e) {
            System.out.println("Error al escribir el fichero." + e.getMessage());
        }

    }

    private void obtenerInventario(){
      try(Scanner scanner = new Scanner(new File(NOMBRE_ARCHIVO))){
       while (scanner.hasNextLine()){ // mientras haya una línea en el siguiente salto de línea
         var linea = scanner.nextLine();
         String [] partes = linea.split(","); // El Array de String partes estará delimitado por cada coma
           if (partes.length == 4) {    // si está bien formado ( 4 elementos: id,nombre,precio,stock)
               int id = Integer.parseInt(partes[0].trim()); // quitamos espaciados por error con trim
               String nombre = partes[1].trim();
               double precio = Double.parseDouble(partes[2].trim());
               int stock = Integer.parseInt(partes[3].trim());
               // Ahora tras descomponer cada línea de texto en partes , formaremos el snack para añadirlo
               inventario.add(new Snack(nombre,precio,stock,id));

           } else{
               System.out.println("Línea mal formada. No se puede añadir : "+linea);
           }
                                                   }
      } catch ( FileNotFoundException e){
          System.out.println("No se ha encontrado el archivo. "+ e.getMessage());
      } catch (Exception e ){
          System.out.println("Error inesperado al leer el archivo. "+e.getMessage());
      }
    }

    public boolean comprarSnack(int id, double saldoDisponible){
        Snack snack = buscarPorId(id);  // variable snack = al Snack del id pedido
        if (snack == null) {
            System.out.println("Snack no encontrado.");
            return false;
        }
        if (snack.getPrecio() > saldoDisponible) {
            System.out.println("Saldo insuficiente. No se ha podido realizar la compra. ");
            return false;
        }
        // Entramos al metodo descontarStock. Si  hay stock se descontará, sino imprimirá el mensaje
        if (!snack.descontarStock()) {
            System.out.println("Stock insuficiente. No se ha podido realizar la compra. ");
            return false;
        }
        // con el Stock ya descontado entonces se actualiza el inventario.
        guardarInventarioCompleto();
        System.out.println("Compra realizada con éxito. ");
        return true;
    }

    private void cargarSnacksIniciales() {

     this.agregarSnack("Chocolate",1.30,3);
     this.agregarSnack("Patatas", 1.80,4);
     this.agregarSnack("Refresco",1.50,5);
     this.agregarSnack("Sandwich",3.10,3);
    }


    @Override
    public void agregarSnack(String nombre, double precio, int stock) {
        Snack nuevoSnack = new Snack(nombre, precio, stock);
        // 1 . Se guarda el snack en la lista en memoria
    this.inventario.add(nuevoSnack);
        // 2. Guardamos el nuevo snack en el archivo.
     this.agregarSnackArchivo(nuevoSnack);
    }


// metodo para ir agrenando los snacks al archivo de forma manual de uno en uno . AÑADE al final el nuevo producto
    private void agregarSnackArchivo(Snack snack){
       try {PrintWriter salida = new PrintWriter(new FileWriter(NOMBRE_ARCHIVO,true));
           // ,true abre el archivo en modo añadir --append. Si no existe lo crea, si existe le AÑADE .
    salida.printf("%d,%s,%.2f,%d%n",snack.getId(),snack.getNombre(),snack.getPrecio(),snack.getStock());
       } catch (Exception e) {
           System.out.println("Error al agregar el archivo. "+ e.getMessage());
       }
    }

    // metodo para sobreescribir el inventario por completo
    // lo hacemos PRIVATE POR ENCAPSULAMIENTO.  Lo invocaremos con comprarSnack , eliminarSnack.. etc
    // nos servirá por si tenemos que borrar algún producto o rellenarlo desde cero
    private void guardarInventarioCompleto(){
        try(PrintWriter salida = new PrintWriter(new FileWriter(NOMBRE_ARCHIVO))) {
        for ( Snack s : inventario){
            // Locale Us es para que se escriban los decimales como en Estados Unidos ( con puntos )
            // y no con comas ',' como en España
            salida.printf(Locale.US, "%d,%s,%.2f,%d%n",s.getId(),s.getNombre(),s.getPrecio(),s.getStock());
        }
        } catch (IOException e){
            System.out.println("Error en la salida del archivo: "+ e.getMessage());
        } catch (Exception e){
            System.out.println("Error inesperado al sobreescribir el archivo del inventario: " +e.getMessage());
        }
    }

    @Override
    public void mostrarInventario() {
        if (inventario.isEmpty()) {
            System.out.println("El inventario está vacío. ");
        } else {
            inventario.forEach(System.out::println);
        }

    }

    @Override
    public Snack buscarPorId(int id) {
        for (Snack s : inventario){
            if ( s.getId() == id  ) {
                return s;
            }
        }
       return null;
    }

    @Override
    public List<Snack> getSnacks() {
        return inventario;
    }


}
