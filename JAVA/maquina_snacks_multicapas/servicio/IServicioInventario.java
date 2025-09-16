package maquina_snacks_multicapas.servicio;

import maquina_snacks_multicapas.dominio.Snack;

import java.util.List;

public interface IServicioInventario {
    // Definimos todos los métodos tal y como están en Inventario, que se deben implementar ->  Son public por defecto
    void agregarSnack(String nombre, double precio, int stock);
    void mostrarInventario();
    Snack buscarPorId(int id);
    List<Snack> getSnacks();
    boolean comprarSnack ( int id, double saldoDisponible);

}