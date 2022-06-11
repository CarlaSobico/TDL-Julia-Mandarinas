module Output

    # Includes

    # Structs
    mutable struct Output
        value::String  # La  cantidad de Algocoins a transferir en este output
        addr::String; # La direccion de origen de los fondos (que debe coincidir con la direccion del output referenciado)

        Output(value = "",addr = "") = new(value, addr)
    end
    export Output

    function compareAddr(output::Output, addr::String) 
        cmp(output.addr, addr)
    end

    function toString(output::Output)
        string(value, "\n", addr, "\n")
    end

end # module Output
