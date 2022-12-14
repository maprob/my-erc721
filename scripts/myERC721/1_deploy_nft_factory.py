from brownie import accounts, config, MyERC721

def main():
    acc = accounts.add(config["wallets"]["from_key"])
    baseUri = "ipfs://QmTRSq9tj3pbxa8eCgF9S9PdCpG6NxjmvgA3ydm9rAS9FA"
    pf = 3.5e+9
    name, symbol = "NFT", "NFT"
    erc721 = MyERC721.deploy(
        name, symbol, baseUri,
        {"from": acc, "priority_fee": pf},
        publish_source=True
    )
    return erc721