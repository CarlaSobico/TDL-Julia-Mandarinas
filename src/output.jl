module OutputModule

# Includes

# Structs
mutable struct Output
    value::Float64  # La cantidad de Algocoins a transferir en este output
    addr::String # La direccion de origen de los fondos (que debe coincidir con la direccion del output referenciado)

    Output(value=0, addr="default_addr") = new(value, addr)
end

function CompareAddr(output::Output, addr::String)
    return cmp(output.addr, addr) == 0
end

function ToString(output::Output)
    value_string = string(output.value)
    return string(value_string, " ", output.addr, "\n")
end

end # module Output
