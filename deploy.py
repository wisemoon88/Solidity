# from solcx library import compile_standard and install_solc methods
from solcx import compile_standard, install_solc

# importing json library
import json

# importing Web3 methods from web 3 library
from web3 import Web3

# importing os library
import os

# importing dotenv library for reading environment variable
from dotenv import load_dotenv

load_dotenv()

# this is reading the simplestorage sol file and storing it in a variable
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    # print(simple_storage_file)

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
# print(compile_sol)

# creating a json file that will store the compile_sol in a json syntax
with open("compile_code.json", "w") as file:
    json.dump(compile_sol, file)

# need to get bytecode first to deploy in python
bytecode = compile_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# need to get the abi as well
abi = compile_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# printing out the ABI
# print(abi)

# connecting to ganache, will need the http provider which is used to connect to the blockchain, the chain ID (eg:  rinksby, kovan etc), and the address that will be funding the deployment
# next phase was to connect to the rinkeby testnet so needed to get a host node provider
w3 = Web3(
    Web3.HTTPProvider("https://rinkeby.infura.io/v3/2ebb2c36959748c696fe6c351c84adef")
)
chain_id = 4
my_address = "0x180D98222b615751BaFdD4058D6b8fB6144C4d27"
private_key = os.getenv("PRIVATE_KEY")
print(private_key)

# creating a contract in python using web3, this is just creating a contract object, we are not yet deploying the contract
SimpleStorage = w3.eth.contract(
    abi=abi,
    bytecode=bytecode,
)
# print(SimpleStorage)

# build a transaction.  Building contract and building the transaction is 2 different things, will need to build contract first then assign contract to transaction
## getting the lastest nounce from the address that we are using
nonce = w3.eth.getTransactionCount(my_address)
print(nonce)

# this is building the transaction to deploy the contract
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        # this for some reason causes the run to fail, new web3 does not need chaiin id?
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
    }
)
# print(transaction)

# after transaction is built, will need to sign the transaction using the private key to get the message
# NEVER EVER hardcode your private key into the code
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

# environment variables are variables that we can create from the command line
# print(signed_txn)

# sending out the signed transaction so that it will be verified and included in a block.  it will be stored in the defined variable
print("deploying contract...")
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("deployed!!")

# working with methods in a contract that is already deployed
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
# printing out the results of the retrieve method.  will need a call method as well to differentiate it from a transact
# call --> simulate making a call, returning a value does not perform state change
# transact --> make a state change, will require a transaction
print(simple_storage.functions.retrieve().call())
print("updating contract")
# calling the store function
# print(simple_storage.functions.store(15).call())
# print(simple_storage.functions.retrieve().call())
# actually using the transact method will require building a transaction similar to building a contract
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce + 1,
    }
)
# print(store_transaction)
signed_store_tx = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)
# print(signed_store_tx)

store_tx_hash = w3.eth.send_raw_transaction(signed_store_tx.rawTransaction)
store_tx_receipt = w3.eth.wait_for_transaction_receipt(store_tx_hash)

# checking that the store function works and retrieveing will give us the new stored value
print("updated!!")
print(simple_storage.functions.retrieve().call())
