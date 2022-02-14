from solcx import compile_standard, install_solc

# this is reading the simplestorage sol file and storing it in a variable
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    print(simple_storage_file)

# We add these two lines that we forgot from the video!
print("Installing...")
install_solc("0.6.0")

# compiling our solidity code
compile_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)
print(compile_sol)
