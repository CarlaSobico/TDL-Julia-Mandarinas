module InputModule

    # Includes

    # Structs
    mutable struct Input
        tx_id::String  # outpoint  Es un hash de la transaccion de donde este input toma fondos
        idx::Int64; # outpoint //Valor entero no negativo que representa un indice sobre la secuencia de outputs de la transaccion con hash tx id
        addr::String; # input //La direccion de origen de los fondos (que debe coincidir con la direccion del output referenciado)
	
        Input(tx_id = "default_input_tx_id", idx = 0, addr = "default_input_addr") = new(tx_id, idx, addr)
    end

    function CompareAddr(input::Input, addr::String) 
        cmp(input.addr, addr) == 0
    end

    function ToString(input::Input) 
        idx_string = string(input.idx)
        string(input.tx_id, " ", input.idx, " ", input.addr, '\n')
    end

end # InputModule
