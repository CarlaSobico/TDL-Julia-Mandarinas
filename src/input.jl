module Input

    # Includes

    # Structs
    mutable struct Input
        tx_id::String  # outpoint  Es un hash de la transaccion de donde este input toma fondos
        idx::Int64; # outpoint //Valor entero no negativo que representa un indice sobre la secuencia de outputs de la transaccion con hash tx id
        addr::String; # input //La direccion de origen de los fondos (que debe coincidir con la direccion del output referenciado)
	
        Input(tx_id = "", idx = 0, addr = "") = new(tx_id, idx, addr)
    end
    export Input

    function compareAddr(input::Input, addr::String) 
        cmp(input.addr, addr)
    end

    function toString(input::Input) 
        idx_string = string(idx)
        string(tx_id, "\n", idx_string, "\n", addr, "\n")
    end

end # module Input
