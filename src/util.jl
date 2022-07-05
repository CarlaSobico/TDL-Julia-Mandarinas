
import SHA

# Const strings 
const tx_id_str = "tx_id"
const idx_str = "idx"
const value_str = "value"
const addr_str = "addr"
const output_str = "output"

const fail_str = "FAIL"
const ok_str = "OK"
const default_path = ""

const prev_block_genesis_str = "F"^32

# Comandos
const init_command = "init"
const transfer_command = "transfer"
const mine_command = "mine"
const balance_command = "balance"
const block_command = "block"
const txn_command = "txn"
const load_command = "load"
const save_command = "save"

# Aplica la funcion sha256 a una string
function HashString(str::String)
    return bytes2hex(SHA.sha256(str))
end
