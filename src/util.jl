
import SHA

# Const strings 
const tx_id_str = "tx_id"
const idx_str = "idx"
const prev_block_genesis_str = "F" ^ 32
const dest_str = "dst"
const value_str = "value"
const addr_str = "addr"
const output_str = "output"

# Apply sha256 hash to input string.
function HashString(str::String)
    return bytes2hex(SHA.sha256(str))
end
