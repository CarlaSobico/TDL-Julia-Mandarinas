module InputModule

# Includes

# Structs
mutable struct Input
    tx_id::String  # outpoint - Es un hash de la transaccion de donde este input toma fondos
    idx::Int64 # outpoint - Valor entero no negativo que representa un indice sobre la secuencia de outputs de la transaccion con hash tx id
    addr::String # input - La direccion de origen de los fondos (que debe coincidir con la direccion del output referenciado)

    Input(tx_id="default_tx_id", idx=0, addr="default_addr") = new(tx_id, idx, addr)
end

function Genesis()
    return Input("F"^32, 0, "F"^32)
end

function CompareAddr(input::Input, addr::String)
    return cmp(input.addr, addr) == 0
end

function ToString(input::Input)
    idx_string = string(input.idx)
    return string(input.tx_id, " ", idx_string, " ", input.addr, "\n")
end

function LoadInput(file::IOStream)

    input = Input()

    input.tx_id = readuntil(file, " ")
    input.idx = parse(Int, readuntil(file, " "))
    input.addr = readline(file)

    return input
end

end # InputModule
