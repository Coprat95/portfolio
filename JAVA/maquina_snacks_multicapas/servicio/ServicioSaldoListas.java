package maquina_snacks_multicapas.servicio;

import maquina_snacks_multicapas.dominio.Saldo;

public class ServicioSaldoListas implements IServicioSaldo{
    private final Saldo saldo = new Saldo();

    public void agregarSaldo(double cantidad){
        saldo.agregarSaldo(cantidad);
    }

    public boolean descontarSaldo(double cantidad){
        return saldo.descontarSaldo(cantidad);
    }

    public double getSaldoDisponible(){
        return saldo.getSaldoDisponible();
    }
}
