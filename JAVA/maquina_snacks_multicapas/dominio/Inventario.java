package maquina_snacks_multicapas.dominio;

import java.util.ArrayList;
import java.util.List;

public class Inventario {
    private final List<Snack> snacks;  // lista de snacks tipo Snack

    public Inventario (){
        snacks = new ArrayList<>();
        inicializadorInventario();  // iniciamos inventario cuando se instancia

    }
    // clase para iniciar el inventario
    public void inicializadorInventario(){
        agregarSnack("Chocolate",1.30,3);
        agregarSnack("Patatas", 1.80,4);
        agregarSnack("Refresco",1.50,5);
        agregarSnack("Sandwich",3.10,3);

    }
    // metodo para agregar nuevos snacks al inventario
    public void agregarSnack(String nombre, double precio, int stock){
        snacks.add(new Snack(nombre,precio,stock));
    }
    // metodo para mostrar el inventario
    public void mostrarInventario(){
        System.out.println("""
                
                -- Inventario de la máquina expendedora --
                """);
        if (snacks.isEmpty()) {
            System.out.println("Sin existencias de stock. ");
            return;
        }
        for ( Snack s: snacks) {
            System.out.println(s);
        }
    }

    // metodo buscarporId para que en otras clases se pueda buscar más facil los snacks
    public Snack buscarPorId(int id){
        for (Snack s: snacks) {
            if (s.getId() == id) {
                return s;
            }
        }
        return null;

    }
    // Getter de snacks
    public List<Snack> getSnacks() {
        return snacks;
    }
}
