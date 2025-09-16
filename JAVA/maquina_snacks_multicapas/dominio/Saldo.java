package maquina_snacks_multicapas.dominio;

public class Saldo {
    private  double saldoDisponible ;

    public Saldo(){
        this.saldoDisponible = 0;
    }

        // metodo para agregar saldo
        public void agregarSaldo(double cantidad){
        if (cantidad >0 && cantidad <= 50) {
                    saldoDisponible += cantidad;
                    System.out.printf("El saldo actualizado es de : %.2f€\n",saldoDisponible);
        } else {
                    System.out.println("La cantidad introducida no es válida.");
                }
        }
        public boolean descontarSaldo (double cantidad){
        if (cantidad >0 && cantidad <= saldoDisponible ) {
            saldoDisponible -= cantidad;
            return true;
        }else {
            System.out.println("No se puede descontar esa cantidad.");
            return false;
        }
    }

        //Getter para obtener el saldo
    public double getSaldoDisponible() {
        return saldoDisponible;
    }


}

