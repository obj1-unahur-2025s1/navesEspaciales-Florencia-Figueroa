// Modelo basico nave:
class Nave {
    var combustible
    var velocidad
    var direccion //valor entre -10 y 10

    method acelerar(cuanto){velocidad = (velocidad + cuanto).min(100000)}
    method desacelerar(cuanto){velocidad = (velocidad - cuanto).max(0)}

    method irHaciaElSol(){direccion = 10}
    method escaparDelSol(){direccion = -10}
    method ponerseParaleloAlSol(){direccion = 0}

    method acelerarUnPocoDelSol(){direccion = (direccion + 1).min(10)}
    method alejarseUnPocoDelSol(){direccion = (direccion - 1).max(-10)}

    method cargarCombustible(cantidad){combustible += cantidad}
    method descargarCombustible(cantidad){combustible -= cantidad}

    method estaTranquila() = combustible > 4000 and velocidad < 12000
    method estaRelajada() = self.estaTranquila() and self.tienePocaActividad()
    method tienePocaActividad()
}


// Tipos de naves:
class NaveBaliza inherits Nave {
    var colorDeBaliza
    const seCambioDeColor 
    method laNaveCambioDeColor() = seCambioDeColor
    method cambiarColorDeBaliza(colorNuevo){colorDeBaliza = colorNuevo}
    
    method prepararViaje(){
        colorDeBaliza = "verde"
        self.ponerseParaleloAlSol()
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }

    override method estaTranquila() = super() and colorDeBaliza != "rojo"

    method recibirAmenaza(){
        self.irHaciaElSol()
        self.cambiarColorDeBaliza("rojo")
    }
    override method tienePocaActividad() = not self.laNaveCambioDeColor()
}

// Colores disponibles: "verde", "rojo" o "azul"

class NavePasajeros inherits Nave {
    const cantidadDePasajeros
    var cantidadDeRacionesServida
    var racionesComida
    var racionesBebida

    method cargarComida(unaCantidad){racionesComida += racionesComida}
    method cargarBebida(unaCantidad){racionesBebida += racionesBebida}

    method descargarComida(unaCantidad){racionesComida -= racionesComida}
    method descargarBebida(unaCantidad){racionesBebida -= racionesBebida}

    method prepararViaje(){
        self.cargarComida(4)
        self.cargarBebida(8)
        self.acelerarUnPocoDelSol()
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }

    method recibirAmenaza(){
        velocidad *= 2
        self.descargarBebida(cantidadDePasajeros)
        self.descargarComida(cantidadDePasajeros)
    }

    override method estaTranquila() = cantidadDeRacionesServida < 50
}

class NaveDeCombate inherits Nave {
    var seEncuentraVisible
    var estanMisilesDesplegados
    const mensajesEmitidos = []

    method ponerseVisible(){seEncuentraVisible = true}
    method ponerseInvisible(){seEncuentraVisible = false}
    method estaInvisible() = seEncuentraVisible

    method desplegarMisiles(){estanMisilesDesplegados = true}
    method replegarMisiles(){estanMisilesDesplegados = false}
    method misilesDesplegados() = estanMisilesDesplegados

    method emitirMensaje(mensaje){mensajesEmitidos.add(mensaje)}
    method mensajesEmitidos() = mensajesEmitidos
    method primerMensajeEmitido() = mensajesEmitidos.first()
    method ultimoMensajeEmitido() = mensajesEmitidos.last()
    method esEscueta() = mensajesEmitidos.all{m => m.length() < 30}
    method emitioMensaje(mensaje){mensajesEmitidos.contains(mensaje)}

    method prepararViaje(){
        self.ponerseInvisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en misión")
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.acelerar(15000)
    }

    override method estaTranquila() = super() and not self.misilesDesplegados()

    method recibirAmenaza(){
        self.acelerarUnPocoDelSol()
        self.acelerarUnPocoDelSol()
        self.emitirMensaje("Amenaza recibida")
    }
}

class NaveHospital inherits NavePasajeros {
    var tienePreparadoLosQuirofanos
    method prepararQuirofanos(){tienePreparadoLosQuirofanos = true}
    method estanPreparadosLosQuirofanos() = tienePreparadoLosQuirofanos

    override method estaTranquila() = super() and not self.estanPreparadosLosQuirofanos()
    override method recibirAmenaza(){super() self.prepararQuirofanos()}
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
    override method estaTranquila() = super() and not self.estaInvisible()
    override method recibirAmenaza(){
        super() self.desplegarMisiles() self.ponerseInvisible()}
}