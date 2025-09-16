package maquina_snacks_multicapas.dominio;

import java.io.Serializable;
import java.util.Objects;

public class Snack implements Serializable {
private static int contador = 0;
private int id;
private String nombre;
private double precio;
private int stock;

    public Snack (){}
    // Constructor  con id que se genera automáticamente
    public Snack (String nombre, double precio, int stock ) {
        this.id = ++contador ;
        this.nombre = nombre;
        this.precio = precio;
        this.stock = stock;
    }

    // Constructor con id explícito (para cargar desde archivo)
    public Snack (String nombre, double precio, int stock, int id ) {
        this.id = id;
        this.nombre = nombre;
        this.precio = precio;
        this.stock = stock;
        if (id >= contador) {
            contador = id +1;
        }
    }



    // Getters & Setters


    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    // metodo descontar Stock
    // metodo para descontar Stock
    public boolean descontarStock(){
        if (stock > 0 ){
            stock--;
            return true;
        }
        return false;
    }

    // metodo para reiniciar contador
    public static void reiniciarContador(){
        contador = 0;
    }

    // mostrarSnack / toString
    // Cuando hagamos un System.out.println(snack) saldrá con el formato siguiente:
    public String mostrarSnack() {
       return String.format("ID: %d | Nombre: %s | precio: %.2f € | Stock restante: %d",
               getId(),getNombre(),getPrecio(),getStock());
    }

    @Override
    public String toString() {
        return mostrarSnack();
    }

    // Equals y hashCode

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Snack snack = (Snack) o;
        return id == snack.id && Double.compare(precio, snack.precio) == 0 && Objects.equals(nombre, snack.nombre);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, nombre, precio);
    }
}
