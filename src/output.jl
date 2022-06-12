module OutputModule

    # Includes

    # Structs
    mutable struct Output
        value::String  # La cantidad de Algocoins a transferir en este output
        addr::String; # La direccion de origen de los fondos (que debe coincidir con la direccion del output referenciado)

        Output(value = "default_output_value", addr = "default_output_addr") = new(value, addr)
    end

    function CompareAddr(output::Output, addr::String) 
        cmp(output.addr, addr) == 0
    end

    function ToString(output::Output)
        string(output.value, " ", output.addr, "\n")
    end

end # module Output
