from brownie import accounts, config, NFT

def main():
    acc = accounts.add(config["wallets"]["from_key"])
    baseUri = "ipfs://QmTRSq9tj3pbxa8eCgF9S9PdCpG6NxjmvgA3ydm9rAS9FA"
    notRevealedUri = ""
    pf = 3.5e+9
    name, symb = "MyNFT", "NFT"
    timeToReveal = 60 # 1 minute

    nft = NFT.deploy(
        name, symb, baseUri, notRevealedUri, 
        timeToReveal, 
        {"from": acc, "priority_fee": pf},
        publish_source=True
    )
    return nft