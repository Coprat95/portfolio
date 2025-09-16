package maquina_snacks_multicapas.servicio;

public interface IServicioSaldo {
    void agregarSaldo(double cantidad);
    boolean descontarSaldo(double cantidad);
    double getSaldoDisponible();
}
