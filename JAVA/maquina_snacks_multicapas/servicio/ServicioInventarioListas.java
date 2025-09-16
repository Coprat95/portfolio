package maquina_snacks_multicapas.servicio;

import maquina_snacks_multicapas.dominio.Inventario;
import maquina_snacks_multicapas.dominio.Snack;

import java.util.List;

public class ServicioInventarioListas implements  IServicioInventario {
    // Implementamos los métodos que heredamos de la interface
    // Creamos un objeto inventario para ello
    private final Inventario inventario = new Inventario();



    @Override
    public void agregarSnack(String nombre, double precio, int stock){
        inventario.agregarSnack(nombre, precio, stock);
    }
    @Override
    public void mostrarInventario(){
        inventario.mostrarInventario();
    }
    @Override
    public Snack buscarPorId(int id){
       return inventario.buscarPorId(id);
    }
    @Override
    public List<Snack> getSnacks(){
       return  inventario.getSnacks();
    }
    @Override
    public boolean comprarSnack(int id, double saldoDisponible) {
        Snack snack = inventario.buscarPorId(id);
        if (snack == null) return false;
        if (snack.getPrecio() > saldoDisponible) return false;
        if (!snack.descontarStock()) return false;
        return true;
    }
}


